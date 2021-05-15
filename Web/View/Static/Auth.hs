{-# LANGUAGE ImportQualifiedPost #-}
module Web.View.Static.Auth where

import Web.View.Prelude

data AuthView = AuthView

instance View AuthView where
  html AuthView =
    [hsx|
<div class="border">
<!-- Nav tabs -->
<ul class="nav nav-pills" id="myTab" role="tablist">
  <li class="nav-item" role="presentation">
    <a class="nav-link active" id="login-tab" data-toggle="pill" href="#login" role="tab" aria-controls="login" aria-selected="true">Вход</a>
  </li>
  <li class="nav-item" role="presentation">
    <a class="nav-link" id="signup-tab" data-toggle="pill" href="#signup" role="tab" aria-controls="signup" aria-selected="false">Регистрация</a>
  </li>
</ul>

<!-- Tab panes -->
<div class="tab-content">
  <div class="tab-pane fade show active" id="login" role="tabpanel" aria-labelledby="login-tab">
      {CreateEmployeeAction}
  </div>
  <div class="tab-pane fade" id="signup" role="tabpanel" aria-labelledby="signup-tab">
      signup
  </div>
</div>
</div>
    |]
