---
layout: default
title: MbArray Tutorial
short_title: MbArray Tutorial
---

`MbArray` is an indexed sequence container that matches the performance of raw arrays when used in miniboxed contexts. Also, unlike arrays, MbArray creation does not require the presence of a ClassTag, which makes it more versatile. This page will describe the motivation behind MbArray and will show how to use it through examples. 

## Motivation

Raw arrays offer the best access performance for primitive types, but they can only be instantiated in generic contexts if a ClassTag is present -- which is not always possible. Consider the following code :


```
scala> class A[T](len: Int) {
     | val array = new Array[T](len)
     | }
<console>:8: error: cannot find class tag for element type T
       val array = new Array[T](len)
```


Now would it be possible to have the performances of an array without its drawbacks? 
Well, this is the main purpose of the `MbArray`, when used with the miniboxing transformation.
The following code equivalent performance-wise to the one above, except that it works without requiring any condition on `T`.


```
scala> class B[@miniboxed T](len :Int) {
     | val array = MbArray.empty[T](len)
     | }
Specializing class B...

defined class B
```


MbArrays are included in the runtime support package for the miniboxing transformation. To see how to add miniboxing to your project, please see [this page](tutorial.md).

## Usage

## Conclusion

MbArray is therefore a great choice of the underlying container for any custom collection, as it does not impose additional conditions on the type parameter(s) of the collection, without compromising the performances.

{% include status.md %}
