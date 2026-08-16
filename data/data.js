window.BENCHMARK_DATA = {
  "lastUpdate": 1786924268658,
  "repoUrl": "https://github.com/jcubic/lips",
  "entries": {
    "LIPS interpreter benchmark": [
      {
        "commit": {
          "author": {
            "email": "jcubic@jcubic.pl",
            "name": "Jakub Jankiewicz",
            "username": "jcubic"
          },
          "committer": {
            "email": "jcubic@jcubic.pl",
            "name": "Jakub Jankiewicz",
            "username": "jcubic"
          },
          "distinct": true,
          "id": "340b021e5edb82c1667437d8b50436a71eb5b6be",
          "message": "update GitHub benchmark workflow",
          "timestamp": "2026-08-14T17:22:29+02:00",
          "tree_id": "3a50c80122f7c08641b74925b7c120d9621115cc",
          "url": "https://github.com/jcubic/lips/commit/340b021e5edb82c1667437d8b50436a71eb5b6be"
        },
        "date": 1786721017966,
        "tool": "benchmarkjs",
        "benches": [
          {
            "name": "array-map: pow",
            "value": 1339,
            "range": "±1.85%",
            "unit": "ops/sec",
            "extra": "86 samples"
          },
          {
            "name": "array-map: mix",
            "value": 1195,
            "range": "±0.88%",
            "unit": "ops/sec",
            "extra": "95 samples"
          },
          {
            "name": "array-map: string",
            "value": 582,
            "range": "±0.74%",
            "unit": "ops/sec",
            "extra": "92 samples"
          },
          {
            "name": "recursion: fib(18)",
            "value": 2.9,
            "range": "±0.99%",
            "unit": "ops/sec",
            "extra": "12 samples"
          },
          {
            "name": "recursion: fib-map",
            "value": 1487,
            "range": "±1.00%",
            "unit": "ops/sec",
            "extra": "91 samples"
          }
        ]
      },
      {
        "commit": {
          "author": {
            "email": "jcubic@jcubic.pl",
            "name": "Jakub T. Jankiewicz",
            "username": "jcubic"
          },
          "committer": {
            "email": "noreply@github.com",
            "name": "GitHub",
            "username": "web-flow"
          },
          "distinct": true,
          "id": "b6d1146b7f3e9007d16701ff706466b0665a7c9a",
          "message": "Merge pull request #541 from jcubic/continuations-2\n\nContinuations and TCO",
          "timestamp": "2026-08-14T21:48:43+02:00",
          "tree_id": "f03520b73b5a2e480a39349a3d2e9ef89178d00d",
          "url": "https://github.com/jcubic/lips/commit/b6d1146b7f3e9007d16701ff706466b0665a7c9a"
        },
        "date": 1786736998931,
        "tool": "benchmarkjs",
        "benches": [
          {
            "name": "array-map: pow",
            "value": 578,
            "range": "±1.73%",
            "unit": "ops/sec",
            "extra": "92 samples"
          },
          {
            "name": "array-map: mix",
            "value": 554,
            "range": "±0.35%",
            "unit": "ops/sec",
            "extra": "94 samples"
          },
          {
            "name": "array-map: string",
            "value": 247,
            "range": "±0.58%",
            "unit": "ops/sec",
            "extra": "90 samples"
          },
          {
            "name": "recursion: fib(18)",
            "value": 11.27,
            "range": "±1.00%",
            "unit": "ops/sec",
            "extra": "33 samples"
          },
          {
            "name": "recursion: fib-map",
            "value": 623,
            "range": "±0.60%",
            "unit": "ops/sec",
            "extra": "96 samples"
          }
        ]
      },
      {
        "commit": {
          "author": {
            "email": "jcubic@jcubic.pl",
            "name": "Jakub Jankiewicz",
            "username": "jcubic"
          },
          "committer": {
            "email": "jcubic@jcubic.pl",
            "name": "Jakub Jankiewicz",
            "username": "jcubic"
          },
          "distinct": true,
          "id": "b10dd9168c913602cb408617308459ef69df702c",
          "message": "chore: update deps",
          "timestamp": "2026-08-15T00:17:16+02:00",
          "tree_id": "e749e1eb42dfe62d8971011f538abf2ffff2e0e7",
          "url": "https://github.com/jcubic/lips/commit/b10dd9168c913602cb408617308459ef69df702c"
        },
        "date": 1786745912219,
        "tool": "benchmarkjs",
        "benches": [
          {
            "name": "array-map: pow",
            "value": 641,
            "range": "±1.22%",
            "unit": "ops/sec",
            "extra": "90 samples"
          },
          {
            "name": "array-map: mix",
            "value": 587,
            "range": "±0.78%",
            "unit": "ops/sec",
            "extra": "91 samples"
          },
          {
            "name": "array-map: string",
            "value": 259,
            "range": "±0.75%",
            "unit": "ops/sec",
            "extra": "88 samples"
          },
          {
            "name": "recursion: fib(18)",
            "value": 13.43,
            "range": "±1.45%",
            "unit": "ops/sec",
            "extra": "38 samples"
          },
          {
            "name": "recursion: fib-map",
            "value": 633,
            "range": "±0.79%",
            "unit": "ops/sec",
            "extra": "89 samples"
          }
        ]
      },
      {
        "commit": {
          "author": {
            "email": "jcubic@jcubic.pl",
            "name": "Jakub Jankiewicz",
            "username": "jcubic"
          },
          "committer": {
            "email": "jcubic@jcubic.pl",
            "name": "Jakub Jankiewicz",
            "username": "jcubic"
          },
          "distinct": true,
          "id": "18b860aa26076492b3abc56e9347dddb9e827c4b",
          "message": "fix truncate function on rationals",
          "timestamp": "2026-08-15T13:05:50+02:00",
          "tree_id": "4a65650be13262acd5560b6c8bde6d7052279eb0",
          "url": "https://github.com/jcubic/lips/commit/18b860aa26076492b3abc56e9347dddb9e827c4b"
        },
        "date": 1786792042978,
        "tool": "benchmarkjs",
        "benches": [
          {
            "name": "array-map: pow",
            "value": 514,
            "range": "±1.63%",
            "unit": "ops/sec",
            "extra": "88 samples"
          },
          {
            "name": "array-map: mix",
            "value": 494,
            "range": "±0.66%",
            "unit": "ops/sec",
            "extra": "92 samples"
          },
          {
            "name": "array-map: string",
            "value": 224,
            "range": "±0.86%",
            "unit": "ops/sec",
            "extra": "87 samples"
          },
          {
            "name": "recursion: fib(18)",
            "value": 11.32,
            "range": "±1.27%",
            "unit": "ops/sec",
            "extra": "33 samples"
          },
          {
            "name": "recursion: fib-map",
            "value": 550,
            "range": "±1.34%",
            "unit": "ops/sec",
            "extra": "89 samples"
          }
        ]
      },
      {
        "commit": {
          "author": {
            "email": "jcubic@jcubic.pl",
            "name": "Jakub T. Jankiewicz",
            "username": "jcubic"
          },
          "committer": {
            "email": "noreply@github.com",
            "name": "GitHub",
            "username": "web-flow"
          },
          "distinct": true,
          "id": "7233c31ae67ca4edfe3f99c9bccd97b0d660af53",
          "message": "Merge branch 'master' into devel",
          "timestamp": "2026-08-15T19:08:34+02:00",
          "tree_id": "1a1a79ffb39e86b0fbfce42ebbb8956636a4fb77",
          "url": "https://github.com/jcubic/lips/commit/7233c31ae67ca4edfe3f99c9bccd97b0d660af53"
        },
        "date": 1786813788791,
        "tool": "benchmarkjs",
        "benches": [
          {
            "name": "array-map: pow",
            "value": 539,
            "range": "±1.62%",
            "unit": "ops/sec",
            "extra": "90 samples"
          },
          {
            "name": "array-map: mix",
            "value": 525,
            "range": "±0.25%",
            "unit": "ops/sec",
            "extra": "92 samples"
          },
          {
            "name": "array-map: string",
            "value": 235,
            "range": "±0.75%",
            "unit": "ops/sec",
            "extra": "85 samples"
          },
          {
            "name": "recursion: fib(18)",
            "value": 11.6,
            "range": "±1.02%",
            "unit": "ops/sec",
            "extra": "33 samples"
          },
          {
            "name": "recursion: fib-map",
            "value": 585,
            "range": "±0.74%",
            "unit": "ops/sec",
            "extra": "91 samples"
          }
        ]
      },
      {
        "commit": {
          "author": {
            "email": "jcubic@jcubic.pl",
            "name": "Jakub Jankiewicz",
            "username": "jcubic"
          },
          "committer": {
            "email": "jcubic@jcubic.pl",
            "name": "Jakub Jankiewicz",
            "username": "jcubic"
          },
          "distinct": true,
          "id": "00123f1d5f23286125dd66c2c3ff5155fc8eb5b7",
          "message": "update browsrlist",
          "timestamp": "2026-08-15T20:38:35+02:00",
          "tree_id": "8a7083882013b0ed95abb007e500a59c7040ef79",
          "url": "https://github.com/jcubic/lips/commit/00123f1d5f23286125dd66c2c3ff5155fc8eb5b7"
        },
        "date": 1786819199905,
        "tool": "benchmarkjs",
        "benches": [
          {
            "name": "array-map: pow",
            "value": 523,
            "range": "±2.02%",
            "unit": "ops/sec",
            "extra": "87 samples"
          },
          {
            "name": "array-map: mix",
            "value": 508,
            "range": "±0.38%",
            "unit": "ops/sec",
            "extra": "93 samples"
          },
          {
            "name": "array-map: string",
            "value": 228,
            "range": "±0.63%",
            "unit": "ops/sec",
            "extra": "88 samples"
          },
          {
            "name": "recursion: fib(18)",
            "value": 11.32,
            "range": "±0.93%",
            "unit": "ops/sec",
            "extra": "33 samples"
          },
          {
            "name": "recursion: fib-map",
            "value": 568,
            "range": "±0.75%",
            "unit": "ops/sec",
            "extra": "92 samples"
          }
        ]
      },
      {
        "commit": {
          "author": {
            "email": "jcubic@jcubic.pl",
            "name": "Jakub Jankiewicz",
            "username": "jcubic"
          },
          "committer": {
            "email": "jcubic@jcubic.pl",
            "name": "Jakub Jankiewicz",
            "username": "jcubic"
          },
          "distinct": true,
          "id": "4a52d2638b4022c90f60cdc8cfe03b559fe37b17",
          "message": "fix `vector-fill!` off-by-one error",
          "timestamp": "2026-08-15T20:49:04+02:00",
          "tree_id": "0f3550111965118e2c7ea87cf191faabe0d7049d",
          "url": "https://github.com/jcubic/lips/commit/4a52d2638b4022c90f60cdc8cfe03b559fe37b17"
        },
        "date": 1786819818961,
        "tool": "benchmarkjs",
        "benches": [
          {
            "name": "array-map: pow",
            "value": 570,
            "range": "±1.73%",
            "unit": "ops/sec",
            "extra": "93 samples"
          },
          {
            "name": "array-map: mix",
            "value": 542,
            "range": "±0.92%",
            "unit": "ops/sec",
            "extra": "95 samples"
          },
          {
            "name": "array-map: string",
            "value": 243,
            "range": "±0.73%",
            "unit": "ops/sec",
            "extra": "88 samples"
          },
          {
            "name": "recursion: fib(18)",
            "value": 11.68,
            "range": "±1.45%",
            "unit": "ops/sec",
            "extra": "34 samples"
          },
          {
            "name": "recursion: fib-map",
            "value": 610,
            "range": "±0.94%",
            "unit": "ops/sec",
            "extra": "93 samples"
          }
        ]
      },
      {
        "commit": {
          "author": {
            "email": "jcubic@jcubic.pl",
            "name": "Jakub Jankiewicz",
            "username": "jcubic"
          },
          "committer": {
            "email": "jcubic@jcubic.pl",
            "name": "Jakub Jankiewicz",
            "username": "jcubic"
          },
          "distinct": true,
          "id": "06d10b4a929ab3b1d69e4f32d85c55e70a1614c1",
          "message": "parallelize unit tests",
          "timestamp": "2026-08-15T22:31:58+02:00",
          "tree_id": "f52a6d5ab86b025cc4cf093ad20cb489f2f9f4f6",
          "url": "https://github.com/jcubic/lips/commit/06d10b4a929ab3b1d69e4f32d85c55e70a1614c1"
        },
        "date": 1786826002160,
        "tool": "benchmarkjs",
        "benches": [
          {
            "name": "array-map: pow",
            "value": 537,
            "range": "±1.60%",
            "unit": "ops/sec",
            "extra": "91 samples"
          },
          {
            "name": "array-map: mix",
            "value": 514,
            "range": "±0.53%",
            "unit": "ops/sec",
            "extra": "92 samples"
          },
          {
            "name": "array-map: string",
            "value": 231,
            "range": "±0.58%",
            "unit": "ops/sec",
            "extra": "90 samples"
          },
          {
            "name": "recursion: fib(18)",
            "value": 11.54,
            "range": "±1.61%",
            "unit": "ops/sec",
            "extra": "33 samples"
          },
          {
            "name": "recursion: fib-map",
            "value": 572,
            "range": "±0.63%",
            "unit": "ops/sec",
            "extra": "92 samples"
          }
        ]
      },
      {
        "commit": {
          "author": {
            "email": "jcubic@jcubic.pl",
            "name": "Jakub Jankiewicz",
            "username": "jcubic"
          },
          "committer": {
            "email": "jcubic@jcubic.pl",
            "name": "Jakub Jankiewicz",
            "username": "jcubic"
          },
          "distinct": true,
          "id": "5411151a7f4d7b8b9b440fc6cdbc02bbfeb388ce",
          "message": "add build artifacts",
          "timestamp": "2026-08-15T22:41:22+02:00",
          "tree_id": "3add64bffc5eccdd8e1eae0d92371c242eff77f5",
          "url": "https://github.com/jcubic/lips/commit/5411151a7f4d7b8b9b440fc6cdbc02bbfeb388ce"
        },
        "date": 1786826556925,
        "tool": "benchmarkjs",
        "benches": [
          {
            "name": "array-map: pow",
            "value": 564,
            "range": "±1.80%",
            "unit": "ops/sec",
            "extra": "92 samples"
          },
          {
            "name": "array-map: mix",
            "value": 543,
            "range": "±0.33%",
            "unit": "ops/sec",
            "extra": "95 samples"
          },
          {
            "name": "array-map: string",
            "value": 241,
            "range": "±0.97%",
            "unit": "ops/sec",
            "extra": "88 samples"
          },
          {
            "name": "recursion: fib(18)",
            "value": 11.64,
            "range": "±0.88%",
            "unit": "ops/sec",
            "extra": "33 samples"
          },
          {
            "name": "recursion: fib-map",
            "value": 608,
            "range": "±0.55%",
            "unit": "ops/sec",
            "extra": "93 samples"
          }
        ]
      },
      {
        "commit": {
          "author": {
            "email": "jcubic@jcubic.pl",
            "name": "Jakub Jankiewicz",
            "username": "jcubic"
          },
          "committer": {
            "email": "jcubic@jcubic.pl",
            "name": "Jakub Jankiewicz",
            "username": "jcubic"
          },
          "distinct": true,
          "id": "f5efe3ab739a8b1a58864614c823646c7f651f08",
          "message": "refactor tests",
          "timestamp": "2026-08-15T23:19:34+02:00",
          "tree_id": "c1218776f4862c78a3ac537a94c9255707750498",
          "url": "https://github.com/jcubic/lips/commit/f5efe3ab739a8b1a58864614c823646c7f651f08"
        },
        "date": 1786829193952,
        "tool": "benchmarkjs",
        "benches": [
          {
            "name": "array-map: pow",
            "value": 561,
            "range": "±2.29%",
            "unit": "ops/sec",
            "extra": "89 samples"
          },
          {
            "name": "array-map: mix",
            "value": 548,
            "range": "±0.36%",
            "unit": "ops/sec",
            "extra": "93 samples"
          },
          {
            "name": "array-map: string",
            "value": 248,
            "range": "±0.52%",
            "unit": "ops/sec",
            "extra": "90 samples"
          },
          {
            "name": "recursion: fib(18)",
            "value": 12.04,
            "range": "±0.77%",
            "unit": "ops/sec",
            "extra": "34 samples"
          },
          {
            "name": "recursion: fib-map",
            "value": 623,
            "range": "±0.73%",
            "unit": "ops/sec",
            "extra": "93 samples"
          }
        ]
      },
      {
        "commit": {
          "author": {
            "email": "jcubic@jcubic.pl",
            "name": "Jakub Jankiewicz",
            "username": "jcubic"
          },
          "committer": {
            "email": "jcubic@jcubic.pl",
            "name": "Jakub Jankiewicz",
            "username": "jcubic"
          },
          "distinct": true,
          "id": "8a7261539fd7e40e8dfe469f53751af622f2ca14",
          "message": "chrore: fix workflow",
          "timestamp": "2026-08-15T23:41:45+02:00",
          "tree_id": "8eb34e258bfcdb70ac990f397c55ba698db89e19",
          "url": "https://github.com/jcubic/lips/commit/8a7261539fd7e40e8dfe469f53751af622f2ca14"
        },
        "date": 1786830185968,
        "tool": "benchmarkjs",
        "benches": [
          {
            "name": "array-map: pow",
            "value": 539,
            "range": "±1.69%",
            "unit": "ops/sec",
            "extra": "91 samples"
          },
          {
            "name": "array-map: mix",
            "value": 522,
            "range": "±0.34%",
            "unit": "ops/sec",
            "extra": "93 samples"
          },
          {
            "name": "array-map: string",
            "value": 235,
            "range": "±0.29%",
            "unit": "ops/sec",
            "extra": "86 samples"
          },
          {
            "name": "recursion: fib(18)",
            "value": 11.59,
            "range": "±1.93%",
            "unit": "ops/sec",
            "extra": "33 samples"
          },
          {
            "name": "recursion: fib-map",
            "value": 583,
            "range": "±0.81%",
            "unit": "ops/sec",
            "extra": "92 samples"
          }
        ]
      },
      {
        "commit": {
          "author": {
            "email": "jcubic@jcubic.pl",
            "name": "Jakub Jankiewicz",
            "username": "jcubic"
          },
          "committer": {
            "email": "jcubic@jcubic.pl",
            "name": "Jakub Jankiewicz",
            "username": "jcubic"
          },
          "distinct": true,
          "id": "58dc10bd4a4f4a2547c1fd73c033d22e0687e23b",
          "message": "update workflows",
          "timestamp": "2026-08-16T00:02:27+02:00",
          "tree_id": "0546c37289ced232c65f7499b49d28d08f5623ff",
          "url": "https://github.com/jcubic/lips/commit/58dc10bd4a4f4a2547c1fd73c033d22e0687e23b"
        },
        "date": 1786831426344,
        "tool": "benchmarkjs",
        "benches": [
          {
            "name": "array-map: pow",
            "value": 534,
            "range": "±1.78%",
            "unit": "ops/sec",
            "extra": "90 samples"
          },
          {
            "name": "array-map: mix",
            "value": 519,
            "range": "±0.40%",
            "unit": "ops/sec",
            "extra": "94 samples"
          },
          {
            "name": "array-map: string",
            "value": 233,
            "range": "±0.70%",
            "unit": "ops/sec",
            "extra": "85 samples"
          },
          {
            "name": "recursion: fib(18)",
            "value": 11.44,
            "range": "±1.31%",
            "unit": "ops/sec",
            "extra": "33 samples"
          },
          {
            "name": "recursion: fib-map",
            "value": 582,
            "range": "±0.80%",
            "unit": "ops/sec",
            "extra": "91 samples"
          }
        ]
      },
      {
        "commit": {
          "author": {
            "email": "jcubic@jcubic.pl",
            "name": "Jakub Jankiewicz",
            "username": "jcubic"
          },
          "committer": {
            "email": "jcubic@jcubic.pl",
            "name": "Jakub Jankiewicz",
            "username": "jcubic"
          },
          "distinct": true,
          "id": "6edfe27e751417ecea914e68ff3bace6fe20d271",
          "message": "fix flaky tests",
          "timestamp": "2026-08-16T00:52:15+02:00",
          "tree_id": "c82ba26efc3bc55541ec018a8a9f2a00c567f014",
          "url": "https://github.com/jcubic/lips/commit/6edfe27e751417ecea914e68ff3bace6fe20d271"
        },
        "date": 1786834420468,
        "tool": "benchmarkjs",
        "benches": [
          {
            "name": "array-map: pow",
            "value": 501,
            "range": "±2.00%",
            "unit": "ops/sec",
            "extra": "87 samples"
          },
          {
            "name": "array-map: mix",
            "value": 489,
            "range": "±0.71%",
            "unit": "ops/sec",
            "extra": "91 samples"
          },
          {
            "name": "array-map: string",
            "value": 219,
            "range": "±0.87%",
            "unit": "ops/sec",
            "extra": "85 samples"
          },
          {
            "name": "recursion: fib(18)",
            "value": 11.46,
            "range": "±0.85%",
            "unit": "ops/sec",
            "extra": "33 samples"
          },
          {
            "name": "recursion: fib-map",
            "value": 550,
            "range": "±0.60%",
            "unit": "ops/sec",
            "extra": "92 samples"
          }
        ]
      },
      {
        "commit": {
          "author": {
            "email": "jcubic@jcubic.pl",
            "name": "Jakub Jankiewicz",
            "username": "jcubic"
          },
          "committer": {
            "email": "jcubic@jcubic.pl",
            "name": "Jakub Jankiewicz",
            "username": "jcubic"
          },
          "distinct": true,
          "id": "02e7e3b81ad07ec7673c674f9d7e347c93bcaf4f",
          "message": "add `#!cycle`/`#!no-cycle` and `#!promise`/`#!no-promise` optimization directives",
          "timestamp": "2026-08-16T11:59:18+02:00",
          "tree_id": "15488f050676c1f69f4be17e180ff909f0837004",
          "url": "https://github.com/jcubic/lips/commit/02e7e3b81ad07ec7673c674f9d7e347c93bcaf4f"
        },
        "date": 1786874440894,
        "tool": "benchmarkjs",
        "benches": [
          {
            "name": "array-map: pow",
            "value": 679,
            "range": "±1.54%",
            "unit": "ops/sec",
            "extra": "89 samples"
          },
          {
            "name": "array-map: mix",
            "value": 680,
            "range": "±1.03%",
            "unit": "ops/sec",
            "extra": "92 samples"
          },
          {
            "name": "array-map: string",
            "value": 295,
            "range": "±0.80%",
            "unit": "ops/sec",
            "extra": "88 samples"
          },
          {
            "name": "recursion: fib(18)",
            "value": 11.4,
            "range": "±1.38%",
            "unit": "ops/sec",
            "extra": "33 samples"
          },
          {
            "name": "recursion: fib-map",
            "value": 708,
            "range": "±0.74%",
            "unit": "ops/sec",
            "extra": "91 samples"
          }
        ]
      },
      {
        "commit": {
          "author": {
            "email": "jcubic@jcubic.pl",
            "name": "Jakub Jankiewicz",
            "username": "jcubic"
          },
          "committer": {
            "email": "jcubic@jcubic.pl",
            "name": "Jakub Jankiewicz",
            "username": "jcubic"
          },
          "distinct": true,
          "id": "c917268dabc8de766bfebb3a5d9f1e1a5887ea41",
          "message": "improve error handling + fix not function",
          "timestamp": "2026-08-16T14:37:10+02:00",
          "tree_id": "330cd33b87e85c0e4f56c3ec5f37afc02236018d",
          "url": "https://github.com/jcubic/lips/commit/c917268dabc8de766bfebb3a5d9f1e1a5887ea41"
        },
        "date": 1786884260394,
        "tool": "benchmarkjs",
        "benches": [
          {
            "name": "array-map: pow",
            "value": 697,
            "range": "±1.60%",
            "unit": "ops/sec",
            "extra": "89 samples"
          },
          {
            "name": "array-map: mix",
            "value": 704,
            "range": "±0.57%",
            "unit": "ops/sec",
            "extra": "93 samples"
          },
          {
            "name": "array-map: string",
            "value": 303,
            "range": "±0.63%",
            "unit": "ops/sec",
            "extra": "90 samples"
          },
          {
            "name": "recursion: fib(18)",
            "value": 11.68,
            "range": "±0.94%",
            "unit": "ops/sec",
            "extra": "33 samples"
          },
          {
            "name": "recursion: fib-map",
            "value": 732,
            "range": "±0.72%",
            "unit": "ops/sec",
            "extra": "92 samples"
          }
        ]
      },
      {
        "commit": {
          "author": {
            "email": "jcubic@jcubic.pl",
            "name": "Jakub Jankiewicz",
            "username": "jcubic"
          },
          "committer": {
            "email": "jcubic@jcubic.pl",
            "name": "Jakub Jankiewicz",
            "username": "jcubic"
          },
          "distinct": true,
          "id": "6a79013ab1c3e83a17381e41e16237fae64cc20a",
          "message": "make directives return void",
          "timestamp": "2026-08-16T15:07:11+02:00",
          "tree_id": "e4efc743dd48ac773b5df6b5c266ea98f3e97ac0",
          "url": "https://github.com/jcubic/lips/commit/6a79013ab1c3e83a17381e41e16237fae64cc20a"
        },
        "date": 1786885709306,
        "tool": "benchmarkjs",
        "benches": [
          {
            "name": "array-map: pow",
            "value": 697,
            "range": "±1.52%",
            "unit": "ops/sec",
            "extra": "89 samples"
          },
          {
            "name": "array-map: mix",
            "value": 704,
            "range": "±0.85%",
            "unit": "ops/sec",
            "extra": "92 samples"
          },
          {
            "name": "array-map: string",
            "value": 303,
            "range": "±0.74%",
            "unit": "ops/sec",
            "extra": "90 samples"
          },
          {
            "name": "recursion: fib(18)",
            "value": 11.91,
            "range": "±0.80%",
            "unit": "ops/sec",
            "extra": "34 samples"
          },
          {
            "name": "recursion: fib-map",
            "value": 727,
            "range": "±1.10%",
            "unit": "ops/sec",
            "extra": "91 samples"
          }
        ]
      },
      {
        "commit": {
          "author": {
            "email": "jcubic@jcubic.pl",
            "name": "Jakub Jankiewicz",
            "username": "jcubic"
          },
          "committer": {
            "email": "jcubic@jcubic.pl",
            "name": "Jakub Jankiewicz",
            "username": "jcubic"
          },
          "distinct": true,
          "id": "74e2beae40b466d7b46e7efd8eb50045a042d5a8",
          "message": "fix LIPS in browser + add browser smoke test",
          "timestamp": "2026-08-16T16:34:10+02:00",
          "tree_id": "2052e0efbfcd0d8f73cedb786942c1518d2fb6be",
          "url": "https://github.com/jcubic/lips/commit/74e2beae40b466d7b46e7efd8eb50045a042d5a8"
        },
        "date": 1786890935426,
        "tool": "benchmarkjs",
        "benches": [
          {
            "name": "array-map: pow",
            "value": 668,
            "range": "±1.58%",
            "unit": "ops/sec",
            "extra": "89 samples"
          },
          {
            "name": "array-map: mix",
            "value": 683,
            "range": "±0.66%",
            "unit": "ops/sec",
            "extra": "92 samples"
          },
          {
            "name": "array-map: string",
            "value": 295,
            "range": "±0.68%",
            "unit": "ops/sec",
            "extra": "90 samples"
          },
          {
            "name": "recursion: fib(18)",
            "value": 11.47,
            "range": "±0.99%",
            "unit": "ops/sec",
            "extra": "33 samples"
          },
          {
            "name": "recursion: fib-map",
            "value": 713,
            "range": "±0.35%",
            "unit": "ops/sec",
            "extra": "92 samples"
          }
        ]
      },
      {
        "commit": {
          "author": {
            "email": "jcubic@jcubic.pl",
            "name": "Jakub Jankiewicz",
            "username": "jcubic"
          },
          "committer": {
            "email": "jcubic@jcubic.pl",
            "name": "Jakub Jankiewicz",
            "username": "jcubic"
          },
          "distinct": true,
          "id": "12a129ec0b2d26ce202253d1376f9c9c403dfd76",
          "message": "make generator function sync",
          "timestamp": "2026-08-16T20:01:29+02:00",
          "tree_id": "3452ef9637303df20f747add57d990ac72ba6969",
          "url": "https://github.com/jcubic/lips/commit/12a129ec0b2d26ce202253d1376f9c9c403dfd76"
        },
        "date": 1786903384436,
        "tool": "benchmarkjs",
        "benches": [
          {
            "name": "array-map: pow",
            "value": 902,
            "range": "±1.33%",
            "unit": "ops/sec",
            "extra": "91 samples"
          },
          {
            "name": "array-map: mix",
            "value": 883,
            "range": "±0.64%",
            "unit": "ops/sec",
            "extra": "96 samples"
          },
          {
            "name": "recursion: nested loops",
            "value": 1.12,
            "range": "±1.58%",
            "unit": "ops/sec",
            "extra": "7 samples"
          },
          {
            "name": "array-map: string",
            "value": 377,
            "range": "±1.16%",
            "unit": "ops/sec",
            "extra": "91 samples"
          },
          {
            "name": "recursion: fib(18)",
            "value": 15.31,
            "range": "±0.25%",
            "unit": "ops/sec",
            "extra": "42 samples"
          },
          {
            "name": "recursion: fib-map",
            "value": 892,
            "range": "±0.61%",
            "unit": "ops/sec",
            "extra": "93 samples"
          }
        ]
      },
      {
        "commit": {
          "author": {
            "email": "jcubic@jcubic.pl",
            "name": "Jakub Jankiewicz",
            "username": "jcubic"
          },
          "committer": {
            "email": "jcubic@jcubic.pl",
            "name": "Jakub Jankiewicz",
            "username": "jcubic"
          },
          "distinct": true,
          "id": "698ab0bfd447db90ea59e9de9b04e23d1452a654",
          "message": "enable metadata when using calling (trace)",
          "timestamp": "2026-08-16T20:45:06+02:00",
          "tree_id": "c38c2fa04cba60ea00a29ef4d90ef50b1ad5fd0c",
          "url": "https://github.com/jcubic/lips/commit/698ab0bfd447db90ea59e9de9b04e23d1452a654"
        },
        "date": 1786905999882,
        "tool": "benchmarkjs",
        "benches": [
          {
            "name": "array-map: pow",
            "value": 738,
            "range": "±1.73%",
            "unit": "ops/sec",
            "extra": "92 samples"
          },
          {
            "name": "array-map: mix",
            "value": 740,
            "range": "±0.55%",
            "unit": "ops/sec",
            "extra": "94 samples"
          },
          {
            "name": "recursion: nested loops",
            "value": 0.88,
            "range": "±0.31%",
            "unit": "ops/sec",
            "extra": "7 samples"
          },
          {
            "name": "array-map: string",
            "value": 319,
            "range": "±0.48%",
            "unit": "ops/sec",
            "extra": "90 samples"
          },
          {
            "name": "recursion: fib(18)",
            "value": 11.79,
            "range": "±0.34%",
            "unit": "ops/sec",
            "extra": "34 samples"
          },
          {
            "name": "recursion: fib-map",
            "value": 738,
            "range": "±3.64%",
            "unit": "ops/sec",
            "extra": "92 samples"
          }
        ]
      },
      {
        "commit": {
          "author": {
            "email": "jcubic@jcubic.pl",
            "name": "Jakub Jankiewicz",
            "username": "jcubic"
          },
          "committer": {
            "email": "jcubic@jcubic.pl",
            "name": "Jakub Jankiewicz",
            "username": "jcubic"
          },
          "distinct": true,
          "id": "eb184013db92a15d52bf16f53de865a738bdd424",
          "message": "fix and improve error handling",
          "timestamp": "2026-08-16T23:58:41+02:00",
          "tree_id": "4986a5e431e7fed6ffcf89e6bceb0d5f2ad21023",
          "url": "https://github.com/jcubic/lips/commit/eb184013db92a15d52bf16f53de865a738bdd424"
        },
        "date": 1786917619581,
        "tool": "benchmarkjs",
        "benches": [
          {
            "name": "array-map: pow",
            "value": 673,
            "range": "±1.64%",
            "unit": "ops/sec",
            "extra": "89 samples"
          },
          {
            "name": "array-map: mix",
            "value": 678,
            "range": "±0.68%",
            "unit": "ops/sec",
            "extra": "92 samples"
          },
          {
            "name": "recursion: nested loops",
            "value": 0.76,
            "range": "±1.10%",
            "unit": "ops/sec",
            "extra": "6 samples"
          },
          {
            "name": "array-map: string",
            "value": 289,
            "range": "±0.42%",
            "unit": "ops/sec",
            "extra": "91 samples"
          },
          {
            "name": "recursion: fib(18)",
            "value": 11.44,
            "range": "±0.29%",
            "unit": "ops/sec",
            "extra": "33 samples"
          },
          {
            "name": "recursion: fib-map",
            "value": 702,
            "range": "±0.63%",
            "unit": "ops/sec",
            "extra": "93 samples"
          }
        ]
      },
      {
        "commit": {
          "author": {
            "email": "jcubic@jcubic.pl",
            "name": "Jakub Jankiewicz",
            "username": "jcubic"
          },
          "committer": {
            "email": "jcubic@jcubic.pl",
            "name": "Jakub Jankiewicz",
            "username": "jcubic"
          },
          "distinct": true,
          "id": "b6d7a818541c5031d477f9b86c67217ffc040d6c",
          "message": "fix promise quotation",
          "timestamp": "2026-08-17T01:01:46+02:00",
          "tree_id": "b6af3d3c09f17fa01b723c6774446452679ef259",
          "url": "https://github.com/jcubic/lips/commit/b6d7a818541c5031d477f9b86c67217ffc040d6c"
        },
        "date": 1786921411696,
        "tool": "benchmarkjs",
        "benches": [
          {
            "name": "array-map: pow",
            "value": 677,
            "range": "±1.50%",
            "unit": "ops/sec",
            "extra": "90 samples"
          },
          {
            "name": "array-map: mix",
            "value": 687,
            "range": "±0.59%",
            "unit": "ops/sec",
            "extra": "93 samples"
          },
          {
            "name": "recursion: nested loops",
            "value": 0.78,
            "range": "±1.05%",
            "unit": "ops/sec",
            "extra": "6 samples"
          },
          {
            "name": "array-map: string",
            "value": 292,
            "range": "±0.62%",
            "unit": "ops/sec",
            "extra": "89 samples"
          },
          {
            "name": "recursion: fib(18)",
            "value": 11.62,
            "range": "±0.17%",
            "unit": "ops/sec",
            "extra": "33 samples"
          },
          {
            "name": "recursion: fib-map",
            "value": 712,
            "range": "±0.77%",
            "unit": "ops/sec",
            "extra": "93 samples"
          }
        ]
      },
      {
        "commit": {
          "author": {
            "email": "jcubic@jcubic.pl",
            "name": "Jakub Jankiewicz",
            "username": "jcubic"
          },
          "committer": {
            "email": "jcubic@jcubic.pl",
            "name": "Jakub Jankiewicz",
            "username": "jcubic"
          },
          "distinct": true,
          "id": "1cd6bf07d44738c9820d696047d8d275ab25fba9",
          "message": "add `async-generator` function",
          "timestamp": "2026-08-17T01:43:23+02:00",
          "tree_id": "bd7f276c24a3ab5c0c75c7f18a463a41ecf6053c",
          "url": "https://github.com/jcubic/lips/commit/1cd6bf07d44738c9820d696047d8d275ab25fba9"
        },
        "date": 1786923897948,
        "tool": "benchmarkjs",
        "benches": [
          {
            "name": "array-map: pow",
            "value": 679,
            "range": "±1.74%",
            "unit": "ops/sec",
            "extra": "89 samples"
          },
          {
            "name": "array-map: mix",
            "value": 688,
            "range": "±0.58%",
            "unit": "ops/sec",
            "extra": "93 samples"
          },
          {
            "name": "recursion: nested loops",
            "value": 0.79,
            "range": "±0.30%",
            "unit": "ops/sec",
            "extra": "6 samples"
          },
          {
            "name": "array-map: string",
            "value": 293,
            "range": "±0.70%",
            "unit": "ops/sec",
            "extra": "90 samples"
          },
          {
            "name": "recursion: fib(18)",
            "value": 11.66,
            "range": "±0.79%",
            "unit": "ops/sec",
            "extra": "33 samples"
          },
          {
            "name": "recursion: fib-map",
            "value": 713,
            "range": "±0.52%",
            "unit": "ops/sec",
            "extra": "91 samples"
          }
        ]
      },
      {
        "commit": {
          "author": {
            "email": "jcubic@jcubic.pl",
            "name": "Jakub Jankiewicz",
            "username": "jcubic"
          },
          "committer": {
            "email": "jcubic@jcubic.pl",
            "name": "Jakub Jankiewicz",
            "username": "jcubic"
          },
          "distinct": true,
          "id": "91a4462e05fce73f15ad2380261cc690da8b42c3",
          "message": "remove trace from -m/--meta CLI flags",
          "timestamp": "2026-08-17T01:49:32+02:00",
          "tree_id": "703a16c5f6d46407370c22b47462ddd1f9119c84",
          "url": "https://github.com/jcubic/lips/commit/91a4462e05fce73f15ad2380261cc690da8b42c3"
        },
        "date": 1786924267888,
        "tool": "benchmarkjs",
        "benches": [
          {
            "name": "array-map: pow",
            "value": 717,
            "range": "±2.68%",
            "unit": "ops/sec",
            "extra": "90 samples"
          },
          {
            "name": "array-map: mix",
            "value": 734,
            "range": "±0.64%",
            "unit": "ops/sec",
            "extra": "95 samples"
          },
          {
            "name": "recursion: nested loops",
            "value": 0.88,
            "range": "±0.63%",
            "unit": "ops/sec",
            "extra": "7 samples"
          },
          {
            "name": "array-map: string",
            "value": 312,
            "range": "±1.04%",
            "unit": "ops/sec",
            "extra": "89 samples"
          },
          {
            "name": "recursion: fib(18)",
            "value": 11.71,
            "range": "±0.29%",
            "unit": "ops/sec",
            "extra": "34 samples"
          },
          {
            "name": "recursion: fib-map",
            "value": 757,
            "range": "±1.09%",
            "unit": "ops/sec",
            "extra": "93 samples"
          }
        ]
      }
    ]
  }
}