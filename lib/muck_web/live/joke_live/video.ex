defmodule MuckWeb.JokeLive.Video do
  use MuckWeb, :live_view

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end
end
