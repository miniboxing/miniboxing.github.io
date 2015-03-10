---
layout: default
title: MbArray Tutorial
short_title: MbArray Tutorial
---

## What is MbArray ?

`MbArray` is an array wrapper providing basic random access operations which are optimized for primitive types, while still being completely generic. When instantiated in a generic context, the default scala `Array` would require the type parameter to have information about itself available at runtime using a `Manifest` or a `TypeTag` view bound, whereas an `MbArray` can be instantiated without any constraint on its type parameter, while still offering performances that are similar to those of an `Array`. 

Consider the following declarations :

{% highlight scala %}
class A[T](len: Int) {
    val array = new Array[T](len)
}
{% endhighlight %}

The code above is invalid scala and would not compile.

{% highlight scala %}
class B[T](len: Int) {
    val array = MbArray.empty[T](len)
}
{% endhighlight %}

The code above is valid scala but is suboptimal, as it could be automatically optimized when B is instantiated with a primitive type parameter by adding the `@miniboxed` annotation to the type parameter as below.

{% highlight scala %}
class C[@miniboxed T](len: Int) {
    val array = MbArray.empty[T](len)
}
{% endhighlight %}

MbArray is therefore a great choice of the underlying container for any custom collection, as it does not impose additional conditions on the type parameter(s) of the collection, without compromising the performances.

{% include status.md %}
