defmodule BlockchainAPIWeb.AccountTransactionController do
  use BlockchainAPIWeb, :controller

  alias BlockchainAPI.{Util, Query}
  import BlockchainAPI.Cache.CacheService
  require Logger

  action_fallback BlockchainAPIWeb.FallbackController

  def index(conn, %{"account_address" => address} = params) do
    bin_address = address |> Util.string_to_bin()

    txns = bin_address |> Query.AccountTransaction.list(params)

    conn
    |> put_cache_headers(ttl: :never)
    |> render("index.json", account_transactions: txns)
  end
end
