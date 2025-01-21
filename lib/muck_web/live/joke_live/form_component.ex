defmodule MuckWeb.JokeLive.FormComponent do
  use MuckWeb, :live_component

  alias Muck.Jokes

  @impl true
  def render(assigns) do
    ~H"""
    <div>
      <.header>
        {@title}
        <:subtitle>Use this form to manage joke records in your database.</:subtitle>
      </.header>

      <.simple_form
        for={@form}
        id="joke-form"
        phx-target={@myself}
        phx-change="validate"
        phx-submit="save"
      >
        <.input field={@form[:setup]} type="text" label="Setup" />
        <.input field={@form[:punchline]} type="text" label="Punchline" />
        <.input field={@form[:author]} type="text" label="Author" />
        <:actions>
          <.button phx-disable-with="Saving...">Save Joke</.button>
        </:actions>
      </.simple_form>
    </div>
    """
  end

  @impl true
  def update(%{joke: joke} = assigns, socket) do
    {:ok,
     socket
     |> assign(assigns)
     |> assign_new(:form, fn ->
       to_form(Jokes.change_joke(joke))
     end)}
  end

  @impl true
  def handle_event("validate", %{"joke" => joke_params}, socket) do
    changeset = Jokes.change_joke(socket.assigns.joke, joke_params)
    {:noreply, assign(socket, form: to_form(changeset, action: :validate))}
  end

  def handle_event("save", %{"joke" => joke_params}, socket) do
    save_joke(socket, socket.assigns.action, joke_params)
  end

  defp save_joke(socket, :edit, joke_params) do
    case Jokes.update_joke(socket.assigns.joke, joke_params) do
      {:ok, joke} ->
        notify_parent({:saved, joke})

        {:noreply,
         socket
         |> put_flash(:info, "Joke updated successfully")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, form: to_form(changeset))}
    end
  end

  defp save_joke(socket, :new, joke_params) do
    case Jokes.create_joke(joke_params) do
      {:ok, joke} ->
        notify_parent({:saved, joke})

        {:noreply,
         socket
         |> put_flash(:info, "Joke created successfully")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, form: to_form(changeset))}
    end
  end

  defp notify_parent(msg), do: send(self(), {__MODULE__, msg})
end
