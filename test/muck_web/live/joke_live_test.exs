defmodule MuckWeb.JokeLiveTest do
  use MuckWeb.ConnCase

  import Phoenix.LiveViewTest
  import Muck.JokesFixtures

  @create_attrs %{author: "some author", setup: "some setup", punchline: "some punchline"}
  @update_attrs %{author: "some updated author", setup: "some updated setup", punchline: "some updated punchline"}
  @invalid_attrs %{author: nil, setup: nil, punchline: nil}

  defp create_joke(_) do
    joke = joke_fixture()
    %{joke: joke}
  end

  describe "Index" do
    setup [:create_joke]

    test "lists all jokes", %{conn: conn, joke: joke} do
      {:ok, _index_live, html} = live(conn, ~p"/jokes")

      assert html =~ "Listing Jokes"
      assert html =~ joke.author
    end

    test "saves new joke", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, ~p"/jokes")

      assert index_live |> element("a", "New Joke") |> render_click() =~
               "New Joke"

      assert_patch(index_live, ~p"/jokes/new")

      assert index_live
             |> form("#joke-form", joke: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert index_live
             |> form("#joke-form", joke: @create_attrs)
             |> render_submit()

      assert_patch(index_live, ~p"/jokes")

      html = render(index_live)
      assert html =~ "Joke created successfully"
      assert html =~ "some author"
    end

    test "updates joke in listing", %{conn: conn, joke: joke} do
      {:ok, index_live, _html} = live(conn, ~p"/jokes")

      assert index_live |> element("#jokes-#{joke.id} a", "Edit") |> render_click() =~
               "Edit Joke"

      assert_patch(index_live, ~p"/jokes/#{joke}/edit")

      assert index_live
             |> form("#joke-form", joke: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert index_live
             |> form("#joke-form", joke: @update_attrs)
             |> render_submit()

      assert_patch(index_live, ~p"/jokes")

      html = render(index_live)
      assert html =~ "Joke updated successfully"
      assert html =~ "some updated author"
    end

    test "deletes joke in listing", %{conn: conn, joke: joke} do
      {:ok, index_live, _html} = live(conn, ~p"/jokes")

      assert index_live |> element("#jokes-#{joke.id} a", "Delete") |> render_click()
      refute has_element?(index_live, "#jokes-#{joke.id}")
    end
  end

  describe "Show" do
    setup [:create_joke]

    test "displays joke", %{conn: conn, joke: joke} do
      {:ok, _show_live, html} = live(conn, ~p"/jokes/#{joke}")

      assert html =~ "Show Joke"
      assert html =~ joke.author
    end

    test "updates joke within modal", %{conn: conn, joke: joke} do
      {:ok, show_live, _html} = live(conn, ~p"/jokes/#{joke}")

      assert show_live |> element("a", "Edit") |> render_click() =~
               "Edit Joke"

      assert_patch(show_live, ~p"/jokes/#{joke}/show/edit")

      assert show_live
             |> form("#joke-form", joke: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert show_live
             |> form("#joke-form", joke: @update_attrs)
             |> render_submit()

      assert_patch(show_live, ~p"/jokes/#{joke}")

      html = render(show_live)
      assert html =~ "Joke updated successfully"
      assert html =~ "some updated author"
    end
  end
end
