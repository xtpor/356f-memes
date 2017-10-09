
defmodule JsonRpcTest.Helper do
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

defmodule JsonRpcTest.MockHandler do

  def call("sum", numbers) when is_list(numbers) do
    {:ok, Enum.sum(numbers)}
  end

  def call("notify_hello", [_value]) do
    {:ok, :ignored}
  end

  def call("subtract", [a, b]) do
    {:ok, a - b}
  end

  def call("subtract", %{"minuend" => a, "subtrahend" => b}) do
    {:ok, a - b}
  end

  def call("get_data", nil) do
    {:ok, ["hello", 5]}
  end

  def call(_, _) do
    {:error, :method_not_found}
  end

end

defmodule JsonRpcTest do
  use ExUnit.Case
  import JsonRpcTest.Helper
  alias JsonRpcTest.MockHandler

  test "rpc call with positional parameters #1" do
    assert_request_response(
      req: ~s(
        {"jsonrpc": "2.0", "method": "subtract", "params": [42, 23], "id": 1}
      ),
      res: ~s(
        {"jsonrpc": "2.0", "result": 19, "id": 1}
      ),
      handler: &MockHandler.call/2
    )
  end

  test "rpc call with positional parameters #2" do
    assert_request_response(
      req: ~s(
        {"jsonrpc": "2.0", "method": "subtract", "params": [23, 42], "id": 2}
      ),
      res: ~s(
        {"jsonrpc": "2.0", "result": -19, "id": 2}
      ),
      handler: &MockHandler.call/2
    )
  end

  test "rpc call with named parameters #1" do
    assert_request_response(
      req: ~s(
        {"jsonrpc": "2.0", "method": "subtract", "params": {"subtrahend": 23, "minuend": 42}, "id": 3}
      ),
      res: ~s(
        {"jsonrpc": "2.0", "result": 19, "id": 3}
      ),
      handler: &MockHandler.call/2
    )
  end

  test "rpc call with named parameters #2" do
    assert_request_response(
      req: ~s(
        {"jsonrpc": "2.0", "method": "subtract", "params": {"minuend": 42, "subtrahend": 23}, "id": 4}
      ),
      res: ~s(
        {"jsonrpc": "2.0", "result": 19, "id": 4}
      ),
      handler: &MockHandler.call/2
    )
  end

  test "a Notification #1" do
    assert_request_response(
      req: ~s(
        {"jsonrpc": "2.0", "method": "update", "params": [1,2,3,4,5]}
      ),
      res: :noreply,
      handler: &MockHandler.call/2
    )
  end

  test "a Notification #2" do
    assert_request_response(
      req: ~s(
        {"jsonrpc": "2.0", "method": "foobar"}
      ),
      res: :noreply,
      handler: &MockHandler.call/2
    )
  end

  test "rpc call of non-existent method" do
    assert_request_response(
      req: ~s(
        {"jsonrpc": "2.0", "method": "foobar", "id": "1"}
      ),
      res: ~s(
        {"jsonrpc": "2.0", "error": {"code": -32601, "message": "Method not found"}, "id": "1"}
      ),
      handler: &MockHandler.call/2
    )
  end

  test "rpc call with invalid JSON" do
    assert_request_response(
      req: ~s(
        {"jsonrpc": "2.0", "method": "foobar, "params": "bar", "baz]
      ),
      res: ~s(
        {"jsonrpc": "2.0", "error": {"code": -32700, "message": "Parse error"}, "id": null}
      ),
      handler: &MockHandler.call/2
    )
  end

  test "rpc call with invalid Request object" do
    assert_request_response(
      req: ~s(
        {"jsonrpc": "2.0", "method": 1, "params": "bar"}
      ),
      res: ~s(
        {"jsonrpc": "2.0", "error": {"code": -32600, "message": "Invalid Request"}, "id": null}
      ),
      handler: &MockHandler.call/2
    )
  end

  test "rpc call Batch, invalid JSON" do
    assert_request_response(
      req: ~s(
        [
          {"jsonrpc": "2.0", "method": "sum", "params": [1,2,4], "id": "1"},
          {"jsonrpc": "2.0", "method"
        ]
      ),
      res: ~s(
        {"jsonrpc": "2.0", "error": {"code": -32700, "message": "Parse error"}, "id": null}
      ),
      handler: &MockHandler.call/2
    )
  end

  test "rpc call with an empty Array" do
    assert_request_response(
      req: ~s(
        []
      ),
      res: ~s(
        {"jsonrpc": "2.0", "error": {"code": -32600, "message": "Invalid Request"}, "id": null}
      ),
      handler: &MockHandler.call/2
    )
  end

  test "rpc call with an invalid Batch (but not empty)" do
    assert_request_response(
      req: ~s(
        [1]
      ),
      res: ~s(
        [
          {"jsonrpc": "2.0", "error": {"code": -32600, "message": "Invalid Request"}, "id": null}
        ]
      ),
      handler: &MockHandler.call/2
    )
  end

  test "rpc call with invalid Batch" do
    assert_request_response(
      req: ~s(
        [1,2,3]
      ),
      res: ~s(
        [
          {"jsonrpc": "2.0", "error": {"code": -32600, "message": "Invalid Request"}, "id": null},
          {"jsonrpc": "2.0", "error": {"code": -32600, "message": "Invalid Request"}, "id": null},
          {"jsonrpc": "2.0", "error": {"code": -32600, "message": "Invalid Request"}, "id": null}
        ]
      ),
      handler: &MockHandler.call/2
    )
  end

  test "rpc call Batch" do
    assert_request_response(
      req: ~s(
        [
          {"jsonrpc": "2.0", "method": "sum", "params": [1,2,4], "id": "1"},
          {"jsonrpc": "2.0", "method": "notify_hello", "params": [7]},
          {"jsonrpc": "2.0", "method": "subtract", "params": [42,23], "id": "2"},
          {"foo": "boo"},
          {"jsonrpc": "2.0", "method": "foo.get", "params": {"name": "myself"}, "id": "5"},
          {"jsonrpc": "2.0", "method": "get_data", "id": "9"}
        ]
      ),
      res: ~s(
        [
          {"jsonrpc": "2.0", "result": 7, "id": "1"},
          {"jsonrpc": "2.0", "result": 19, "id": "2"},
          {"jsonrpc": "2.0", "error": {"code": -32600, "message": "Invalid Request"}, "id": null},
          {"jsonrpc": "2.0", "error": {"code": -32601, "message": "Method not found"}, "id": "5"},
          {"jsonrpc": "2.0", "result": ["hello", 5], "id": "9"}
        ]
      ),
      handler: &MockHandler.call/2
    )
  end

  test "rpc call Batch (all notifications)" do
    assert_request_response(
      req: ~s(
        [
          {"jsonrpc": "2.0", "method": "notify_sum", "params": [1,2,4]},
          {"jsonrpc": "2.0", "method": "notify_hello", "params": [7]}
        ]
      ),
      res: :noreply,
      handler: &MockHandler.call/2
    )
  end
end
