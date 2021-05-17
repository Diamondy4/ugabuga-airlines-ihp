module Web.View.Airports.Edit where

import Web.View.Prelude

data EditView = EditView {airport :: Airport}

instance View EditView where
  html EditView {..} =
    renderModal
      Modal
        { modalTitle = "Аэропорт",
          modalCloseUrl = pathTo AirportsAction,
          modalFooter = Nothing,
          modalContent = [hsx|
{renderForm airport}
<br>
<a class="js-delete btn btn-primary" href={DeleteAirportAction (get #id airport)}>Удалить</a>
|]
        }

renderForm :: Airport -> Html
renderForm airport =
  formFor
    airport
    [hsx|
    {(textField #name) {fieldLabel ="Название"}}
    {(textField #address) {fieldLabel ="Адрес"}}
    {(submitButton) {label = "Сохранить"}}
|]
