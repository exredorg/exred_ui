defmodule ExredUIWeb.NodeView do
  use ExredUIWeb, :view
  use JaSerializer.PhoenixView

  attributes([
    :name,
    :category,
    :module,
    :info,
    :config,
    :is_prototype,
    :flow_id,
    :x,
    :y,
    :ui_attributes
  ])

  has_many(:in_conns,
    serializer: ExredUIWeb.ConnectionView,
    include: false,
    # when_included
    identifiers: :always
  )

  has_many(:out_conns,
    serializer: ExredUIWeb.ConnectionView,
    include: false,
    # when_included
    identifiers: :always
  )

  def in_conns(struct, _conn) do
    case struct.in_conns do
      %Ecto.Association.NotLoaded{} ->
        struct
        |> Ecto.assoc(:in_conns)
        |> ExredUI.SqliteRepo.all()

      other ->
        other
    end
  end

  def out_conns(struct, _conn) do
    case struct.out_conns do
      %Ecto.Association.NotLoaded{} ->
        struct
        |> Ecto.assoc(:out_conns)
        |> ExredUI.SqliteRepo.all()

      other ->
        other
    end
  end

  # def render("index.json", %{nodes: nodes}) do
  #   %{data: render_many(nodes, NodeView, "node.json")}
  # end
  #
  # def render("show.json", %{node: node}) do
  #   %{data: render_one(node, NodeView, "node.json")}
  # end
  #
  # def render("node.json", %{node: node}) do
  #   %{id: node.id,
  #     name: node.name,
  #     type: node.type,
  #     module: node.module,
  #     config: node.config,
  #     info: node.info}
  # end
end
