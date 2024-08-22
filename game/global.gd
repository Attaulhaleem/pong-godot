extends Node

enum GameMode {AI, MIRROR, VERSUS}

@warning_ignore("unused_signal")
signal game_started(mode: GameMode)
