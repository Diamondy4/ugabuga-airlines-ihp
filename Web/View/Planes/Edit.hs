module Web.View.Planes.Edit where

import Data.Coerce (coerce)
import Web.View.Prelude

data EditView = EditView {plane :: Plane, airports :: [Airport]}

instance View EditView where
  html EditView {..} =
    renderModal
      Modal
        { modalTitle = "Самолет",
          modalCloseUrl = pathTo PlanesAction,
          modalFooter = Nothing,
          modalContent = [hsx|
{renderForm plane airports}
<br>
<a class="js-delete btn btn-primary" href={DeletePlaneAction (get #id plane)}>Удалить</a>
|]
        }

renderForm :: Plane -> [Airport] -> Html
renderForm plane airports =
  formFor
    plane
    [hsx|
    {(textField #name) {fieldLabel = "Название"}}
    {(textField #capacity) {fieldLabel = "Вместимость"}}
    {(selectField #airportId airportsBox) {fieldLabel = "Аэропорт"}}
    {(textField #model) {fieldLabel = "Модель"}}
    {(textField #number) {fieldLabel = "Номер"}}
    {(submitButton) {label = "Сохранить"}}
|]
  where
    airportsBox :: [AirportBox] = coerce airports

newtype AirportBox = Box Airport

instance CanSelect AirportBox where
  -- Here we specify that the <option> value should contain a `Id User`
  type SelectValue AirportBox = Id Airport

  -- Here we specify how to transform the model into <option>-value
  selectValue (Box x) = get #id x

  -- And here we specify the <option>-text
  selectLabel (Box x) = get #name x
