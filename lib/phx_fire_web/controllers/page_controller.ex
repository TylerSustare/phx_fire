defmodule PhxFireWeb.PageController do
  use PhxFireWeb, :controller

  def home(conn, _params) do
    # The home page is often custom made,
    # so skip the default app layout.

    {:ok, now} = DateTime.now("Etc/UTC")

    d = %GoogleApi.Firestore.V1.Model.Document{
      name:
        "projects/<CHANGEME-to-your-project-id>/databases/(default)/documents/demo-elixir-firestore/123",
      createTime: now,
      updateTime: now,
      fields: %{
        "order_id" => %GoogleApi.Firestore.V1.Model.Value{
          stringValue: "123"
        }
      }
    }

    test_token = "abc123"

    notification = %{
      title: "Test notification",
      body: "Test notification"
    }

    data = %{
      type: "foo",
      type_id: "123",
      messageId: "123",
      messageTime: Time.to_iso8601(now)
    }

    n = Pigeon.FCM.Notification.new({:token, test_token}, notification, data)
    IO.inspect(n)
    PhxFire.FCM.push(n)

    {:ok, res} = PhxFire.Firestore.DAO.save("<CHANGEME-to-your-project-id>", d)
    IO.inspect(res)

    render(conn, :home, layout: false)
  end
end
