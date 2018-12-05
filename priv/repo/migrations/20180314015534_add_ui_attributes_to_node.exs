defmodule ExredUI.Repo.Migrations.AddUiAttributesToNode do
  use Ecto.Migration

  def change do
    alter table(:nodes) do
      add :ui_attributes, :map
    end
  end
end
