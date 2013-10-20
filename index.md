---
layout: default
title: Miniboxing Plugin for Scala
short_title: Welcome
comments: "off"
---

Miniboxing is a research project at [EPFL](http://lamp.epfl.ch) aimed at improving the performance of generic code running on the Java Virtual Machine. It is implementedas a [Scala compiler](http://scala-lang.org) plugin, and can speed up generics by up to 22x when used for numeric types, such as integer or double.

Using miniboxing is as easy as adding an annotation:
{% highlight scala %}
class Vector[@miniboxed T](start: Int, end: Int) {
  ...
}
{% endhighlight %}

Learn more about miniboxing by reading the [introduction](intro.html).
