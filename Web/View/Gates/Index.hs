module Web.View.Gates.Index where

import Web.View.Helpers.ProfileLayout (tabsLayout)
import Web.View.Prelude

data IndexView = IndexView {gates :: [Gate], airports :: [Airport]}

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
						<a href={NewGateAction} class="m-3 btn btn-primary text-right ">Создать</a>
					</div>
					<table class="data-table table table-bordered">
						<thead class="thead-dark">
							<tr>
								<th>Название</th>
								<th>Аэропорт</th>
								<th>Расписание работы</th>
							</tr>
						</thead>
						<tbody>
							{forEach (zip gates airports) renderGate}
						</tbody>
					</table>
				</div>
                </form>
|]

renderGate ((gate, airport) :: (Gate, Airport)) =
  [hsx|
  <tr href={EditGateAction gateId}>
        <td>{get #gatename gate}</td>
        <td>{get #name airport}</td>
        <td>{get #schedule gate}</td>
  </tr>
|]
  where
    gateId = get #id gate