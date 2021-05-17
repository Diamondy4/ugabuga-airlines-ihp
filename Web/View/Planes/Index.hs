module Web.View.Planes.Index where

import Web.View.Helpers.ProfileLayout (tabsLayout)
import Web.View.Prelude

data IndexView = IndexView {planes :: [Plane], airports :: [Airport]}

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
						<a href={NewPlaneAction} class="m-3 btn btn-primary text-right ">Создать</a>
					</div>
					<table class="data-table table table-bordered">
						<thead class="thead-dark">
							<tr>
								<th>Название</th>
								<th>Вместимость</th>
                <th>Аэропорт</th>
                <th>Модель</th>
                <th>Номер</th>
							</tr>
						</thead>
						<tbody>
							{forEach (zip planes airports) renderPlane}
						</tbody>
					</table>
				</div>
                </form>
|]

renderPlane ((plane, airport) :: (Plane, Airport)) =
  [hsx|
  <tr href={EditPlaneAction planeId}>
        <td>{get #name plane}</td>
        <td>{get #capacity plane}</td>
        <td>{get #name airport}</td>
        <td>{get #model plane}</td>
        <td>{get #number plane}</td>
        </tr>
|]
  where
    planeId = get #id plane