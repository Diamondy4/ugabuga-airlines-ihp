module Web.View.Sessions.New where

import IHP.AuthSupport.View.Sessions.New
import Web.View.Prelude

instance View (NewView Employee) where
  html NewView {..} =
    authLayout
      Login
      [hsx|
        <div class="h-100" id="sessions-new">
            <div class="d-flex align-items-center">
                <div class="w-100">
                    <div style="max-width: 400px" class="mx-auto mb-5">
                        {renderForm user}
                    </div>
                </div>
            </div>
        </div>
    |]

renderForm :: Employee -> Html
renderForm user =
  [hsx|
    <form method="POST" action={CreateSessionAction}>
        <div class="form-group">
            <label for="email">E-Mail</label>
            <input id="email" name="email" value={get #email user} type="email" class="form-control" required autofocus placeholder="ugabuga@pipi.pupu"/>
        </div>
        <div class="form-group">
            <label for="password">Пароль</label>
            <input required id="password" name="password" type="password" class="form-control" placeholder="Пароль"/>
        </div>
        <div class="flex items-center justify-between">
            <button type="submit" class="btn btn-primary btn-block btn-gray">Войти</button>
        </div>
    </form>
|]