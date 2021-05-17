module Web.View.Gates.Edit where

import Data.Coerce (coerce)
import Web.View.Prelude

data EditView = EditView {gate :: Gate, airports :: [Airport]}

instance View EditView where
  html EditView {..} =
    renderModal
      Modal
        { modalTitle = "Гейт",
          modalCloseUrl = pathTo GatesAction,
          modalFooter = Nothing,
          modalContent = [hsx|
{renderForm gate airports}
<br>
<a class="js-delete btn btn-primary" href={DeleteGateAction (get #id gate)}>Удалить</a>
|]
        }

renderForm :: Gate -> [Airport] -> Html
renderForm gate airports =
  formFor
    gate
    [hsx|
    {(textField #gatename) {fieldLabel = "Найзвание гейта"}}
    {(selectField #airportId airportsBox) {fieldLabel = "Аэропорт"}}
    {(textField #schedule) {fieldLabel = "Расписание"}}
    {submitButton  {label = "Сохранить"}}
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