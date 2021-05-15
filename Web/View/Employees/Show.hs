module Web.View.Employees.Show where
import Web.View.Prelude

data ShowView = ShowView { employee :: Employee }

instance View ShowView where
    html ShowView { .. } = [hsx|
        <nav>
            <ol class="breadcrumb">
                <li class="breadcrumb-item"><a href={EmployeesAction}>Employees</a></li>
                <li class="breadcrumb-item active">Show Employee</li>
            </ol>
        </nav>
        <h1>Show Employee</h1>
        <p>{employee}</p>
    |]
