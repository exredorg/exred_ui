defmodule ExredUI.Repo.Migrations.CreateNodes do
  use Ecto.Migration

  def change do
    create table(:nodes, primary_key: false) do
      add :id, :uuid, primary_key: true
      add :type, :string
      add :name, :string
      add :category, :string
      add :module, :string
      add :config, :map
      add :info, :string
      add :is_prototype, :boolean, default: false
      add :flow_id, references(:flows, on_delete: :nothing, type: :uuid)

      timestamps()
    end

    create index(:nodes, [:flow_id])
  end
end
