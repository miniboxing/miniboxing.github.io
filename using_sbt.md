---
layout: default
title: Using Miniboxing in Sbt
short_title: Using in Sbt
---

This page will explain how to enable miniboxing with your <a href="http://www.scala-sbt.org" target="_blank">sbt</a> project.

Miniboxing is a Scala compiler plugin and thus performs its transformations as part of the compilation pipeline. In order to use miniboxing, you will need to add two components:
 * the miniboxing runtime support library and
 * the miniboxing compiler plugin

Fortunately, both artifacts are <a href="https://travis-ci.org/miniboxing/miniboxing-plugin" target="_blank">published nightly on sonatype</a>, so you can easily get them.

{% include status.md %}

## Adding Miniboxing

Depending on your project's size, you may be using the <a href="http://www.scala-sbt.org/0.13.5/docs/Getting-Started/Basic-Def.html" target="_blank">basic project definition</a> (in a `.sbt` file) or the <a href="http://www.scala-sbt.org/0.13.5/docs/Getting-Started/Full-Def.html" target="_blank">full project definition</a> (usually in `project/Build.scala`).

### ... to a basic project definition

The miniboxing runtime support library is marked as a dependency to the project by adding the following lines to `build.sbt`:

{% highlight scala %}
resolvers += Resolver.sonatypeRepo("snapshots")
libraryDependencies += "org.scala-miniboxing.plugins" %%
                       "miniboxing-runtime" % "0.4-SNAPSHOT"
{% endhighlight %}

Just by adding the library, you can already annotate type parameters with `@miniboxed`. Still, in order to have the code transformed based on the annotations, you need to add the miniboxing compiler plugin:

{% highlight scala %}
addCompilerPlugin("org.scala-miniboxing.plugins" %%
                  "miniboxing-plugin" % "0.4-SNAPSHOT")
{% endhighlight %}

Finally, it is important to run the optimizer after compiling using the miniboxing plugin (this may be become redundant in future versions):

{% highlight scala %}
scalacOptions += "-optimize"
{% endhighlight %}

An example `build.sbt` file, with the required empty lines between commands, is:

{% highlight scala %}
name := "hello-miniboxing-world"

version := "1.0"

scalaVersion := "2.11.1"

resolvers += Resolver.sonatypeRepo("snapshots")

libraryDependencies += "org.scala-miniboxing.plugins" %%
                       "miniboxing-runtime" % "0.4-SNAPSHOT"

addCompilerPlugin("org.scala-miniboxing.plugins" %%
                  "miniboxing-plugin" % "0.4-SNAPSHOT")

scalacOptions += "-optimize"
{% endhighlight %}

This project definition file only works with sbt 0.12 or newer, so you should create `project/build.properties` to enforce using your desired sbt version:

{% highlight scala %}
sbt.version=0.13.5
{% endhighlight %}

### ... to a full project definition

The exact same commands are needed in the full build, except that they are now wrapped in a `val` and are separated by commas instead of empty lines:

{% highlight scala %}
val miniboxingSettings: Seq[Setting[_]] = Seq(
  resolvers += Resolver.sonatypeRepo("snapshots"),
  libraryDependencies += "org.scala-miniboxing.plugins" %%
                         "miniboxing-runtime" % "0.4-SNAPSHOT",
  addCompilerPlugin("org.scala-miniboxing.plugins" %%
                    "miniboxing-plugin" % "0.4-SNAPSHOT"),
  scalacOptions += "-optimize"
)
{% endhighlight %}

And you also need to add the `val` containing settings to your project's settings:

{% highlight scala %}
  lazy val root: Project = Project("miniboxing-example", file("."),
                                   settings = Defaults.defaultSettings ++
                                              miniboxingSettings)
{% endhighlight %}

The same requirement stands for full project definitions: sbt 0.12 or newer is required, so you may want to create the `project/build.properties` file as described in the basic project definition.

## Command Line Options

When using the miniboxing plugin in sbt, you can control the compiler plugin and enable logging by adding command line arguments. This is done using the command:

{% highlight scala %}
scalacOptions += "-P:minibox:log"
{% endhighlight %}

The command can be written directly in `build.sbt` or added to `miniboxingSettings` (careful, add a comma to the command before it!). Another trick is to use the sbt prompt to add arguments when needed:

{% highlight scala %}
> set scalacOptions += "-P:minibox:log"
[info] Defining *:scalac-options
[info] Reapplying settings...
[info] Set current project to hello-miniboxing-world
>
{% endhighlight %}

For the list of all command line arguments, see the [command line page](/using_out.html).

## Example Project

If you want to see these changes in place, or want to just try out the miniboxing plugin without creating a project, have a look at the [example project](/example.html) we posted that uses miniboxing. The examples all build on top of this project.

## All set!

You're all set to add your first `@miniboxed` annotation! If you haven't read the [introduction](/intro.html) and [tutorial](/tutorial.html), it's a good time to do so!