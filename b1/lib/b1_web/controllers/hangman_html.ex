defmodule B1Web.HangmanHTML do
  use B1Web, :html

  embed_templates("hangman_html/*")

  def continue_or_try_again(assigns) when assigns in [:won, :lost] do
    ~H(
        <.form for={%{}} method="get" action={~p"/hangman"}>
            <.button>Make a new game</.button>
        </.form>
      )
  end

  def continue_or_try_again(assigns) do
    ~H(
      <.form for={%{}} as={:make_move} method="put" action={~p"/hangman"} :let={f}>
          <.input field={f[:guess]} type="text" label="Guess" />
          <.button>Make next guess</.button>
      </.form>
    )
  end

  def move_status(:initializing) do
    "Initializing the game"
  end

  def move_status(:won) do
    "You Win!"
  end

  def move_status(:lost) do
    "You Lost :("
  end

  def move_status(:good_guess) do
    "You guessed a letter!"
  end

  def move_status(:bad_guess) do
    "Nope, not that letter!"
  end

  def move_status(:already_used) do
    "You already guessed that!"
  end

  def move_status(:invalid_guess) do
    "You can't guess that!"
  end

  def figure_for(0) do
    ~s{
      ┌───┐
      │   │
      O   │
     /|\\  │
     / \\  │
          │
    ══════╧══
    }
  end

  def figure_for(1) do
    ~s{
      ┌───┐
      │   │
      O   │
     /|\\  │
     /    │
          │
    ══════╧══
    }
  end

  def figure_for(2) do
    ~s{
    ┌───┐
    │   │
    O   │
   /|\\  │
        │
        │
  ══════╧══
}
  end

  def figure_for(3) do
    ~s{
    ┌───┐
    │   │
    O   │
   /|   │
        │
        │
  ══════╧══
}
  end

  def figure_for(4) do
    ~s{
    ┌───┐
    │   │
    O   │
    |   │
        │
        │
  ══════╧══
}
  end

  def figure_for(5) do
    ~s{
    ┌───┐
    │   │
    O   │
        │
        │
        │
  ══════╧══
}
  end

  def figure_for(6) do
    ~s{
    ┌───┐
    │   │
        │
        │
        │
        │
  ══════╧══
}
  end

  def figure_for(7) do
    ~s{
    ┌───┐
        │
        │
        │
        │
        │
  ══════╧══
}
  end
end
