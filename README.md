<p align="center"><img alt="Mutiny wordmark with red crossed-out circle" src="logo.png" width="400" height="113" /></p>
<p align="center">
  <a href="https://github.com/newaperio/mutiny/actions?query=workflow%3ACI">
    <img alt="CI badge" src="https://github.com/newaperio/mutiny/workflows/CI/badge.svg" />
  </a>
</p>

---

# Mutiny

Need database-level assurance that certain records are immutable—that is to
say, unable to be `UPDATE`d once `INSERT`ed? Mutiny is glad to oblige.

## Installation

Mutiny is available on [Hex][hex] and can be installed by
adding `mutiny` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:mutiny, "~> 0.1.0"}
  ]
end
```

## Usage

Check the [documentation][hex] for full details.

Mutiny generates SQL commands for you and is designed to be used in conjunction
with [Ecto SQL][ecto] migrations.

First off, you'll want to create the database function that Mutiny calls.
Mutiny can generate a migration for you that will do just that:

```sh
mix mutiny.gen.migration postgres
mix ecto.migrate
```

If you'd rather write the migration yourself, take a look at
`Mutiny.create_prevent_update_function/0` and
`Mutiny.drop_prevent_update_function/0`.

Now you're ready to `use` Mutiny in your migrations:

```elixir
defmodule MyApp.Repo.Migrations.CreateSnapshots do
  use Ecto.Migration
  use Mutiny, adapter: Mutiny.Adapters.Postgres

  def change do
    create table("snapshots") do
      add :data, :map
      add :last_viewed, :utc_datetime
    end

    table("snapshots")
    |> protect(:data)
    |> execute()
  end
end
```

## Contributing

Contributions are welcome! To make changes, clone the repo, make sure tests
pass, and then open a PR on GitHub.

```sh
git clone https://github.com/newaperio/mutiny.git
cd mutiny
mix deps.get
mix test
```

Please note that this project is released with a [Contributor Code of
Conduct][coc]. By participating in this project you agree to abide by its
terms.

## License

Mutiny is Copyright © 2020 NewAperio. It is free software, and may be
redistributed under the terms specified in the [LICENSE][license] file.

## About NewAperio

Mutiny is built by NewAperio, LLC.

NewAperio is a web and mobile design and development studio. We offer [expert
Elixir and Phoenix][services] development as part of our portfolio of services.
[Get in touch][contact] to see how our team can help you.


[hex]: https://hexdocs.pm/mutiny
[ecto]: https://hex.pm/ecto_sql
[coc]: https://github.com/newaperio/mutiny/blob/master/CODE_OF_CONDUCT.md
[license]: https://github.com/newaperio/mutiny/blob/master/LICENSE
[services]: https://newaperio.com/services#elixir?utm_source=github
[contact]: https://newaperio.com/contact?utm_source=github
