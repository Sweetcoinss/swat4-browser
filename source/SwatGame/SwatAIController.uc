class SwatAIController extends AI_Controller
	native
	config
	hidecategories(Karma);

event OnHearSound(Actor SoundMaker, Vector SoundOrigin, name SoundCategory)
{
	if(NotEqual_ObjectObject(SwatAI(Pawn).Hearing, none))
	{
		SwatAI(Pawn).Hearing.OnHearSound(SoundMaker, SoundOrigin, SoundCategory);
	}
	return;
}
