defmodule BlogWeb.Live.DashboardLive.Index do
  use BlogWeb, :live_view

  def mount(_params, _session, socket) do
    {:ok, socket}
  end
end
