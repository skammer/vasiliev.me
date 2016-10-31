---
layout: post
title: Complexities of using CSS in modern web apps and how ClojureScript can leverage Garden to generate style sheets at runtime
published: true
lang: en
---

## tl;dr

> We attempt replacing all style management magic provided by webpack with about
> 60 lines of ClojureScript and, arguably, achieve astounding success.

Some people think that CSS is about building cascades of styles. It is not,
fortunately. Sadly, newcomers to web developpment tend to confuse
cascading style inheritance, which is a good thing, with neccessity to
build said cascades themselves using oh so helpful tools such as LESS or
SASS. This leads to unmaintainable mess of code which you've probably
encountered multiple times in different projects.

{% highlight scss %}
.book {
  &_container {
    font-size: 14px;
    color: #333;

    .title {
      font-size: 16px;
      font-weight: bold;

      &:hover {
        color: #666;
      }
    }

    &_placeholder {
      color: #eee;
      text-transform: uppercase;

      &_line {
        white-space: nowrap;
        margin-bottom: 1em;

        &_letter {
          margin-right: 10px

          &:last-child {
            margin-right: 0;
          }
        }
      }

      &--empty {
        background-color: #f00;
      }
    }
  }
}
{% endhighlight %}

Well, you get the general idea. Somehow people are trying to:
<br/>
a) manually do work that a browser is supposed to do, having a CSS engine and 
all that;
<br/>
b) delay having to think about architecture by using complex macro-like magic.

You can add to this Javascript libraries like Modernizr[^modernizr], or the 
ones that sniff device type[^devicejs], it's dpi, orientation and screen size 
and add corresponding css classes to body[^restivejs] so you can target your 
styles more precisely.

Confronted with such level of complexity, the best course of action is usually
to throw it all away, stop and ~~rethink your life priorities~~ let computer do
as much of your job as possible. And this is exactly what libraries like
webpack's `css-loader`[^css-loader] do currently. You just require your CSS
files as you would your regular `*.js` files and receive a map containing all
classes from imported style sheet.

{% highlight js %}
// fancy-button.jsx

require React from 'react';
require cs from 'class-names';

require styles from 'button.css';

export default class FancyButton extends React.Component {
  render() {
    const {priority, children} = this.props;

    const priorityStyle = styles[priority] || styles.primary;
    const className = cs(styles.button, priorityStyle);

    return (
      <button className={className}>{children}</button>
    );
  }
}
{% endhighlight %}

That `button.css` file might look like snippet below. Note, that because 
`css-loader` prefixes all classes, there is a need to denote cases where 
prefixing should be omitted. For this, following syntax is used: 
`:global(.class)`.

{% highlight scss %}
// button.css

.button {
  border-radius: 3px;
  border: none;
}

.primary {
  background-color: blue;
  color: red;
}

.error {
  background-color: red;
  color: green;
}

.button :global(.fa-icon) {
  display: none;
}
{% endhighlight %}

Everything is magically included, css is parsed, all classes camelcased for
your convenience and, more importantly, automagically prefixed to include
file's name in class names (i.e. `.button` gets turned into
`.fancy-button__button` based on name of file wherein CSS file was
included, or whatever prefixing settings you specify). This ensures class
names won't collide and you had to do pleasantly nothing to enjoy it.

But this creates another problem of managing many CSS files. While before we had 
everything taken care of by diligent SASS compiler, now we are forced to rely 
on a plugin inside webpack. And while access to CSS classes in JS is a great 
improvement, we still can't manipulate our styles through code in a consistent 
way. Things like CSS variables[^cssvars] promise us some flexibility, but given 
the time it takes to implement such controversial features in all major 
browsers, we shouldn't rely on them in foreseeable future. CSS and JS still 
live in completely different and largely isolated worlds -- without DOM acting 
as a glue there is no easy way of accessing styles that are to be applied.

{% ditaa %}
/----------+  SASS  +---------+    +--------------+    /-----------+
| Requires +------->+ Webpack +--->+ Uglify and   +--->+ Resulting |
+----------+  LESS  +----+----+    | Autoprefixer |    | CSS file  |
                         ^         +--------------+    +-----------+
/-----------+            |
| Loose CSS +------------/
+-----------+
{% endditaa %}

In a project I'm currently working on, we have a rather complicated way of 
building CSS bundle. It involves separately compiling SASS files, then running 
through webpack dependency graph identifying and transforming required CSS 
files, running autoprefixer an all those files and finally concatenating 
everything and minifying result.

While this is obviously capable of producing production-ready results, I don't 
think one would call it straightforward. Too much magic is happening inside of 
wabpack, too many moving parts, and all sorts of configuration is needed to make 
this work in a desirable way. Moreover, there is regrettably no control over, or 
indication of, order parts of CSS are concatenated in. More than once this forced 
me to resort to `!important` in unobvious places.

## Meet Clojure(Script)

The running theme in Clojure world is to simplify everything until 
things are so simple it would be very difficult to simplify them any further.

When you look at React wrappers, for instance, you'll notice that, with 
a notable exception of OM[^omcljs], they mostly focus on using pure functions for rendering, 
simple atoms for state and some form of array-based HTML description language[^hiccup].

Continuing this tradition, we'll use Garden[^garden] to manage our stylesheets.
In order to achieve feature parity with our previous setup we need to implement following:

1. Generated stylesheets with prefixed classes;
2. Inclusion of appropriate styles;
3. A convenient way to generate prefixed classnames.

To have something to start from, lets take a simple Icon component and use it as a baseline.

{% highlight clojure %}
(ns hoarder.components.icon
  (:require [rum.core :as rum]
            [hoarder.css.manager :refer [include-styles pref]]))

(def styles
  [[:.icon
    {:position "relative"
     :display "inline-block"
     :overflow "hidden"
     :line-height "100%"
     :fill "currentColor"
     }]
   [:.default
    {:height "50px"
     :width "50px"
     :font-size "50px"}]
   [:.small
    {:height "25px"
     :width "25px"
     :font-size "25px"}]
   [:.container
    {:width "100%"
     :height "100%"
     :background "inherit"
     :fill "inherit"
     :pointer-events "none"
     :transform "translateX(0)"
     :-ms-transform "translate(.5px, -.3px)"}]])

;; Add comments

(rum/defc icon < (include-styles styles :icon) ;; RUM mixin
  [iname iclass]
  (let [c (pref :icon)] ;; class name generator
    [:div {:class [(c (or iclass "default")) (c "icon")] :key iname}
     [:svg {:class (c "container")}
      [:use {:xlink-href (str "/img/icons/" iname ".svg#icon")}]]]))

{% endhighlight %}

Here we define some simple styles, create a RUM component, then include styles,
and use prefixed class names in component's template.

Now all we need is to define a minimal implementation of our style sheet
management thing so that our component will at least render.

### Stylesheet generation

Garden can do many things, including, but not limited to, unit calculations,
color manipulation and, obviously, it can generate CSS.

While I'm not entirely sure using hiccup-like syntax for CSS is a good thing,
we'll leave this discussion for later time. For now, let's agree this is a
_manageable_ way to represent complex AST of a modern CSS preprocessor and
roll with it.

{% highlight clojure %}

(defn prefix-with
  "Prefix all class names or ids in a chain
  (prefix-with :test \"#id.hello.world\") #=> \"#test-id.test-hello.test-world\""
  [prefix subj]
  (keyword
   (clojure.string/replace subj #"([\.#])(.+?)" (str "$1" (stringify-keyword prefix) "-" "$2"))))

(defn type-match? [t v] (= t (type v)))

(defn prefix-styles
  "Recursively prefix Garden classes and ids"
  [prefix form]
  (condp type-match? form
    cljs.core/PersistentVector (mapv (partial prefix-styles prefix) form)
    cljs.core/Keyword (prefix-with prefix (name form))
    js/String (prefix-with prefix form)
    form))

(defn make-style'
  "Create renderable styles"
  [prefix st]
  (css (prefix-styles prefix st)))

(def make-style (memoize make-style'))

{% endhighlight %}

After some testing, it appears that all modern browsers are fast enough at
concatenating strings. Except Firefox. This little bastard managed to add
almost a 100ms every time styles were rendered. Thus, because memory is cheap
and I sure didn't want to spend time investigating why Firefox is the only one
behaving this way, memoizing[^memoize] style generation function was chosen as a passable
remedy for those annoying delays.

### DOM manipulation

Now that we have a string with CSS, we need a way to load it into a browser.
Also, we need a way to rename class names in such a way, that would ensure we
bind nicely to CSS classes we generated previously.

{% highlight clojure %}

(defn insert-styles
  "Inserts Stylesheet into document head"
  [styles id]
  (let [el (.createElement js/document "style")
        node (.createTextNode js/document styles)]
    (.setAttribute el "id" id)
    (.appendChild el node)
    (.appendChild (.-head js/document) el)
    el))

(defn stringify-keyword [kw]
  (-> kw str (subs 1) (clojure.string/replace "/" "-")))

(defn rum-prefix
  "Prefix RUM classes"
  [p cls]
  (let [prefix (stringify-keyword p)
        mkpref #(str prefix "-" %)]
    (if (vector? cls)
      (map mkpref cls)
      (mkpref cls))))

(defn pref
  "Helper function for easy class name prefixing"
  [prefix]
  (partial rum-prefix prefix))

(defn render-stylesheet [style prefix]
  (let [prefixed-styles (make-style prefix style)
        id (stringify-keyword prefix)]
    (if-let [el (.getElementById js/document id)]
      (do
       (aset el "innerHTML" prefixed-styles)
       (comment .appendChild el (.createTextNode js/document prefixed-styles)))
      (insert-styles prefixed-styles id))))

(defn include-styles
  "RUM mixin to automagically load prefixed styles"
  [styles prefix]
  (let [f (fn [state]
            (render-stylesheet styles prefix)
            state)]
    {:will-mount f}))

{% endhighlight %}

Here, everything is pretty straightforward. Styles get inserted in a style with
a specific id, or, if such id already exists, styles get updated with new ones.

A RUM mixin tries to update styles when component tries to mount itself.
Obvious added benefit of this approach is naturally hierarchical order of
`<style/>` elements in `<head/>`.

It is reasonable to assume that using `(ns-name *ns*)` as a fallback prefix
value would simplify default use case, but I haven't tried it yet.

This constitutes a minimal system needed to get reloadable, modifiable and
in-situ style sheets for your components. While depending on a rather large
libraries to generate CSS and to reload code on the fly[^boot-reload], the code
to _manage_ styles is extremely small and concise.  There is absolutely no
reason why such approach couldn't be implemented in pure Javascript, and,
arguably, this has already been adopted in React Native[^rn-styles].

Bundling CSS inside JS payload is nothing new[^css-bundling]
and is obviously not of everyone. Benefit of reducing the number of moving
parts, reducing number of cached/requested files and radically simplifying
`manifest.json` my be desirable for B2B apps, electron[^electron]
wrappers, webapps[^manifestjs] and generally less
initial-load-time-sensitive apps, is rather an impediment if you develop highly
latency-optimized or content-heavy sites. But then you probably wouldn't be
using Clojurescript in the first place, I think.

### (Un)intended consequences

While being able to manipulate units[^garden-units] and
macro-like media-queries and keyframes[^garden-keyframes] in
Garden are a nice thing to have, in my experience have a somewhat limited use.

What I found a lot more powerful is ability to seamlessly integrate
Clojurescript with stylesheets. Use functions to generate code, access DOM
and/or JS APIs whenever needed, generate CSS without having to put up with
whatever syntax SASS decided was OK to have for it's mixins.

{% highlight clojure %}

(def mobile-padding
  "iOS status bar offset"
  (if standalone? {:padding-top "20px"}))

(defn random-background-url []
  (str "url(" "/img/backgrounds/" (Math/floor (rand 6)) ".jpg)"))

;; Mostly iOS 10 colors
(def colors
  {:red "255, 59, 48"
   :orange "255, 149, 0"
   :yellow "255, 204, 0"
   :green "76, 217, 100"
   :teal-blue "90, 200, 250"
   :blue "0, 122, 255"
   :purple "88, 86, 214"
   :pink "255, 45, 85"
   :black "30, 30, 31" ; #1e1e1f
   :white "247, 247, 247"
   :true-white "255, 255, 255"
   :text "3, 3, 3"
   :text-soft "146, 146, 146"
   :shadow "22, 28, 34"
   :bluish "228, 233, 234" ; #e4e9ea
   })

(defn palette-color
  "Genereate a color from palette with a given opacity"
  ([color-name] (palette-color color-name 1.0))
  ([color-name opacity]
   (if-let [color (get colors color-name)]
     (str "rgba(" color ", " opacity ")")
     (palette-color :black))))


;; Spinner animation using keyframes

(defkeyframes sk-stretchdelay
  [["0%, 40%, 100%" {:transform "scaleY(0.4)"}]
   ["20%" {:transform "scaleY(1.0)"}]])

(def styles
  [sk-stretchdelay
   [:.spinner
    {:width "50px"
     :height "40px"
     :text-align "center"
     :font-size "10px"}
    [:&>div
     {:background-color (palette-color :green)
      :height "100%"
      :width "6px"
      :margin-right "2px"
      :display "inline-block"
      :-webkit-animation "sk-stretchdelay 1.2s infinite ease-in-out"
      :animation "sk-stretchdelay 1.2s infinite ease-in-out"}]
    [:.rect2 {:animation-delay "-1.1s"}]
    [:.rect3 {:animation-delay "-1.0s"}]
    [:.rect4 {:animation-delay "-0.9s"}]
    [:.rect5 {:animation-delay "-0.8s"}]]])

{% endhighlight %}

As you've probably guessed by now, one can easily compose styles by requiring
needed pieces and adding as a node whenever needed. Keeping libraries of
often-used styles will enable not only easy reuse, but efficient tree-shaking
of unused branches, provided for free by Clojurescirpt compiler.

### Conclusion

It is pretty obvious that approach described above isn't remotely ideal. It's
not intended to be. The idea was to reduce perceived complexity and make
underlying style manipulations predictable and manageable. Optimizing for a
larger set of constraints is left as an exercise for the reader.

[^modernizr]: <https://modernizr.com/> "Modernizr"
[^devicejs]: <https://github.com/matthewhudson/device.js> "device.js"
[^restivejs]: <http://www.restivejs.com/> "restive.js"
[^cssvars]: <https://developer.mozilla.org/en-US/docs/Web/CSS/Using_CSS_variables> "CSS variables"
[^omcljs]: <https://github.com/omcljs/om> "OM cljs"
[^hiccup]: <https://github.com/weavejester/hiccup> "Hiccup"
[^garden]: <https://github.com/noprompt/garden> "Garden"
[^css-loader]: <https://github.com/webpack/css-loader> "css-loader"
[^memoize]: <https://clojuredocs.org/clojure.core/memoize> "clojure.core/memoize"
[^boot-reload]: <https://github.com/adzerk-oss/boot-reload> "adzerk-oss/boot-reload"
[^rn-styles]: <https://facebook.github.io/react-native/docs/style.html> "Styles in React Native"
[^css-bundling]: <https://css-tricks.com/the-debate-around-do-we-even-need-css-anymore/> "Do We Even Need CSS Anymore?"
[^electon]: <http://electron.atom.io/> "Electronjs"
[^manifestjs]: <https://developer.mozilla.org/en-US/docs/Web/Manifest> "Web app manifest"
[^garden-units]: <https://github.com/noprompt/garden/wiki/Units-&-Arithmetic> "garden units"
[^garden-keyframes]: <https://github.com/noprompt/garden/wiki/Compiler#vendors> "garden keyframes"
