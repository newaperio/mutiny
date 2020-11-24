defmodule Mutiny do
  @moduledoc """
  Functions for generating database commands that enforce immutability.
  """

  alias Ecto.Migration.Table
  alias Mutiny.Adapter

  @doc """
  Injects shorthand Mutiny functions that implicitly pass the specified
  `adapter`. These functions include:

  * `protect/1` - Makes a table immutable
  * `protect/3` - Makes specific columns of a table immutable
  * `create_prevent_update_function/0` - Creates the database function Mutiny calls
  * `drop_prevent_update_function/0` - Drops the database function Mutiny calls

  When `use`ing this module, a database adapter module should be specified. The
  currently available modules are:

  * `Mutiny.Adapters.Postgres`

  Note that `Mutiny` exposes public versions of all these functions, should you
  desire to call them directly.

  ## Options

  * `adapter` - The Mutiny database adapter to use

  ## Examples

      defmodule MyApp.Repo.Migrations.CreateSnapshots do
        use Ecto.Migration
        use Mutiny, adapter: Mutiny.Adapter.Postgres

        create table("snapshots") do
          add :data, :map
        end

        protect(table("snapshots"))
      end

  """
  @spec __using__(opts :: keyword()) :: Macro.t()
  defmacro __using__(opts) do
    quote do
      import unquote(__MODULE__)

      @adapter unquote(Keyword.fetch!(opts, :adapter))

      def protect(table) do
        protect(table, @adapter)
      end

      def protect(table, columns, opts \\ []) do
        protect(table, columns, opts, @adapter)
      end

      def create_prevent_update_function do
        create_prevent_update_function(@adapter)
      end

      def drop_prevent_update_function do
        drop_prevent_update_function(@adapter)
      end
    end
  end

  @doc """
  Returns a command to create a database trigger that prevents `UPDATE`s to the
  given `Ecto.Migration.Table`.

  An `adapter` module that implements `Mutiny.Adapter` should be specified in
  correspondence with your Ecto adapter.

  ## Examples

      iex> table("users")
      ...> |> protect(Mutiny.Postgres)
      ...> |> execute()
      :ok

  """
  @spec protect(Table.t(), atom()) :: String.t()
  def protect(table, adapter) do
    adapter.protect(table)
  end

  @doc """
  Returns a command to create a database trigger that prevents `UPDATE`s to the
  given `columns` of the `Ecto.Migration.Table`.

  An `adapter` module that implements `Mutiny.Adapter` should be specified in
  correspondence with your Ecto adapter.

  Options may be specified as an `opts` list that will be passed to the given
  adapter.

  ## Examples

      iex> table("users")
      ...> |> protect([:uuid, :birthdate], Mutiny.Adapters.Postgres)
      ...> |> execute()
      :ok

      iex> table("users")
      ...> |> protect([:uuid], Mutiny.Adapters.Postgres, nullable: true)
      ...> |> execute()
      :ok

  """
  @spec protect(Table.t(), Adapter.columns(), atom(), Adapter.opts()) :: String.t()
  def protect(table, columns, adapter, opts \\ []) do
    adapter.protect(table, columns, opts)
  end

  @doc """
  Returns a function that can be executed to prevent `UPDATE`s to a database
  table. This function only needs to be executed once per database.

  ## Examples

    iex> Mutiny.Adapters.Postgres
    ...> |> create_prevent_update_function()
    ...> |> execute()
    :ok

  """
  @spec create_prevent_update_function(atom()) :: String.t()
  def create_prevent_update_function(adapter) do
    adapter.create_prevent_update_function()
  end

  @doc """
  Drops the function created by `create_prevent_update_function/0`, if it
  exists. Useful when rolling back a migration.

  ## Examples

    iex> Mutiny.Adapters.Postgres
    ...> |> drop_prevent_update_function()
    ...> |> execute()
    :ok

  """
  @spec drop_prevent_update_function(atom()) :: String.t()
  def drop_prevent_update_function(adapter) do
    adapter.drop_prevent_update_function()
  end
end
