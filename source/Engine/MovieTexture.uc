class MovieTexture extends Texture
	native
	safereplace
	hidecategories(Object);

var const transient Movie Movie;
var string MovieFilename;
var int FrameRate;

// Export UMovieTexture::execInitializeMovie(FFrame&, void* const)
native final function InitializeMovie();

defaultproperties
{
	FrameRate=30
}