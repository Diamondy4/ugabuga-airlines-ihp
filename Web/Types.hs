module Web.Types where

import Generated.Types
import IHP.LoginSupport.Types
import IHP.ModelSupport
import IHP.Prelude

data WebApplication = WebApplication deriving (Eq, Show)

data StaticController deriving (Eq, Show, Data)

instance HasNewSessionUrl Employee where
  newSessionUrl _ = "/NewSession"

type instance CurrentUserRecord = Employee

data SessionsController
  = NewSessionAction
  | CreateSessionAction
  | DeleteSessionAction
  deriving (Eq, Show, Data)

data AuthFormType = Login | Signup

data EmployeesController
  = EmployeesAction
  | NewEmployeeAction
  | CreateEmployeeAction
  | EditEmployeeAction {employeeId :: !(Id Employee)}
  | UpdateEmployeeAction {employeeId :: !(Id Employee)}
  | DeleteEmployeeAction {employeeId :: !(Id Employee)}
  | RemoveEmployeesAction {employeeIds :: ![Id Employee]}
  deriving (Eq, Show, Data)

data ProfileController
  = ShowProfileAction
  | EditPasswordProfileAction
  deriving (Eq, Show, Data)

data AirportsController
  = AirportsAction
  | NewAirportAction
  | CreateAirportAction
  | EditAirportAction {airportId :: !(Id Airport)}
  | UpdateAirportAction {airportId :: !(Id Airport)}
  | DeleteAirportAction {airportId :: !(Id Airport)}
  deriving (Eq, Show, Data)

data FlightsController
  = AllFlightsAction
  | FlightsAction
  | UserFlightsAction
  | NewFlightAction
  | CreateFlightAction
  | EditFlightAction {flightId :: !(Id Flight)}
  | UpdateFlightAction {flightId :: !(Id Flight)}
  | DeleteFlightAction {flightId :: !(Id Flight)}
  deriving (Eq, Show, Data)

data PlanesController
  = PlanesAction
  | NewPlaneAction
  | CreatePlaneAction
  | EditPlaneAction {planeId :: !(Id Plane)}
  | UpdatePlaneAction {planeId :: !(Id Plane)}
  | DeletePlaneAction {planeId :: !(Id Plane)}
  deriving (Eq, Show, Data)

data GatesController
  = GatesAction
  | NewGateAction
  | CreateGateAction
  | EditGateAction {gateId :: !(Id Gate)}
  | UpdateGateAction {gateId :: !(Id Gate)}
  | DeleteGateAction {gateId :: !(Id Gate)}
  | GatesByAirportAction {airportId :: !(Id Airport)}
  deriving (Eq, Show, Data)

data AdminController
  = AdminAction
  deriving (Eq, Show, Data)
