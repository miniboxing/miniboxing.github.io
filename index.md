---
layout: default
title: Miniboxing Plugin for Scala
short_title: Welcome
comments: "off"
---

Miniboxing is a research project at [EPFL](http://lamp.epfl.ch) aimed at improving the performance of generic code running on the Java Virtual Machine. It is implementedas a [Scala compiler](http://scala-lang.org) plugin, and can speed up generics by up to 22x when used for numeric types, such as integer or double.

Using miniboxing is as easy as adding an annotation:
{% highlight scala %}
$ cat C.scala 
class C[@miniboxed T](val t: T)

$ scalac -bootclasspath miniboxing-runtime.jar:miniboxing-plugin.jar \
         -Xplugin:miniboxing-plugin.jar \ 
         -P:minibox:log \
         -optimize \
         C.scala
         
Specializing class C...

  // interface:
  abstract trait C[T] extends Object {
    val t(): T                                                            
    val t_J(val T_TypeTag: Byte): Long                                    
  }

  // specialized class:
  class C_J[Tsp] extends C[Tsp] {
    def <init>(val C_J|T_TypeTag: Byte,t: Long): C_J[Tsp] // is a specialized implementation of constructor C
    private[this] val C_J|T_TypeTag: Byte                 // no info
    private[this] val t: Long                             // is a specialized implementation of value t
    val t(): Tsp                                          // is a forwarder to value t_J
    val t_J(val T_TypeTag: Byte): Long                    // is a setter or getter for value t
  }

  // specialized class:
  class C_L[Tsp] extends C[Tsp] {
    def <init>(t: Tsp): C_L[Tsp]                          // is a specialized implementation of constructor C
    private[this] val t: Tsp                              // is a specialized implementation of value t
    val t(): Tsp                                          // is a setter or getter for value t
    val t_J(val T_TypeTag: Byte): Long                    // is a forwarder to value t
  }

{% endhighlight %}

Learn more about miniboxing by reading the [introduction](intro.html).
