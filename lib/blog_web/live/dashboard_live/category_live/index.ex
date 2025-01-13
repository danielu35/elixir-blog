defmodule BlogWeb.Live.DashboardLive.CategoryLive.Index do
  use BlogWeb, :live_view
  alias Blog.Catalog
  alias Blog.Category
  alias Blog.Accounts


  def mount(_params, session, socket) do
    current_user = Accounts.get_user_by_session_token(session["user_token"])
    changeset = Catalog.change_category(%Category{}, %{})
    categories = Catalog.list_categories()

    socket =
      socket
      |> stream(:categories, categories)
      |> assign(:current_user, current_user)
      |> assign(form: to_form(changeset))
      |> assign(check_errors: false)

    {:ok, socket}
  end

  def handle_event("validate", %{"category" => category_params}, socket) do
    changeset =
      %Category{}
      |> Catalog.change_category(category_params)
      |> Map.put(:action, :validate)

    form = to_form(changeset)
    {:noreply, assign(socket, form: form, check_errors: true)}

    {:noreply, socket}
  end

  def handle_event("save", %{"category" => category_params}, socket) do
    case Catalog.create_category(category_params) do
      {:ok, _category} ->
        # Reset the form by assigning a fresh changeset
        changeset = Catalog.change_category(%Category{}, %{})
        IO.inspect(changeset, label: "Reset changeset")
        IO.inspect(to_form(changeset), label: "Reset form data")

        {:noreply,
         assign(socket, form: to_form(changeset), check_errors: false)
         |> put_flash(:info, "Category created successfully")}

      {:error, %Ecto.Changeset{} = changeset} ->
        # Handle errors by reassigning the form with errors
        form = to_form(changeset)
        {:noreply, assign(socket, form: form, check_errors: true)}
    end
  end
end
