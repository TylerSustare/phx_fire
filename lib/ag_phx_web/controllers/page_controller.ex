defmodule AgPhxWeb.PageController do
  use AgPhxWeb, :controller

  def home(conn, _params) do
    # The home page is often custom made,
    # so skip the default app layout.

    # {:ok, now} = DateTime.now("Etc/UTC")

    # d = %GoogleApi.Firestore.V1.Model.Document{
    #   name: "projects/archery-guru/databases/(default)/documents/demo-elixir-firestore/123",
    #   createTime: now,
    #   updateTime: now,
    #   fields: %{
    #     "order_id" => %GoogleApi.Firestore.V1.Model.Value{
    #       stringValue: "123"
    #     }
    #   }
    # }

    {:ok, token} = Goth.fetch("https://www.googleapis.com/auth/datastore")
    # {:ok, res} = AgPhx.Firestore.DAO.save("archery-guru", d)
    # IO.inspect(res)
    IO.inspect(token)

    render(conn, :home, layout: false)
  end
end
