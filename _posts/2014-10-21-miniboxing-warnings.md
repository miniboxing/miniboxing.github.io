---
layout: default
title: "... if only miniboxing could TALK"
newstitle: "... if only miniboxing could TALK"
news: true
---

<!-- jekyll don't be stupid -->

One of the most difficult problems in using specialization is finding out when something went wrong and the code reverts
to using boxed primitives. This gave birth to a very useful post by Alex Prokopec explaining the <a href="http://axel22.github.io/2013/11/03/specialization-quirks.html" target="_blank">quirks of specialization</a>.

<a href="https://github.com/miniboxing/miniboxing-plugin/issues/137" target="_blank">Some of these quirks also apply to miniboxing</a>. Yet, there is an important difference. To see it, one should ask the question "what is a quirk?" for specialization. A quirk, as Alex's explanation shows, is a design or technical limitation that results
in a seemingly correct compilation, but that produces suboptimal code. From this perspective, we can say that:

### Quirk = limitation + silent failure

As everything else, miniboxing and specialization have to make compromises. These can occur at different levels, from well-understood
design decisions that sacrifice certain code patterns all the way to purely technical limitations where the problem is simply not worth the
effort to solve.

But there is a second ingredient: **the silent failure**. Without silently failing, specialization would just point the user into the
right direction by providing a workaround or explaining why a limitation occurred. Yet, not doing so made it much harder to use,
allowing only an elite of the Scala community to benefit from the unboxed generics. If only specialization could TALK...

Well, miniboxing does talk :)

### Miniboxing Warnings

If you add the `-P:minibox:warn` argument to the scala compiler, the miniboxing plugin will start talking. And it will
expose all the code where it was not able to correctly specialize generics.

For example, here are a few cases:

* When the type arguments do not allow an unambiguous choice between primitives and references:

{% highlight text %}
$ mb-scala -P:minibox:warn -language:_
...

scala> def foo[@miniboxed T](t: T) = t
foo: [T](t: T)T

scala> foo[Int](3) // clearly a primitive
res0: Int = 3

scala> foo[String]("5") // clearly an object
res1: String = 5

scala> foo[Any](2) // could be both

<console>:9: warning: Using the type argument "Any" for the miniboxed type
parameter T of method foo is not specific enough, as it could mean either a
primitive or a reference type. Although method foo is miniboxed, it won't
benefit from that:
              foo[Any](2)
                 ^
res2: Any = 2

scala> foo[T forSome { type T }](2) // uh-oh

<console>:9: warning: Using the type argument "T forSome { type T }" for
the miniboxed type parameter T of method foo is not specific enough, as it
could mean either a primitive or a reference type. Although method foo is
miniboxed, it won't benefit from that:
              foo[T forSome { type T }](2)
                 ^
res3: Any = 2
{% endhighlight %}


* when adding an annotation could benefit the transformation:
{% highlight text %}
scala> class C[@miniboxed T]
defined class C

scala> def foo[X] = new C[X]

<console>:8: warning: The following code could benefit from miniboxing
specialization if the type parameter X of method foo would be marked as
"@miniboxed X" (it would be used to instantiate miniboxed type parameter
T of C)
       def foo[X] = new C[X]
                    ^
foo: [X]=> C[X]

scala> class D[Z] extends C[Z]

<console>:8: warning: The following code could benefit from miniboxing
specialization if the type parameter Z of class D would be marked as
"@miniboxed Z" (it would be used to instantiate miniboxed type parameter
T of C)
       class D[Z] extends C[Z]
             ^
defined class D
{% endhighlight %}

* when a technical limitation prevents the plugin from compiling the code:
{% highlight text %}
scala> class W[@miniboxed Z](z: Z) { println(z) }

<console>:7: warning: The following constructor statement will not be
specialized in the miniboxed trait W. This is a technical limitation
that can be worked around: (please see
https://github.com/miniboxing/miniboxing-plugin/issues/64)
       class W[@miniboxed Z](z: Z) { println(z) }
                                            ^
<console>:7: error: The following code is accessing field z of miniboxed
class/trait W, a pattern which becomes invalid after the miniboxing
transformation. Please allow Scala to generate accessors by using val/var
or removing the "private[this]" qualifier: val z: Z".
       class W[@miniboxed Z](z: Z) { println(z) }
                                             ^
defined class W
{% endhighlight %}

* when a class you might expect to be specialized won't be:

{% highlight text %}
scala> class C[@miniboxed T] {
     |   class D {
     |     def foo(t: T): T = t
     |   }
     | }
<console>:8: warning: The class D will not be miniboxed based on type 
parameter(s) T of miniboxed class C. To have it transformed, declare
new type parameters marked with @miniboxed and instantiate it using
the parameters from class C.
         class D {
               ^
defined class C
{% endhighlight %}

* or when a the code is just suboptimal:
{% highlight text %}
scala> class W[@miniboxed Z](val z: Z) { println(z) }

<console>:7: warning: The following constructor statement will not be
specialized in the miniboxed trait W. This is a technical limitation
that can be worked around: (please see
https://github.com/miniboxing/miniboxing-plugin/issues/64)
       class W[@miniboxed Z](val z: Z) { println(z) }
                                                ^
<console>:7: warning: The following code could not benefit from m
iniboxing specialization due to technical limitations:
       class W[@miniboxed Z](val z: Z) { println(z) }
                                                 ^
defined class W
{% endhighlight %}

Until the feature is enabled by default, to get the miniboxing plugin to talk (generate the warnings), use the `-P:minibox:warn` flag!

### Thanks guys!

Thanks to <a href="https://github.com/pstutz" target="_blank">@pstutz</a>, <a href="https://github.com/ichoran" target="_blank">@ichoran</a>, <a href="https://github.com/dragos" target="_blank">@dragos</a> and <a href="http://twitter.com/StuHood" target="_blank">@StuHood</a> for their precious comments, which
spawned this feature!
