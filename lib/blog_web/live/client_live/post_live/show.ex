defmodule BlogWeb.Live.ClientLive.PostLive.Show do
  use BlogWeb, :client_live_view

  def mount(%{"id" => id}, _session, socket) do
    post = Blog.Catalog.get_post!(id)

    formatted_posts = %{
      post
      | inserted_at: Timex.format!(post.inserted_at, "{Mfull} {D}, {YYYY}")
    }

    socket = socket |> assign(post: formatted_posts)
    {:ok, socket}
  end
end
