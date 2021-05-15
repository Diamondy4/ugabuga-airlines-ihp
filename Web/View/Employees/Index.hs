module Web.View.Employees.Index where
import Web.View.Prelude

data IndexView = IndexView { employees :: [Employee] }

instance View IndexView where
    html IndexView { .. } = [hsx|
        <nav>
            <ol class="breadcrumb">
                <li class="breadcrumb-item active"><a href={EmployeesAction}>Employees</a></li>
            </ol>
        </nav>
        <h1>Index <a href={pathTo NewEmployeeAction} class="btn btn-primary ml-4">+ New</a></h1>
        <div class="table-responsive">
            <table class="table">
                <thead>
                    <tr>
                        <th>Employee</th>
                        <th></th>
                        <th></th>
                        <th></th>
                    </tr>
                </thead>
                <tbody>{forEach employees renderEmployee}</tbody>
            </table>
        </div>
    |]


renderEmployee employee = [hsx|
    <tr>
        <td>{employee}</td>
        <td><a href={ShowEmployeeAction (get #id employee)}>Show</a></td>
        <td><a href={EditEmployeeAction (get #id employee)} class="text-muted">Edit</a></td>
        <td><a href={DeleteEmployeeAction (get #id employee)} class="js-delete text-muted">Delete</a></td>
    </tr>
|]
