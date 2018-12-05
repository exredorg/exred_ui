defmodule ExredUIWeb.ConnectionController do
  use ExredUIWeb, :controller

  alias ExredUI.Editor
  alias ExredUI.Editor.Connection

  action_fallback ExredUIWeb.FallbackController

  def index(conn, _params) do
    connections = Editor.list_connections()
    render(conn, "index.json-api", data: connections)
  end


  def create(conn, %{"data" => %{"type" => "connections", "id" => id,
  "attributes" => attributes, "relationships" => relationships}}) do
    connection_params = attributes
    |> Map.put("id", id)
    |> Map.put("flow_id", relationships["flow_id"]["data"]["id"])
    |> Map.put("source_id", relationships["source_id"]["data"]["id"])
    |> Map.put("target_id", relationships["target_id"]["data"]["id"])

    IO.inspect connection_params, label: "CONNECTION PARAMS"

    with {:ok, %Connection{} = connection} <- Editor.create_connection(connection_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", connection_path(conn, :show, connection))
      |> render("show.json-api", data: connection)
    end
  end

  def show(conn, %{"id" => id}) do
    connection = Editor.get_connection!(id)
    render(conn, "show.json-api", data: connection)
  end

  def update(conn, %{"id" => id, "connection" => connection_params}) do
    connection = Editor.get_connection!(id)

    with {:ok, %Connection{} = connection} <- Editor.update_connection(connection, connection_params) do
      render(conn, "show.json-api", data: connection)
    end
  end

  def delete(conn, %{"id" => id}) do
    connection = Editor.get_connection!(id)
    with {:ok, %Connection{}} <- Editor.delete_connection(connection) do
      send_resp(conn, :no_content, "")
    end
  end
end
