---
layout: default
title: Example Sbt Project
short_title: Example Sbt Project
---

This page will present an example project meant to quickly get you up and running with the miniboxing plugin.

[`Miniboxing-example`](https://github.com/miniboxing/miniboxing-example) is an sbt project with [a single source file](https://github.com/miniboxing/miniboxing-example/blob/master/src/main/scala/miniboxing/example/Test.scala). It is hosted on github at <https://github.com/miniboxing/miniboxing-example> and can be cloned by running:

{% highlight bash %}
$ git clone https://github.com/miniboxing/miniboxing-example.git
{% endhighlight %}

Once you cloned the project, change directory to `miniboxing-example` and run `sbt`. In the console, you'll have the following options:
 * `compile` will compile the project (running `set scalacOptions += "-P:minibox:log"` before `compile` will also log the class specialization process)
 * `run` will run the project: it will output the names of miniboxed classes for different cases, so you get a feeling of what miniboxing does under the hood
 * `console` is probably the most interesting task, as it allows you to try your own programs with miniboxing (the other examples rely on using the console)

The [`README`](https://github.com/miniboxing/miniboxing-example/blob/master/README.md) file of the project shows the ouput you should expect for the different commands.

Like the miniboxing plugin, the example project is distributed under a [3-clause BSD license](https://github.com/miniboxing/miniboxing-example/blob/master/LICENSE) so you can build your project on top of it.
