defmodule RadiusServer do
  @moduledoc """
  Example of using eradius, will be updated, as it will be have better elixir interface.
  """
  import Radius.Data
  import Logger

  # Require dictionary macros
  require Attr

  def server() do
    :application.ensure_all_started(:eradius)
    # See config/config.exs for example configuration
    spawn(fn ->
            # this should be called in application starts, that eradius linked to application and
            # stops distributing requests to a module, if application is not running
            :eradius.modules_ready([__MODULE__])
            :timer.sleep(:infinity)
          end)
  end

  @doc """
  Implementation of a callback.
  """
  def radius_request(radius_request(cmd: :request) = request, _nas_prop, _handler_args) do
    username = :eradius_lib.get_attr(request, Attr.user_name)
    password = :eradius_lib.get_attr(request, Attr.user_password)

    Logger.log(:info, "Authenticated user #{username} with password #{password}")

    #{:reply, radius_request(cmd: :reject)}
    {:reply, radius_request(cmd: :accept)}
  end

  def radius_request(radius_request(cmd: :accreq) = request, _nas_prop, _handler_args) do
    username = :eradius_lib.get_attr(request, Attr.user_name)
    password = :eradius_lib.get_attr(request, Attr.user_password)

    Logger.log(:info, "Authenticated user #{username} with password #{password}")

    #{:reply, radius_request(cmd: :reject)}
    {:reply, radius_request(cmd: :accept)}
  end

  @doc """
  Simple client code for testing it
  """
  @secret "secret"
  @server {{127, 0, 0, 1}, 1812, @secret}
  def client() do
    request = radius_request(cmd: :request) |> :eradius_lib.set_attributes([{Attr.user_name, "foo"}, {Attr.user_password, "test"}])
    case :eradius_client.send_request(@server, request) do
      {:ok, result, auth} ->
        :eradius_lib.decode_request(result, @secret, auth)
      error ->
        error
    end
  end
end
