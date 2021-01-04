# Getting started

This guide is a brief introduction to [Mutiny]. For detailed information about
the usage of invidual functions, you'll want to check the [full documentation].

## Overview

Mutiny allows you to protect certain database tables or columns from updates by
calling simple functions in your [Ecto] migrations.

Currently, [PostgreSQL] is the only supported database, but the library is
designed in such a way that adding support for other databases should be
relatively straightforward.

## Installation

Mutiny is designed to work with Ecto, and in fact requires it to be installed
for initial setup. You can install Ecto, a database driver (so Ecto can talk to
your database), and Mutiny by adding the appropriate dependencies to `mix.exs`:

```elixir
def deps do
  [
    {:ecto_sql, "~> 3.0"},
    {:postgrex, ">= 0.0.0"},
    {:mutiny, "~> 0.1.0"}
  ]
end
```

## Setup

Under the hood, Mutiny works by calling a database function when update events
occur in your database. Naturally, this function will need to be added to your
database before you start using Mutiny in your migrations.

Mutiny comes with a Mix task that will create the required database function
for you: `mutiny.gen.migration`. Be sure to supply an argument to indicate the
type of database you're using:

```sh
mix mutiny.gen.migration postgres
mix ecto.migrate
```

If you'd rather write the migration yourself, take a look at
`Mutiny.create_prevent_update_function/0` and
`Mutiny.drop_prevent_update_function/0`.

## Usage

Now you're ready to start using Mutiny in your project.

Mutiny generates SQL commands that can be executed as part of an Ecto
migration. Simply `use` Mutiny in a migration and specify the adapter that
corresponds with your database.

The following migration will protect the `data` column of the `snapshots` table
from updates:

```elixir
defmodule MyApp.Repo.Migrations.CreateSnapshots do
  use Ecto.Migration
  use Mutiny, adapter: Mutiny.Adapters.Postgres

  def change do
    create table(:snapshots) do
      add :data, :map
      add :last_viewed, :utc_datetime
    end

    table(:snapshots)
    |> protect(:data)
    |> execute()
  end
end
```

You can also protect entire tables:

```elixir
protect(my_table)
```

Or allow protected columns to be set to `NULL`:

```elixir
protect(my_table, :data, nullable: true)
```

[Mutiny]: https://github.com/newaperio/mutiny
[full documentation]: https://hexdocs.pm/mutiny/api-reference.html
[Ecto]: https://github.com/elixir-ecto/ecto
[PostgreSQL]: https://www.postgresql.org/

## About NewAperio

Mutiny is built by NewAperio, LLC.

NewAperio is a web and mobile design and development studio. We offer [expert
Elixir and Phoenix][services] development as part of our portfolio of services.
[Get in touch][contact] to see how our team can help you.

[services]: https://newaperio.com/services#elixir?utm_source=github
[contact]: https://newaperio.com/contact?utm_source=github
