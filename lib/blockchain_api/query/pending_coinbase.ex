defmodule BlockchainAPI.Query.PendingCoinbase do
  @moduledoc false
  import Ecto.Query, warn: false

  alias BlockchainAPI.{Repo, RORepo, Schema.PendingCoinbase}

  def create(attrs \\ %{}) do
    %PendingCoinbase{}
    |> PendingCoinbase.changeset(attrs)
    |> Repo.insert()
  end

  def get!(hash) do
    PendingCoinbase
    |> where([pc], pc.hash == ^hash)
    |> RORepo.one!()
  end

  def get_by_id!(id) do
    PendingCoinbase
    |> where([pc], pc.id == ^id)
    |> RORepo.one!()
  end

  def update!(pc, attrs \\ %{}) do
    pc
    |> PendingCoinbase.changeset(attrs)
    |> Repo.update!()
  end
end
