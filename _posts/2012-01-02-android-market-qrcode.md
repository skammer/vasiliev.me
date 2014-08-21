---
layout: post
date: "2012-01-02"
title: QRCode для Android Market
categories: блог, js, qrcode, android, market
---

Я жутко не люблю печатать на мобильных телефонах и очень люблю QR коды.  
А ещё у меня Android телефон. И по роду деятельности мне приходится 
регулярно пользоваться несколькими браузерами, и не везде я залогинен 
в Google с нужной мне учётной записью. Чтобы устанавливать приложения из 
маркета было поще, я написал маленькую штуку для `~/.js`.

Эта штука добавляет большущий и жутко удобный QR код с ссылкой на 
приложение сразу под кнопкой «Купить/Установить».

![Google Play with QR code]({% asset_path market-qrcode.png %})

{% highlight javascript %}
// Add handy QR Codes to Android Market.
// For ~/.js
 
var url = encodeURIComponent(window.location.href);
var title = $("h1.doc-banner-title").text();
var dimentions = "276x276";
 
var request_url = "http://chart.apis.google.com/chart?cht=qr&chs=" +
                  dimentions +
                  "&chl=MECARD%3AN%3A" +
                  title +
                  "%3BURL%3A" +
                  url +
                  "%3B%3B";
 
$("<img />")
  .attr("src", request_url)
  .attr("title", title)
  .prependTo(".doc-similar.padded-content5");
{% endhighlight %}

За `~/.js` надо дружно поблагодарить [Chris 
Wanstrath](http://defunkt.io/dotjs/). А вот ссылки на расширение для 
[Chrome](https://github.com/defunkt/dotjs) 
и [Safari](https://github.com/wfarr/dotjs.safariextension), и на аддон 
для [Firefox](https://github.com/rlr/dotjs-addon).
