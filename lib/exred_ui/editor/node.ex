defmodule ExredUI.Editor.Node do
  use Ecto.Schema
  import Ecto.Changeset
  alias ExredUI.Editor.Node

  @primary_key {:id, :binary_id, autogenerate: true}
  @derive {Phoenix.Param, key: :id}

  schema "nodes" do
    field :name, :string
    field :category, :string
    field :config, :map
    field :info, :string
    field :module, :string
    field :is_prototype, :boolean
    field :x, :integer
    field :y, :integer
    field :ui_attributes, :map

    belongs_to :flow, ExredUI.Editor.Flow, type: :binary_id
    has_many :in_conns, ExredUI.Editor.Connection, foreign_key: :target_id
    has_many :out_conns, ExredUI.Editor.Connection, foreign_key: :source_id

    timestamps()
  end

  @doc false
  def changeset(%Node{} = node, attrs) do
    node
    |> cast(attrs, [:id, :flow_id, :name, :module, :config, :info, :is_prototype, :category, :x, :y, :ui_attributes])
    |> validate_required([:id, :name, :module, :config, :info, :is_prototype, :category])
  end
end
