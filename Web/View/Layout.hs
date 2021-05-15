module Web.View.Layout (defaultLayout, Html, authLayout) where

import Generated.Types
import IHP.Controller.RequestContext
import IHP.Environment
import IHP.ViewPrelude
import qualified Text.Blaze.Html5 as H
import qualified Text.Blaze.Html5.Attributes as A
import Web.Routes
import Web.Types

defaultLayout :: Html -> Html
defaultLayout inner =
  H.docTypeHtml ! A.lang "ru" $
    [hsx|
<head>
    {metaTags}

    {stylesheets}
    {scripts}

    <title>App</title>
</head>
<body>
  {ugaBugaHeader}
    <div class="container mt-4">
        {renderFlashMessages}
        {inner}
    </div>
    {ugaBugaFooter}
</body>
|]

stylesheets :: Html
stylesheets =
  [hsx|
        <link rel="stylesheet" href="/vendor/bootstrap.min.css"/>
        <link rel="stylesheet" href="/vendor/flatpickr.min.css"/>
        <link rel="stylesheet" href="/app.css"/>
    |]

scripts :: Html
scripts =
  [hsx|
        <script id="livereload-script" src="/livereload.js"></script>
        <script src="/vendor/jquery-3.2.1.slim.min.js"></script>
        <script src="/vendor/timeago.js"></script>
        <script src="/vendor/popper.min.js"></script>
        <script src="/vendor/bootstrap.min.js"></script>
        <script src="/vendor/flatpickr.js"></script>
        <script src="/vendor/morphdom-umd.min.js"></script>
        <script src="/vendor/turbolinks.js"></script>
        <script src="/vendor/turbolinksInstantClick.js"></script>
        <script src="/vendor/turbolinksMorphdom.js"></script>
        <script src="/helpers.js"></script>
        <script src="/ihp-auto-refresh.js"></script>
    |]

metaTags :: Html
metaTags =
  [hsx|
    <meta charset="utf-8"/>
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no"/>
    <meta property="og:title" content="App"/>
    <meta property="og:type" content="website"/>
    <meta property="og:url" content="TODO"/>
    <meta property="og:description" content="TODO"/>
    {autoRefreshMeta}
|]

ugaBugaHeader :: Html
ugaBugaHeader =
  [hsx|
  <header>
    <nav class="navbar navbar-expand-md navbar-dark bg-info py-4"  style="font-family:Comic Sans MS">
        <a class="navbar-brand" style="font-size:200%" href="#">UGA-BUGA AIRLINES</a>
    </nav>
  </header>
|]

ugaBugaFooter :: Html
ugaBugaFooter =
  [hsx|
    <footer class="footer">
      <div class="container footer-text text-muted" style="font-family:Comic Sans MS; font-size:150%">
        <span>first the uwu</span>
        <span>then the daddy</span>
      </div>
    </footer>
|]

authLayout :: AuthFormType -> Html -> Html
authLayout auth inner =
  [hsx|
<div class="border">
<!-- Nav tabs -->
<ul class="nav nav-pills border" id="authTab" role="tablist">
  <li class="nav-item" role="presentation">
    <a class={classes ["nav-link", ("active", isActivePath NewSessionAction)]} id="login-tab" href={NewSessionAction} role="tab" aria-controls="login" aria-selected="true">Вход</a>
  </li>
  <li class="nav-item" role="presentation">
    <a class={classes ["nav-link", ("active", isActivePath NewUserAction)]} id="signup-tab" href={NewUserAction} role="tab" aria-controls="signup" aria-selected="false">Регистрация</a>
  </li>
</ul>
<!-- Tab panes -->
<div class="tab-content">
  <div class="tab-pane fade show active">
  {inner}
  </div>
</div>
</div>
|]