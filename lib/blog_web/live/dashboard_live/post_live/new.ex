defmodule BlogWeb.Live.DashboardLive.PostLive.New do
  alias Blog.Accounts
  alias Blog.Catalog
  alias Blog.Catalog.Post
  use BlogWeb, :live_view

  def mount(_params, session, socket) do
    current_user = Accounts.get_user_by_session_token(session["user_token"])
    categories = Catalog.list_categories() |> Enum.map(&{&1.name, &1.id})
    changeset = Catalog.change_post(%Post{}, %{})
    form = to_form(changeset)
    check_errors = false

    socket =
      socket
      |> assign(:current_user, current_user)
      |> assign(:categories, categories)
      |> assign(:form, form)
      |> assign(:check_errors, check_errors)
    {:ok, socket}
  end

  def handle_event("validate", %{"post" => post_params}, socket) do
    changeset =
      %Post{}
      |> Catalog.change_post(post_params)
      |> Map.put(:action, :validate)

    form = to_form(changeset)
    {:noreply, assign(socket, form: form, check_errors: true)}
  end

  def handle_event("save", %{"post" => post_params}, socket) do
    case Catalog.create_post(post_params) do
      {:ok, _post} ->
        changeset = Catalog.change_post(%Post{}, %{})

        {:noreply,
         assign(socket, form: to_form(changeset), check_errors: false)
         |> put_flash(:info, "Post created successfully")}

      {:error, %Ecto.Changeset{} = changeset} ->
        form = to_form(changeset)
        {:noreply, assign(socket, form: form, check_errors: true)}
    end
  end
end
