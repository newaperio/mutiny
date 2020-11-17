defmodule Mutiny.Adapter do
  @moduledoc """
  Defines a behaviour that database adapters should adhere to.

  `protect/1` and `protect/3` should return arbitrary SQL suitable for
  execution as part of an Ecto migration.
  """

  @type columns() :: atom() | String.t() | [atom()] | [String.t()]
  @type opts() :: [{:nullable, boolean()}]

  @doc """
  Returns a command to create a database trigger that prevents `UPDATE`s to the
  given `Ecto.Migration.Table`.

  ## Examples

      iex> table("users") |> protect() |> execute()
      :ok

  """
  @callback protect(Ecto.Migration.Table.t()) :: String.t()

  @doc """
  Returns a command to create a database trigger that prevents `UPDATE`s to the
  given `columns` of the `Ecto.Migration.Table`.

  ## Examples

      iex> table("users") |> protect([:uuid, :birthdate]) |> execute()
      :ok

      iex> table("users") |> protect(:uuid, nullable: true) |> execute()
      :ok

  ## Options

  * `nullable` - Whether the `columns` can be set to `NULL`; defaults to `false`

  """
  @callback protect(Ecto.Migration.Table.t(), columns(), opts()) :: String.t()

  @doc """
  Creates a database function that can be triggered to prevent `UPDATE`s to a
  database table.
  """
  @callback create_prevent_update_function() :: String.t()

  @doc """
  Drops the database function created by `create_prevent_update_function/0`, if
  it exists.
  """
  @callback drop_prevent_update_function() :: String.t()
end
