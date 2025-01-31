defmodule BlogWeb.Live.ClientLive.CategoryLive.Posts do
  use BlogWeb, :client_live_view

  def mount(%{"id" => id}, _session, socket) do
    posts = Blog.Catalog.list_posts_by_category(id)
    categories = Blog.Catalog.list_categories()

    formatted_posts =
      Enum.map(posts, fn post ->
        formatted_date =
          post.inserted_at
          |> Timex.to_datetime()
          |> Timex.format("{Mfull} {D}, {YYYY}")

          case formatted_date do
            {:ok, date} -> %{post | inserted_at: date}
            {:error, _reason} -> post
          end
      end)

    socket = socket |> assign(posts: formatted_posts)
    {:ok, assign(socket, categories: categories, posts: formatted_posts)}
  end
end
