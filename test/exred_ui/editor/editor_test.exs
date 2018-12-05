defmodule ExredUI.EditorTest do
  use ExredUI.DataCase

  alias ExredUI.Editor

  describe "nodes" do
    alias ExredUI.Editor.Node

    @valid_attrs %{config: %{}, info: "some info", module: "some module", name: "some name", type: "some type"}
    @update_attrs %{config: %{}, info: "some updated info", module: "some updated module", name: "some updated name", type: "some updated type"}
    @invalid_attrs %{config: nil, info: nil, module: nil, name: nil, type: nil}

    def node_fixture(attrs \\ %{}) do
      {:ok, node} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Editor.create_node()

      node
    end

    test "list_nodes/0 returns all nodes" do
      node = node_fixture()
      assert Editor.list_nodes() == [node]
    end

    test "get_node!/1 returns the node with given id" do
      node = node_fixture()
      assert Editor.get_node!(node.id) == node
    end

    test "create_node/1 with valid data creates a node" do
      assert {:ok, %Node{} = node} = Editor.create_node(@valid_attrs)
      assert node.config == %{}
      assert node.info == "some info"
      assert node.module == "some module"
      assert node.name == "some name"
      assert node.type == "some type"
    end

    test "create_node/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Editor.create_node(@invalid_attrs)
    end

    test "update_node/2 with valid data updates the node" do
      node = node_fixture()
      assert {:ok, node} = Editor.update_node(node, @update_attrs)
      assert %Node{} = node
      assert node.config == %{}
      assert node.info == "some updated info"
      assert node.module == "some updated module"
      assert node.name == "some updated name"
      assert node.type == "some updated type"
    end

    test "update_node/2 with invalid data returns error changeset" do
      node = node_fixture()
      assert {:error, %Ecto.Changeset{}} = Editor.update_node(node, @invalid_attrs)
      assert node == Editor.get_node!(node.id)
    end

    test "delete_node/1 deletes the node" do
      node = node_fixture()
      assert {:ok, %Node{}} = Editor.delete_node(node)
      assert_raise Ecto.NoResultsError, fn -> Editor.get_node!(node.id) end
    end

    test "change_node/1 returns a node changeset" do
      node = node_fixture()
      assert %Ecto.Changeset{} = Editor.change_node(node)
    end
  end

  describe "services" do
    alias ExredUI.Editor.Service

    @valid_attrs %{config: %{}, info: "some info", name: "some name", type: "some type"}
    @update_attrs %{config: %{}, info: "some updated info", name: "some updated name", type: "some updated type"}
    @invalid_attrs %{config: nil, info: nil, name: nil, type: nil}

    def service_fixture(attrs \\ %{}) do
      {:ok, service} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Editor.create_service()

      service
    end

    test "list_services/0 returns all services" do
      service = service_fixture()
      assert Editor.list_services() == [service]
    end

    test "get_service!/1 returns the service with given id" do
      service = service_fixture()
      assert Editor.get_service!(service.id) == service
    end

    test "create_service/1 with valid data creates a service" do
      assert {:ok, %Service{} = service} = Editor.create_service(@valid_attrs)
      assert service.config == %{}
      assert service.info == "some info"
      assert service.name == "some name"
      assert service.type == "some type"
    end

    test "create_service/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Editor.create_service(@invalid_attrs)
    end

    test "update_service/2 with valid data updates the service" do
      service = service_fixture()
      assert {:ok, service} = Editor.update_service(service, @update_attrs)
      assert %Service{} = service
      assert service.config == %{}
      assert service.info == "some updated info"
      assert service.name == "some updated name"
      assert service.type == "some updated type"
    end

    test "update_service/2 with invalid data returns error changeset" do
      service = service_fixture()
      assert {:error, %Ecto.Changeset{}} = Editor.update_service(service, @invalid_attrs)
      assert service == Editor.get_service!(service.id)
    end

    test "delete_service/1 deletes the service" do
      service = service_fixture()
      assert {:ok, %Service{}} = Editor.delete_service(service)
      assert_raise Ecto.NoResultsError, fn -> Editor.get_service!(service.id) end
    end

    test "change_service/1 returns a service changeset" do
      service = service_fixture()
      assert %Ecto.Changeset{} = Editor.change_service(service)
    end
  end

  describe "flows" do
    alias ExredUI.Editor.Flow

    @valid_attrs %{config: %{}, info: "some info", name: "some name", type: "some type"}
    @update_attrs %{config: %{}, info: "some updated info", name: "some updated name", type: "some updated type"}
    @invalid_attrs %{config: nil, info: nil, name: nil, type: nil}

    def flow_fixture(attrs \\ %{}) do
      {:ok, flow} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Editor.create_flow()

      flow
    end

    test "list_flows/0 returns all flows" do
      flow = flow_fixture()
      assert Editor.list_flows() == [flow]
    end

    test "get_flow!/1 returns the flow with given id" do
      flow = flow_fixture()
      assert Editor.get_flow!(flow.id) == flow
    end

    test "create_flow/1 with valid data creates a flow" do
      assert {:ok, %Flow{} = flow} = Editor.create_flow(@valid_attrs)
      assert flow.config == %{}
      assert flow.info == "some info"
      assert flow.name == "some name"
      assert flow.type == "some type"
    end

    test "create_flow/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Editor.create_flow(@invalid_attrs)
    end

    test "update_flow/2 with valid data updates the flow" do
      flow = flow_fixture()
      assert {:ok, flow} = Editor.update_flow(flow, @update_attrs)
      assert %Flow{} = flow
      assert flow.config == %{}
      assert flow.info == "some updated info"
      assert flow.name == "some updated name"
      assert flow.type == "some updated type"
    end

    test "update_flow/2 with invalid data returns error changeset" do
      flow = flow_fixture()
      assert {:error, %Ecto.Changeset{}} = Editor.update_flow(flow, @invalid_attrs)
      assert flow == Editor.get_flow!(flow.id)
    end

    test "delete_flow/1 deletes the flow" do
      flow = flow_fixture()
      assert {:ok, %Flow{}} = Editor.delete_flow(flow)
      assert_raise Ecto.NoResultsError, fn -> Editor.get_flow!(flow.id) end
    end

    test "change_flow/1 returns a flow changeset" do
      flow = flow_fixture()
      assert %Ecto.Changeset{} = Editor.change_flow(flow)
    end
  end

  describe "connections" do
    alias ExredUI.Editor.Connection

    @valid_attrs %{config: %{}}
    @update_attrs %{config: %{}}
    @invalid_attrs %{config: nil}

    def connection_fixture(attrs \\ %{}) do
      {:ok, connection} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Editor.create_connection()

      connection
    end

    test "list_connections/0 returns all connections" do
      connection = connection_fixture()
      assert Editor.list_connections() == [connection]
    end

    test "get_connection!/1 returns the connection with given id" do
      connection = connection_fixture()
      assert Editor.get_connection!(connection.id) == connection
    end

    test "create_connection/1 with valid data creates a connection" do
      assert {:ok, %Connection{} = connection} = Editor.create_connection(@valid_attrs)
      assert connection.config == %{}
    end

    test "create_connection/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Editor.create_connection(@invalid_attrs)
    end

    test "update_connection/2 with valid data updates the connection" do
      connection = connection_fixture()
      assert {:ok, connection} = Editor.update_connection(connection, @update_attrs)
      assert %Connection{} = connection
      assert connection.config == %{}
    end

    test "update_connection/2 with invalid data returns error changeset" do
      connection = connection_fixture()
      assert {:error, %Ecto.Changeset{}} = Editor.update_connection(connection, @invalid_attrs)
      assert connection == Editor.get_connection!(connection.id)
    end

    test "delete_connection/1 deletes the connection" do
      connection = connection_fixture()
      assert {:ok, %Connection{}} = Editor.delete_connection(connection)
      assert_raise Ecto.NoResultsError, fn -> Editor.get_connection!(connection.id) end
    end

    test "change_connection/1 returns a connection changeset" do
      connection = connection_fixture()
      assert %Ecto.Changeset{} = Editor.change_connection(connection)
    end
  end
end
