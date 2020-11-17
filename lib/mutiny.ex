defmodule Mutiny do
  @moduledoc """
  Functions for generating SQL commands that prevent database tables from
  receiving updates.
  """

  @adapter Application.get_env(:mutiny, :adapter, Mutiny.Adapters.Postgres)

  def protect(table) do
    @adapter.protect(table)
  end

  def protect(table, columns, opts) do
    @adapter.protect(table, columns, opts)
  end

  def create_prevent_update_function do
    @adapter.create_prevent_update_function()
  end

  def drop_prevent_update_function do
    @adapter.drop_prevent_update_function()
  end
end
