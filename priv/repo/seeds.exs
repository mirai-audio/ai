# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     Ai.Repo.insert!(%Ai.SomeModel{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.
alias Ai.Repo
alias Ai.Media

Repo.insert!(%Media{title: "AKIRA - Kendas ThemeCreate the Phoenix App", url: "https://www.youtube.com/watch?v=hpDvtIt6Lsc"})
Repo.insert!(%Media{title: "Kenji Kawai - Innocence [LIVE]", url: "https://www.youtube.com/watch?v=LqGq2QgDQR8"})
