defmodule ExredUI.Repo.Migrations.CreateConnections do
  use Ecto.Migration

  def change do
    create table(:connections, primary_key: false) do
      add :id, :uuid, primary_key: true
      add :config, :map
      add :source_id, references(:nodes, on_delete: :nothing, type: :uuid)
      add :target_id, references(:nodes, on_delete: :nothing, type: :uuid)
      add :flow_id, references(:flows, on_delete: :nothing, type: :uuid)

      timestamps()
    end

    create index(:connections, [:source_id])
    create index(:connections, [:target_id])
    create index(:connections, [:flow_id])
  end
end
