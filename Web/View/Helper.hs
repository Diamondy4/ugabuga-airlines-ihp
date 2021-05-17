module Web.View.Helper where

import qualified Data.IntMap as IntMap
import Web.View.Prelude

accessMap :: IntMap String
accessMap =
  IntMap.fromList
    [ (0, "Неактивно"),
      (1, "Стюардесса"),
      (2, "Пилот"),
      (3, "Диспетчер"),
      (4, "Бухгалтер"),
      (5, "Администратор")
    ]

access2text :: Int -> String
access2text user = accessMap IntMap.!  user

newtype AirportBox = Box Airport

instance CanSelect AirportBox where
  -- Here we specify that the <option> value should contain a `Id User`
  type SelectValue AirportBox = Id Airport

  -- Here we specify how to transform the model into <option>-value
  selectValue (Box x) = get #id x

  -- And here we specify the <option>-text
  selectLabel (Box x)= get #name x