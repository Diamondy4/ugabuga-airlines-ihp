module Web.View.Employees.Index where

import Data.Maybe (fromJust)
import Web.Controller.Prelude (AutoRoute (allowedMethodsForAction))
import Web.View.Helper (access2text)
import Web.View.Helpers.ProfileLayout (tabsLayout)
import Web.View.Prelude

data IndexView = IndexView {employees :: [Employee]}

instance View IndexView where
  html IndexView {..} =
    tabsLayout
      currentUser
      [hsx|
	<script src="/view-change-password.js"></script>
    <form method="POST" action="/RemoveEmployeesAction" id="" class="delete-emps-form">
    <div class="tab-pane fade show" id="flights-list">
					<div class="row">
						<input class="m-3 w-25 form-control" id="filterInput" type="text" placeholder="Фильтр...">
						<button type="button" class="m-3 btn btn-primary text-right " onclick="window.print()">Печать</button>
					</div>
					<table class="data-table table table-bordered">
						<thead class="thead-dark">
							<tr>
								<th>E-Mail</th>
								<th>Имя</th>
								<th>Фамилия</th>
								<th>Должность</th>
								<th>Роль</th>
							</tr>
						</thead>
						<tbody>
							{forEach employees renderEmployee}
						</tbody>
					</table>
				</div>
                </form>
|]

renderEmployee (emp :: Employee) =
  [hsx|
  <tr href={EditEmployeeAction empid}>
        <input type="hidden" name="empForm[]" value={show empid}/>
        <td>{get #email emp}</td>
        <td>{get #name emp}</td>
        <td>{get #surname emp}</td>
        <td>{get #jobname emp |> fromMaybe mempty}</td>
        <td>{access2text $ get #accesslevel emp}</td>
    </tr>
|]
  where
    empid = get #id emp

{-
renderEmployee employee = [hsx|
    <tr>
        <td>{employee}</td>
        <td><a href={ShowEmployeeAction (get #id employee)}>Show</a></td>
        <td><a href={EditEmployeeAction (get #id employee)} class="text-muted">Edit</a></td>
        <td><a href={DeleteEmployeeAction (get #id employee)} class="js-delete text-muted">Delete</a></td>
    </tr>
|]
 -}