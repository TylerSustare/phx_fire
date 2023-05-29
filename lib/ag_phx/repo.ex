defmodule AgPhx.Repo do
  use Ecto.Repo,
    otp_app: :ag_phx,
    adapter: Ecto.Adapters.Postgres
end
