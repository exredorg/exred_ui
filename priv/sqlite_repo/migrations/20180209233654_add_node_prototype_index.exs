defmodule ExredUI.Repo.Migrations.AddNodePrototypeIndex do
  use Ecto.Migration

  def change do
    create unique_index(:nodes, [:name], where: :is_prototype)
  end
end
