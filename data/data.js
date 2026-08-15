window.BENCHMARK_DATA = {
  "lastUpdate": 1786792043632,
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
      }
    ]
  }
}