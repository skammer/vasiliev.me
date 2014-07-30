# encoding: UTF-8
# coding: UTF-8
# -*- coding: UTF-8 -*-

# Author: Max Vasiliev


gangster_phrases = [
  "Пиу-пиу-пиу!"
  "I'm going to make him an offer he can't refuse."
  "They'll never take me alive!"
  "Leave the gun. Take the cannolis."
  "Just when I thought that I was out they pull me back in."
  "Make a wish... it'll be your last"
  "Keep your friends close... but your enemies closer."
  "Made it, Ma! Top of the world."
  "Say hello to my lil' friend!"
  "You wanna take me!? You need a fuckin' army if you gonna take me!"
  "Мафия бессмертна."
  "От мафии ещё никто не уходил."
  "Если кого надо убить, напиши — приеду."
  "Розарио Агро еще никому не удавалось уничтожить!"
  "Мы вас грабить никому не дадим. Сами будем."
  "As far back as i can remember, I've always wanted to be a gangster."
  "Okay. Now you can't leave..."
  "Nobody knows anybody. Not that well."
  "OHAI! I CAN HAZ HTML5? KTHXBAI!"
]

christmas_phrases = [
  "Дед мороз, без 100 грамм не красный нос!"
  "Christmas is a time when you get homesick - even when you're home.  ~Carol Nelson"
  "He who has not Christmas in his heart will never find it under a tree.  ~Roy L. Smith"
  "The best of all gifts around any Christmas tree:  the presence of a happy family all wrapped up in each other.  ~Burton Hillis"
  "There has been only one Christmas - the rest are anniversaries.  ~W.J. Cameron"
  "I will honor Christmas in my heart, and try to keep it all the year.  ~Charles Dickens"
  "At Christmas, all roads lead home.  ~Marjorie Holmes"
  "Gifts of time and love are surely the basic ingredients of a truly merry Christmas.  ~Peg Bracken"
  "Blessed is the season which engages the whole world in a conspiracy of love!  ~Hamilton Wright Mabie"
  "Christmas is the day that holds all time together.  ~Alexander Smith"
  "No matter how carefully you stored the lights last year, they will be snarled again this Christmas.  ~Robert Kirby"
  "Nothing's as mean as giving a little child something useful for Christmas.  ~Kin Hubbard"
  "Mail your packages early so the post office can lose them in time for Christmas.  ~Johnny Carson"
  "The perfect Christmas tree? All Christmas trees are perfect! ~Charles N. Barnard"
  "Christmas, children, is not a date. It is a state of mind. ~Mary Ellen Chase"
  "Something about an old-fashioned Christmas is hard to forget. ~Hugh Downs"
  "Christmas is not an eternal event at all, but a piece of one's home that one carries in one's heart. ~Freya Stark"
  "The only blind person at Christmastime is he who has not Christmas in his heart. ~Helen Keller"
  "Как Новый год встретишь, так тебе и надо!"
]

phrases = christmas_phrases

tipsy_options =
  fallback: phrases[Math.floor(Math.random()*(phrases.length))]
  gravity: "sw"
  fade: true
  animate_for: 100
  customClass: 'tipsy-mascot'

$('#mascot').tipsy(tipsy_options)

$('#mascot').click ->
  window.location.href = "/"

$('.dbox').parent().darkbox()

prettyPrint()

numpf = (n, f, s, t) ->
  # f - 1, 21, 31, ...
  # s - 2-4, 22-24, 32-34 ...
  # t - 5-20, 25-30, ...
  n10 = n % 10
  if (n10 == 1) && ( (n == 1) || (n > 20) )
    f
  else if (n10 > 1) && (n10 < 5) && ( (n > 20) || (n < 10) )
    s
  else
    t

jQuery.timeago.settings.strings =
  prefixAgo: null
  prefixFromNow: "через"
  suffixAgo: "назад"
  suffixFromNow: null
  seconds: "меньше минуты"
  minute: "минуту"
  minutes: (value) -> numpf(value, "%d минута", "%d минуты", "%d минут")
  hour: "час"
  hours: (value) -> numpf(value, "%d час", "%d часа", "%d часов")
  day: "день"
  days: (value) -> numpf(value, "%d день", "%d дня", "%d дней")
  month: "месяц"
  months: (value) -> numpf(value, "%d месяц", "%d месяца", "%d месяцев")
  year: "год"
  years: (value) -> numpf(value, "%d год", "%d года", "%d лет")


$('time.timeago').timeago()

