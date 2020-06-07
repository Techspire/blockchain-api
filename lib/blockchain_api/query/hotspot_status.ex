defmodule BlockchainAPI.Query.HotspotStatus do
  @moduledoc ~s(Get hotspot status using libp2p peer information)

  # Consider 60 minutes as stale time delta
  @stale_delta 3_600_000

  require Logger

  def consolidate_status(challenge_status, pubkey_bin) do
    case challenge_status do
      "online" ->
        "online"

      "offline" ->
        case get_staleness(pubkey_bin) do
          {:error, _} ->
            "offline"

          {:ok, true} ->
            "offline"

          {:ok, false} ->
            "online"
        end
    end
  end

  def get_staleness(pubkey_bin) do
    swarm = :blockchain_swarm.swarm()
    pb = :libp2p_swarm.peerbook(swarm)

    # force a pb refresh
    :ok = :libp2p_peerbook.refresh(pb, pubkey_bin)
    # sleep for 200ms, arp is fast ~80ms
    :timer.sleep(200)

    case :libp2p_peerbook.get(pb, pubkey_bin) do
      {:error, reason} = e ->
        Logger.error("Peer not found #{inspect(reason)}")
        e

      {:ok, peer} ->
        is_stale = :libp2p_peer.is_stale(peer, @stale_delta)
        {:ok, is_stale}
    end
  end

  def sync_percent(pubkey_bin, api_height) do
    swarm = :blockchain_swarm.swarm()
    pb = :libp2p_swarm.peerbook(swarm)

    case :libp2p_peerbook.get(pb, pubkey_bin) do
      {:error, reason} ->
        Logger.error("Peer not found #{inspect(reason)}")
        nil

      {:ok, peer} ->
        case :libp2p_peer.signed_metadata_get(peer, <<"height">>, :undefined) do
          height when is_integer(height) and height > 0 ->
            case abs(api_height - height) <= 500 do
              true ->
                1.0

              false ->
                height / api_height
            end

          _ ->
            nil
        end
    end
  end
end
