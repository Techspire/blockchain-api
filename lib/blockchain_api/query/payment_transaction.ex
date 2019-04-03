defmodule BlockchainAPI.Query.PaymentTransaction do
  @moduledoc false
  import Ecto.Query, warn: false

  alias BlockchainAPI.{Repo, Schema.PaymentTransaction}

  def list(params) do
    PaymentTransaction
    |> Repo.paginate(params)
  end

  def get!(hash) do
    PaymentTransaction
    |> where([pt], pt.hash == ^hash)
    |> Repo.one!
  end

  def create(attrs \\ %{}) do
    %PaymentTransaction{}
    |> PaymentTransaction.changeset(attrs)
    |> Repo.insert()
  end
end