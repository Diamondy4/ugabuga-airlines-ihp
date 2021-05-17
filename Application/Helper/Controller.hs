module Application.Helper.Controller where

import IHP.ControllerPrelude
import Database.PostgreSQL.Simple.ToField (ToField)

-- Here you can add functions which are available in all your controllers

validateIsUnique' :: forall field model savedModel validationState fieldValue validationStateValue fetchedModel modelId savedModelId. (
        savedModel ~ NormalizeModel model
        , ?modelContext :: ModelContext
        , FromRow savedModel
        , KnownSymbol field
        , HasField field model fieldValue
        , HasField field savedModel fieldValue
        , KnownSymbol (GetTableName savedModel)
        , ToField fieldValue
        , EqOrIsOperator fieldValue
        , HasField "meta" model MetaBag
        , SetField "meta" model MetaBag
        , HasField "id" savedModel savedModelId
        , HasField "id" model modelId
        , savedModelId ~ modelId
        , Eq modelId
        , GetModelByTableName (GetTableName savedModel) ~ savedModel
    ) => Proxy field -> Text -> model -> IO model
validateIsUnique' fieldProxy message model = do
    let value = getField @field model
    result <- query @savedModel
        |> filterWhere (fieldProxy, value)
        |> fetchOneOrNothing
    case result of
        Just value | not $ (getField @"id" model) == (getField @"id" value) -> pure (attachValidatorResult fieldProxy (Failure message) model)
        _ -> pure (attachValidatorResult fieldProxy Success model)
{-# INLINE validateIsUnique' #-}

getAll label x = x |> fetchRelated label >>= \x -> return $ get label x 

