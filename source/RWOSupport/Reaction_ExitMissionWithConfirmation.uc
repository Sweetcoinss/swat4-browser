class Reaction_ExitMissionWithConfirmation extends Reaction
	editinlinenew
	collapsecategories
	hidecategories(Object);

protected simulated function execute(Actor Owner, Actor Other)
{
	if(AndAnd_BoolBool(EqualEqual_IntInt(int(Owner.Level.NetMode), int(NM_Standalone)), NotEqual_ObjectObject(Owner.Level.GetLocalPlayerController(), none)))
	{
		Owner.Level.GetLocalPlayerController().OnMissionExitDoorUsed();
	}
	return;
}
