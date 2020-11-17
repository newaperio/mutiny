defmodule MutinyTest do
  use ExUnit.Case

  test "defaults to Postgres adapter" do
    assert Regex.match?(~r/plpgsql/, Mutiny.create_prevent_update_function())
  end
end
