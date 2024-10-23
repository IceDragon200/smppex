defmodule SMPPEX.MCTest do
  defmodule MCEchoSession do
    def init(_socket, _transport, opts) do
      {:ok, opts}
    end
  end

  defmodule ESMETestSession do
    require Logger

    # @behaviour SMPPEX.Session

    # @impl true
    def init(socket, transport, args) do
      {:ok, %{socket: socket, transport: transport, args: args}}
    end

    # @impl true
    def terminate(reason, _lost_pdus, _state) do
      case reason do
        :normal ->
          :stop

        other ->
          Logger.error "terminating test session: #{inspect reason}"
          :stop
      end
    end

    # @impl true
    def handle_socket_closed(state) do
      {:normal, state}
    end

    # @impl true
    def handle_call(:hello, _from, state) do
      {:reply, {:ok, :hello}, state}
    end

    # @impl true
    def handle_send_pdu_result(_pdu, :ok, state) do
      state
    end
  end

  use ExUnit.Case

  alias SMPPEX.MC

  describe "start/2" do
    test "start, ranch 1.x transport_opts format" do
      {:ok, pid} = Agent.start_link(fn -> [] end)
      handler = fn {:init, _socket, _transport}, st -> {:ok, st} end

      assert {:ok, _} = MC.start({Support.Session, {pid, handler}}, transport_opts: [port: 0])
    end

    test "start" do
      {:ok, pid} = Agent.start_link(fn -> [] end)
      handler = fn {:init, _socket, _transport}, st -> {:ok, st} end

      assert {:ok, _} =
               MC.start({Support.Session, {pid, handler}}, transport_opts: %{socket_opts: [port: 0]})
    end

    test "stop" do
      {:ok, pid} = Agent.start_link(fn -> [] end)
      handler = fn {:init, _socket, _transport}, st -> {:ok, st} end

      assert {:ok, mc_server} =
               MC.start({Support.Session, {pid, handler}}, transport_opts: %{socket_opts: [port: 0]})

      assert :ok == MC.stop(mc_server)
    end

    test "child_spec" do
      {:ok, pid} = Agent.start_link(fn -> [] end)
      handler = fn {:init, _socket, _transport}, st -> {:ok, st} end

      assert {:ok, _pid} =
               start_supervised({
                 MC,
                 session: {Support.Session, {pid, handler}},
                 transport_opts: %{socket_opts: [port: 0]}
               })
    end

    test "a esme can connect to it" do
      {:ok, pid} = Agent.start_link(fn -> [] end)
      handler = fn {:init, _socket, _transport}, st -> {:ok, st} end

      assert {:ok, mc_server} =
        MC.start({MCEchoSession, {pid, handler}}, transport_opts: %{socket_opts: [port: 0]})

      assert port = :ranch.get_port(mc_server)

      assert {:ok, pid} = SMPPEX.ESME.start_link("localhost", port, {ESMETestSession, [:ok]})
      assert {:ok, :hello} = SMPPEX.ESME.call(pid, :hello)
      pdu = SMPPEX.Pdu.Factory.bind_transceiver("sysid", "passw")
      assert :ok = SMPPEX.Session.send_pdu(pid, pdu)

      assert :ok = SMPPEX.ESME.stop(pid)

      assert :ok == MC.stop(mc_server)
    end
  end
end
