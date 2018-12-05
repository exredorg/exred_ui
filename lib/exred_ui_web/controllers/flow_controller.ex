defmodule ExredUIWeb.FlowController do
  use ExredUIWeb, :controller

  alias ExredUI.Editor
  alias ExredUI.Editor.Flow

  action_fallback ExredUIWeb.FallbackController

  def index(conn, _params) do
    flows = Editor.list_flows()
    render(conn, "index.json-api", data: flows)
  end


  def create(conn, %{"data" => %{"type" => "flows", "id" => id,
  "attributes" => attributes, "relationships" => relationships}}) do
    flow_params = attributes
    |> Map.put("id", id)
    |> Map.put("service_id", relationships["service_id"]["data"]["id"])

    IO.inspect flow_params, label: "FLOW PARAMS"
    
    with {:ok, %Flow{} = flow} <- Editor.create_flow( flow_params ) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", flow_path(conn, :show, flow))
      |> render("show.json-api", data: flow)
    end
  end


  def show(conn, %{"id" => id}) do
    flow = Editor.get_flow!(id)
    render(conn, "show.json-api", data: flow)
  end

  def update(conn, %{"id" => id, "flow" => flow_params}) do
    flow = Editor.get_flow!(id)

    with {:ok, %Flow{} = flow} <- Editor.update_flow(flow, flow_params) do
      render(conn, "show.json-api", data: flow)
    end
  end

  def delete(conn, %{"id" => id}) do
    flow = Editor.get_flow!(id)
    with {:ok, %Flow{}} <- Editor.delete_flow(flow) do
      send_resp(conn, :no_content, "")
    end
  end
end
