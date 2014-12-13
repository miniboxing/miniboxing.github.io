---
layout: default
title: "Image Processing Example - PNWScala"
short_title: "Image Processing Example - PNWScala"
---
<!-- jekyll don't be stupid -->

<img align="left" src="/images/pnwscala.png" width="40px" />

The following example is based on the miniboxing presentation at <b><a href="http://pnwscala.org" target="_blank">PNWScala</a></b>. A huge thanks to the <a href="https://twitter.com/tlockney" target="_blank">Thomas Lockney</a> and the PNWScala organizers for the wonderful conference and the <a href="http://confreaks.com/events/PNWS2014" target="_blank">confreaks guys</a> who recorded the presentation!

<center>
<iframe width="800px" height="400px" src="//www.youtube.com/embed/RnIupOJv_oM" frameborder="0" allowfullscreen></iframe>
</center>

<br/>

This page will guide you through the steps necessary to run the example in the presentation. The <a href="http://stephenjudkins.github.io/pureimage-presentation/#/" target="_blank">pureimage library</a> is located at <a href="https://github.com/stephenjudkins/pureimage" target="_blank">github.com/stephenjudkins/pureimage</a>. The mock-up used for the presentation is located at <a href="https://github.com/VladUreche/image-example" target="_blank">github.com/VladUreche/image-example</a>.

To start, clone the pureimage mock-up:

{% highlight text %}
$ git clone https://github.com/VladUreche/image-example.git
Cloning into 'image-example'...
...

$ cd image-example
{% endhighlight %}

Let's generate the Eclipse project files to load the project in the IDE:

{% highlight text %}
$ sbt eclipse
[info] Loading global plugins from /home/sun/.sbt/0.13/plugins
...
[info] Done updating.
[info] Successfully created Eclipse project files for project(s):
[info] image-example
{% endhighlight %}

Cool. Now, all you need is the latest <a href="http://scala-ide.org/" target="_blank">Scala IDE for Eclipse to load the project</a>. Please use a version for **Scala 2.11**, in order to stay compatible with the rest of the project. Now, to load the project:

 * `File` &gt; `Import ...` &gt; `General` &gt; `Existing Projects into Workspace`
 * point Eclipse to the `image-example` directory, select `image-example` and hit `Finish`

You should see the project in Eclipse:

<center>
<a class='colorbox' href="/images/pureimage/pureimage-begin.png" rel="colorbox" title="Pureimage mock-up project in ScalaIDE"><img src="/images/pureimage/pureimage-begin.png" width="800px" title=""/></a>
</center>
<br/>

Open `Test.scala` from package `image.example`, located in `src/main/scala`, and run it:

<center>
<a class='colorbox' href="/images/pureimage/pureimage-run.png" rel="colorbox" title="Pureimage mock-up running in ScalaIDE"><img src="/images/pureimage/pureimage-run.png" width="800px" title=""/></a>
</center>
<br/>

On my laptop, I got the following times:

{% highlight text %}
Operation took 4192 milliseconds.
Operation took 4957 milliseconds.
Operation took 4755 milliseconds.
Operation took 3969 milliseconds.
Operation took 4073 milliseconds.
{% endhighlight %}

The miniboxing plugin generated a couple of warnings during compilation:

<center>
<a class='colorbox' href="/images/pureimage/pureimage-warnings.png" rel="colorbox" title="Miniboxing warnings in the ScalaIDE"><img src="/images/pureimage/pureimage-warnings.png" width="800px" title=""/></a>
</center>
<br/>

One such warning is:

{% highlight text %}
The class image.example.Pixel would benefit from miniboxing type parameter Repr, since it is 
instantiated by a primitive type.
{% endhighlight %}

So let's go in and fix that. Open `Pixel.scala` and mark the type parameter `Repr` of class `Pixel` by `@miniboxed`:

{% highlight scala %}
abstract class Pixel[@miniboxed Repr: Manifest] {
  def r(t: Repr): Double // red
  def g(t: Repr): Double // green
  def b(t: Repr): Double // blue
  def a(t: Repr): Double // alpha
  def pack(r: Double, g: Double, b: Double, a: Double): Repr
  // to allow Image to build an array:
  implicit def manifest = implicitly[Manifest[Repr]]
}
{% endhighlight %}

<center>
<a class='colorbox' href="/images/pureimage/pureimage-fixed.png" rel="colorbox" title="Miniboxing warnings in the ScalaIDE"><img src="/images/pureimage/pureimage-fixed.png" width="800px" title=""/></a>
</center>
<br/>

We can fix the other 8 warnings that appear and recompile. Surprisingly, after compiling again, we get an error:

{% highlight text %}
The method map in class ImageImpl overrides method map in class Image therefore needs to 
have the follwing type parameters marked with @miniboxed: type Repr2.
{% endhighlight %}

<center>
<a class='colorbox' href="/images/pureimage/pureimage-error.png" rel="colorbox" title="After adding the @miniboxed annotations"><img src="/images/pureimage/pureimage-error.png" width="800px" title=""/></a>
</center>
<br/>

This is because we added the `@miniboxed` annotation to method `map` in `Image`:

{% highlight scala %}
abstract class Image[Repr: Pixel] {
  def width: Int
  def height: Int
  def apply(x: Int, y: Int): Repr
  def map[@miniboxed Repr2: Pixel](f: Image[Repr] => Generator[Repr2]): Image[Repr2]
}
{% endhighlight %}

but did not add the annotation to method `map` in `ImageImpl`, which extends `Image`:

{% highlight scala %}
private class ImageImpl[Repr: Pixel](val width: Int, val height: Int) extends Image[Repr] {
  ...
  def map[Repr2: Pixel](f: Image[Repr] => Generator[Repr2]): Image[Repr2] = {
    ...
  }
}
{% endhighlight %}

Let's fix that:

{% highlight scala %}
private class ImageImpl[Repr: Pixel](val width: Int, val height: Int) extends Image[Repr] {
  ...
  def map[@miniboxed Repr2: Pixel](f: Image[Repr] => Generator[Repr2]): Image[Repr2] = {
    ...
  }
}
{% endhighlight %}

If we recompile, the error is gone, but we get another batch of `26 warnings`:

<center>
<a class='colorbox' href="/images/pureimage/pureimage-warnings2.png" rel="colorbox" title="Even more warnings"><img src="/images/pureimage/pureimage-warnings2.png" width="800px" title=""/></a>
</center>
<br/>

Let's try to run the program now, despite the warnings:

<center>
<a class='colorbox' href="/images/pureimage/pureimage-run2.png" rel="colorbox" title="Hmmm... getting better"><img src="/images/pureimage/pureimage-run2.png" width="800px" title=""/></a>
</center>
<br/>

So by adding a couple of annotations, we just shaved off one quarter of the running time:

{% highlight text %}
Operation took 3082 milliseconds.
Operation took 2998 milliseconds.
Operation took 3017 milliseconds.
Operation took 2535 milliseconds.
Operation took 2615 milliseconds.
{% endhighlight %}

Maybe this miniboxing thing is actually worth it... 
<br/>

Let's now address all the warnings. But let's be smart about it:

 * go to `Project` &gt; `Properties` (if that's disabled, make sure the `image-example` project is selected)
 * in the window go to `Scala Compiler` and add `-P:minibox:mark-all` to the `Additional command line parameters` field.

As explained in the [command line options](/using_out.html#miniboxing-command-line-arguments), the `-P:minibox:mark-all` flag will mark all type parameters with `@miniboxed` automatically. 

<center>
<a class='colorbox' href="/images/pureimage/pureimage-properties.png" rel="colorbox" title="Project Properties"><img src="/images/pureimage/pureimage-properties.png" width="800px" title=""/></a>
</center>
<br/>

<center>
<a class='colorbox' href="/images/pureimage/pureimage-markall.png" rel="colorbox" title="Adding -P:minibox:mark-all"><img src="/images/pureimage/pureimage-markall.png" width="800px" title=""/></a>
</center>
<br/>

Recompile and you should not see any more warnings. Now let's run again:

<center>
<a class='colorbox' href="/images/pureimage/pureimage-run3.png" rel="colorbox" title="Adding -P:minibox:warn"><img src="/images/pureimage/pureimage-run3.png" width="800px" title=""/></a>
</center>
<br/>

{% highlight text %}
Operation took 1346 milliseconds.
Operation took 1187 milliseconds.
Operation took 1178 milliseconds.
Operation took 1094 milliseconds.
Operation took 1163 milliseconds.
{% endhighlight %}

Wow, **that's four times faster than our initial running time**. That's what miniboxing can do for numeric-intensive applications!
