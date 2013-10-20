---
layout: default
title: Latest News
short_title: News <a href="/feed.xml"><img src="/images/rss.png" /></a>
comments: "off"
---

<ul>
{% for post in site.posts %}
  <li>
    {% if post.image contains "/" %}
      <img src="{{ post.image }}" align="right"/>
    {% endif %}
    <span class="date">{{ post.date | date: "%d.%m.%Y" }}</span>
    <span class="title"><a class="link" href="{{ post.url }}">{{ post.newstitle }}</a></span>
  </li>
{% endfor %}
</ul>

