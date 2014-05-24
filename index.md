---
layout: default
title: Miniboxing Plugin for Scala
short_title: Welcome
comments: "off"
---

Miniboxing is a research project at [EPFL](http://lamp.epfl.ch) aimed at improving the performance of generic code running on the Java Virtual Machine. Compared to [Scala specialization](http://days2010.scala-lang.org/node/138/151/15-7-E%20-%20Specialization%20-%20Dragos.mp4), miniboxing typically produces 4-100x less bytecode, thus paving the way for [deeply specialized Scala collections](https://github.com/MelodyLucid/freezing-ironman). In turn, miniboxed collections can perform an order of magnitude faster operations for primitive numeric types, such as integers or floating point numbers. 

Miniboxing is implemented as a [Scala compiler](http://scala-lang.org) plugin which you can [easily try on your project](/using-sbt.html).

{% include status.md %}

We sped up by 2x a mock-up Scala collection on an implementation of the _Least Square method_, a procedure which finds the best-fitting linear curve to a given set of points. Basically, we made a custom library that we applied to the following benchmark :

{% highlight scala %}
  // list of (x,y) coordinates:
  val xy = xx.zip(yy)
  
  // function (x, y) => x * y
  val mult = new Function1[Tuple2[Double,Double], Double] {
    def apply(t: Tuple2[Double, Double]): Double = t._1 * t._2
  }
  
  // function x => x * x
  val square = new Function1[Double, Double] {
    def apply(x: Double): Double = x * x
  }

  // intermediary sums:
  val sumx  = xx.sum
  val sumy  = yy.sum
  val sumxy = xy.map(mult).sum
  val sumsquare = xx.map(square).sum
  
  // slope and intercept approximation:
  val slope = (size*sumxy - sumx*sumy) / (size*sumsquare - sumx*sumx)
  val intercept = (sumy*sumsquare - sumx*sumxy) / (size*sumsquare - sumx*sumx)
{% endhighlight %}

We ran this method with two different versions of the library, one with the plugin activated, and one without, for different amount of points. This has led to following results :

<center><img width="90%" src="/graphs/lsm.png" title="Yes, we also used the Least Square method to draw the graph"/></center>

After 500,000 points, the results show a speedup of 2x for the Miniboxed collection.

Using miniboxing is as easy as adding an annotation:
{% highlight scala %}
class C[@miniboxed T](val t: T)
{% endhighlight %}

And adding a compiler plugin to your [sbt build](/using_sbt.html) or [command line](/using_out.html).

To learn more, read the [introduction to miniboxing](/intro.html).

