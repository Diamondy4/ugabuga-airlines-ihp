module Web.Controller.Static where

import Web.Controller.Prelude
import Web.View.Static.Auth

instance Controller StaticController where
  action AuthAction = render AuthView
