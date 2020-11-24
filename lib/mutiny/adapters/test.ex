defmodule Mutiny.Adapters.Test do
  @moduledoc """
  Implements `Mutiny.Adapter` to provide commands for testing.
  """

  @behaviour Mutiny.Adapter

  @doc false
  @impl true
  def protect(%Ecto.Migration.Table{name: table}) do
    "protect: #{table}"
  end

  @doc false
  @impl true
  def protect(%Ecto.Migration.Table{name: table}, [column], _opts) do
    "protect: #{table}.#{column}"
  end

  @doc false
  @impl true
  def create_prevent_update_function do
    "create: prevent_update_function"
  end

  @doc false
  @impl true
  def drop_prevent_update_function do
    "drop: prevent_update_function"
  end
end
