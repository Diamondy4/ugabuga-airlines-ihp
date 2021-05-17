module Web.View.Profile.Show where

import IHP.ControllerPrelude (AutoRoute (allowedMethodsForAction))
import Web.View.Helpers.ProfileLayout
import Web.View.Prelude
import qualified Data.HashMap.Strict as Map

data ShowView = ShowView {user :: Employee, airports :: [Airport]}

instance View ShowView where
  html ShowView {..} =
    tabsLayout
      user
      [hsx|
			<div class="h-50 d-inline-block w-100 tab-content border">
				<div class="tab-pane fade show active" id="employee-info">
					<div class="row">
						{renderInfo user isActivated airports}
					</div>
				</div>
			</div>
    |]
    where
      isActivated = get #accesslevel user /= 0

wtf = allowedMethodsForAction @EmployeesController "DeleteEmployeeAction"

renderInfo user isActivated airports =
  [hsx|
<div class="col m-3">
	<p class="m-1"><b>Почта</b>: {get #email user}</p>
	<p class="m-1"><b>Работник</b>: {get #surname user} {get #name user}</p>
	<p class="m-1"><b>Паспорт</b>: {get #passport user}</p>
	
	{inner}
</div>
|]
  where
    inner =
      if not isActivated
        then
          [hsx|
		<br>
		<p class="m-1">Дождитесь активации аккаунта от администратора.</p>
		<p>{get #accesslevel user}</p>
		|]
        else
          [hsx|
		<p class="m-1"><b>Аэропорт</b>: {(get #airportId user) |> maybe "" (\x -> fromMaybe "" ((Map.!?) airportMap x))}</p>
		<p class="m-1"><b>График работы</b>: {get #schedule user}</p>
		<p class="m-1"><b>Должность</b>: {get #jobname user  |> fromMaybe mempty}</p>
		<p class="m-1"><b>Зарплата</b>: {(get #salary user)}  руб.</p>
		|]
      where
        airportMap = Map.fromList $ (\x -> (get #id x, get #name x)) <$> airports
