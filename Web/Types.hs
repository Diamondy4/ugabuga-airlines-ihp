module Web.Types where

import Generated.Types
import IHP.LoginSupport.Types
import IHP.ModelSupport
import IHP.Prelude

data WebApplication = WebApplication deriving (Eq, Show)

data StaticController = AuthAction deriving (Eq, Show, Data)

instance HasNewSessionUrl Employee where
  newSessionUrl _ = "/NewSession"

type instance CurrentUserRecord = Employee

data SessionsController
  = NewSessionAction
  | CreateSessionAction
  | DeleteSessionAction
  deriving (Eq, Show, Data)

data AuthFormType = Login | Signup
data EmployeesController
    = EmployeesAction
    | NewEmployeeAction
    | ShowEmployeeAction { employeeId :: !(Id Employee) }
    | CreateEmployeeAction
    | EditEmployeeAction { employeeId :: !(Id Employee) }
    | UpdateEmployeeAction { employeeId :: !(Id Employee) }
    | DeleteEmployeeAction { employeeId :: !(Id Employee) }
    deriving (Eq, Show, Data)
