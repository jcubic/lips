window.BENCHMARK_DATA = {
  "lastUpdate": 1786736999477,
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
      }
    ]
  }
}