defmodule ExredUI.Repo.Migrations.AddAnchorTypesToConnections do
  use Ecto.Migration

  def change do
    alter table(:connections) do
      add :source_anchor_type, :string, default: "Left"
      add :target_anchor_type, :string, default: "Right"
    end
  end
end
