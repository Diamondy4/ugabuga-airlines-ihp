module Web.View.Users.New where

import Web.View.Prelude

data NewView = NewView {user :: User, employee :: Employee}

instance View NewView where
  html NewView {..} =
    authLayout
      Signup
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

renderForm :: User -> Employee -> Html
renderForm user emp =
  formFor
    user
    [hsx|
    {(textField #)}
    {(textField #email)}
    {(textField #passwordHash)}
    {submitButton}
|]
