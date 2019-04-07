defmodule ExredUI.Editor.Service do
  use Ecto.Schema
  import Ecto.Changeset
  alias ExredUI.Editor.Service

  @primary_key {:id, Ecto.UUID, autogenerate: true}
  @foreign_key_type Ecto.UUID
  @derive {Phoenix.Param, key: :id}

  schema "services" do
    field(:type, :string)

    field(:name, :string)
    field(:info, :string)
    field(:config, :map)

    has_many(:flows, ExredUI.Editor.Flow)

    timestamps()
  end

  @doc false
  def changeset(%Service{} = service, attrs) do
    service
    |> cast(attrs, [:name, :type, :info, :config])
    |> validate_required([:name, :type, :info, :config])
  end
end
