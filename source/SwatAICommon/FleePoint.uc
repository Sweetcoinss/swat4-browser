class FleePoint extends PathNode
	config
	hidecategories(Karma,Lighting,LightColor,Karma,Force);

var bool ShouldCrouchAtPoint;
var private Pawn FleePointUser;

function ClaimPoint(Pawn NewFleePointUser)
{
	FleePointUser = NewFleePointUser;
	if(FleePointUser.logAI)
	{
		Log(Concat_StrStr(Concat_StrStr(string(FleePointUser.Name), " claimed "), string(Name)));
	}
	return;
}

function Pawn GetFleePointUser()
{
	if(Not_PreBool(Class'Engine.Pawn'.static.checkConscious(FleePointUser)))
	{
		FleePointUser = none;
	}
	return FleePointUser;
	return;
}

function UnclaimPoint()
{
	if(AndAnd_BoolBool(NotEqual_ObjectObject(FleePointUser, none), FleePointUser.logAI))
	{
		Log(Concat_StrStr(Concat_StrStr(string(FleePointUser.Name), " unclaimed "), string(Name)));
	}
	FleePointUser = none;
	return;
}

defaultproperties
{
	ShouldCrouchAtPoint=true
	bPropagatesSound=false
	Texture=Texture'SWAT4editorTex.FleePoint'
}