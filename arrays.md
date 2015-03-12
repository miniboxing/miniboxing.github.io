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
     |   val array = new Array[T](len)
     | }
{% endhighlight %}

Pressing enter will result in the following error :

{% highlight scala %}
<console>:8: error: cannot find class tag for element type T
       val array = new Array[T](len)
{% endhighlight %}

This could be addressed, at the expense of performance, by letting the scala runtime have access to type informations about `T` using a `ClassTag` from `scala.reflect` : 

{% highlight scala %}
scala> import scala.reflect._
import scala.reflect._

scala> class B[T : ClassTag](len: Int) {
     |   val array = new Array[T](len)
     | }
defined class B
{% endhighlight %}

While this works, it may not be sufficiently fast for algorithms where high performance is expected. Instead, `MbArray` combined with the miniboxing transformation offers performances that are similar to those of raw arrays without having to carry around a `ClassTag`. The following code will work without requiring any condition on `T`. On top of that, any read or write to the array will perform better.

{% highlight scala %}
scala> class C[@miniboxed T](len :Int) {
     |   val array = MbArray.empty[T](len)
     | }
Specializing class C...

  ... (The miniboxing transformation operates)

defined class C
{% endhighlight %}

MbArrays are included in the runtime support package for the miniboxing transformation. To see how to add miniboxing to your project, please see [this page](example.html).

## Usage

Let's take a closer look at how exactly a program can be transformed to take full advantage of the miniboxing transformation and MbArrays. Consider a classic implementation of the merge sort algorithm using a raw `Array` with an implicit `ClassTag` :

{% highlight scala %}
import scala.reflect._
import scala.util._

object MergeSort {
  def mergeSort[T : ClassTag](ary: Array[T], comp: (T, T)=>Boolean): Array[T] = {
    def merge(a: Array[T], b: Array[T]): Array[T] = {
	  val res = new Array[T](a.length + b.length)
	  var ai = 0
	  var bi = 0
	  while (ai < a.length && bi < b.length) {
	    if (comp(a(ai), b(bi))) {
		  res(ai + bi) = a(ai)
		  ai += 1
	    } else {
		  res(ai + bi) = b(bi)
		  bi += 1
	    }
	  }
	  while (ai < a.length) {
		  res(ai + bi) = a(ai)
		  ai += 1
	  }
	  while (bi < b.length) {
		  res(ai + bi) = b(bi)
		  bi += 1
	  }
	  res
	}
	val len = ary.length
     if (len <= 1) ary
	else {
       val mid = len / 2
	  val a = new Array[T](mid)
	  val b = new Array[T](len - mid)
	  
	  for (i <- 0 until mid) a(i) = ary(i)
	  for (i <- mid until len) b(i - mid) = ary(i)
	  
	  merge(mergeSort(a, comp), mergeSort(b, comp))
	}
  }
  
  def main(args: Array[String]) = {
    val ary = new Array[Int](50)
    val rnd = new Random
    for (i <- 0 until len) {
      ary(i) = rnd.nextInt(len)
    }
    val sorted = mergeSort(ary, (a: Int, b: Int) => a < b)
  }
}
  
{% endhighlight %}

### The transformation

Now let's transform the code above such that it uses miniboxing and MbArrays. 

1. Let's first add the line `import MbArray._`.
2. Then, replace all occurences of the type `Array[T]` by `MbArray[T]`, and all the array instantiations `new Array[T](...)` by `MbArray.empty[T](...)`. 
3. Finally, remove the `ClassTag` bound on the type parameter `T`.

Compiling at this point will yield the following output :

```
[warn] (...) The method MergeSort.mergeSort would benefit from miniboxing type parameter T, since it is instantiated by a primitive type.
[warn]     val sorted = mergeSort(ary, (a: Int, b: Int) => a < b)
[warn]                  ^
[warn] (...) The following code instantiating an `MbArray` object cannot be optimized since the type argument is not a primitive type (like Int), a miniboxed type paramter or a subtype of AnyRef. This means that primitive types could end up boxed:
[warn]    val res = MbArray.empty[T](a.length + b.length)
[warn]                      ^
[warn] (...) The following code instantiating an `MbArray` object cannot be optimized since the type argument is not a primitive type (like Int), a miniboxed type paramter or a subtype of AnyRef. This means that primitive types could end up boxed:
[warn]    val a = MbArray.empty[T](mid)
[warn]                    ^
[warn] (...) The following code instantiating an `MbArray` object cannot be optimized since the type argument is not a primitive type (like Int), a miniboxed type paramter or a subtype of AnyRef. This means that primitive types could end up boxed:
[warn]    val b = MbArray.empty[T](len - mid)
[warn]                    ^
[warn] 5 warnings found
```
 
The miniboxing plugin informs us that code is suboptimal and could get faster if we were to use the `@miniboxed` annotation on the type parameter `T`. After proceeding and compiling again, we observe that there are no more warnings and our code has been successfully optimized by the miniboxing transformation.

### Benchmarks

## Conclusion

MbArray is therefore a great choice of the underlying container for any custom collection, as it does not impose additional conditions on the type parameter(s) of the collection, without compromising the performances.

{% include status.md %}
