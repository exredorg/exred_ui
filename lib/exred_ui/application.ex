defmodule ExredUI.Application do
  use Application
  require Logger

  def start(_type, _args) do
    import Supervisor.Spec, warn: false

    {:ok,_} = EctoBootMigration.migrate(:exred_ui)
    
    # workaround to make sure Repo is down
    # EctoBootMigration only sends the exit signal to the Repo 
    # but it doesn't wait for it to exit
    # In some cases starting the Supervisor below fails because 
    # the Repo is still running
    case Process.whereis(ExredUI.Repo) do
      nil -> :not_alive
      
      pid ->
        ref = Process.monitor(pid)
        Logger.info "Waiting for ExredUI.Repo to exit"
        receive do
          {:DOWN, ^ref, _, _, _} -> 
            Logger.info "ExredUI.Repo exited"
            :repo_is_down
        after
          30000 -> :timeout
        end
    end
    
    Logger.info "Starting"
    children = [
      supervisor(ExredUI.Repo, []),
      supervisor(ExredUIWeb.Endpoint, []),
    ]
    opts = [strategy: :one_for_one, name: ExredUI.Supervisor]
    Supervisor.start_link(children, opts)
  end

  def config_change(changed, _new, removed) do
    ExredUIWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
