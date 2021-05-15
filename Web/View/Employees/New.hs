module Web.View.Employees.New where
import Web.View.Prelude

data NewView = NewView { employee :: Employee }

instance View NewView where
  html NewView {..} =
    authLayout
      Signup
      [hsx|
      <div class="h-100" id="sessions-new">
            <div class="d-flex align-items-center">
                <div class="w-100">
                    <div style="max-width: 400px" class="mx-auto mb-5">
                        {renderForm employee}
                    </div>
                </div>
            </div>
        </div>
    |]

renderForm :: Employee -> Html
renderForm emp =
  formFor [hsx|
    {(textField #name)}
    {(textField #email)}
    {(textField #passwordHash)}
    {submitButton}
|]
