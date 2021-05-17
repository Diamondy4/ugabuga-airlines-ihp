module Web.Controller.Employees where

import qualified ClassyPrelude as CP
import Data.Char (isDigit, isLetter)
import Text.Regex.TDFA ((=~))
import Web.Controller.Prelude
import Web.View.Employees.Edit
import Web.View.Employees.Index
import Web.View.Employees.New

import Web.View.Helpers.ProfileLayout (isAdmin)
import Data.Traversable (Traversable(traverse))
import Data.Foldable (for_)
import ClassyPrelude (print)

instance Controller EmployeesController where
  action RemoveEmployeesAction {..} = do
    employees <- traverse fetch employeeIds
    let count = length employeeIds

    for_ employees $ \employee ->
      print employee      
      --deleteRecord employee
      
    setSuccessMessage $ show count <> " работников удалено."
    --redirectTo EmployeesAction

  action EmployeesAction = do
    ensureIsUser
    accessDeniedUnless $ isAdmin currentUser
    employees <- query @Employee |> fetch
    render IndexView {..}

  action NewEmployeeAction = do
    let employee = newRecord
    render NewView {..}

  action EditEmployeeAction {employeeId} = do
    ensureIsUser
    unless (isAdmin currentUser) $ redirectTo ShowProfileAction
    user <- fetch employeeId
    airports <- query @Airport |> fetch
    setModal EditView {..}
    jumpToAction EmployeesAction
    
  action UpdateEmployeeAction {employeeId} = do
    employee <- fetch employeeId
    employee
      |> editEmployee
      |> validateField #name (validateAll [nonEmpty', isText])
      |> validateField #surname (validateAll [nonEmpty', isText])
      |> validateField #passport passportValidator
      |> validateField #schedule scheduleValidator
      |> validateField #jobname (toMaybe nonEmpty')
      |> validateField #salary isInSalRange
      |> validateField #accesslevel isActivated
      |> validateField #airportId nothingMaybeValidator
      |> ifValid \case
        Left user -> do
          airports <- query @Airport |> fetch
          render EditView {..}
        Right employee -> do
          employee <- employee |> updateRecord
          setSuccessMessage "Employee updated"
          redirectTo EditEmployeeAction {..}

  action CreateEmployeeAction = do
    let user = newRecord @Employee
    user
      |> buildEmployee
      |> validateField #name (validateAll [nonEmpty', isText])
      |> validateField #surname (validateAll [nonEmpty', isText])
      |> validateField #passport passportValidator
      |> validateField #email isEmail'
      |> validateField #passwordHash nonEmpty'
      |> validateIsUnique' #email "Этот адрес уже используется."
      >>= validateIsUnique' #passport "Этот паспорт уже используется."
      >>= ifValid \case
        Left employee -> render NewView {..}
        Right employee -> do
          hashed <- hashPassword (get #passwordHash employee)
          employee <-
            employee
              |> set #passwordHash hashed
              |> createRecord
          setSuccessMessage "Вы зарегестрированы! Войдите используя почту и пароль."
          redirectTo NewSessionAction
  action DeleteEmployeeAction {employeeId} = do
    employee <- fetch employeeId
    deleteRecord employee
    setSuccessMessage "Employee deleted"
    redirectTo EmployeesAction

nothingMaybeValidator :: Maybe a -> ValidatorResult
nothingMaybeValidator = maybe (Failure "Не заполнено.") (const Success)

isActivated :: Int -> ValidatorResult
isActivated lvl = if lvl > 0 && lvl <= 5 then Success else Failure "Активируйте аккаунт."

isInSalRange :: Float -> ValidatorResult
isInSalRange sal= if sal >= 0 && sal <= 10^^1024 then Success else Failure "Зарплата должна быть числом и больше 0."

buildEmployee user = user |> fill @["email", "passwordHash", "passport", "name", "surname"]

editEmployee user = user |> fill @["name", "surname", "passport", "schedule", "jobname", "salary", "accesslevel", "airportId"]

passportValidator passport =
  if passport =~ ("[0-9]{5} [0-9]{6}" :: Text)
    then Success
    else Failure "Введите серию и номер паспорта в формате \"12345 123456\""

scheduleValidator schedule =
  if maybe False (\x -> x =~ ("[0-2]?[0-9]:[0-5][0-9]-[0-2]?[0-9]:[0-5][0-9]" :: Text)) schedule
    then Success
    else Failure "Введите расписание в формате \"12:34-13:45\""

isText :: (CP.MonoFoldable mono, CP.Element mono ~ Char) => mono -> ValidatorResult
isText txt = if CP.all (\x -> isLetter x || x == '-') txt then Success else Failure "Может состоять только из букв"

nonEmpty' = nonEmpty |> withCustomErrorMessage "Поле не может быть пустым"

isEmail' = isEmail |> withCustomErrorMessage "Не является верным e-mail адресом"

toMaybe :: (a -> ValidatorResult) -> Validator (Maybe a)
toMaybe =
  ( \fav ma ->
      case ma of
        Nothing -> Success
        (Just a) -> fav a
  )

