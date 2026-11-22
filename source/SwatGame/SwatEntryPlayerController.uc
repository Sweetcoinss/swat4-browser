class SwatEntryPlayerController extends SwatPlayerController
	config(SwatGame)
	hidecategories(Karma);

event PostBeginPlay()
{
	Log("[dkaplan]: In PostBeginPlay of SwatEntryPlayerController");
	super.PostBeginPlay();
	return;
}
