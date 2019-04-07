defmodule ExredUI.Repo.Migrations.CreateServices do
  use Ecto.Migration

  def change do
    create table(:services, primary_key: false) do
      add(:id, :uuid, primary_key: true)
      add(:name, :string)
      add(:type, :string)
      add(:info, :text)
      add(:config, :map)

      timestamps()
    end

    flush()

    # execute(
    # "insert into services(id, name, inserted_at, updated_at) values('da434ad6-d2aa-4295-857a-2361b44934d0', 'Default', current_timestamp, current_timestamp)"
    # "insert into services(name, inserted_at, updated_at) values('Default', current_timestamp, current_timestamp)"
    # )
  end
end
