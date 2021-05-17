module Web.View.Helpers.ProfileLayout where

import Data.Functor (($>))
import Web.View.Prelude

tabsLayout user inner =
  [hsx|
<div class="container">
			<ul class="nav nav-tabs">
				{aboutTab}
        {flightTab $ any (\x -> get #accesslevel currentUser == x) [1,2,3]}
        {usersTab}
        {airportsTab}
        {planeTab}
        {gateTab}
			</ul>
      {inner}
</div>
|]

-- Profile tab

aboutTab :: _ => Html
aboutTab =
  [hsx|
<li class="nav-item">
	<a class={classes ["nav-link", ("active", isActivePath ShowProfileAction)]} href={ShowProfileAction}>О себе</a>
</li>
|]

-- Flighers tab

flightTab :: _ => Bool -> Html
flightTab True =
  [hsx|
<li class="nav-item">
	<a class={classes ["nav-link", ("active", isActivePath FlightsAction)]} href={FlightsAction}>Рейсы</a>
</li>
|]
flightTab False = ""

-- Admin tabs

usersTab :: _ => Html
usersTab = whenAdmin code
  where
    code =
      [hsx|
<li class="nav-item">
	<a class={classes ["nav-link", ("active", isActivePath EmployeesAction)]} href={EmployeesAction}>Работники</a>
</li>
|]

airportsTab :: _ => Html
airportsTab = whenAdmin code
  where
    code =
      [hsx|
<li class="nav-item">
	<a class={classes ["nav-link", ("active", isActivePath AirportsAction)]} href={AirportsAction}>Аэропорты</a>
</li>
|]

planeTab :: _ => Html
planeTab = whenAdmin code
  where
    code =
      [hsx|
<li class="nav-item">
	<a class={classes ["nav-link", ("active", isActivePath PlanesAction)]} href={PlanesAction}>Самолеты</a>
</li>
|]

gateTab :: _ => Html
gateTab = whenAdmin code
  where
    code =
      [hsx|
<li class="nav-item">
	<a class={classes ["nav-link", ("active", isActivePath GatesAction)]} href={GatesAction}>Гейты</a>
</li>
|]

isAdmin :: Employee -> Bool
isAdmin user = get #accesslevel user == 5

whenAdmin :: _ => p -> p
whenAdmin inner = if isAdmin currentUser then inner else mempty

