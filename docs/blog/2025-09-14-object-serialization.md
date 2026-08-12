---
slug: serialization
title: "How to Serialize Any Object in JavaScript?"
authors: jcubic
image: /img/serialization.png
tags: [javascript, internals]
---

In this article, I will explain how the serialization of objects (in dump compiler) works in LIPS.

<!-- truncate -->

As a way of optimization, I decided to save the representation of the parsed code as a file.

The input Scheme code was read, parsed, and the tree structure was then serialized. The code had
objects, like a Pair, that needed to be saved and restored to and from a file.

The compiler in LIPS, is the same code that evaluate the code, it only returns different results, the
code instead of a value. So if there are any side effects, they will happen during compilation.
That's why it's a dump compiler, where the output code is serialized into a file, that can then later
be unserialized.

## Serialization with JSON

The first approach, to serialize the data, was to use JSON and take the benefit of the second
argument in JSON.stringify and JSON.parse.

Each object was saved as `{"@": "class", "#": data}`.

So the Pair class was saved as:

```json
{"@": "Pair", "#": [car, cdr]}
```

Later, the class field was change into an index to make the output JSON file smaller.

The code responsible for serialization is still part of the project, so LIPS can still open old files. It looks like this:

```javascript
function serialize(data) {
    return JSON.stringify(data, function(key, value) {
        const v0 = this[key];
        if (v0) {
            if (v0 instanceof RegExp) {
                return {
                    '@': mangle_name('regex'),
                    '#': [v0.source, v0.flags]
                };
            }
            var cls = mangle_name(v0.constructor.__class__);
            if (!is_undef(cls)) {
                return {
                    '@': cls,
                    '#': v0.serialize()
                };
            }
        }
        return value;
    });
}
```

As you can see from the code, it can serialize the regular expressions and internal classes by calling a serialize method.

Here is example serialize method for class Pair:

```javascript
Pair.prototype.serialize = function() {
    return [
        this.car,
        this.cdr
    ];
};
```

Function `mangle_name` was also an optimization that make the classes smaller. Each class had an
index where Pair had index `0` saved in `serialization_map`:

```javascript
var serialization_map = {
    'pair': ([car, cdr]) => Pair(car, cdr),
    'number': function(value) {
        if (LString.isString(value)) {
            return LNumber([value, 10]);
        }
        return LNumber(value);
    },
    'regex': function([pattern, flag]) {
        return new RegExp(pattern, flag);
    },
    'nil': function() {
        return nil;
    },
    'symbol': function(value) {
        if (LString.isString(value)) {
            return LSymbol(value);
        } else if (Array.isArray(value)) {
            return LSymbol(Symbol.for(value[0]));
        }
    },
    'string': LString,
    'character': LCharacter
};
```

A serialization map was also used to unserialized the data from the JSON. Here is how the function look like:

```javascript
function unserialize(string) {
    return JSON.parse(string, (_, object) => {
        if (object && typeof object === 'object') {
            if (!is_undef(object['@'])) {
                var cls = resolve_name(object['@']);
                if (serialization_map[cls]) {
                    return serialization_map[cls](object['#']);
                }
            }
        }
        return object;
    });
}
```

Function `resolve_name` is reverse of `mangle_name` which return class name based on index.

## Serialization with compressed CBOR

But the output of JSON file was big, so I decided to create a better serialization. This is when I
found about [CBOR binary data format](https://en.wikipedia.org/wiki/CBOR). I found a fast library
[cbor-x](https://github.com/kriszyp/cbor-x).

The library has an API that allow adding custom extensions to add any type of objects.

This the function that add support for all internal data types:

```javascript
const cbor = (function() {

    var types = {
        'pair': Pair,
        'symbol': LSymbol,
        'number': LNumber,
        'string': LString,
        'character': LCharacter,
        'nil': nil.constructor,
        'regex': RegExp
    };

    function serializer(Class, fn) {
        return {
            deserialize: fn,
            Class
        };
    }

    var encoder = new Encoder();

    const cbor_serialization_map = {};
    for (const [ name, fn ] of Object.entries(serialization_map)) {
        const Class = types[name];
        cbor_serialization_map[name] = serializer(Class, fn);
    }
    // add CBOR data mapping
    let tag = 43311;
    Object.keys(cbor_serialization_map).forEach(type => {
        const data = cbor_serialization_map[type];
        if (typeof data === 'function') {
            const Class = data;
            addExtension({
                Class,
                tag,
                encode(instance, encode) {
                    encode(instance.serialize());
                },
                decode(data) {
                    return new Class(data);
                }
            });
        } else {
            const { deserialize, Class } = data;
            addExtension({
                Class,
                tag,
                encode(instance, encode) {
                    if (instance instanceof RegExp) {
                        return encode([instance.source, instance.flags]);
                    }
                    encode(instance.serialize());
                },
                decode(data) {
                    return deserialize(data);
                }
            });
        }
        tag++;
    });
    return encoder;
})();
```

After this, you only need to use the `cbor.encode` to serialize the data and `cbor.decode` to unserialize.

But the CBOR output data was still big, it could be compressed (I could also do the same with JSON files).

I was searching for good and fast compression library and found implementation of
[LZJB](https://en.wikipedia.org/wiki/Jeff_Bonwick#LZJB) and a library [lzjb-k](https://github.com/copy/jslzjb-k)
on GitHub. I converted it into a module and published to NPM as [lzjb-pack](https://www.npmjs.com/package/lzjb-pack).

To create a binary file I compressed the output CBOR data and add a magic number in front.

```javascript
import { addExtension, Encoder } from 'cbor-x';

function encode_magic() {
    const VERSION = 1;
    const encoder = new TextEncoder('utf-8');
    return encoder.encode(`LIPS${VERSION.toString().padStart(3, ' ')}`);
}

const MAGIC_LENGTH = 7;

function decode_magic(obj) {
    const decoder = new TextDecoder('utf-8');
    const prefix = decoder.decode(obj.slice(0, MAGIC_LENGTH));
    const name = prefix.substring(0, 4);
    if (name === 'LIPS') {
        const m = prefix.match(/^(....).*([0-9]+)$/);
        if (m) {
            return {
                type: m[1],
                version: Number(m[2])
            };
        }
    }
    return {
        type: 'unknown'
    };
}
```

This will make it easier for the future to read multiple version of the binary data.

The serialization and deserialization functions look like this:

```javascript
import { pack, unpack } from 'lzjb-pack';

function serialize_bin(obj) {
    const magic = encode_magic();
    const payload = cbor.encode(obj);
    return merge_uint8_array(magic, pack(payload, { magic: false }));
}

function unserialize_bin(data) {
    const { type, version } = decode_magic(data);
    if (type === 'LIPS' && version === 1) {
        const arr = unpack(data.slice(MAGIC_LENGTH), { magic: false });
        return cbor.decode(arr);
    } else {
        throw new Error(`Invalid file format ${type}`);
    }
}
```

And this is the whole serialization, done by LIPS.

## Conclusion

The compressed CBOR file is way smaller than the source code and way smaller than JSON file,
that is way bigger then the input file. But the JSON can still be compressed which was not tested.

This is summary of the size of the standard library serialized in this way:

| File Comparison    | Size |Size Difference | Percentage Change | Description |
|--------------------|------|----------------|-------------------|-------------|
| std.scm            | 207k | -              | -                 | source code |
| std.xcm            | 478K | +271k          | +130.92%          | JSON        |
| std.xcb            | 105K | -102k          | -49.28%           | CBOR+LZJB   |
