defmodule MuckWeb.JokeLive.Video do
require Logger
  use MuckWeb, :live_view

   alias LiveExWebRTC.Publisher

  @impl true
  def mount(_params, _session, socket) do
    Process.send_after(self(), :ping, 2000)

    {:ok, assign(socket, %{message: 0})}
  end

  @impl true

  def handle_info(:ping, socket) do
    %{message: mes} = socket.assigns
    Process.send_after(self(), :ping, 2000)
    {:noreply, assign(socket, %{message: mes + 1})}
  end

  @impl true
  def handle_info(_msg, socket) do
    {:noreply, socket}
  end
end
