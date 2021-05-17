module Web.View.Employees.Edit(EditView(..)) where

import Web.View.Prelude

import Web.Helper

data EditView = EditView {user :: Employee, airports :: [Airport]}

instance View EditView where
  html EditView {..} =
    renderModal
      Modal
        { modalTitle = "Редактирование: " <> get #name user <> " " <> get #surname user,
          modalCloseUrl = pathTo EmployeesAction,
          modalFooter = Nothing,
          modalContent = [hsx|
{renderForm airports user}
<br>
<a class="js-delete btn btn-primary" href={DeleteEmployeeAction (get #id user)}>Удалить</a>
|]
        }

renderForm :: _ => [Airport] -> Employee -> Html
renderForm airports user =
  formFor
    user
    [hsx|
    {(textField #name) {fieldLabel = "Имя", placeholder = "Имя"}}
    {(textField #surname) {fieldLabel = "Фамилия", placeholder = "Имя"}}
    {(textField #passport) {fieldLabel = "Паспорт", placeholder = "Имя"}}
    {(textField #schedule) {fieldLabel = "Расписание", placeholder = "Имя"}}
    {(textField #salary) {fieldLabel = "Зарплата", placeholder = "Имя"}}
    {(selectField #airportId airports)}
    {(textField #jobname) {fieldLabel = "Должность", placeholder = "Имя"}}
    {(selectField #accesslevel accessList) {fieldLabel = "Уровень доступа"}}
    {submitButton {label  = "Изменить"}}
|]

data AccessLevel = AccessLevel {accessInt :: Int, accessText :: Text}

accessList =
  build
    <$> [ (0, "Неактивно"),
          (1, "Стюардесса"),
          (2, "Пилот"),
          (3, "Диспетчер"),
          (4, "Бухгалтер"),
          (5, "Администратор")
        ]
  where
    build (a, b) = AccessLevel a b

instance CanSelect AccessLevel where
  -- Here we specify that the <option> value should contain a `Id User`
  type SelectValue AccessLevel = Int

  -- Here we specify how to transform the model into <option>-value
  selectValue = accessInt

  -- And here we specify the <option>-text
  selectLabel = accessText
