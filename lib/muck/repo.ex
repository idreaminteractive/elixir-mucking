defmodule Muck.Repo do
  use Ecto.Repo,
    otp_app: :muck,
    adapter: Ecto.Adapters.SQLite3
end
