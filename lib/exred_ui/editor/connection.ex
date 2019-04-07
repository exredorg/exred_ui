defmodule ExredUI.Editor.Connection do
  use Ecto.Schema
  import Ecto.Changeset
  alias ExredUI.Editor.Connection

  @primary_key {:id, Ecto.UUID, autogenerate: true}
  @foreign_key_type Ecto.UUID
  @derive {Phoenix.Param, key: :id}

  schema "connections" do
    field(:config, :map)
    field(:source_anchor_type, :string)
    field(:target_anchor_type, :string)

    belongs_to(:source, ExredUI.Editor.Node, type: Ecto.UUID, foreign_key: :source_id)
    belongs_to(:target, ExredUI.Editor.Node, type: Ecto.UUID, foreign_key: :target_id)

    belongs_to(:flow, ExredUI.Editor.Flow, type: Ecto.UUID)

    timestamps()
  end

  @doc false
  def changeset(%Connection{} = connection, attrs) do
    connection
    |> cast(attrs, [
      :id,
      :source_id,
      :target_id,
      :flow_id,
      :config,
      :source_anchor_type,
      :target_anchor_type
    ])
    |> validate_required([:id, :source_id, :target_id, :flow_id, :config])
  end
end
