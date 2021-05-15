module Web.View.Employees.Edit where
import Web.View.Prelude

data EditView = EditView { employee :: Employee }

instance View EditView where
    html EditView { .. } = [hsx|
        <nav>
            <ol class="breadcrumb">
                <li class="breadcrumb-item"><a href={EmployeesAction}>Employees</a></li>
                <li class="breadcrumb-item active">Edit Employee</li>
            </ol>
        </nav>
        <h1>Edit Employee</h1>
        {renderForm employee}
    |]

renderForm :: Employee -> Html
renderForm employee = formFor employee [hsx|

    {submitButton}
|]
