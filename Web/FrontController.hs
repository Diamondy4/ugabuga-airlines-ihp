module Web.FrontController where

import IHP.LoginSupport.Middleware
import IHP.RouterPrelude
-- Controller Imports

import Web.Controller.Gates
import Web.Controller.Planes
import Web.Controller.Flights
import Web.Controller.Airports

import Web.Controller.Employees
import Web.Controller.Prelude
import Web.Controller.Profile
import Web.Controller.Sessions
import Web.Controller.Static
import Web.View.Layout (defaultLayout)

instance FrontController WebApplication where
  controllers =
    [ startPage ShowProfileAction
      ,parseRoute @SessionsController
      -- Generator Marker
        , parseRoute @GatesController
        , parseRoute @PlanesController
        , parseRoute @FlightsController
      , parseRoute @AirportsController
      ,parseRoute @ProfileController
      ,parseRoute @EmployeesController
    ]

instance InitControllerContext WebApplication where
  initContext = do
    setLayout defaultLayout
    initAutoRefresh
    initAuthentication @Employee
