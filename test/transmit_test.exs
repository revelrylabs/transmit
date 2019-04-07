defmodule TransmitTest do
  use ExUnit.Case
  doctest Transmit

  use ExUnit.Case, async: true
  use Plug.Test

  @opts [signer: Transmit.MockSigner]

  defmodule TestRouter do
    use Plug.Router

    plug(:match)
    plug(:dispatch)

    forward("/uploads", to: Transmit, signer: Transmit.MockSigner)
  end

  test "init" do
    assert [] = Transmit.init([])
  end

  test "without file_name param" do
    conn = Transmit.call(conn(:get, "/"), @opts)
    assert conn.status == 422
    assert conn.resp_body =~ "errors"
  end

  test "with file_name param" do
    conn = Transmit.call(conn(:get, "/?file_name=zebra.jpg"), @opts)
    assert conn.status == 200
    assert conn.resp_body =~ "data"
  end

  test "with bad file_name param" do
    conn = Transmit.call(conn(:get, "/?file_name=error.jpg"), @opts)
    assert conn.status == 422
    assert conn.resp_body =~ "errors"
  end

  test "in a router" do
    conn = TestRouter.call(conn(:get, "/uploads?file_name=zebra.jpg"), @opts)
    assert conn.status == 200
    assert conn.resp_body =~ "data"
  end
end
