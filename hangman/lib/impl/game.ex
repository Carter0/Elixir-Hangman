defmodule Hangman.Impl.Game do
  alias Hangman.Type

  @type t :: %__MODULE__{
          turns_left: integer(),
          game_state: Type.state(),
          letters: list(String.t()),
          used: MapSet.t(String.t())
        }

  defstruct(
    turns_left: 7,
    game_state: :initializing,
    letters: [],
    used: MapSet.new()
  )

  @spec new_game() :: t()
  def new_game do
    new_game(Dictionary.random_word())
  end

  @spec new_game(String.t()) :: t()
  def new_game(word) do
    %__MODULE__{
      letters: String.codepoints(word)
    }
  end

  @spec make_move(t(), String.t()) :: {t(), Type.tally()}
  def make_move(game = %{game_state: state}, _guess) when state in [:won, :lost] do
    return_with_tally(game)
  end

  def make_move(game, guess) do
    if validate_guess(guess) do
      game
      |> accept_guess(guess, MapSet.member?(game.used, guess))
      |> return_with_tally()
    else
      game = %{game | game_state: :invalid_guess}
      return_with_tally(game)
    end
  end

  def validate_guess(guess) do
    String.length(guess) == 1 and ascii?(guess)
  end

  def ascii?(string) do
    string
    |> String.to_charlist()
    |> Enum.all?(&(&1 in 0..127))
  end

  defp accept_guess(game, _guess, _already_used = true) do
    %{game | game_state: :already_used}
  end

  defp accept_guess(game, guess, _already_used) do
    new_game = %{game | used: MapSet.put(game.used, guess)}
    score_guess(new_game, Enum.member?(game.letters, guess))
  end

  defp score_guess(game, _good_guess = true) do
    new_state = maybe_won(MapSet.subset?(MapSet.new(game.letters), game.used))
    %{game | game_state: new_state}
  end

  defp score_guess(game = %{turns_left: 1}, _bad_guess) do
    %{game | game_state: :lost, turns_left: 0}
  end

  defp score_guess(game, _bad_guess) do
    %{game | game_state: :bad_guess, turns_left: game.turns_left - 1}
  end

  defp return_with_tally(game) do
    {game, tally(game)}
  end

  def tally(game) do
    %{
      turns_left: game.turns_left,
      game_state: game.game_state,
      letters: reveal_guessed_letters(game),
      used: game.used |> MapSet.to_list() |> Enum.sort()
    }
  end

  def reveal_guessed_letters(game = %{game_state: :lost}) do
    game.letters
  end

  def reveal_guessed_letters(game) do
    Enum.map(game.letters, fn letter ->
      already_used_letter? = MapSet.member?(game.used, letter)
      maybe_reveal(already_used_letter?, letter)
    end)
  end

  defp maybe_won(true), do: :won
  defp maybe_won(_), do: :good_guess

  defp maybe_reveal(true, letter), do: letter
  defp maybe_reveal(_, _letter), do: "_"
end
