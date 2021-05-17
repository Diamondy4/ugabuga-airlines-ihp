module Web.Controller.Flights where

import qualified ClassyPrelude as CP
import Data.Traversable (Traversable (traverse), for)
import Web.Controller.Prelude
import Web.View.Flights.Edit
import Web.View.Flights.Index
import Data.Functor
import Web.Controller.Airports (nonEmpty')
import Web.Controller.Planes (ifNotMsg)

instance Controller FlightsController where
  beforeAction = do
    ensureIsUser
    accessDeniedUnless $ any (\x -> get #accesslevel currentUser == x) [1, 2, 3]

  action FlightsAction = do
    let user = currentUser
    redirectTo
      if get #accesslevel currentUser == 1
        then UserFlightsAction
        else AllFlightsAction

  action AllFlightsAction = do
    accessDeniedUnless $ any (\x -> get #accesslevel currentUser == x) [2, 3]
    flights <- query @Flight |> fetch
    let user = currentUser
        getFromGate = getAll #outputgateId 
        getToGate = getAll #inputgateId 
        getAirport = getAll #airportId
        getPlane = getAll #planeId
    flightsToGate <- traverse getToGate flights
    flightsFromGate <- traverse getFromGate flights

    
    flightsToGateAirport <- traverse getAirport flightsToGate
    flightsFromGateAirport <- traverse getAirport flightsFromGate

    flightsPlanes <- traverse getPlane flights
    
    render IndexView {..}

  action UserFlightsAction = do
    userFlightsQuery <- get #employeeflight currentUser |> fetch >>= collectionFetchRelated #flightId
    let flights =  userFlightsQuery <&> get #flightId 
        user = currentUser
        getFromGate = getAll #outputgateId 
        getToGate = getAll #inputgateId 
        getAirport = getAll #airportId
        getPlane = getAll #planeId
    flightsToGate <- traverse getToGate flights
    flightsFromGate <- traverse getFromGate flights

    
    flightsToGateAirport <- traverse getAirport flightsToGate
    flightsFromGateAirport <- traverse getAirport flightsFromGate

    flightsPlanes <- traverse getPlane flights
    
    render IndexView {..}
    
  action NewFlightAction = do
    let flight = newRecord
    airports <- query @Airport |> fetch
    gates <- query @Gate |> fetch
    planes <- query @Plane |> fetch

    render EditView {..} 
    jumpToAction AllFlightsAction


  action EditFlightAction {flightId} = do
    flight <- fetch flightId
    airports <- query @Airport |> fetch
    gates <- query @Gate |> fetch
    planes <- query @Plane |> fetch
    
    setModal EditView {..} 
    jumpToAction AllFlightsAction

  action UpdateFlightAction {flightId} = do
    flight <- fetch flightId
    flight
      |> buildFlight
      |> ifValid \case
        Left flight -> do
          airports <- query @Airport |> fetch
          gates <- query @Gate |> fetch
          planes <- query @Plane |> fetch

          setModal EditView {..} 
          jumpToAction AllFlightsAction
        Right flight -> do
          flight <- flight |> updateRecord
          setSuccessMessage "Flight updated"
          redirectTo EditFlightAction {..}

  action CreateFlightAction = do
    let flight = newRecord @Flight
    flight
      |> buildFlight
      |> validateField #flightnumber nonEmpty'
      |> \x -> validateField #outputgateId (ifNotMsg (\_ ->  get #outputgateId x /= get #inputgateId x) "Аэропорты вылета и прилета должны быть различны.") x
      |> validateField #outputgateId nonEmpty'
      |> validateField #inputgateId nonEmpty'
      |> validateField #planeId nonEmpty'
      |> validateField #flighttype nonEmpty'
      |> \x -> validateField #departuretime (ifNotMsg (\_ -> get #departuretime x < get #arrivaltime x) "Вылет должен быть до прилета.") x
      |> validateIsUnique #flightnumber
      >>= ifValid \case
            Left flight -> do
              airports <- query @Airport |> fetch
              gates <- query @Gate |> fetch
              planes <- query @Plane |> fetch
              setErrorMessage "Error"
              setModal EditView {..}
              jumpToAction AllFlightsAction
            Right flight -> do
              flight <- flight |> fillAirport >>= createRecord
              setSuccessMessage "Flight created"
              redirectTo AllFlightsAction
          
  action DeleteFlightAction {flightId} = do
    flight <- fetch flightId
    deleteRecord flight
    setSuccessMessage "Полет удален"
    redirectTo FlightsAction

--buildFlight :: _ => Flight -> Flight
buildFlight flight =
  flight
    |> fill @'["id","planeId","flightnumber","outputgateId","inputgateId", "flighttype","departuretime","arrivaltime"]

fillAirport (x :: Flight) = do
  fromGate <- get #outputgateId x |> fetch
  toGate <- get #inputgateId x |> fetch
  let fromAir = get #airportId fromGate
      toAir = get #airportId toGate
  return $ x |> set #fromportId fromAir |> set #toportId toAir
