defmodule Mix.Tasks.Mutiny.Gen.Migration do
  use Mix.Task

  @shortdoc "Generates the Mutiny migration file"

  @doc """
  Generates an Ecto migration that can be run in order to create the database
  function that Mutiny calls.

  ## Arguments

  An `adapter` argument corresponding to your database should be specified.
  Currently, the following arguments are accepted:

  * `postgres`

  ## Examples

      mix mutiny.gen.migration postgres

  """
  @impl true
  def run([adapter_opt]) do
    adapter = get_adapter(adapter_opt)
    migration_fns = migration_up(adapter) <> "\n\n" <> migration_down(adapter)
    filename = Mix.Task.run("ecto.gen.migration", ["set_up_mutiny"])

    content =
      filename
      |> File.read!()
      |> String.replace("def change do\n\n  end", migration_fns)

    File.write(filename, content)
  end

  def run(_), do: raise_adapter_error()

  @spec raise_adapter_error() :: none()
  def raise_adapter_error, do: raise(ArgumentError, "must specify a valid database adapter")

  @spec get_adapter(String.t()) :: atom()
  defp get_adapter("postgres"), do: Mutiny.Adapters.Postgres
  defp get_adapter(_), do: raise_adapter_error()

  @spec migration_up(atom()) :: String.t()
  defp migration_up(adapter) do
    """
    def up do
        execute "#{adapter.create_prevent_update_function()}"
      end
    """
  end

  @spec migration_down(atom()) :: String.t()
  defp migration_down(adapter) do
    """
      def down do
        execute "#{adapter.drop_prevent_update_function()}"
      end
    """
  end
end
