---
layout: default
title: Introduction to Miniboxing
short_title: Introduction
---

Miniboxing is a compilation scheme that improves the performance of generics in [the Scala programming language](http://scala-lang.org). The miniboxing transformation is generic enough to be potentially useful for any statically typed language running on one of the Java Virtual Machines, such as [Managed X10](http://x10-lang.org), [Kotlin](http://kotlin.jetbrains.org/) or [Ceylon](http://ceylon-lang.org).

We'll start by following what happens to a generic class, as it gets compiled. Let's take `class C` as an example:

{% highlight scala %}
 class C[T](t: T)
{% endhighlight %}

After compiling this class to Java Virtual Machine bytecode, under the <a href="http://en.wikipedia.org/wiki/Type_erasure" target="_blank">erasure</a> <a href="http://homepages.inf.ed.ac.uk/wadler/gj/" target="_blank">transformation</a> one would get bytecode which roughly corresponds to:

{% highlight scala %}
 class C {
   var t: Object = _         // field
   def C(t: Object): C = {   // constructor
     this.t = t
   }
 }
{% endhighlight %}

As you can see, erasure transformed `t` from a generic value into a pointer to a heap object. While this is perfectly suited for storing a string or another class inside `class C`, it becomes suboptimal when dealing with primitive value types, such as booleans, bytes, integers and floating point numbers.

The reason it's suboptimal is because primitive value types are not heap objects but values passed on the stack, so under the Java Virtual Machine it is common to encode them as heap objects, a process known as <a href="http://en.wikipedia.org/wiki/Object_type_%28object-oriented_programming%29#Boxing" target="_blank">boxing</a>.

But boxing primitive values has several disadvantages:

* it uses more heap memory than necessary, as the objects containing primitive types also contain headers and padding bits
* it makes access to primitive value types indirect, thus slowing down program execution (also known as chasing pointers)
* objects storing primitive values need to be garbage collected, as they are not eliminated together with the class
* objects potentially break cache locality: an array of integers as values guarantees they are stored contiguously, thus guarantees locality. Contrarily, accessing an array of pointers to objects encoding integers only guarantees pointers are stored contiguously, but the objects can be randomly spread around the heap.

As you can probably figure out from the list of disadvantages, that's a major drawback in terms of performance. This is exactly where miniboxing comes in:

{% highlight scala %}
 class C[@miniboxed T](t: T)
{% endhighlight %}

By adding the `@miniboxed` annotation, if you use `C` to store an integer, it will be stored in the class instead of a separate object:

{% highlight scala %}
 new C[Int](3) // this instance of C will store the 3 inside it
               // instead of creating a new java.lang.Integer
               // and storing the pointer to it, as in erasure.
{% endhighlight %}

[Benchmarks](/benchmarks.html) have shown the miniboxing transformation can speed up generic code by up to 22x when used with integers.

## Comparison to Specialization

If you're familiar with Scala, you'll probably wonder at this point how miniboxing compares to <a href="http://infoscience.epfl.ch/record/150134" target="_blank">specialization</a>, and why should you use miniboxing instead of specialization.

**Short answer:** because it matches the performance of specialization, without the bytecode blowup. For the `Tuple3` class:

{% highlight scala %}
case class Tuple3[@specialized +T1, @specialized +T2, @specialized +T3]
                 (_1: T1, _2: T2, _3: T3)
{% endhighlight %}

Specialization generates **1000 classes**. Just change `@specialized` to `@miniboxed` and you get **only 8 classes**.

**Long answer:** Aside from reducing the bytecode size, the miniboxing technique improves important aspects of specialization:

* miniboxing-specialized classes don't inherit generic fields (see <a href="https://issues.scala-lang.org/browse/SI-3585" target="_blank">SI-3585</a>);
* miniboxing-specialized classes can inherit from their miniboxing-specialized parents (see <a href="https://issues.scala-lang.org/browse/SI-8405" target="_blank">SI-8405</a>).

While there's certainly an overlap between specialization and miniboxing, both in terms of ideas and implementation (miniboxing reuses some of the code from specialization), we hope miniboxing will soon reach the maturity necessary to replace specialization in the Scala compiler.

## Next Steps

 * If you want to start using miniboxing in your project, have a look at the [sbt configuration necessary](/use_sbt.html).
 * If you're interested in how miniboxing works, have a look at the [transformation description](/transformation.html).


