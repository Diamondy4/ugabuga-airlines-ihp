module Web.Controller.Gates where

import Web.Controller.Prelude
import Web.View.Gates.Index
import Web.View.Gates.Edit
import Data.Functor ((<&>))
import Data.Traversable (Traversable(sequenceA))
import Text.Regex.TDFA ((=~))
import Web.Controller.Airports (nonEmpty')
import Web.Controller.Planes (ifNotMsg)
import qualified ClassyPrelude as CP


instance Controller GatesController where
    action GatesAction = do
        gates <- query @Gate |> fetch
        airports <- (gates <&> fetchRelated #airportId) |> sequenceA >>= \x -> return $ get #airportId <$> x
        render IndexView {..} 

    action NewGateAction = do
        let gate = newRecord
        airports <- query @Airport |> fetch
        setModal EditView {..} 
        jumpToAction GatesAction

    action EditGateAction { gateId } = do
        gate <- fetch gateId
        airports <- query @Airport |> fetch
        setModal EditView {..} 
        jumpToAction GatesAction

    action UpdateGateAction { gateId } = do
        gate <- fetch gateId
        gate
            |> buildGate
            |> ifValid \case
                Left gate -> do
                    airports <- query @Airport |> fetch
                    setModal EditView {..} 
                    jumpToAction GatesAction
                Right gate -> do
                    gate <- gate |> updateRecord
                    setSuccessMessage "Гейт обновлен"
                    redirectTo EditGateAction { .. }

    action CreateGateAction = do
        let gate = newRecord @Gate
        gate
            |> buildGate
            |> validateField #gatename nonEmpty'
            |> validateField #schedule scheduleValidator
            |> validateField #airportId nonEmpty'
            |> ifValid \case
                Left gate -> do
                    airports <- query @Airport |> fetch
                    setModal EditView {..} 
                    jumpToAction GatesAction
                Right gate -> do
                    gate <- gate |> createRecord
                    setSuccessMessage "Гейт создан"
                    redirectTo GatesAction

    action DeleteGateAction { gateId } = do
        gate <- fetch gateId
        deleteRecord gate
        setSuccessMessage "Gate deleted"
        redirectTo GatesAction

    action GatesByAirportAction { airportId } = do
        airport <- fetch airportId
        gates <- get #gates airport |> fetch
        renderJson (toJSON gates)

buildGate gate = gate
    |> fill @'["gatename","airportId","schedule"]

scheduleValidator schedule =
  if schedule =~ ("[0-2]?[0-9]:[0-5][0-9]-[0-2]?[0-9]:[0-5][0-9]" :: Text)
    then Success
    else Failure "Введите расписание в формате \"12:34-13:45\""

instance ToJSON Gate where
        toJSON gate = object
         [ "id" .= get #id gate
         , "gatename" .= get #gatename gate
         , "airportId" .= get #airportId gate
         ]