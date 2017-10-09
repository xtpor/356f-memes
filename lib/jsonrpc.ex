defmodule JsonRpc do

  @opaque json_value :: number() | boolean() | String.t | json_array() |
                      json_object()

  @opaque json_array :: [json_value()]

  @opaque json_object :: %{String.t => json_value()}

  @opaque predefined_error :: :parse_error |
                              :invalid_request |
                              :method_not_found |
                              :invalid_params |
                              :internal_error

  @type error :: predefined_error() |
                 {error_code(), String.t} |
                 {error_code(), String.t, json_value()}

  @type error_code :: -32678..-32000

  @type dispatcher :: (String.t,
                      json_array() | json_object() ->
                      {:ok, json_value()} |
                      {:error, error()})

  # Serializer

  @spec rpc(String.t, dispatcher()) :: {:reply, String.t} | :noreply
  def rpc(text, callback) when is_function(callback, 2) do
    try do
      text
      |> decode_request
      |> dispatch(callback)
    catch
      {:error, e} -> e |> expand_error |> error_response
    end
    |> encode_response
  end

  defp decode_request(text) do
    case Poison.decode(text) do
      {:ok, json} -> json
      _ -> throw {:error, :parse_error}
    end
  end

  defp encode_response(:noreply) do
    :noreply
  end

  defp encode_response({:reply, json}) do
    {:reply, Poison.encode!(json)}
  end

  defp dispatch(json, callback) do
    case json do
      json when is_map(json) -> handle_single(json, callback)
      [] -> throw {:error, :invalid_request}
      json when is_list(json) -> handle_batch(json, callback)
      _ -> throw {:error, :invalid_request}
    end
  end

  defp handle_single(json, callback) do
    case verify_request(json) do
      %{"id" => _} = req -> handle_request(req, callback)
      req -> handle_notification(req, callback)
    end
  end

  defp handle_notification(req, callback) do
    try do
      rpc_callback(req, callback)
    catch
      # ignore all error
      :throw, {:error, _} -> nil
    end
    :noreply
  end

  defp handle_request(%{"id" => id} = req, callback) do
    try do
      result = rpc_callback(req, callback)
      {:reply, %{"jsonrpc" => "2.0", "result" => result, "id" => id}}
    catch
      :throw, {:error, e} ->
        e |> expand_error |> error_response(id)
    end
  end

  defp handle_batch(json, callback) do
    result =
      json
      |> Enum.map(fn req ->
        try do
          handle_single(req, callback)
        catch
          {:error, e} -> e |> expand_error |> error_response
        end
      end)
      |> Enum.reject(&match?(:noreply, &1))
      |> Enum.map(fn {:reply, res} -> res end)

    case result do
      [] -> :noreply
      r -> {:reply, r}
    end
  end

  defp error_response(e) do
    error_response(e, nil)
  end

  defp error_response({code, message, nil}, id) do
    {:reply,
      %{
        "jsonrpc" => "2.0",
        "error" => %{"code" => code, "message" => message},
        "id" => id
      }
    }
  end

  defp error_response({code, message, data}, id) do
    {:reply,
      %{
        "jsonrpc" => "2.0",
        "error" => %{"code" => code, "message" => message, "data" => data},
        "id" => id
      }
    }
  end

  defp verify_request(json) do
    json
    |> field_jsonrpc
    |> field_method
    |> field_params
    |> field_id
  end

  defp field_jsonrpc(req) do
    case req do
      %{"jsonrpc" => "2.0"} -> req
      _ -> throw {:error, :invalid_request}
    end
  end

  defp field_method(req) do
    case req do
      %{"method" => m} when is_binary(m) -> req
      _ -> throw {:error, :invalid_request}
    end
  end

  defp field_params(req) do
    case req do
      %{"params" => id} when is_map(id) -> req
      %{"params" => id} when is_list(id) -> req
      %{"params" => _} -> throw {:error, :invalid_request}
      _ -> req
    end
  end

  defp field_id(req) do
    case req do
      %{"id" => id} when is_number(id) -> req
      %{"id" => id} when is_binary(id) -> req
      %{"id" => id} when is_nil(id) -> req
      %{"id" => _} -> throw {:error, :invalid_request}
      _ -> req
    end
  end

  defp rpc_callback(req, fun) do
    try do
      try do
        case fun.(req["method"], req["params"]) do
          {:ok, json} -> verify_json!(json)
          {:error, _} = e -> throw verify_error!(e)
        end
      catch
        :throw, {:ok, json} -> verify_json!(json)
        :throw, {:error, _} = e -> throw verify_error!(e)
      end
    catch
      :error, e ->
        require Logger

        Exception.format(:error, e, :erlang.get_stacktrace)
        |> Logger.error
        throw {:error, :internal_error}
    end
  end

  defp verify_json!(value) do
    Poison.encode!(value)
    value
  end

  defp verify_error!({:error, inner} = e) do
    expand_error(inner)
    e
  end

  defp expand_error(:parse_error), do: {-32700, "Parse error", nil}
  defp expand_error(:invalid_request), do: {-32600, "Invalid Request", nil}
  defp expand_error(:method_not_found), do: {-32601, "Method not found", nil}
  defp expand_error(:invalid_params), do: {-32602, "Invalid params", nil}
  defp expand_error(:internal_error), do: {-32603, "Internal error", nil}

  defp expand_error({code, message})
      when code in -32678..-32000 and is_binary(message) do
    {code, message, nil}
  end

  defp expand_error({code, message, data})
      when code in -32678..-32000 and is_binary(message) do
    verify_json!(data)
    {code, message, data}
  end

  # Dispatcher

  @spec method_mapper(atom()) :: dispatcher()
  def method_mapper(module) do
    &dispatch(&1, &2, module)
  end

  defp dispatch(method, params, module) do
    fun = parse_fun(method )
    args = parse_args(params)
    ensure_existent_mfa(module, fun, args)

    try do
      apply(module, fun, args)
    catch
      :error, :function_clause ->
        case :erlang.get_stacktrace do
          [{^module, ^fun, ^args, _}, {__MODULE__, :dispatch, _, _} | _] ->
            {:error, :invalid_params}
          st ->
            :erlang.raise(:error, :function_clause, st)
        end
    end
  end

  defp parse_fun(method) do
    try do
      String.to_existing_atom(method)
    catch
      :error, :badarg -> throw {:error, :method_not_found}
    end
  end

  defp parse_args(params) do
    case is_list(params) do
      true -> params
      false -> throw {:error, :invalid_params}
    end
  end

  defp ensure_existent_mfa(m, f, a) do
    Code.ensure_loaded(m)
    case :erlang.function_exported(m, f, length(a)) do
      true -> nil
      false -> throw {:error, :method_not_found}
    end
  end

end
