defmodule Mucking.Repo do
  use Ecto.Repo,
    otp_app: :mucking,
    adapter: Ecto.Adapters.SQLite3
end
