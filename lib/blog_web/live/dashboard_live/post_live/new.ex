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
      |> allow_upload(:image,
        accept: ~w(image/*),
        max_entries: 1,
        max_file_size: 5_000_000
      )

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
    image_location =
      consume_uploaded_entries(socket, :image, fn meta, entry ->
        destination_dir = Path.join(["priv", "static", "uploads"])
        IO.inspect(destination_dir, label: "destination_dir")

        destination = Path.join([destination_dir, "#{entry.uuid}-#{entry.client_name}"])

        File.cp!(meta.path, destination)

        file_path = static_path(socket, "/uploads/#{Path.basename(destination)}")
        IO.inspect(file_path, label: "file_path")

        {:ok, file_path}
      end)

    new_post_params = Map.put(post_params, "image", List.first(image_location))

    IO.inspect(new_post_params, label: "params")

    case Catalog.create_post(new_post_params) do
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
