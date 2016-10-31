---
layout: post
title: Test ditaa integration
published: false
lang: ru
---

Different types [^2] of [links] [1].

{% ditaa %}
/----+  DAAP /-----+-----+ Audio  /--------+
| PC |<------| RPi | MPD |------->| Stereo |
+----+       +-----+-----+        +--------+
   |                 ^ ^
   |     ncmpcpp     | | mpdroid /---------+
   +--------=--------+ +----=----| Nexus S |
                                 +---------+
{% endditaa %}
{: .center}

И ещё немного картинок

{% ditaa %}
+---------------------------+
| No separation and shadows |
+---------------------------+
{% endditaa %}
{: .center}

[1]: <http://yandex.ru> "Yandex russia"
[^2]: <http://google.ru> "google russia"
