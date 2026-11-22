class ActionShakeCamera extends Action
	editinlinenew
	collapsecategories
	hidecategories(Object);

var float rollMagnitude "How far to roll the view";
var float RollRate "How fast to roll the view";
var float rollTime "How long to roll the view";
var /*0x00000000-0x00100000*/ Vector offsetMagnitude "How far to offset the view";
var /*0x00000000-0x00100000*/ Vector OffsetRate "How fast to offset the view";
var float OffsetTime "How long to offset the view";

latent function Variable execute()
{
	local PlayerController pcc;

	super.execute();
	pcc = parentScript.Level.GetLocalPlayerController();
	if(NotEqual_ObjectObject(pcc, none))
	{
		pcc.ShakeView(rollTime, rollMagnitude, offsetMagnitude, RollRate, OffsetRate, OffsetTime);
	}
	else
	{
		SLog("Couldn't get the players controller");
	}
	return none;
	return;
}

function editorDisplayString(out string S)
{
	S = "Shake the players view";
	return;
}

defaultproperties
{
	rollMagnitude=400.0000000
	RollRate=12000.0000000
	rollTime=25.0000000
	offsetMagnitude=(X=5.0000000,Y=0.0000000,Z=10.0000000)
	OffsetRate=(X=250.0000000,Y=250.0000000,Z=250.0000000)
	OffsetTime=10.0000000
	actionDisplayName="Shake Camera"
	actionHelp="Sakes the players view"
	category="AudioVisual"
}