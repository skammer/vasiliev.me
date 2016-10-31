---
layout: post
title: Social network metadata image sizes
date: 2015-10-02T03:17:20+03:00
lang: ru
---

Небольшой пост, чтобы в очередной раз не лезть в этот черновик.

## Facebook
{: #not-facebook }

Для превью с картинкой во всю ширину картинка должна быть больше 
_600х315_, а рекомендовано _1200x630_.  Если картинка _меньше 600x315_, то 
превью будет с картинкой сбоку.
Дока [тут](https://developers.facebook.com/docs/sharing/best-practices).
Про текст не очень очевидно. Цитирую:

> A detailed description of the piece of content, usually between 2 and 
> 4 sentences.

## Twitter

Для твита с большой картинкой, картинка должна быть _минимум 280x150_ 
и меньше 1МБ.

[Документация](https://dev.twitter.com/cards/types/summary-large-image)

Максимум 200 символов в описании. Обрезается по словам.

Для твита с маленькой картинкой — минимально 120x120 пикселей, но надо 
предусмотреть, что для некоторых отображений она будет обрезаться до 
соотношения 4:3 (120х90 пикселей, например).
[Ещё документация](https://dev.twitter.com/cards/types/summary)

## ВК

Просит картинку _100x100_. Скорее всего. Документация очень запутанная.  
Где-то говрят, что он понимает open graph, как и facebook, а где-то 
пишут так же, как в этой [доке](http://vk.com/pages?oid=-17680044&p=Sharing_External_Pages) (в самом низу).
Про длину текста ни слова. Полагаю, что 180 символов должно переварить.

## GooglePlus
{: #not-google-plus }

Минимум _400 в ширину_, с пропорциями _5:2_ (width:height). Если уже 400 
пикселей, то будет показываться маленькая картинка слева от текста.

Документация: 
[раз](https://developers.google.com/+/web/snippet/article-rendering) 
и [два](https://developers.google.com/+/web/snippet/).
По тексту не очень понятно. Судя по примеру из документации, 176 
символов показываются нормально.

> Google uses the Headline or Title (depending on your markup) and 
> Description in the Google+ post. These fields are truncated if they are too 
> long.
