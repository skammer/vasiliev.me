---
layout: post
title: Test ditaa integration
---

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

{% ditaa -S -E %}
+---------------------------+
| No separation and shadows |
+---------------------------+
{% endditaa %}
{: .center}