defmodule PeekChallenge.Repo do
  use Ecto.Repo,
    otp_app: :PeekChallenge,
    adapter: Ecto.Adapters.Postgres
end
