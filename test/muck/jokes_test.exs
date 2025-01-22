defmodule Muck.JokesTest do
  use Muck.DataCase

  alias Muck.Jokes

  describe "jokes" do
    alias Muck.Jokes.Joke

    import Muck.JokesFixtures

    @invalid_attrs %{author: nil, setup: nil, punchline: nil}

    test "list_jokes/0 returns all jokes" do
      joke = joke_fixture()
      assert Jokes.list_jokes() == [joke]
    end

    test "get_joke!/1 returns the joke with given id" do
      joke = joke_fixture()
      assert Jokes.get_joke!(joke.id) == joke
    end

    test "create_joke/1 with valid data creates a joke" do
      valid_attrs = %{author: "some author", setup: "some setup", punchline: "some punchline"}

      assert {:ok, %Joke{} = joke} = Jokes.create_joke(valid_attrs)
      assert joke.author == "some author"
      assert joke.setup == "some setup"
      assert joke.punchline == "some punchline"
    end

    test "create_joke/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Jokes.create_joke(@invalid_attrs)
    end

    test "update_joke/2 with valid data updates the joke" do
      joke = joke_fixture()

      update_attrs = %{
        author: "some updated author",
        setup: "some updated setup",
        punchline: "some updated punchline"
      }

      assert {:ok, %Joke{} = joke} = Jokes.update_joke(joke, update_attrs)
      assert joke.author == "some updated author"
      assert joke.setup == "some updated setup"
      assert joke.punchline == "some updated punchline"
    end

    test "update_joke/2 with invalid data returns error changeset" do
      joke = joke_fixture()
      assert {:error, %Ecto.Changeset{}} = Jokes.update_joke(joke, @invalid_attrs)
      assert joke == Jokes.get_joke!(joke.id)
    end

    test "delete_joke/1 deletes the joke" do
      joke = joke_fixture()
      assert {:ok, %Joke{}} = Jokes.delete_joke(joke)
      assert_raise Ecto.NoResultsError, fn -> Jokes.get_joke!(joke.id) end
    end

    test "change_joke/1 returns a joke changeset" do
      joke = joke_fixture()
      assert %Ecto.Changeset{} = Jokes.change_joke(joke)
    end
  end
end
