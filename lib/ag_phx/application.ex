defmodule AgPhx.Application do
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
    #  {:ok, contents} =
    #     Path.join(File.cwd!(), "gcloud-key.json")
    #     |> File.read()

    #   credentials = Jason.decode!(contents)
    IO.inspect(credentials)

    source = {:service_account, credentials}

    children = [
      # Start the Telemetry supervisor
      AgPhxWeb.Telemetry,
      # Start the Ecto repository
      AgPhx.Repo,
      # Start the PubSub system
      {Phoenix.PubSub, name: AgPhx.PubSub},
      # Start Finch
      {Finch, name: AgPhx.Finch},
      # Start the Endpoint (http/https)
      AgPhxWeb.Endpoint,
      # Start a worker by calling: AgPhx.Worker.start_link(arg)
      # {AgPhx.Worker, arg}
      {Goth, name: AgPhx.Goth, source: source}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: AgPhx.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    AgPhxWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
