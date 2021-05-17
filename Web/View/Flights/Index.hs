module Web.View.Flights.Index where

import Web.View.Helpers.ProfileLayout
import Web.View.Prelude

data IndexView = IndexView {user :: Employee, flights :: [Flight], flightsToGate :: [Gate], flightsToGateAirport :: [Airport], flightsFromGate :: [Gate], flightsFromGateAirport :: [Airport], flightsPlanes :: [Plane]}

instance View IndexView where
  html IndexView {..} =
    tabsLayout
      user
      [hsx|
	  {script}
    <div class="tab-pane fade show" id="flights-list">
					<div class="row">
						<input class="m-3 w-25 form-control" id="filterInput" type="text" placeholder="Фильтр...">
						<button type="button" class="m-3 btn btn-primary text-right " onclick="window.print()">Печать</button>
						{newFlightB user}
					</div>
					<table class="data-table table table-bordered">
						<thead class="thead-dark">
							<tr>
								<th>№ Аэропорта</th>
								<th>Откуда</th>
								<th>Куда</th>
								<th>Тип полета</th>
								<th>Тип самолета</th>
								<th>Время вылета</th>
								<th>Время прилета</th>
							</tr>
						</thead>
						<tbody>
							{forEach merged renderFlight}
						</tbody>
					</table>
				</div>
    |]
    where
        merged = zip6 flights flightsToGate flightsToGateAirport flightsFromGate flightsFromGateAirport flightsPlanes
        script = includeIfD user [hsx|<script src="/view-change-password.js"></script>|]

newFlightB user = includeIfD user [hsx|<a href={NewFlightAction} class="m-3 btn btn-primary text-right ">Создать</a>|]

includeIfD :: _ => Employee -> Html -> Html
includeIfD user code = if uAL == 3 then code else ""
  where
    uAL :: Int = get #accesslevel user

renderFlight :: _ => (Flight, Gate, Airport, Gate, Airport, Plane) -> Html
renderFlight (flight, toGate, toAirport, fromGate, fromAirport, plane) =
  [hsx|
    <tr href={EditFlightAction flightId}>
        <td>{get #flightnumber flight}</td>
        <td>{get #name fromAirport} : {get #gatename fromGate}</td>
        <td>{get #name toAirport} : {get #gatename toGate}</td>
        <td>{get #flighttype flight}</td>
		<td>{get #model plane}-{get #number plane}</td>
		<td>{get #departuretime flight}</td>
		<td>{get #arrivaltime flight}</td>
    </tr>
|]
 where flightId = get #id flight
