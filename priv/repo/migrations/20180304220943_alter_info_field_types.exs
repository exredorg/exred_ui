defmodule ExredUI.Repo.Migrations.AlterInfoFieldTypes do
  use Ecto.Migration

  def change do
    alter table("nodes") do
      modify :info, :text
    end

    alter table("flows") do
      modify :info, :text
    end

    alter table("services") do
      modify :info, :text
    end
  end
end
