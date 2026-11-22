class TyrionUnitTest extends Actor
	config
	placeable
	hidecategories(Karma);

const PASS_THRESHOLD_PROXIMITY = 100;

var string nextLevelURL;
var Pawn workPawn;
var AI_Controller workController;

function PostBeginPlay()
{
	super.PostBeginPlay();
	SetTimer(3.0000000, false);
	return;
}

event Timer()
{
	GotoState('UnitTestState');
	return;
}

function logTest(string Text)
{
	Log(Concat_StrStr("Unit Test: ", Text));
	return;
}

function signalPassed()
{
	Log("Test Passed");
	gotoNextLevel();
	return;
}

function signalFailed(string Reason)
{
	Log(Concat_StrStr("Test Failed: ", Reason));
	gotoNextLevel();
	return;
}

function gotoNextLevel()
{
	if(EqualEqual_StrStr(nextLevelURL, ""))
	{
		Log("Unit Test Chain Finished");
	}
	else
	{
		Level.ServerTravel(nextLevelURL, false);
	}
	return;
}

function Pawn getPawn(string pawnName)
{
	return Pawn(FindObject(pawnName, Class'Engine.Pawn', Level.Outer));
	return;
}

defaultproperties
{
	bHidden=true
	bNoDelete=true
	Texture=Texture'Engine_res.S_Trigger'
	bCollideWhenPlacing=true
	CollisionRadius=80.0000000
	CollisionHeight=100.0000000
}