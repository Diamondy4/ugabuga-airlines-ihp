module Web.Controller.Planes where

import Web.Controller.Prelude
import Web.View.Planes.Index
import Web.View.Planes.Edit
import Data.Functor
import Data.Traversable (Traversable(sequenceA, traverse))
import Web.Controller.Airports (nothingMaybeValidator, nonEmpty')

instance Controller PlanesController where
    action PlanesAction = do
        planes <- query @Plane |> fetch
        airports <- (planes <&> fetchRelated #airportId) |> sequenceA >>= \x -> return $ get #airportId <$> x
        render IndexView { .. }

    action NewPlaneAction = do
        let plane = newRecord
        airports <- query @Airport |> fetch
        setModal EditView {..} 
        jumpToAction PlanesAction

    action EditPlaneAction { planeId } = do
        plane <- fetch planeId
        airports <- query @Airport |> fetch
        setModal EditView {..} 
        jumpToAction PlanesAction

    action UpdatePlaneAction { planeId } = do
        plane <- fetch planeId
        plane
            |> buildPlane
            |> validateField #name nonEmpty'
            |> validateField #capacity (ifNotMsg (> 0) "Вместимость должна быть положительной")
            |> validateField #airportId nonEmpty'
            |> validateField #model nonEmpty'
            |> validateField #number nonEmpty'
            |> ifValid \case
                Left plane -> do
                    airports <- query @Airport |> fetch
                    setModal EditView {..} 
                    jumpToAction PlanesAction
                Right plane -> do
                    plane <- plane |> updateRecord
                    setSuccessMessage "Plane updated"
                    redirectTo PlanesAction

    action CreatePlaneAction = do
        let plane = newRecord @Plane
        plane
            |> buildPlane
            |> validateField #name nonEmpty'
            |> validateField #capacity (ifNotMsg (> 0) "Вместимость должна быть положительной")
            |> validateField #airportId nonEmpty'
            |> validateField #model nonEmpty'
            |> validateField #number nonEmpty'
            |> ifValid \case
                Left plane -> do
                    airports <- query @Airport |> fetch
                    setModal EditView {..} 
                    jumpToAction PlanesAction
                Right plane -> do
                    plane <- plane |> createRecord
                    setSuccessMessage "Plane created"
                    redirectTo PlanesAction

    action DeletePlaneAction { planeId } = do
        plane <- fetch planeId
        deleteRecord plane
        setSuccessMessage "Plane deleted"
        redirectTo PlanesAction

buildPlane plane = plane
    |> fill @'["name","id","capacity","airportId","model","number"]

ifNotMsg f msg x = if f x then Success else Failure msg

