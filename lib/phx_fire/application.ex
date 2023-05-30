defmodule PhxFire.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    credentials =
      "GOOGLE_APPLICATION_CREDENTIALS_JSON"
      |> System.fetch_env!()
      |> Jason.decode!()

    # Using the following method - from a file
    # instead of the JSON string in an ENV has the same result:
    # {:ok, contents} =
    #   Path.join(File.cwd!(), "gcloud-key.json")
    #   |> File.read()

    # credentials = Jason.decode!(contents)

    source = {:service_account, credentials}

    children = [
      # Start the Telemetry supervisor
      PhxFireWeb.Telemetry,
      # Start the Ecto repository
      PhxFire.Repo,
      # Start the PubSub system
      {Phoenix.PubSub, name: PhxFire.PubSub},
      # Start Finch
      {Finch, name: PhxFire.Finch},
      # Start the Endpoint (http/https)
      PhxFireWeb.Endpoint,
      # Start a worker by calling: PhxFire.Worker.start_link(arg)
      # {PhxFire.Worker, arg}
      {Goth, name: PhxFire.Goth, source: source}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: PhxFire.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    PhxFireWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
