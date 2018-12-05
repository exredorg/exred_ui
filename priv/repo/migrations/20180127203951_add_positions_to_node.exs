defmodule ExredUI.Repo.Migrations.AddPositionsToNode do
  use Ecto.Migration

  def change do
    alter table(:nodes) do
      add :x, :integer, default: 0
      add :y, :integer, default: 0
    end
  end
end
