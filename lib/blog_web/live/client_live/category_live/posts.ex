defmodule BlogWeb.Live.ClientLive.CategoryLive.Posts do
  use BlogWeb, :client_live_view
  alias Blog.Catalog

  def mount(%{"id" => id}, _session, socket) do
    posts = Blog.Catalog.list_posts_by_category(id)
    categories = Blog.Catalog.list_categories()
    {:ok, assign(socket, posts: posts, categories: categories)}
  end
end
