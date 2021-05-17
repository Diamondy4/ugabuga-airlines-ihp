module Web.View.Profile.EditPassword where

import Web.View.Prelude

data EditPasswordView = EditPasswordView {user :: Employee}

instance View EditPasswordView where
  html EditPasswordView {..} =
    renderModal
      Modal
        { modalTitle = "New Project",
          modalCloseUrl = pathTo ShowProfileAction,
          modalFooter = Nothing,
          modalContent = renderForm user
        }

renderForm :: Employee -> Html
renderForm user =
  formFor
    user
    [hsx|
    {(textField #passwordHash) {fieldName="pass", fieldLabel = "Старый пароль", placeholder = "Старый пароль"}}
    {(textField #passwordHash) {fieldName="newpass", fieldLabel = "Новый пароль",placeholder = "Новый пароль"}}
    {(textField #passwordHash) {fieldName="newpassrep", fieldLabel = "Повторите новый пароль",placeholder = "Повторите новый пароль"}}
    {submitButton {label  = "Изменить"}}
|]
