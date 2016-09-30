---
layout: default
title: Miniboxing Plugin for Scala
short_title: Welcome
comments: "off"
---

<br/>

Miniboxing is a program transformation that improves the performance of Scala generics when used with primitive types. [It can speed up generic collections by factors between 1.5x and 22x](/benchmarks.html), while maintaining bytecode duplication to a minimum. <a href="using_sbt.html"><b>You can easily add miniboxing to your sbt project.</b></a>

<br/>

<center>
<iframe width="800px" height="400px" src="//www.youtube.com/embed/NshGH7qlgEg" frameborder="0" allowfullscreen></iframe>
<!--<iframe type="text/html" width="800px" height="400px" mozallowfullscreen="true" allowfullscreen="true" webkitallowfullscreen="true" src="//www.parleys.com/share.html#play/53a7d2d0e4b0543940d9e567" frameborder="0">&lt;br /&gt;</iframe>-->
</center>


## Why use Miniboxing?

**Performance** The miniboxing plugin improves generics performance and has been tested on <a href="example_linkedlist.html">linked lists</a>, <a href="example_rrbvector.html">vectors</a>, <a href="example_streams.html">streams</a>, <a href="example_pureimage.html">image processing</a> and <a href="benchmarks.html">other examples</a>.

**Advisories** Miniboxing issues actionable performance advisories while compiling the code, so programmers know what they need to do to improve the performance of their code. 

**Integration** The miniboxing transformation reuses the machinery in the Scala compiler, so it can easily and reliably integrate with existing tools, such as the Scala IDE and the IntelliJ Scala plugin.

## Disclaimer

{% include status.md %}
