defmodule MutinyTest do
  use ExUnit.Case

  @table %Ecto.Migration.Table{name: "table"}

  test "protect/2 delegates to database adapter" do
    assert Mutiny.protect(@table, Mutiny.Adapters.Test) == "protect: table"
  end

  test "protect/4 delegates to database adapter" do
    assert Mutiny.protect(@table, [:column], Mutiny.Adapters.Test) == "protect: table.column"
  end

  test "create_prevent_update_function/0 delegates to database adapter" do
    assert Mutiny.create_prevent_update_function(Mutiny.Adapters.Test) ==
             "create: prevent_update_function"
  end

  test "drop_prevent_update_function/0 delegates to database adapter" do
    assert Mutiny.drop_prevent_update_function(Mutiny.Adapters.Test) ==
             "drop: prevent_update_function"
  end
end
