---
date: "2012-01-02"
title: QRCode для Android Market
tags: блог, js, qrcode, android, market
---

Я жутко не люблю печатать на мобильных телефонах и очень люблю QR коды.  
А ещё у меня Android телефон. И по роду деятельности мне приходится 
регулярно пользоваться несколькими браузерами, и не везде я залогинен 
в Google с нужной мне учётной записью. Чтобы устанавливать приложения из 
маркета было поще, я написал маленькую штуку для `~/.js`.

Эта штука добавляет большущий и жутко удобный QR код с ссылкой на приложение сразу под кнопкой «Купить/Установить».

{summary}

![Google Play with QR code](/blog/2012-01-02-android-market-qrcode/market-qrcode.png)

<script src="https://gist.github.com/945173.js"></script>

За `~/.js` надо дружно поблагодарить [Chris 
Wanstrath](http://defunkt.io/dotjs/). А вот ссылки на расширение для 
[Chrome](https://github.com/defunkt/dotjs) 
и [Safari](https://github.com/wfarr/dotjs.safariextension), и на аддон 
для [Firefox](https://github.com/rlr/dotjs-addon).
