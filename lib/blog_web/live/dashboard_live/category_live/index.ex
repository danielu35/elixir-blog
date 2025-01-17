defmodule BlogWeb.Live.DashboardLive.CategoryLive.Index do
  use BlogWeb, :live_view
  alias Blog.Catalog.{Category}
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
    # Create a changeset with the category params and validate it
    changeset =
      %Category{}
      |> Catalog.change_category(category_params)
      |> Map.put(:action, :validate)

    form = to_form(changeset)
    # Assign the form with errors if there are any
    {:noreply, assign(socket, form: form, check_errors: true)}
  end

  def handle_event("save", %{"category" => category_params}, socket) do
    case Catalog.create_category(category_params) do
      # If the category was created successfully, insert it into the socket at the top
      {:ok, category} ->
        socket = stream_insert(socket, :categories, category, at: 0)
        changeset = Catalog.change_category(%Category{}, %{})
        # Clear the form and show a success message
        {:noreply,
         assign(socket, form: to_form(changeset), check_errors: false)
         |> put_flash(:info, "Category created successfully")}

      {:error, %Ecto.Changeset{} = changeset} ->
        # Handle errors by reassigning the form with errors
        form = to_form(changeset)
        {:noreply, assign(socket, form: form, check_errors: true)}
    end
  end

  def handle_event("delete", %{"id" => id}, socket) do
    category = Catalog.get_category!(id)
    case Catalog.delete_category(category) do
      {:ok, _category} ->
        socket = stream_delete(socket, :categories, category)
        {:noreply, socket |> put_flash(:info, "Category deleted successfully")}

      {:error, _reason} ->
        # Handle errors by showing an error message
        {:noreply, socket |> put_flash(:error, "Failed to delete category")}
    end
  end
end
