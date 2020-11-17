defmodule Mutiny.Adapters.PostgresTest do
  use ExUnit.Case

  alias Mutiny.Adapters.Postgres

  @table %Ecto.Migration.Table{name: "table"}

  test "protect/1 returns the correct SQL command" do
    assert Postgres.protect(@table) == """
           CREATE OR REPLACE TRIGGER prevent_update
           BEFORE UPDATE on table
           FOR EACH ROW EXECUTE PROCEDURE prevent_update();
           """
  end

  test "protect/3 returns the correct SQL command" do
    assert Postgres.protect(@table, :uuid) ==
             """
             DO $$
             BEGIN
               IF NOT EXISTS(
                 SELECT *
                 FROM information_schema.triggers
                 WHERE event_object_table = 'table'
                 AND trigger_name = 'prevent_update_uuid'
               )
               THEN
                 CREATE TRIGGER prevent_update_uuid
                 BEFORE UPDATE ON table
                 FOR EACH ROW
                 WHEN ((old.uuid IS DISTINCT FROM new.uuid AND new.uuid IS NOT NULL))
                 EXECUTE PROCEDURE prevent_update();
               END IF;
             END;
             $$
             """
  end

  test "protect/3 with multiple columns and nullable option returns the correct SQL command" do
    assert Postgres.protect(@table, [:uuid, :birthdate], nullable: true) ==
             """
             DO $$
             BEGIN
               IF NOT EXISTS(
                 SELECT *
                 FROM information_schema.triggers
                 WHERE event_object_table = 'table'
                 AND trigger_name = 'prevent_update_uuid_birthdate'
               )
               THEN
                 CREATE TRIGGER prevent_update_uuid_birthdate
                 BEFORE UPDATE ON table
                 FOR EACH ROW
                 WHEN ((old.uuid IS DISTINCT FROM new.uuid) OR (old.birthdate IS DISTINCT FROM new.birthdate))
                 EXECUTE PROCEDURE prevent_update();
               END IF;
             END;
             $$
             """
  end

  test "create_prevent_update_function/0 returns the correct SQL command" do
    assert Postgres.create_prevent_update_function() == """
           CREATE OR REPLACE FUNCTION prevent_update()
           RETURNS trigger AS $prevent_update$
           BEGIN
             RAISE EXCEPTION 'data is immutable';
           END;
           $prevent_update$ LANGUAGE plpgsql;
           """
  end

  test "drop_prevent_update_function/0 returns the correct SQL command" do
    assert Postgres.drop_prevent_update_function() == "DROP FUNCTION IF EXISTS prevent_update();"
  end
end
