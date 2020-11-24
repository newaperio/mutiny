defmodule Mutiny.Adapter do
  @moduledoc """
  Defines a behaviour that database adapters should adhere to.

  Callbacks should return arbitrary SQL suitable for execution as part of an
  Ecto migration.
  """

  @type columns() :: atom() | String.t() | [atom()] | [String.t()]
  @type opts() :: [{:nullable, boolean()}]

  @callback protect(table :: Ecto.Migration.Table.t()) :: String.t()
  @callback protect(table :: Ecto.Migration.Table.t(), columns(), opts()) :: String.t()
  @callback create_prevent_update_function() :: String.t()
  @callback drop_prevent_update_function() :: String.t()
end
