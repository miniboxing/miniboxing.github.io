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
<a href="https://github.com/miniboxing/miniboxing-plugin/blob/wip/docs/2013-07-oopsla-preprint.pdf" target="_blank"><img src="/images/mbox-oopsla.png" width="45%" style="border:3px solid black; box-shadow: 10px 10px 5px #888888;"/></a>&nbsp;
<a href="https://github.com/miniboxing/miniboxing-plugin/blob/wip/docs/2013-11-miniboxing-poster.pdf" target="_blank"><img src="/images/mbox-poster.png" width="45%" style="border:3px solid black; box-shadow: 10px 10px 5px #888888;"/></a>
</center>

<p>
<br/>
<div class="paper">
<b>Paper errata:</b>

<p>
We were notified by our peers that one of the times reported is impossible to reproduce. While this does not affect the paper&#39;s contributions, we would like explain the discrepancy in detail:
</p>

<p>
Table 3 lists the times taken by the <b>List create</b> microbenchmark for the <b>generic</b> case as:
<ul> 
 <li>16.7ms for the "Single context" case</li>
 <li>1841ms for the "Multi context" case</li>
</ul>
</p>
<p>The number from the "Multi context" case was very noisy (with a standard deviation of 1068ms <a href="https://github.com/miniboxing/miniboxing-plugin/blob/wip/docs/2013-03-oopsla-draft.pdf" target="_blank">as shown in the first version of the paper</a>) and we are also not able to reproduce it. We think this number was affected by a job running on the server we used for benchmarking, which would explain the long running time and the huge standard deviation seen in the measurements. Our expectation is that the numbers for "Single context" and "Multi context" should be comparable. The measurements taken on the Graal virtual machine (in Table 4) exhibit this expected behavior. We apologize for not double-checking this number, misleading other authors who tried to reproduce it.
</p>
</div>
</p>

## Talks

### Devoxx UK 2015 (London, UK)

<center>
<div data-parleys-presentation="miniboxing-fast-generics-primitive-types" style="width:800px;height:400px"><script type = "text/javascript" src="//parleys.com/js/parleys-share.js"></script></div>
</center>

### Miniboxing Warnings (PNWScala, Portalnd, OR)

<center>
<iframe width="800px" height="400px" src="//www.youtube.com/embed/RnIupOJv_oM" frameborder="0" allowfullscreen></iframe>
</center>
<br/>

<script async class="speakerdeck-embed" data-id="aeecca804e97013264a712c8f4a94aec" data-ratio="1.33333333333333" src="//speakerdeck.com/assets/embed.js"></script>
<br/>

### Miniboxing Transformation (ScalaDays 2014 Berlin, Germany)

<center>
<div data-parleys-presentation="miniboxing-specialization-diet" style="width:800px;height:400px"><script type = "text/javascript" src="//parleys.com/js/parleys-share.js"></script></div>
</center>
<br/>

<script async class="speakerdeck-embed" data-id="92685ec0dbaa0131d9c62a008baf6e6b" data-ratio="1.33333333333333" src="//speakerdeck.com/assets/embed.js"></script>
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

