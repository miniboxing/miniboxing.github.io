---
layout: default
title: Using Miniboxing in the Command Line
short_title: Command Line
---

This page will explain how to use the miniboxing plugin on the command line.

Miniboxing is a Scala compiler plugin and thus performs its transformations as part of the compilation pipeline. In order to use miniboxing, you will need to add two artifacts:
 * the miniboxing runtime support library and
 * the miniboxing compiler plugin

Fortunately, both artifacts are [published nightly on maven](https://travis-ci.org/miniboxing/miniboxing-plugin), so you can easily get them.

{% include status.md %}

## Getting the Artifact Jars

The two artifacts are hosted on the [Sonatype OSS snapshots repository](https://docs.sonatype.org/display/Repository/Sonatype+OSS+Maven+Repository+Usage+Guide). You can either [download them manually](https://oss.sonatype.org/content/repositories/snapshots/org/scala-miniboxing/plugins/miniboxing-runtime_2.10/0.2-SNAPSHOT/) ([runtime is here](https://oss.sonatype.org/content/repositories/snapshots/org/scala-miniboxing/plugins/miniboxing-runtime_2.10/0.1-SNAPSHOT/miniboxing-runtime_2.10-0.1-SNAPSHOT.jar) and [plugin is here](https://oss.sonatype.org/content/repositories/snapshots/org/scala-miniboxing/plugins/miniboxing-plugin_2.10/0.1-SNAPSHOT/miniboxing-plugin_2.10-0.1-SNAPSHOT.jar)) or ask your dependency manager to fetch them:

Runtime support library:
{% highlight xml %}
<dependency>
  <groupId>org.scala-miniboxing.plugins</groupId>
  <artifactId>miniboxing-runtime_2.10</artifactId>
  <version>0.2-SNAPSHOT</version>
</dependency>
{% endhighlight %}


Scala compiler plugin:
{% highlight xml %}
<dependency>
  <groupId>org.scala-miniboxing.plugins</groupId>
  <artifactId>miniboxing-plugin_2.10</artifactId>
  <version>0.2-SNAPSHOT</version>
</dependency>
{% endhighlight %}

## Running `scala` and `scalac`

Once the two artifacts have been downloaded, you can use them to run the Scala console:

{% highlight bash %}
$ scala \ 
  -bootclasspath miniboxing-runtime.jar:miniboxing-plugin.jar \
  -Xplugin:miniboxing-plugin.jar \
  -optimize

Welcome to Scala version 2.10.3 (...).
Type in expressions to have them evaluated.
Type :help for more information.

scala> def foo[@miniboxed T](t: T) = 
     |   println((new Exception).getStackTrace()(0).getMethodName())
foo: [T](t: T)Unit

scala> foo(3)
foo_n_J

scala> foo("x")
foo
{% endhighlight %}

If you followed [the tutorial](tutorial.html), you will know this means miniboxing is optimizing your code. :)

To run the scalac compiler, you only need to swap `scalac` for `scala` and indicate the files you want to compile.

## Miniboxing Command Line Arguments

The miniboxing plugin can be controlled using command-line arguments. The most useful command-line argument is `-P:minibox:hijack`, which allows a program using specialization (`@specialized`) to automatically be converted to miniboxing, without any annotation change.

Another very useful flag is `-P:minibox:log` which explains how classes are transformed.

A full list of flags can be obtained by calling either `scala` or `scalac` with the plugin and `-help`:

{% highlight text %}
Options for plugin 'minibox':
  -P:minibox:log          log miniboxing signature transformations
  -P:minibox:stats        log miniboxing tree transformations (verbose logging)
  -P:minibox:debug        debug logging for the miniboxing plugin (rarely used)  
  -P:minibox:hijack       hijack the @specialized(...) notation for miniboxing
  -P:minibox:spec-no-opt  don't optimize method specialization
  -P:minibox:loader       generate classloader-friendly code (but more verbose)
{% endhighlight %}

An example of using `-P:minibox:log` and `-P:minibox:hijack` (notice the `@specialized` annotation instead of `@miniboxed`):

{% highlight scala %}
$ cat C.scala 
class C[@specialized T]

$ scalac \
  -bootclasspath miniboxing-runtime.jar:miniboxing-plugin.jar \
  -Xplugin:miniboxing-plugin.jar \
  -optimize \
  -P:minibox:hijack \
  -P:minibox:log \
  C.scala

Specializing class C...

  // interface:
  abstract trait C[T] extends Object {
  }

  // specialized class:
  class C_J[Tsp] extends C[Tsp] {
    def <init>(val C_J|T_TypeTag: Byte): C_J[Tsp] 
      // is a specialized implementation of constructor C
    private[this] val C_J|T_TypeTag: Byte
      // no info
  }

  // specialized class:
  class C_L[Tsp] extends C[Tsp] {
    def <init>(): C_L[Tsp]
      // is a specialized implementation of constructor C
  }
{% endhighlight %}

