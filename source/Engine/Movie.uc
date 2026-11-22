class Movie extends Object
	native
	noexport;

var const transient int FMovie;

// Export UMovie::execPlay(FFrame&, void* const)
native final function Play(string MovieFilename, bool UseSound, bool LoopMovie);

// Export UMovie::execPause(FFrame&, void* const)
native final function Pause(bool Pause);

// Export UMovie::execIsPaused(FFrame&, void* const)
native final function bool IsPaused();

// Export UMovie::execStopNow(FFrame&, void* const)
native final function StopNow();

// Export UMovie::execStopAtEnd(FFrame&, void* const)
native final function StopAtEnd();

// Export UMovie::execIsPlaying(FFrame&, void* const)
native final function bool IsPlaying();

// Export UMovie::execGetWidth(FFrame&, void* const)
native final function int GetWidth();

// Export UMovie::execGetHeight(FFrame&, void* const)
native final function int GetHeight();
