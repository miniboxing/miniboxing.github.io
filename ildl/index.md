---
layout: default
title: Data-Centric Metaprogramming with ildl (Incremental Late Data Layout)
short_title: Data-Centric Metaprogramming with ildl
---

<img src="/images/ildl-frog.png" width="18%" align="right">

iLDL is a Scala compiler transformation that enables data-centric metaprogramming. Using the ildl compiler plugin, developers can target any composed data structure within their program and designate a better memory representation for it. Based on this information, the Scala compiler automatically replaces the original data structure by the improved representation without any change on the programmer side.

We have tested several cases of data-centric metaprogramming, [with exceptional results](#benchmarks). We also have a [paper and a poster](#paper-and-poster) describing the technique.

<br/>

<script async class="speakerdeck-embed" data-id="6fa0f3eecf43458b9315bb4f861da8c0" data-ratio="1.33333333333333" src="//speakerdeck.com/assets/embed.js"></script>


## Paper and Poster
<br/>
<center>
<a href="https://github.com/miniboxing/miniboxing-plugin/blob/wip/docs/2015-08-ildl-oopsla.pdf?raw=true" target="_blank"><img src="/images/ildl-paper.png" width="45%" style="border:3px solid black; box-shadow: 10px 10px 5px #888888;"/></a>&nbsp;
<a href="https://github.com/miniboxing/miniboxing-plugin/blob/wip/docs/2015-05-ildl-poster.pdf?raw=true" target="_blank"><img src="/images/ildl-poster.png" width="45%" style="border:3px solid black; box-shadow: 10px 10px 5px #888888;"/></a>
</center>

<br/>

## Benchmarks

Several benchmarks are available on the <a href="https://github.com/miniboxing/ildl-plugin/wiki" target="_blank">project wiki</a>:

* <a href="https://github.com/miniboxing/ildl-plugin/wiki/Sample-%7E-Data-Encoding" target="_blank">Tweaking the Data Encoding</a>
* <a href="https://github.com/miniboxing/ildl-plugin/wiki/Sample-%7E-Efficient-Collections" target="_blank">Tweaking Collections</a>
* <a href="https://github.com/miniboxing/ildl-plugin/wiki/Sample-%7E-Deforestation" target="_blank">Lazyfying Operations (Deforestation)</a>
* <a href="https://github.com/miniboxing/ildl-plugin/wiki/Sample-%7E-Array-of-Struct" target="_blank">Improving Locality</a>

You can find more on the transformation <a href="https://github.com/miniboxing/ildl-plugin/wiki" target="_blank">here</a>.


## Other Talks

### EcoCloud 2015 

<script async class="speakerdeck-embed" data-id="369827bc85ee43ff9194ff4f8661559e" data-ratio="1.33333333333333" src="//speakerdeck.com/assets/embed.js"></script>

