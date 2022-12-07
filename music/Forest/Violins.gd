extends MusicTrack

func volume(_n):
	return 0.0 if enemy_count("") >= 5 else -99.0
