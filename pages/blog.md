---
title: Blog
permalink: /blog/
layout: page
description: Posts and articles by Sam Caldwell.
keyword: politics, technology, science, society, ramblings
---

<ul class="list-group">
  {% for post in site.posts %}
  <li class="list-group-item d-flex justify-content-between align-items-center">
    <a href="{{ post.url | relative_url }}">{{ post.title }}</a>
    <small class="text-muted">{{ post.date | date: "%b %d, %Y" }}</small>
  </li>
  {% else %}
  <li class="list-group-item">No posts yet.</li>
  {% endfor %}
  </ul>

