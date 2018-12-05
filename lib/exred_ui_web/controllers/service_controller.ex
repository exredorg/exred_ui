defmodule ExredUIWeb.ServiceController do
  use ExredUIWeb, :controller

  alias ExredUI.Editor
  alias ExredUI.Editor.Service

  action_fallback ExredUIWeb.FallbackController

  def index(conn, _params) do
    services = Editor.list_services()
    render(conn, "index.json-api", data: services)
  end

  def create(conn, %{"service" => service_params}) do
    with {:ok, %Service{} = service} <- Editor.create_service(service_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", service_path(conn, :show, service))
      |> render("show.json-api", data: service)
    end
  end

  def show(conn, %{"id" => id}) do
    service = Editor.get_service!(id)
    render(conn, "show.json-api", data: service)
  end

  def update(conn, %{"id" => id, "service" => service_params}) do
    service = Editor.get_service!(id)

    with {:ok, %Service{} = service} <- Editor.update_service(service, service_params) do
      render(conn, "show.json-api", data: service)
    end
  end

  def delete(conn, %{"id" => id}) do
    service = Editor.get_service!(id)
    with {:ok, %Service{}} <- Editor.delete_service(service) do
      send_resp(conn, :no_content, "")
    end
  end
end
