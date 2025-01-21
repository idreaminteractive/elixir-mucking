defmodule Muck.Repo.Migrations.CreateJokes do
  use Ecto.Migration

  def change do
    create table(:jokes) do
      add :setup, :string
      add :punchline, :string
      add :author, :string

      timestamps(type: :utc_datetime)
    end
  end
end
