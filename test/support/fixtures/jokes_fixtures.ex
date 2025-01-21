defmodule Muck.JokesFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Muck.Jokes` context.
  """

  @doc """
  Generate a joke.
  """
  def joke_fixture(attrs \\ %{}) do
    {:ok, joke} =
      attrs
      |> Enum.into(%{
        author: "some author",
        punchline: "some punchline",
        setup: "some setup"
      })
      |> Muck.Jokes.create_joke()

    joke
  end
end
