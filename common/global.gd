extends Node

enum GamePlayer {LEFT, RIGHT}
enum GameMode {AI, MIRROR, VERSUS}

@warning_ignore("unused_signal")
signal mode_selected(mode: GameMode)
@warning_ignore("unused_signal")
signal game_started(mode: GameMode)
@warning_ignore("unused_signal")
signal goal_scored(player: GamePlayer)
