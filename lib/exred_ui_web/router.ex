defmodule ExredUIWeb.Router do
  use ExredUIWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :put_secure_browser_headers
  end
  
  scope "/", ExredUIWeb do
    pipe_through :browser
    #resources "/", IndexController
    #resources "/assets", IndexController
    get "/", IndexController, :index
  end


  pipeline :api do
    plug :accepts, ["json", "json-api"]
    plug JaSerializer.Deserializer
  end

  scope "/api", ExredUIWeb do
    pipe_through :api
    resources "/services", ServiceController, except: [:new, :edit]
    resources "/flows", FlowController, except: [:new, :edit]
    resources "/connections", ConnectionController, except: [:new, :edit]
    resources "/nodes", NodeController, except: [:new, :edit]
  end
end
