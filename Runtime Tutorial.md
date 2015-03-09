---
layout: default
title: Runtime Tutorial
short_title: Runtime Tutorial
---

This page will present an example project meant to quickly get you up and running with the miniboxing plugin.

<a href="https://github.com/miniboxing/miniboxing-example" target="_blank"><code>Miniboxing-example</code></a> is an sbt project with <a href="https://github.com/miniboxing/miniboxing-example/blob/master/src/main/scala/miniboxing/example/Test.scala" target="_blank">a single source file</a>. It is hosted on github at <a href="https://github.com/miniboxing/miniboxing-example" target="_blank">https://github.com/miniboxing/miniboxing-example</a> and can be cloned by running:

{% highlight bash %}
$ git clone https://github.com/miniboxing/miniboxing-example.git
{% endhighlight %}

Once you cloned the project, change directory to `miniboxing-example` and run `sbt`. In the console, you'll have the following options:

 * `compile` will compile the project (running `set scalacOptions += "-P:minibox:log"` before `compile` will also log the class specialization process)
 * `run` will run the project: it will output the names of miniboxed classes for different cases, so you get a feeling of what miniboxing does under the hood
 * `console` is probably the most interesting task, as it allows you to try your own programs with miniboxing (the other examples rely on using the console)

The <a href="https://github.com/miniboxing/miniboxing-example/blob/master/README.md" target="_blank"><code>README</code></a> file of the project shows the output you should expect for the different commands.

Like the miniboxing plugin, the example project is distributed under a <a href="https://github.com/miniboxing/miniboxing-example/blob/master/LICENSE" target="_blank">3-clause BSD license</a> so you can build your project on top of it.

{% include status.md %}
