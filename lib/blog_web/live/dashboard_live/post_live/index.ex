defmodule BlogWeb.Live.DashboardLive.PostLive.Index do
  use BlogWeb, :live_view
  alias Blog.Catalog

  def mount(_params, _session, socket) do
    posts = Catalog.list_posts()
    socket = socket |> stream(:posts, posts)
    {:ok, socket}
  end

  def handle_event("delete", %{"id" => id}, socket) do
    post = Blog.Catalog.get_post!(id)

    case Blog.Catalog.delete_post(post) do
      {:ok, _post} -> {:noreply, socket |> put_flash(:info, "Post deleted successfully")}
      {:error, _changeset} -> {:noreply, socket |> put_flash(:error, "Post could not be deleted")}
    end
  end
end
