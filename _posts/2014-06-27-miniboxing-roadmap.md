---
layout: default
title: "Will miniboxing be merged into Scala?"
newstitle: "Will miniboxing be merged into Scala?"
news: true
---

<!-- jekyll don't be stupid -->

Lately the question of merging the miniboxing plugin into the Scala compiler has arisen in <a href="https://twitter.com/alexey_r/status/481766677399756800" target="_blank">different</a> <a href="https://groups.google.com/d/msg/scala-debate/YTmYhVAwt7M/vVmkJIwmc6wJ" target="_blank">contexts</a>. We have seen <a href="https://groups.google.com/d/msg/scala-internals/Fw37NmUUiqs/nlqyupYaGNIJ" target="_blank">Scala collections miniboxed by hand</a>, and we have even <a href="https://twitter.com/stuhood/status/429124902214316032" target="_blank">received a suggestion</a> that miniboxing should be an opt-out instead of opt-in, meaning that unless a type parameter is annotated otherwise, it automatically undergoes the miniboxing transformation.

We are very glad such questions are asked, as it gives us the chance to clarify the roadmap.

## So, will the miniboxing plugin be merged into Scala?

### Short answer

It depends on you! For now, it will stay a plugin, but the more projects use miniboxing, the more chances it has to become the standard.

###Long answer:

Miniboxing is not currently on the Scala roadmap, but we can change that!

The first step for any plugin that changes the compilation pipeline is to become trusted. And to do so, we need projects using it and reporting their experience. We have already tested the [Scala linked list](/example_linkedlist.html) with 1.5-4x speedups, the [spire](/2014/06/16/spire-miniboxed.html) library and we will continue trying other use-cases. But there's a huge number of cool projects that could use the miniboxing transformation and we need your help!

**So if you'd like to see miniboxing in Scala:**

1. <a href="/using_sbt.html" target="_blank">Start using it as a plugin</a>, no matter how big or small your project is! Rest assured that <a href="https://github.com/miniboxing/miniboxing-plugin/tree/wip/tests/correctness/resources/miniboxing/tests/compile" target="_blank">with 150+ tests</a> [running with each commit](/2013/12/04/travis.html), there's little risk that miniboxing will break your code;
1. Ask <a href="https://groups.google.com/forum/#!forum/scala-miniboxing" target="_blank">questions on the mailing list</a> or <a href="https://twitter.com/miniboxing" target="_blank">via twitter</a>;
1. Report any errors you encounter on the <a href="https://github.com/miniboxing/miniboxing-plugin/issues" target="_blank">github issue tracker</a>;
1. Write about your use-case and <a href="https://github.com/miniboxing/miniboxing.github.io" target="_blank">submit a pull request for the website</a> (we welcome contributions!);
1. Help spread the word, so others can use miniboxing too.

If the miniboxing plugin becomes a common sight in Scala project builds, it may be worth merging it into `scalac`. Then again, having it as a `scalac` plugin means easier development and quicker fixes, so keeping it a plugin might not a bad solution at all.

**To wrap up, miniboxing will stay as a separate compiler plugin at least for the next Scala release. Whether or not it will become part of `scalac` in the future depends on you!**

## Will miniboxing become opt-out?

**YES!** We are currently working on a flag that will turn miniboxing on by default. Stay tuned! :)
