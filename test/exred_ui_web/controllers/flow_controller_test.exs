defmodule ExredUIWeb.FlowControllerTest do
  use ExredUIWeb.ConnCase

  alias ExredUI.Editor
  alias ExredUI.Editor.Flow

  @create_attrs %{config: %{}, info: "some info", name: "some name", type: "some type"}
  @update_attrs %{config: %{}, info: "some updated info", name: "some updated name", type: "some updated type"}
  @invalid_attrs %{config: nil, info: nil, name: nil, type: nil}

  def fixture(:flow) do
    {:ok, flow} = Editor.create_flow(@create_attrs)
    flow
  end

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all flows", %{conn: conn} do
      conn = get conn, flow_path(conn, :index)
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create flow" do
    test "renders flow when data is valid", %{conn: conn} do
      conn = post conn, flow_path(conn, :create), flow: @create_attrs
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get conn, flow_path(conn, :show, id)
      assert json_response(conn, 200)["data"] == %{
        "id" => id,
        "config" => %{},
        "info" => "some info",
        "name" => "some name",
        "type" => "some type"}
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post conn, flow_path(conn, :create), flow: @invalid_attrs
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update flow" do
    setup [:create_flow]

    test "renders flow when data is valid", %{conn: conn, flow: %Flow{id: id} = flow} do
      conn = put conn, flow_path(conn, :update, flow), flow: @update_attrs
      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get conn, flow_path(conn, :show, id)
      assert json_response(conn, 200)["data"] == %{
        "id" => id,
        "config" => %{},
        "info" => "some updated info",
        "name" => "some updated name",
        "type" => "some updated type"}
    end

    test "renders errors when data is invalid", %{conn: conn, flow: flow} do
      conn = put conn, flow_path(conn, :update, flow), flow: @invalid_attrs
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete flow" do
    setup [:create_flow]

    test "deletes chosen flow", %{conn: conn, flow: flow} do
      conn = delete conn, flow_path(conn, :delete, flow)
      assert response(conn, 204)
      assert_error_sent 404, fn ->
        get conn, flow_path(conn, :show, flow)
      end
    end
  end

  defp create_flow(_) do
    flow = fixture(:flow)
    {:ok, flow: flow}
  end
end
