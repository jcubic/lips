window.BENCHMARK_DATA = {
  "lastUpdate": 1786826003084,
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
      }
    ]
  }
}