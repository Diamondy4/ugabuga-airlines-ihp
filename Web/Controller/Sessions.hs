module Web.Controller.Sessions where

import qualified IHP.AuthSupport.Controller.Sessions as Sessions
import Web.Controller.Prelude
import Web.View.Sessions.New

instance Controller SessionsController where
  action NewSessionAction = Sessions.newSessionAction @Employee
  action CreateSessionAction = Sessions.createSessionAction @Employee
  action DeleteSessionAction = Sessions.deleteSessionAction @Employee

instance Sessions.SessionsControllerConfig Employee