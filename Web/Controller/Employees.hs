module Web.Controller.Employees where

import Web.Controller.Prelude
import Web.View.Employees.Edit
import Web.View.Employees.Index
import Web.View.Employees.New
import Web.View.Employees.Show

instance Controller EmployeesController where
  action EmployeesAction = do
    employees <- query @Employee |> fetch
    render IndexView {..}
  action NewEmployeeAction = do
    let employee = newRecord
    render NewView {..}
  action ShowEmployeeAction {employeeId} = do
    employee <- fetch employeeId
    render ShowView {..}
  action EditEmployeeAction {employeeId} = do
    employee <- fetch employeeId
    render EditView {..}
  action UpdateEmployeeAction {employeeId} = do
    employee <- fetch employeeId
    employee
      |> buildEmployee
      |> ifValid \case
        Left employee -> render EditView {..}
        Right employee -> do
          employee <- employee |> updateRecord
          setSuccessMessage "Employee updated"
          redirectTo EditEmployeeAction {..}
  action CreateEmployeeAction = do
    let user = newRecord @Employee
    user
      |> buildEmployee
      |> validateField #email isEmail
      |> validateField #passwordHash nonEmpty
      |> validateIsUnique #email
      >>= ifValid \case
        Left user -> render NewView {..}
        Right user -> do
          hashed <- hashPassword (get #passwordHash user)
          user <-
            user
              |> set #passwordHash hashed
              |> createRecord
          setSuccessMessage "You have registered successfully"
  action DeleteEmployeeAction {employeeId} = do
    employee <- fetch employeeId
    deleteRecord employee
    setSuccessMessage "Employee deleted"
    redirectTo EmployeesAction

buildEmployee user = user |> fill @["email", "passwordHash"]