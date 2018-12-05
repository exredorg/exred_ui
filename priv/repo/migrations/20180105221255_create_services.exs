defmodule ExredUI.Repo.Migrations.CreateServices do
  use Ecto.Migration

  def change do
    execute "create extension if not exists \"uuid-ossp\"", "drop extension if exists \"uuid-ossp\""
    
    create table(:services, primary_key: false) do
      add :id, :uuid, primary_key: true
      add :name, :string
      add :type, :string
      add :info, :string
      add :config, :map

      timestamps()
    end
    
    flush

    execute "insert into services(id, name, inserted_at, updated_at) values(uuid_generate_v4(), 'Default', current_timestamp, current_timestamp)"
  end
end
