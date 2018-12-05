defmodule ExredUIWeb.CmdChannel do
  use ExredUIWeb, :channel

  require Logger

  def join("cmd:general", payload, socket) do
    if authorized?(payload) do
      # Logger.info "Joined: #{inspect socket}\npayload: #{inspect payload}"
      {:ok, socket}
    else
      {:error, %{reason: "unauthorized"}}
    end
  end

  def join("cmd:" <> _private_topic_id, _params, _socket) do
    {:error, %{reason: "unauthorized"}}
  end

  def handle_in("request", payload, socket) do
    broadcast(socket, "request", payload)
    {:reply, :ok, socket}
  end

  def handle_in("notification", payload, socket) do
    broadcast(socket, "notification", payload)
    {:reply, :ok, socket}
  end

  # Channels can be used in a request/response fashion
  # by sending replies to requests from the client
  def handle_in("ping", payload, socket) do
    {:reply, {:ok, payload}, socket}
  end

  # It is also common to receive messages from the client and
  # broadcast to everyone in the current topic (cmd:lobby).
  def handle_in("shout", payload, socket) do
    broadcast(socket, "shout", payload)
    {:noreply, socket}
  end

  def handle_in(event, payload, socket) do
    Logger.debug("unhandled event: #{inspect(event)}, payload: #{inspect(payload)}")
    {:noreply, socket}
  end

  # Add authorization logic here as required.
  defp authorized?(_payload) do
    true
  end
end
