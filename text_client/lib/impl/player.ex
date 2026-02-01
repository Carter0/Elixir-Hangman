defmodule TextClient.Impl.Player do
  @typep game :: Hangman.game()
  @typep tally :: Hangman.tally()
  @typep state :: {game, tally}

  @spec start(game) :: :ok
  def start(game) do
    tally = Hangman.tally(game)
    interact({game, tally})
  end

  # :initializing | :won | :lost | :good_guess | :bad_guess | :already_used | :invalid_guess
  @spec interact(state) :: :ok
  def interact({_game, _tally = %{game_state: :won}}) do
    IO.puts("Congratulations. You Won!")
  end

  def interact({_game, tally = %{game_state: :lost}}) do
    IO.puts("Sorry, you lost... the word was #{Enum.join(tally.letters)}")
  end

  def interact({game, tally}) do
    IO.puts(feedback_for(tally))
    IO.puts(current_word(tally))
    guess = get_guess()
    updated_tally = Hangman.make_move(game, guess)
    interact({game, updated_tally})
  end

  def feedback_for(tally = %{game_state: :initializing}) do
    "Welcome! I'm thinking of a #{length(tally.letters)} letter word"
  end

  def feedback_for(_tally = %{game_state: :good_guess}), do: "Good guess!"

  def feedback_for(_tally = %{game_state: :bad_guess}),
    do: "Sorry, that letter is not in the word"

  def feedback_for(_tally = %{game_state: :invalid_guess}),
    do: "Input a valid character"

  def feedback_for(_tally = %{game_state: :already_used}), do: "You already used that letter"

  def current_word(tally) do
    [
      "Word so far: ",
      IO.ANSI.format([:green, :bright, Enum.join(tally.letters, " ")]),
      "   turns left: ",
      IO.ANSI.format([:yellow, :bright, to_string(tally.turns_left)]),
      "   used so far: ",
      IO.ANSI.format([:red, :bright, Enum.join(tally.used, ",")])
    ]
  end

  def get_guess() do
    IO.gets("Next letter: ")
    |> String.trim()
    |> String.downcase()
  end
end
