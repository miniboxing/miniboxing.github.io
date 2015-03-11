---
layout: default
title: MbArray Tutorial
short_title: MbArray Tutorial
---

`MbArray` is an indexed sequence container that matches the performance of raw arrays when used in miniboxed contexts. Also, unlike arrays, MbArray creation does not require the presence of a ClassTag, which makes it more versatile. This page will describe the motivation behind MbArray and will show how to use it through examples. 

## Motivation

Raw arrays offer the best access performance for primitive types, but they can only be instantiated in generic contexts if a ClassTag is present -- which is not always possible. Consider typing the following code in the REPL :

{% highlight scala %}
scala> class A[T](len: Int) {
     | val array = new Array[T](len)
     | }
{% endhighlight %}

Pressing enter will result in the following error :

{% highlight scala %}
<console>:8: error: cannot find class tag for element type T
       val array = new Array[T](len)
{% endhighlight %}

This can be fixed by letting the scala runtime have access to type informations about `T` using a `ClassTag` : 

{% highlight scala %}
scala> import scala.reflect._
import scala.reflect._

scala> class B[T : ClassTag](len: Int) {
     | val array = new Array[T](len)
     | }
defined class B
{% endhighlight %}

Now would it be possible to have the performances of an array without having to carry around a ClassTag ? 
Well, this is the main purpose of the `MbArray`, when used in combination with the miniboxing transformation.
The following code is equivalent performance-wise to the one above, except that it works without requiring any condition on `T`.

{% highlight scala %}
scala> class B[@miniboxed T](len :Int) {
     | val array = MbArray.empty[T](len)
     | }
Specializing class B...

defined class B
{% endhighlight %}

MbArrays are included in the runtime support package for the miniboxing transformation. To see how to add miniboxing to your project, please see [this page](tutorial.md).

## Usage

## Conclusion

MbArray is therefore a great choice of the underlying container for any custom collection, as it does not impose additional conditions on the type parameter(s) of the collection, without compromising the performances.

{% include status.md %}
