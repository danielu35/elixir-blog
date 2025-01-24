defmodule BlogWeb.Live.ClientLive.HomeLive.Index do
  use BlogWeb, :client_live_view
  alias Blog.Catalog

  def mount(_params, _session, socket) do
    # catalogs = Catalog.list_catalogs()
    # socket = socket |> stream(:catalogs, catalogs)
    {:ok, socket}
  end

  # def handle_event("delete", %{"id" => id}, socket) do
  #   catalog = Blog.Catalog.get_catalog!(id)

  #   case Blog.Catalog.delete_catalog(catalog) do
  #     {:ok, _catalog} -> {:noreply, socket |> put_flash(:info, "Catalog deleted successfully")}
  #     {:error, _changeset} -> {:noreply, socket |> put_flash(:error, "Catalog could not be deleted")}
  #   end
  # end
end
