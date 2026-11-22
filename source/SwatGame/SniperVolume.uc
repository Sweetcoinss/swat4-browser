class SniperVolume extends HighGroundVolume
	config(HighGround)
	hidecategories(Karma,Events,Force,Karma,LightColor,Lighting,Sound,Object);

var name AssociatedSniperTag "The tag of the sniper pawn that is linked with this volume";
var SniperPawn AssociatedSniper;
var bool bAlreadyPlayedEntryTeam;

function PostBeginPlay()
{
	local SniperPawn Sniper;

	super.PostBeginPlay();
	foreach DynamicActors(Class'SwatGame.SniperPawn', Sniper, AssociatedSniperTag)
	{
		AssociatedSniper = Sniper;
		AssociatedSniper.SniperName = string(RoomName);
		break;
	}
	return;
}

function bool ShouldRejectCondition(HighGroundCondition inCondition)
{
	if(NotEqual_IntInt(int(Level.NetMode), int(NM_Standalone)))
	{
		return true;
	}
	if(OrOr_BoolBool(EqualEqual_NameName(inCondition.Subject, 'SwatPlayer'), EqualEqual_NameName(inCondition.Subject, 'SwatOfficer')))
	{
		if(bAlreadyPlayedEntryTeam)
		{
			return true;
		}
		bAlreadyPlayedEntryTeam = true;
	}
	return false;
	return;
}

function OnConditionPlayed()
{
	if(AndAnd_BoolBool(AndAnd_BoolBool(AndAnd_BoolBool(AndAnd_BoolBool(NotEqual_ObjectObject(Level.GetLocalPlayerController(), none), Level.GetLocalPlayerController().IsA('SwatGamePlayerController')), NotEqual_NameName(PlayingCondition.Subject, 'SwatPlayer')), NotEqual_NameName(PlayingCondition.Subject, 'SwatOfficer')), NotEqual_NameName(PlayingCondition.Action, 'Left')))
	{
		SwatGamePlayerController(Level.GetLocalPlayerController()).OnSniperAlerted(AssociatedSniper);
	}
	return;
}
