defmodule BlogWeb.Live.DashboardLive.PostLive.Edit do
  alias Blog.Catalog.Post
  alias Blog.Catalog
  use BlogWeb, :live_view

  def mount(params, session, socket) do
    categories = Blog.Catalog.list_categories() |> Enum.map(&{&1.name, &1.id})
    post = Blog.Catalog.get_post!(String.to_integer(params["id"]))
    current_user = Blog.Accounts.get_user_by_session_token(session["user_token"])
    changeset = Blog.Catalog.change_post(post, %{})
    check_errors = false
    form = to_form(changeset)

    socket =
      socket
      |> assign(:current_user, current_user)
      |> assign(:categories, categories)
      |> assign(:form, form)
      |> assign(:check_errors, check_errors)
      |> assign(:uploaded_files, [])
      |> assign(:post, post)
      |> allow_upload(:image,
        accept: ~w(image/*),
        max_entries: 1,
        max_file_size: 5_000_000
      )

    {:ok, socket}
  end

  def handle_event("validate", %{"post" => post_params}, socket) do
    changeset = Blog.Catalog.change_post(%Post{}, post_params) |> Map.put(:action, :validate)
    {:noreply, assign(socket, form: to_form(changeset), check_errors: false)}
  end

  def handle_event("save", %{"post" => post_params}, socket) do
    post = socket.assigns.post

    image_location =
      consume_uploaded_entries(socket, :image, fn meta, entry ->
        destination_dir = Path.join(["priv", "static", "uploads"])

        File.mkdir_p(destination_dir)

        destination = Path.join([destination_dir, "#{entry.uuid}-#{entry.client_name}"])
        File.cp!(meta.path, destination)

        file_path = static_path(socket, "/uploads/#{Path.basename(destination)}")

        {:ok, file_path}
      end)

    new_post_params = Map.put(post_params, "image", List.first(image_location))

    case Blog.Catalog.update_post(post, new_post_params) do
      {:ok, post} ->
        changeset = Blog.Catalog.change_post(post)
        form = to_form(changeset)

        {:noreply,
         assign(socket, form: form, check_errors: false)
         |> put_flash(:info, "Post updated successfully")}

      {:error, %Ecto.Changeset{} = changeset} ->
        form = to_form(changeset)
        {:noreply, assign(socket, form: form, check_errors: true)}
    end
  end
end
