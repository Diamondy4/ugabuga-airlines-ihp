module Web.View.Employees.New where

import Web.View.Prelude

data NewView = NewView {employee :: Employee}

instance View NewView where
  html NewView {..} =
    authLayout
      Signup
      [hsx|
      <div class="h-100" id="sessions-new">
            <div class="d-flex align-items-center">
                <div class="w-100">
                    <div style="max-width: 400px" class="mx-auto mb-5">
                        {renderForm employee}
                    </div>
                </div>
            </div>
        </div>
    |]

renderForm :: Employee -> Html
renderForm emp =
  formFor
    emp
    [hsx|
    <div class="row flex justify-content-center">
        <div class="col">
          {(textField #name) {fieldLabel = "Имя",fieldClass = "col", disableGroup = True, placeholder = "Уга"}  }
        </div>
        <div class="col">
          {(textField #surname) {fieldLabel= "Фамилия",fieldClass = "col", disableGroup = True, placeholder = "Буга"}}
        </div>
    </div>
    {(textField #passport) {fieldLabel = "Паспорт", placeholder = "12345 123456"}}
    {(textField #email) {fieldLabel = "E-Mail", placeholder = "login@server.com"}}
    {(passwordField #passwordHash) {fieldLabel = "Пароль", placeholder = "Пароль"}}
    <div class="flex items-center justify-between">
      {submitButton {label = "Зарегистрироваться", buttonClass = "btn btn-primary btn-block btn-gray"}}
    </div>
|]
