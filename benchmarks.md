---
layout: default
title: Benchmarks
short_title: Benchmarks
---

{% include oopsla.md %}

The OOPSLA papers presents several benchmarks:

* performance microbenchmarks
  * on the HotSpot JVM with the Server compiler
  * on the HotSpot JVM with the Graal compiler
* interpreter performance microbenchmarks
* bytecode size
* classloader overhead
  * performance impact
  * heap consumption

In short, miniboxed code:
* is up to *22x faster* than generic code
* matches the performance of specialization
* is marginally slower compared to monomorphic code

{% include oopsla2.md %}
