defmodule BlockchainAPI.Query.POCPathElement do
  @moduledoc false
  import Ecto.Query, warn: false

  alias BlockchainAPI.{Repo, RORepo, Schema.POCPathElement}

  def list(_) do
    POCPathElement
    |> RORepo.all()
  end

  def get!(challengee) do
    POCPathElement
    |> where([poc_path_element], poc_path_element.challengee == ^challengee)
    |> RORepo.one!()
  end

  def create(attrs \\ %{}) do
    %POCPathElement{}
    |> POCPathElement.changeset(attrs)
    |> Repo.insert()
  end

  def get_last_ten(challengee) do
    POCPathElement
    |> where([poc_path_element], poc_path_element.challengee == ^challengee)
    |> order_by([poc_path_element], desc: poc_path_element.id)
    |> select([poc_path_element], poc_path_element.result)
    |> limit(10)
    |> RORepo.all()
  end
end
