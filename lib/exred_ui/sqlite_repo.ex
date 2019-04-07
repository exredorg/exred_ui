defmodule ExredUI.SqliteRepo do
  use Ecto.Repo, otp_app: :exred_ui, adapter: Sqlite.Ecto2
end
