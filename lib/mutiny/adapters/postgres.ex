defmodule Mutiny.Adapters.Postgres do
  @moduledoc """
  Implements `Mutiny.Adapter` to provide commands for PostgreSQL.
  """

  @behaviour Mutiny.Adapter

  @impl true
  def protect(%Ecto.Migration.Table{name: table}) do
    """
    CREATE OR REPLACE TRIGGER prevent_update
    BEFORE UPDATE on #{table}
    FOR EACH ROW EXECUTE PROCEDURE prevent_update();
    """
  end

  @impl true
  def protect(table, columns, opts \\ [])

  @impl true
  def protect(table, column, opts) when not is_list(column) do
    protect(table, [column], opts)
  end

  @impl true
  def protect(%Ecto.Migration.Table{name: table}, columns, opts) do
    trigger_cols =
      columns
      |> Enum.map(&to_string/1)
      |> Enum.join("_")

    trigger_name = "prevent_update_#{trigger_cols}"

    nullable = Keyword.get(opts, :nullable, false)
    action_condition = condition(columns, nullable)

    """
    DO $$
    BEGIN
      IF NOT EXISTS(
        SELECT *
        FROM information_schema.triggers
        WHERE event_object_table = '#{table}'
        AND trigger_name = '#{trigger_name}'
      )
      THEN
        CREATE TRIGGER #{trigger_name}
        BEFORE UPDATE ON #{table}
        FOR EACH ROW
        WHEN (#{action_condition})
        EXECUTE PROCEDURE prevent_update();
      END IF;
    END;
    $$
    """
  end

  defp condition(columns, nullable) do
    columns
    |> Enum.map(fn col ->
      col = to_string(col)

      "(old.#{col} IS DISTINCT FROM new.#{col}#{null_check(col, nullable)})"
    end)
    |> Enum.join(" OR ")
  end

  defp null_check(_col, true), do: ""
  defp null_check(col, false), do: " AND new.#{col} IS NOT NULL"

  @impl true
  def create_prevent_update_function do
    """
    CREATE OR REPLACE FUNCTION prevent_update()
    RETURNS trigger AS $prevent_update$
    BEGIN
      RAISE EXCEPTION 'data is immutable';
    END;
    $prevent_update$ LANGUAGE plpgsql;
    """
  end

  @impl true
  def drop_prevent_update_function do
    "DROP FUNCTION IF EXISTS prevent_update();"
  end
end
