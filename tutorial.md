---
layout: default
title: Miniboxing Tutorial
short_title: Tutorial
---

This page will explain how to use the `@miniboxed` anntotation. Miniboxing is a source-to-source transformation that speeds up generic classes and methods when used with primitive value types, such as `Unit`,`Boolean`, `Byte`, `Char`, `Short`, `Int`, `Float`, `Double` or `Long`.

<p class='paper' markdown='1'>
Before you start using the plugin, please read **this one page**. It will explain how to use the `@miniboxed` annotation, so your program will be optimized properly. Although we don't recommend it, you can skip through to the [example sbt project](example.html) if you don't plan to use miniboxing in your project right now.
</p>

## Quick Facts

Here are a few quick facts about the `@miniboxed` annotation:

* The miniboxing transformation is activated by annotating type parameters with `@miniboxed`, for both classes and methods:
{% highlight scala %}
class C[@miniboxed T](var t: T) {
  def foo(t: T) = t
}
{% endhighlight %}

 * Miniboxing can speed up monomorphic code:
{% highlight scala %}
def bar_good(t: Int) = new C[Int](t).foo()
{% endhighlight %}
In this case, the miniboxing transformation will encounter an instantiation of `C` with type argument `Int`, and will rewrite the `new` instance creation and the `foo` method call to use direct value types, thus speeding up execution and avoiding boxing.

<br/>
 * Miniboxing can't speed up generic code if the type parameters are not annotated with `@miniboxed`:
{% highlight scala %}
def bar_bad[T](t: T) = new C[T](t).foo()
{% endhighlight %}
Since the type parameter `T` of method `bar_bad` is not marked as `@miniboxed`, the erasure transformation will kick in instead of miniboxing. Although the `C` class is transformed by miniboxing, erasure won't perform any program rewriting to improve performance. Therefore, regardless of whether `C` is optimized by miniboxing or not, the performance for `bar_bad` will stay the same. This is intended, since miniboxed code needs to be compatible with erasure-generated code, at the cost of lower performance.

<br/>
 * To recover performance for the previous case, you can annotate the method parameter as `@miniboxed`: 
{% highlight scala %}
def bar_awesome[@miniboxed T](t: T) = new C[T](t).foo()
{% endhighlight %}
Since the type parameter `T` of `bar_awesome` is marked as `@miniboxed`, the method will have two versions: an optimized version for value types and the compatible, erasure-based, slow version of the method. 

## Optimized Trace

While reading the quick facts, you might have wondered whether you can explicitly instantiate the optimized variants of classes or call optimized methods created by miniboxing. Unfortunately the answer is no, you can't, as this would compromise the type safety of the language. Therefore, when using the miniboxing plugin, you will have to pay special attention to making sure the hot methods in your code and the commonly used data structures are rewritten by the compiler to use the optimized variants. Luckily, this is not hard at all, you only need to remember three cases you may find yourself in.

But before we go on to the cases, we need to explain the concept of an **optimized trace**. Let's imagine you're writing a generic k-means algorithm, and the main iteration calls several methods. Ideally, you want the iteration itself and the methods it calls to be the miniboxing-optimized versions. Knowing the optimized methods have a special marking in their name, how could you check your algorithm is using them? One way to do this would be to throw an exception in one of the methods and check the last 2 stack frames -- if the methods have the special miniboxed mark, they are the optimized ones. We call this an **optimized trace**. 

Optimized traces are series of miniboxing-optimized methods that call each other. Let's see an example stack trace, knowing `_J` is one of the markings for miniboxing-optimized methods:

{% highlight scala %}
scala.NotImplementedError: an implementation is missing
	at throwNotImplementedError(<console>) 
                                 // <= optimized trace end (by an inhibitor)
	at sum_J(<console>)      // <=  -- || -- propagation (by a propagator)
        at iter_J(<console>)     // <=  -- || -- propagation (by a propagator)
        at kmeans_J(<console>)   // <=  -- || -- propagation (by a propagator)
        at pre_kmeans(<console>) // <=  -- || -- start (by an initiator)
        at main(<console>)
{% endhighlight %}

In the stack trace above, all our algrithm is miniboxing-optimized, since `kmeans_J`, `iter_J` and `sum_J` all have the miniboxing prefix `_J`, so our algorithm should run efficiently. It is not necessary to have all the program optimized, just the critical parts that execute for a long time. So your task, as a programmer, is to make sure the critical traces in your program only contain miniboxing-marked methods.

That being said, here are the three types of calls that make up the trace:
 * optimized trace **initiators**, which start an optimized trace: method calls where the type argument is a value type and the type parameter is annotated with `@miniboxed`
 * optimized trace **inhibitors**, which end an optimized trace: calls to methods whose type parameter is not marked as `@miniboxed`
 * optimized trace **propagators**, which continue an optimized trace, but only if called from an optimized trace

## An Example, Finally!

Knowing these three cases enables you to make sure the entire trace is optimized. Let's take an example:

{% highlight scala %}
scala> :paste
// Entering paste mode (ctrl-D to finish)

object Test1 {
  def foo[@miniboxed T](t: T): T = 
    throw new Exception("Innermost performance-critical method")
  def bar[@miniboxed T](t: T): T = foo(t)
  def baz[@miniboxed T](t: T): T = bar(t)
}  

def trace(statement: => Unit): Unit =
  try {
    statement
  } catch {
    case e: Exception => 
      // prettify the trace and output it:
      for (frame <- e.getStackTrace.take(3))
        println(frame.toString.replaceAll(".*Test", "Test"))
  }

// Exiting paste mode, now interpreting.

defined module Test1
trace: (statement: => Unit)Unit

scala> trace(Test1.baz(3))
Test1$.foo_n_J(<console>:8)
Test1$.bar_n_J(<console>:9)
Test1$.baz_n_J(<console>:10)
{% endhighlight %}

As before, the `_J` suffix is an indication that the miniboxing-optimized version of the method was executed. We can say the optimized trace was initiated by using a `@miniboxed`-annotated method with a value type.

Now, let's test if we don't initiate the optimized trace:
{% highlight scala %}
scala> trace(Test1.baz("3"))
Test1$.foo(<console>:8)
Test1$.bar(<console>:9)
Test1$.baz(<console>:10)
{% endhighlight %}

As expected, no more `_J`s, so we're using the erasure-based versions! That's because `String` is not a value type, so the optimized trace was not initiated at all. This shows that `foo`, `bar` and `baz` are just propagators: if they are called as part of an optimized trace, they are optimized, but if the optimized trace is not initialized somewhere, the erasure-based slow versions are invoked.

Now, let's see an inhibitor: let us remove the `@miniboxed` annotation from `bar`'s type parameter `T`, in a second object, `Test2`:
{% highlight scala %}
scala> :paste
// Entering paste mode (ctrl-D to finish)

object Test2 {
  def foo[@miniboxed T](t: T): T = 
    throw new Exception("Innermost performance-critical method")
  def bar[T](t: T): T = foo(t)
  def baz[@miniboxed T](t: T): T = bar(t)
}

defined module Test2

scala> trace(Test2.baz(3))
Test2$.foo(<console>:8)
Test2$.bar(<console>:9)
Test2$.baz_n_J(<console>:10)
{% endhighlight %}

The result shouldn't surprise you: the optimized trace was inhibited, since method `bar` does not have an optimized version at all (e.g. the bytecode for object `Test2` doesn't contain `bar_n_J` at all). But the thing to look out for is that **erasure-based versions of the code will always call the erasure-based versions of other methods**. This is why, although `foo` has an optimized version, it won't be called. 

## Classes as Data Structures

We will now focus more on classes. Classes encapsulate both data and code, but, in order to simplify things, we will first consider only data. As you probably figured out already, miniboxing transformed methods have two versions: a generic, erasure-compatible one, and an optimized, value type-carrying one. Pretty much the same happens to a class: it will be transformed into two classes, a generic, erasure-compatible one, and an optimized one:

{% highlight scala %}
class D[@miniboxed T](t: T)
{% endhighlight %}

A very rough approximation of the transformed code for `class D` is:

{% highlight scala %}
trait D[T] { ... }  // common interface between the two
class D_L[T](t: T) extends D[T] { ... }    // generic
class D_J[T](t: Long) extends D[T] { ... } // optimized
{% endhighlight %}

The reason classes are duplicated is because they store data: since references and value types are incompatible on the Java Virtual Machine, we have to duplicate the class, such that the object layout is adapted for the type it is carrying.

The optimized version of the class is created by the instantiation: `new D[U](...)`. The generic version, `D_L` is used, except for two specific cases, when the instantation is rewritten to create the optimized version `D_J`:
 * if the type argument `U` is known and is a value type: `new D[Int](3)`, which is rewritten to `new D_J[Int](3)`
 * if in the class or method containing type parameter `U` is marked with `@miniboxed`, then the optimized version of that class or method will use the optimized version of the class:

{% highlight scala %}
class E[@miniboxed U] {
  def foo(u: U): D[U] = new D[U](u)
}
// E_L will create a D_L instance
// E_J will create a D_J instance
{% endhighlight %}

This corresponds to some extent to the previous 3 cases:
 * optimized trace initiators always create the optimized instance of the class
 * optimized trace propagators create the optimized instance only in their optimized version (`E_L` creates `D_L`, `E_J` creates `D_J` instances)
 * optimized trace inhibitors always create the generic instance of the class


## Classes as Optimized Trace Initiators

Finally, we come to the last point: the code encapsulated in classes. We won't go into details on how this is achieved, but calling a method on an optimized instance of a class (`z_opt` in this case) behaves like an initiator, while calling a method on a generic instance of a class (`z_gen`) behaves as an inhibitor:

{% highlight scala %}
scala> :paste
// Entering paste mode (ctrl-D to finish)

object Test3 {
  class Z[@miniboxed T](t: T) {
    def foo() = trace(Test1.baz(t))
  }

  val z_opt: Z[_] = new Z(3)
  val z_gen: Z[_] = new Z("x")
}

// Exiting paste mode, now interpreting.
defined module Test3

scala> Test3.z_opt.foo()
Test1$.foo_n_J(<console>:8)
Test1$.bar_n_J(<console>:9)
Test1$.baz_n_J(<console>:10)

scala> Test3.z_gen.foo()
Test1$.foo(<console>:8)
Test1$.bar(<console>:9)
Test1$.baz(<console>:10)
{% endhighlight %}
(see [this bug](https://github.com/miniboxing/miniboxing-plugin/issues/53) in [miniboxing-plugin](https://github.com/miniboxing/miniboxing-plugin/))

## Closing Remarks

For an alert reader, this section probably raised many more questions than it answered. The [transformation page](transformation.html) explains the internals of miniboxing, and can answer all your questions, both on the theory and the implementation. Still, as a programmer using miniboxing, what you already know is enough to make sure your performance-critical code is optimized, and you can jump to the [example project page](example.html).

Skipping one step ahead, the `-P:minibox:log` flag passed to the Scala compiler will output all details on how classes are transformed and how their members are affected:

{% highlight text %}
scala> class D[@miniboxed T](val t: T)
Specializing class D...

  // interface:
  abstract trait D[T] extends Object {
    val t(): T                                                            
    val t_J(val T_TypeTag: Byte): Long                                    
  }

  // specialized class:
  class D_J[Tsp] extends D[Tsp] {
    def <init>(val iw$D_J|T_TypeTag: Byte,t: Long): D_J[Tsp]               
      // is a specialized implementation of constructor D
    private[this] val iw$D_J|T_TypeTag: Byte
      // no info
    private[this] val t: Long
      // is a specialized implementation of value t
    val t(): Tsp
      // is a forwarder to value t_J
    val t_J(val T_TypeTag: Byte): Long
      // is a setter or getter for value t
  }

  // specialized class:
  class D_L[Tsp] extends D[Tsp] {
    def <init>(t: Tsp): D_L[Tsp]
      // is a specialized implementation of constructor D
    private[this] val t: Tsp
      // is a specialized implementation of value t
    val t(): Tsp
      // is a setter or getter for value t
    val t_J(val T_TypeTag: Byte): Long
      // is a forwarder to value t
  }

defined class D
{% endhighlight %}

