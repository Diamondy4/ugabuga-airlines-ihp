module Web.Controller.Profile where

import qualified ClassyPrelude as CP
import Web.Controller.Prelude
import Web.View.Profile.Show
import Web.View.Profile.EditPassword

instance Controller ProfileController where
  beforeAction = ensureIsUser

  action ShowProfileAction = do
    let user = currentUser
    airports <- query @Airport |> fetch
    render ShowView {..}
  action EditPasswordProfileAction = do
    let user = currentUser
        act = ShowProfileAction
    --render EditPasswordView {..}
    setModal EditPasswordView {..}
    jumpToAction act