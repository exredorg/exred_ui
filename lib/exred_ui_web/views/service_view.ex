defmodule ExredUIWeb.ServiceView do
  use ExredUIWeb, :view
  use JaSerializer.PhoenixView

  attributes([:name, :info, :config])

  has_many(:flows,
    serializer: ExredUIWeb.FlowView,
    include: true,
    identifiers: :when_included
  )

  def flows(struct, _conn) do
    case struct.flows do
      %Ecto.Association.NotLoaded{} ->
        struct
        |> Ecto.assoc(:flows)
        |> ExredUI.SqliteRepo.all()

      other ->
        other
    end
  end

  #
  # def render("index.json", %{services: services}) do
  #   %{data: render_many(services, ServiceView, "service.json")}
  # end
  #
  # def render("show.json", %{service: service}) do
  #   %{data: render_one(service, ServiceView, "service.json")}
  # end
  #
  # def render("service.json", %{service: service}) do
  #   %{id: service.id,
  #     name: service.name,
  #     type: service.type,
  #     info: service.info,
  #     config: service.config}
  # end
end
