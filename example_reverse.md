---
layout: default
title: Array Reverse Example
short_title: Array Reverse Example
---

This page will show the miniboxing plugin speeding up a method reversing arrays. The example relies on the [example sbt project](example.html) and assumes you will execute the commands in the scala interpreter. 

For the benchmark, we reverse a 10M integer array, and compare the performance of the generic version and the miniboxed version. You get **4-9x speedups** by adding a single `@miniboxed` annotation:

{% highlight scala %}
scala> def reverse_gen[T](array: Array[T]): Unit = ...

scala> def reverse_mb[@miniboxed T](array: Array[T]): Unit = ...

scala> benchmark(() => reverse_gen(array))
Time: 32 ms

scala> benchmark(() => reverse_mb(array))
Time: 8 ms
{% endhighlight %}

To run the benchmark, start by cloning the [miniboxing-example](https://github.com/miniboxing/miniboxing-example) project and running the Scala interpreter console:

{% highlight bash %}
$ git clone https://github.com/miniboxing/miniboxing-example.git
Cloning into 'miniboxing-example'...
remote: Counting objects: 42, done.
remote: Compressing objects: 100% (29/29), done.
remote: Total 42 (delta 11), reused 28 (delta 6)
Unpacking objects: 100% (42/42), done.
 
$ cd miniboxing-example/
 
$ sbt console
Detected sbt version 0.13.0-RC4
 
[...]
 
Welcome to Scala version 2.10.3-20130923-060037-e2fec6b28d (Java ...).
Type in expressions to have them evaluated.
Type :help for more information.
 
scala> // benchmarking method
{% endhighlight %}

Then insert the following code in the console:
{% highlight scala %}
scala> :paste
// Entering paste mode (ctrl-D to finish)

// benchmarking method
def benchmark(f: () => Unit) = {
  var i = 0
 
  // warmup
  while (i < 1000) {
    f()
    i += 1
  }
 
  // measure
  var t = System.currentTimeMillis
  f()
  t = System.currentTimeMillis - t
 
  // report
  println(s"Time: $t ms")
}
 
// generic reverse
def reverse_gen[T](array: Array[T]): Unit = {
  var idx = 0
  var xdi = array.length - 1
  while (idx < xdi) {
    val tmp1 = array(idx)
    val tmp2 = array(xdi)
    array(idx) = tmp2
    array(xdi) = tmp1
    idx += 1
    xdi -= 1
  }
}
 
// miniboxed reverse
def reverse_mb[@miniboxed T](array: Array[T]): Unit = {
  var idx = 0
  var xdi = array.length - 1
  while (idx < xdi) {
    val tmp1 = array(idx)
    val tmp2 = array(xdi)
    array(idx) = tmp2
    array(xdi) = tmp1
    idx += 1
    xdi -= 1
  }
}
 
val array = (1 to 10000000).toArray

// Exiting paste mode, now interpreting.

benchmark: (f: () => Unit)Unit
reverse_gen: [T](array: Array[T])Unit
reverse_mb: [T](array: Array[T])Unit
array: Array[Int] = Array(...)
scala> 

{% endhighlight %}

Finally, you can run the benchmark:

{% highlight scala %}
scala> benchmark(() => reverse_gen(array))
Time: 32 ms

scala> benchmark(() => reverse_mb(array))
Time: 8 ms
{% endhighlight %}

Depending on the size of the heap memory given to `sbt`, the performance gains can be **4-9x** with a single `@miniboxed` annotation added in the right place. :)
