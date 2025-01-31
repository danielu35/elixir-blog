defmodule BlogWeb.Live.ClientLive.HomeLive.Index do
  use BlogWeb, :client_live_view
  alias Blog.Catalog

  def mount(_params, _session, socket) do
    IO.inspect(BlogWeb.static_paths(), label: "static_paths")
    posts = Catalog.list_posts()
    categories = Catalog.list_categories()
    formatted_posts = Enum.map(posts, fn post ->
      %{post | inserted_at: Timex.format!(post.inserted_at, "{Mfull} {D}, {YYYY}")}
    end)
    socket = socket |> assign(posts: formatted_posts)
    {:ok, assign(socket, categories: categories, posts: posts)}
  end

  # def handle_event("delete", %{"id" => id}, socket) do
  #   catalog = Blog.Catalog.get_catalog!(id)

  #   case Blog.Catalog.delete_catalog(catalog) do
  #     {:ok, _catalog} -> {:noreply, socket |> put_flash(:info, "Catalog deleted successfully")}
  #     {:error, _changeset} -> {:noreply, socket |> put_flash(:error, "Catalog could not be deleted")}
  #   end
  # end
end
