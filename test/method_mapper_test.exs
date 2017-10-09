
defmodule MethodMapperTest.Helper do
  require ExUnit.Assertions
  import ExUnit.Assertions

  def assert_json_equals(left, right) do
    {:ok, json_left} = Poison.decode(left)
    {:ok, json_right} = Poison.decode(right)
    assert json_left == json_right
  end

  def assert_request_response(req: req, res: :noreply, handler: handler) do
    assert :noreply == JsonRpc.rpc(req, handler)
  end

  def assert_request_response(req: req, res: res, handler: handler) do
    {:reply, actual_res} = JsonRpc.rpc(req, handler)
    assert_json_equals res, actual_res
  end

end

defmodule MethodMapperTest.MockHandler do

  def sum(a, b) when is_integer(a) and is_integer(b) do
    {:ok, a + b}
  end

  def increment(x) when is_number(x) do
    {:ok, x + 1}
  end

  def error_fun1 do
    # intentional error
    1 = 2
  end

  def error_fun2 do
    # intentional error
    case 1 do
      2 -> nil
    end
  end

  def error_fun3 do
    # intentional error
    __MODULE__.non_existent_fun()
  end

end

defmodule MethodMapperTest do
  use ExUnit.Case
  alias MethodMapperTest.MockHandler
  import MethodMapperTest.Helper

  test "map rpc call to the correct function #1" do
    assert_request_response(
      req: ~s(
        {"jsonrpc": "2.0", "method": "sum", "params": [23, 42], "id": 1}
      ),
      res: ~s(
        {"jsonrpc": "2.0", "result": 65, "id": 1}
      ),
      handler: JsonRpc.method_mapper(MockHandler)
    )
  end

  test "map rpc call to the correct function #2" do
    assert_request_response(
      req: ~s(
        {"jsonrpc": "2.0", "method": "increment", "params": [23], "id": 2}
      ),
      res: ~s(
        {"jsonrpc": "2.0", "result": 24, "id": 2}
      ),
      handler: JsonRpc.method_mapper(MockHandler)
    )
  end

  test "call a non-existent method" do
    assert_request_response(
      req: ~s(
        {"jsonrpc": "2.0", "method": "foobar", "params": [23], "id": 3}
      ),
      res: ~s(
        {"jsonrpc": "2.0", "error": {"code": -32601, "message": "Method not found"}, "id": 3}
      ),
      handler: JsonRpc.method_mapper(MockHandler)
    )
  end

  test "call a existing method with incorrect arity" do
    assert_request_response(
      req: ~s(
        {"jsonrpc": "2.0", "method": "increment", "params": [23, 42], "id": 4}
      ),
      res: ~s(
        {"jsonrpc": "2.0", "error": {"code": -32601, "message": "Method not found"}, "id": 4}
      ),
      handler: JsonRpc.method_mapper(MockHandler)
    )
  end

  test "call a existing method with argument of incorrect type" do
    assert_request_response(
      req: ~s(
        {"jsonrpc": "2.0", "method": "increment", "params": ["a"], "id": 5}
      ),
      res: ~s(
        {"jsonrpc": "2.0", "error": {"code": -32602, "message": "Invalid params"}, "id": 5}
      ),
      handler: JsonRpc.method_mapper(MockHandler)
    )
  end

  test "call a method with error #1" do
    Logger.disable(self())
    assert_request_response(
      req: ~s(
        {"jsonrpc": "2.0", "method": "error_fun1", "params": [], "id": "1"}
      ),
      res: ~s(
        {"jsonrpc": "2.0", "error": {"code": -32603, "message": "Internal error"}, "id": "1"}
      ),
      handler: JsonRpc.method_mapper(MockHandler)
    )
  end

  test "call a method with error #2" do
    Logger.disable(self())
    assert_request_response(
      req: ~s(
        {"jsonrpc": "2.0", "method": "error_fun2", "params": [], "id": "2"}
      ),
      res: ~s(
        {"jsonrpc": "2.0", "error": {"code": -32603, "message": "Internal error"}, "id": "2"}
      ),
      handler: JsonRpc.method_mapper(MockHandler)
    )
  end

  test "call a method with error #3" do
    Logger.disable(self())
    assert_request_response(
      req: ~s(
        {"jsonrpc": "2.0", "method": "error_fun3", "params": [], "id": "3"}
      ),
      res: ~s(
        {"jsonrpc": "2.0", "error": {"code": -32603, "message": "Internal error"}, "id": "3"}
      ),
      handler: JsonRpc.method_mapper(MockHandler)
    )
  end

end
