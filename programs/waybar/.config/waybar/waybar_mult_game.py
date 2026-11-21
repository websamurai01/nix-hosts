#!/usr/bin/env python3
import json
import os
import random
from pathlib import Path

# State file in XDG cache
STATE_DIR = Path(os.getenv("XDG_CACHE_HOME", Path.home() / ".cache")) / "waybar-mult-game"
STATE_FILE = STATE_DIR / "state.json"


def ensure_state_dir():
    STATE_DIR.mkdir(parents=True, exist_ok=True)


def load_state():
    ensure_state_dir()
    if not STATE_FILE.exists():
        return None
    try:
        with STATE_FILE.open("r", encoding="utf-8") as f:
            return json.load(f)
    except Exception:
        return None


def save_state(state):
    ensure_state_dir()
    with STATE_FILE.open("w", encoding="utf-8") as f:
        json.dump(state, f)


def new_question():
    a = random.randint(10, 99)
    b = random.randint(10, 99)
    return {
        "a": a,
        "b": b,
        "answer": a * b,
        "streak": 0,
        "total": 0,
        "correct": 0,
        "input": "",
        "feedback": None,  # "correct" | "wrong" | "error"
    }


def get_or_init_state():
    state = load_state()
    if not state or "a" not in state or "b" not in state or "answer" not in state:
        state = new_question()
        save_state(state)
    # Ensure new keys exist after upgrades
    state.setdefault("streak", 0)
    state.setdefault("total", 0)
    state.setdefault("correct", 0)
    state.setdefault("input", "")
    state.setdefault("feedback", None)
    return state


def reset_for_next_question(state):
    """Generate a new question keeping stats."""
    a = random.randint(10, 99)
    b = random.randint(10, 99)
    state.update(
        {
            "a": a,
            "b": b,
            "answer": a * b,
            "input": "",
            "feedback": None,
        }
    )
    return state


def handle_input_char(state, ch):
    """Append a digit, backspace, or ignore."""
    if ch == "BACKSPACE":
        state["input"] = state["input"][:-1]
    elif ch.isdigit():
        # Limit length to avoid overflow spam
        if len(state["input"]) < 6:
            state["input"] += ch
    return state


def handle_submit(state):
    """Check current input against answer and update stats/state."""
    user_input = state.get("input", "").strip()
    if not user_input:
        # Nothing entered; treat as no-op
        state["feedback"] = None
        return state

    try:
        guess = int(user_input)
    except ValueError:
        # Non-numeric -> wrong
        state["feedback"] = "wrong"
        state["streak"] = 0
        state["total"] += 1
        # Keep same question so user can see mistake
        return state

    state["total"] += 1
    if guess == state["answer"]:
        state["feedback"] = "correct"
        state["correct"] += 1
        state["streak"] += 1
        # After correct answer, immediately move to next question
        reset_for_next_question(state)
    else:
        state["feedback"] = "wrong"
        state["streak"] = 0
        # Keep same question to let them try again
        # Optionally clear input:
        state["input"] = ""

    return state


def output_state():
    """
    Waybar JSON:
    - text: "a×b=[input]_✓/✗"
    - alt: feedback state
    - tooltip: stats and instructions
    - actions:
        - "mult_game_digit_0".."mult_game_digit_9": append digit
        - "mult_game_backspace": delete last char
        - "mult_game_submit": check answer
    """
    state = get_or_init_state()

    a = state["a"]
    b = state["b"]
    inp = state.get("input", "")
    feedback = state.get("feedback")

    # Build main text: question + input
    if inp:
        text = f"{a}×{b}={inp}"
    else:
        text = f"{a}×{b}="

    # Add compact feedback symbol (non-flickery: only when meaningful)
    alt = "idle"
    if feedback == "correct":
        alt = "correct"
    elif feedback == "wrong":
        alt = "wrong"

    # Tooltip with stats and controls
    streak = int(state.get("streak", 0))
    total = int(state.get("total", 0))
    correct = int(state.get("correct", 0))

    tooltip_lines = [
        f"Q: {a} × {b}",
        f"Your input: {inp or '(empty)'}",
        f"Streak: {streak}",
        f"Score: {correct}/{total}" if total > 0 else "Score: 0/0",
        "",
        "Controls:",
        "- Bind Waybar actions to:",
        "  mult_game_digit_0..9: type digit",
        "  mult_game_backspace: delete last digit",
        "  mult_game_submit: submit answer",
    ]
    tooltip = "\n".join(tooltip_lines)

    out = {
        "text": text,
        "tooltip": tooltip,
        "alt": alt,
        "class": "mult-game",
    }
    print(json.dumps(out))


def main():
    """
    This script is designed for Waybar's `on-click`/`on-click-right` etc. actions
    via `exec` with environment variable WAYBAR_ACTION (Waybar >= 0.10.0 supports actions).

    Expected integration:

    - "custom/mult-game": {
        "exec": "~/.config/waybar/waybar_mult_game.py",
        "return-type": "json",
        "interval": 1,
        "on-click": "~/.config/waybar/waybar_mult_game.py mult_game_submit",
        "on-click-right": "~/.config/waybar/waybar_mult_game.py mult_game_backspace",
        "on-scroll-up": "~/.config/waybar/waybar_mult_game.py mult_game_digit_1",
        "on-scroll-down": "~/.config/waybar/waybar_mult_game.py mult_game_digit_2",
        "format": "{}"
      }

    But to keep it flexible, we read the first CLI arg as action:
      - mult_game_digit_0..9
      - mult_game_backspace
      - mult_game_submit
    """
    state = get_or_init_state()

    action = None
    if len(os.sys.argv) > 1:
        action = os.sys.argv[1].strip()

    if action:
        if action.startswith("mult_game_digit_"):
            d = action.split("_")[-1]
            if d.isdigit() and len(d) == 1:
                state = handle_input_char(state, d)
        elif action == "mult_game_backspace":
            state = handle_input_char(state, "BACKSPACE")
        elif action == "mult_game_submit":
            state = handle_submit(state)
        # Save any state changes from actions
        save_state(state)

    # Always output current view
    output_state()


if __name__ == "__main__":
    main()
