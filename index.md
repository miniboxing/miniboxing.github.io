---
layout: default
title: Miniboxing Plugin for Scala
short_title: Welcome
comments: "off"
---

Miniboxing is a program transformation that improves the performance of Scala generics when used with primitive types. [It can speed up generic collections by factors between 1.5x and 22x](/benchmarks.html), while maintaining bytecode duplication to a minimum.

Using miniboxing is as easy as adding the `@miniboxed` annotation to your program and the compiler plugin to your [sbt build](/using_sbt.html) or [command line](/using_out.html).

For more information, see the **[introduction to miniboxing](/intro.html)** and **[the tutorial](/tutorial.html)**.

## Presentation

If you prefer video presentations, you may like the PNWScala talk on miniboxing: <br/><br/>

<center>
<iframe width="800px" height="400px" src="//www.youtube.com/embed/RnIupOJv_oM" frameborder="0" allowfullscreen></iframe>
<!--<iframe type="text/html" width="800px" height="400px" mozallowfullscreen="true" allowfullscreen="true" webkitallowfullscreen="true" src="//www.parleys.com/share.html#play/53a7d2d0e4b0543940d9e567" frameborder="0">&lt;br /&gt;</iframe>-->
</center>

**If you want to follow the live demo in the presentation on your own, [you can use this tutorial](/example_pureimage.html).**

## Disclaimer

{% include status.md %}
