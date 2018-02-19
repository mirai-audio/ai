alias Ai.Repo
alias Ai.Media
alias Ai.User


random_username = "ai_test_" <> Integer.to_string(Enum.random(1111..9999))
first_user = Repo.insert!(%User{username: random_username})

Repo.insert!(%Media{
  user_id: first_user.id,
  title: "AKIRA - Kendas Theme",
  url: "https://www.youtube.com/watch?v=hpDvtIt6Lsc"
})

Repo.insert!(%Media{
  user_id: first_user.id,
  title: "Kenji Kawai - Innocence [LIVE]",
  url: "https://www.youtube.com/watch?v=LqGq2QgDQR8"
})
