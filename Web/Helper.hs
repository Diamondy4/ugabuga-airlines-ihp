module Web.Helper where

import Web.View.Prelude

instance CanSelect Airport where
  -- Here we specify that the <option> value should contain a `Id User`
  type SelectValue Airport = Maybe (Id Airport)

  -- Here we specify how to transform the model into <option>-value
  selectValue x = Just $ get #id x

  -- And here we specify the <option>-text
  selectLabel = get #name
