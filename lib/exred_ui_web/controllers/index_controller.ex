defmodule ExredUIWeb.IndexController do
  use ExredUIWeb, :controller
  
  def index(conn, _params) do
    index_path = List.to_string(:code.priv_dir(:exred_ui)) <> "/static/index.html"
    conn
    |> put_resp_header("content-type", "text/html; charset=utf-8")
    |> Plug.Conn.send_file(200, index_path)
  end

end
