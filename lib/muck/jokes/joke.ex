defmodule Muck.Jokes.Joke do
  use Ecto.Schema
  import Ecto.Changeset

  schema "jokes" do
    field :author, :string
    field :setup, :string
    field :punchline, :string

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(joke, attrs) do
    joke
    |> cast(attrs, [:setup, :punchline, :author])
    |> validate_required([:setup, :punchline, :author])
  end
end
