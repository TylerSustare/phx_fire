defmodule PhxFire.Repo do
  use Ecto.Repo,
    otp_app: :phx_fire,
    adapter: Ecto.Adapters.Postgres
end
