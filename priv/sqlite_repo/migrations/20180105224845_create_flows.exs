defmodule ExredUI.Repo.Migrations.CreateFlows do
  use Ecto.Migration

  def change do
    create table(:flows, primary_key: false) do
      add(:id, :uuid, primary_key: true)
      add(:name, :string)
      add(:type, :string)
      add(:info, :text)
      add(:config, :map)
      add(:service_id, references(:services, on_delete: :nothing, type: :uuid))

      timestamps()
    end

    create(index(:flows, [:service_id]))

    # execute(
    # "insert into flows(id, name, service_id, inserted_at, updated_at) values('a24a3d7d-04c5-4bcf-91df-88d6268a125c', 'Default', (select id from services where name ='Default'), current_timestamp, current_timestamp)"
    # "insert into flows(name, service_id, inserted_at, updated_at) values('Default', (select id from services where name ='Default'), current_timestamp, current_timestamp)"
    # )
  end
end
