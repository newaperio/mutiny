defmodule Mix.Tasks.Mutiny.Gen.Migration do
  use Mix.Task

  @impl true
  def run(_args) do
    filename = Mix.Task.run("ecto.gen.migration", ["set_up_mutiny"])

    migration_fns = migration_up() <> "\n\n" <> migration_down()

    content =
      filename
      |> File.read!()
      |> String.replace("def change do\n\n  end", migration_fns)

    File.write(filename, content)
  end

  defp migration_up do
    """
    def up do
        execute "#{Mutiny.create_prevent_update_function()}"
      end
    """
  end

  defp migration_down do
    """
      def down do
        execute "#{Mutiny.drop_prevent_update_function()}"
      end
    """
  end
end
