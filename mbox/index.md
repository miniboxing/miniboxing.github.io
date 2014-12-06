---
layout: default
title: Miniboxed Value Encoding
short_title: Miniboxed Value Encoding
---

{% include oopsla.md %}

<img src="/images/mbox.png" width="17%" align="right">

The miniboxing plugin encodes all primitive values into long integers. To find out why, see the following resources:

## Paper and Poster
<br/>
<center>
<a href="https://github.com/miniboxing/miniboxing-plugin/blob/wip/docs/2014-07-oopsla-preprint.pdf" target="_blank"><img src="/images/mbox-oopsla.png" width="45%" style="border:3px solid black; box-shadow: 10px 10px 5px #888888;"/></a>&nbsp;
<a href="https://github.com/miniboxing/miniboxing-plugin/blob/wip/docs/2014-11-miniboxing-poster.pdf" target="_blank"><img src="/images/mbox-poster.png" width="45%" style="border:3px solid black; box-shadow: 10px 10px 5px #888888;"/></a>
</center>

## Talks

### Miniboxing Transformation (ScalaDays 2014 Berlin, Germany)

<script async class="speakerdeck-embed" data-id="92685ec0dbaa0131d9c62a008baf6e6b" data-ratio="1.33333333333333" src="//speakerdeck.com/assets/embed.js"></script>
<br/>

<center>
<iframe type="text/html" width="800px" height="400px" mozallowfullscreen="true" allowfullscreen="true" webkitallowfullscreen="true" src="//www.parleys.com/share.html#play/53a7d2d0e4b0543940d9e567" frameborder="0">&lt;br /&gt;</iframe>
</center>
<br/>

### Miniboxing Warnings (PNWScala, Portalnd, OR)

<script async class="speakerdeck-embed" data-id="aeecca804e97013264a712c8f4a94aec" data-ratio="1.33333333333333" src="//speakerdeck.com/assets/embed.js"></script>
<br/>

<!--
| Topic             | Miniboxing                 | Specialization              |
|-------------------|----------------------------|-----------------------------|
| Duplication       | 2 variants/type parameter: | 10 variants/type parameter: |
|                   |  - long integer and        |  - for each value type      |
|                   |  - references              |  - for references           |
| Type encoding     | in a separate type byte    | hardcoded in the variant    |
| Top of hierachy   | interface                  | generic class               |
|                   |  - no duplicate fields     |  - duplicate fields         |
|                   |  - miniboxed inheritance   |  - generic inheritance      |
| Rewiring          | same as specialization     | method, instantiation, parents |
| Characteristics   |  - annotation-driven       |  - annotation-driven        |
|                   |  - compatible              |  - compatible               |
|                   |  - opportunistic           |  - opportunistic            |
-->

## Other Resources

{% include oopsla2.md %}

