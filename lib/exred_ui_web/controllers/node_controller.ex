defmodule ExredUIWeb.NodeController do
  use ExredUIWeb, :controller

  alias ExredUI.Editor
  alias ExredUI.Editor.Node

  action_fallback ExredUIWeb.FallbackController

  def index(conn, _params) do
    nodes = Editor.list_nodes()
    render(conn, "index.json-api", data: nodes)
  end

    #
    # %{"data" =>
    #   %{"attributes" =>
    #     %{
    #       "category" => "function",
    #       "config" =>
    #         %{"handler" => %{"attrs" => %{}, "type" => "codeblock", "value" => ""},
    #         "interval" => %{"attrs" => %{"max" => 3600, "min" => 0}, "type" => "number", "value" => 100},
    #         "name" => %{"attrs" => %{"max" => 15}, "type" => "string", "value" => ""}},
    #       "info" => "Sends messages in regular intervals.\ninputs: 0\noutputs:1\n",
    #       "is_prototype" => false,
    #       "module" => "ExredUI.Nodes.Trigger",
    #       "name" => "Trigger"},
    #   "id" =>"18fb57f9-4943-4abf-820d-152aa000bd16",
    #   "type" => "nodes"}
    # }



  def create(conn, %{"data" => %{"type" => "nodes", "id" => id,
  "attributes" => attributes, "relationships" => relationships}}) do
    node_params = attributes
    |> Map.put("id", id)
    |> Map.put("flow_id", relationships["flow_id"]["data"]["id"])

    IO.inspect node_params, label: "NODE PARAMS"
    
    with {:ok, %Node{} = node} <- Editor.create_node( node_params ) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", node_path(conn, :show, node))
      |> render("show.json-api", data: node)
    end
  end


  def show(conn, %{"id" => id}) do
    node = Editor.get_node!(id)
    render(conn, "show.json-api", data: node)
  end


  def update(conn, %{"data" => %{"type" => "nodes", "id" => id, "attributes" => attributes}}) do
    node_params = Map.put(attributes, "id", id)
    node = Editor.get_node!(id)

    with {:ok, %Node{} = node} <- Editor.update_node(node, node_params) do
      render(conn, "show.json-api", data: node)
    end
  end


  def delete(conn, %{"id" => id}) do
    node = Editor.get_node!(id)
    with {:ok, %Node{}} <- Editor.delete_node(node) do
      send_resp(conn, :no_content, "")
    end
  end
end
