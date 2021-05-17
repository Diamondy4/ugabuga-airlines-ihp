module Web.View.Flights.Edit where

import Data.Coerce (coerce)
import qualified Data.HashMap.Strict as Map
import Web.View.Prelude
import qualified ClassyPrelude as CP

data EditView = EditView {flight :: Flight, airports :: [Airport], gates :: [Gate], planes :: [Plane]}

instance View EditView where
  html EditView {..} =
    renderModal
      Modal
        { modalTitle = "Рейс",
          modalCloseUrl = pathTo FlightsAction,
          modalFooter = Nothing,
          modalContent = [hsx|
          {renderForm flight airports gates planes}
          <br>
          <a class="js-delete btn btn-primary" href={DeleteFlightAction (get #id flight)}>Удалить</a>
          |]
        }

renderForm :: _ => Flight -> [Airport] -> [Gate] -> [Plane] -> Html
renderForm flight airports gates planes =
  formFor
    flight
    [hsx|
    {(textField #flightnumber) {fieldLabel = "Номер рейса"}}
    {(selectField #planeId planes) {fieldLabel = "Самолет"}}
    {(selectField #outputgateId gates') {fieldLabel = "Откуда"}}
    {(selectField #inputgateId gates') {fieldLabel = "Куда"}}
    {(textField #flighttype) {fieldLabel = "Тип полета"}}
    {(dateTimeField #departuretime) {fieldLabel = "Время вылета"}}
    {(dateTimeField #arrivaltime) {fieldLabel = "Время прилета"}}
    {submitButton  {label = "Сохранить"}}
|]
  where
    airportMap = Map.fromList $ (\x -> (get #id x, get #name x)) <$> airports
    gates' = (\x -> (get #id x, (Map.!) airportMap (get #airportId x) <> " : " <> get #gatename x)) <$> gates

newtype AirportBox = Box Airport

instance CanSelect (Id' "Gates", Text) where
  -- Here we specify that the <option> value should contain a `Id User`
  type SelectValue (Id' "Gates", Text) = Id' "Gates"

  -- Here we specify how to transform the model into <option>-value
  selectValue = fst

  -- And here we specify the <option>-text
  selectLabel = snd

instance CanSelect Plane where
  -- Here we specify that the <option> value should contain a `Id User`
  type SelectValue Plane = Id' "Planes"

  -- Here we specify how to transform the model into <option>-value
  selectValue x = get #id x

  -- And here we specify the <option>-text
  selectLabel x = get #name x <> " : " <> get #model x <> "-" <> get #number x
