defmodule MuckWeb.JokeLive.Index do
  use MuckWeb, :live_view

  alias Muck.Jokes
  alias Muck.Jokes.Joke

  @impl true
  def mount(_params, _session, socket) do
    {:ok, stream(socket, :jokes, Jokes.list_jokes())}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Joke")
    |> assign(:joke, Jokes.get_joke!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Joke")
    |> assign(:joke, %Joke{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Jokes")
    |> assign(:joke, nil)
  end

  @impl true
  def handle_info({MuckWeb.JokeLive.FormComponent, {:saved, joke}}, socket) do
    {:noreply, stream_insert(socket, :jokes, joke)}
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    joke = Jokes.get_joke!(id)
    {:ok, _} = Jokes.delete_joke(joke)

    {:noreply, stream_delete(socket, :jokes, joke)}
  end
end
