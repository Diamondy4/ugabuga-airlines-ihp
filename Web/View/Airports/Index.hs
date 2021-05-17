module Web.View.Airports.Index where

import Web.View.Helpers.ProfileLayout (tabsLayout)
import Web.View.Prelude

data IndexView = IndexView {airports :: [Airport]}

instance View IndexView where
  html IndexView {..} =
    tabsLayout
      currentUser
      [hsx|
	<script src="/view-change-password.js"></script>
    <form method="POST" action="/RemoveAirportsAction" id="" class="delete-emps-form">
    <div class="tab-pane fade show" id="flights-list">
					<div class="row">
						<input class="m-3 w-25 form-control" id="filterInput" type="text" placeholder="Фильтр...">
						<button type="button" class="m-3 btn btn-primary text-right " onclick="window.print()">Печать</button>
						<a href={NewAirportAction} class="m-3 btn btn-primary text-right ">Создать</a>
					</div>
					<table class="data-table table table-bordered">
						<thead class="thead-dark">
							<tr>
								<th>Название</th>
								<th>Адрес</th>
							</tr>
						</thead>
						<tbody>
							{forEach airports renderAirport}
						</tbody>
					</table>
				</div>
                </form>
|]

renderAirport (air :: Airport) =
  [hsx|
  <tr href={EditAirportAction airId}>
        <td>{get #name air}</td>
        <td>{get #address air}</td>
  </tr>
|]
  where
    airId = get #id air