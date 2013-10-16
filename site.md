---
layout: default
title: Miniboxing Plugin for Scala
short_title: Welcome
---

Miniboxing is a compilation scheme that improves the performance of generics in [Scala](http://scala-lang.org).

Let''s take `class C` as an example:

```
 class C[T](t: T)
```

Under the [erasure](http://en.wikipedia.org/wiki/Type_erasure) [transformation](http://homepages.inf.ed.ac.uk/wadler/gj/) in Scala, the value `t` is a pointer to a heap object. This is suboptimal, since integers and floating point numbers should be stored directly in the class, instead of separate heap objects. Using separate objects to store primitive types, a process known as [boxing](http://en.wikipedia.org/wiki/Object_type_%28object-oriented_programming%29#Boxing) has several disadvantages:
 * uses more heap memory than necessary, as the objects containing primitive types also contain headers and padding bits
 * makes access to primitive value types indirect, thus slowing down program execution
 * objects storing primitive values need to be garbage collected, as they are not eliminated together with the class
 * objects potentially break cache locality: an array of integers as values guarantees they are stored contiguously, thus guarantees locality. Contrarily, accessing an array of pointers to objects encoding integers only guarantees pointers are stored contiguously, but the objects can be randomly spread around the heap.

This is exactly where miniboxing comes in:
```
 class C[@miniboxed T](t: T)
```

Now, if you use `C` to store an integer, it will be stored in the class instead of a separate object:
```
 new C[Int](3) // this instance of C will store the 3 inside it
               // instead of creating a new java.lang.Integer
               // and storing the pointer to it, as in erasure.
```

A few common questions:
 * Does this mean better performance? [Sure thing, check out our benchmarks: they show up to 22x speedups](benchmarks.html).
 * How can I start using miniboxing? [Have a look at the Usage page](usage.html).
 * How does miniboxing work? [Have a look at the X page](X).
 * How can I start hacking on the plugin? [Have a look at the Contributing page](contributing.html).

Miniboxing is a research project in the [Programming Methods laboratory](http://lamp.epfl.ch) at [EPFL](http://epfl.ch). 


#  News

* _16 Oct 2013_ -- Site is online!
