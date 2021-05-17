module Web.Controller.Airports where

import Web.Controller.Prelude
import Web.View.Airports.Index
import Web.View.Airports.Edit
import qualified ClassyPrelude as CP
import Data.Char (isLetter)

instance Controller AirportsController where
    action AirportsAction = do
        airports <- query @Airport |> fetch
        render IndexView { .. }

    action NewAirportAction = do
        let airport = newRecord

        setModal EditView {..} 
        jumpToAction AirportsAction

    action EditAirportAction { airportId } = do
        airport <- fetch airportId

        setModal EditView {..} 
        jumpToAction AirportsAction

    action UpdateAirportAction { airportId } = do
        airport <- fetch airportId
        airport
            |> buildAirport
            |> validateField #name nonEmpty'
            |> validateField #address nonEmpty'
            |> validateIsUnique' #name "Данный аэропорт уже существует"
            >>= ifValid \case
                Left airport -> do
                    setModal EditView {..} 
                    jumpToAction AirportsAction
                Right airport -> do
                    airport <- airport |> updateRecord
                    setSuccessMessage "Airport updated"
                    redirectTo EditAirportAction { .. }

    action CreateAirportAction = do
        let airport = newRecord @Airport
        airport
            |> buildAirport
            |> validateField #name nonEmpty'
            |> validateField #address nonEmpty'
            |> validateIsUnique' #name "Данный аэропорт уже существует"
            >>= ifValid \case
                Left airport -> do
                    setModal EditView {..} 
                    jumpToAction AirportsAction
                Right airport -> do
                    airport <- airport |> createRecord
                    setSuccessMessage "Airport created"
                    redirectTo AirportsAction

    action DeleteAirportAction { airportId } = do
        airport <- fetch airportId
        deleteRecord airport
        setSuccessMessage "Airport deleted"
        redirectTo AirportsAction

buildAirport airport = airport
    |> fill @'["name","address"]


isText :: (CP.MonoFoldable mono, CP.Element mono ~ Char) => mono -> ValidatorResult
isText txt = if CP.all (\x -> isLetter x || x == '-') txt then Success else Failure "Может состоять только из букв"

nonEmpty' :: forall value. IsEmpty value => value -> ValidatorResult
nonEmpty' = nonEmpty |> withCustomErrorMessage "Поле не может быть пустым"

isEmail' = isEmail |> withCustomErrorMessage "Не является верным e-mail адресом"

toMaybe :: (a -> ValidatorResult) -> Validator (Maybe a)
toMaybe =
  ( \fav ma ->
      case ma of
        Nothing -> Success
        (Just a) -> fav a
  )

nothingMaybeValidator :: Maybe a -> ValidatorResult
nothingMaybeValidator = maybe (Failure "Не заполнено.") (const Success)