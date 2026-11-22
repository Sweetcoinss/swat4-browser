class ActionBase extends Tyrion_ActionBase
	abstract
	native
	collapsecategories
	hidecategories(Object,InternalParameters);

enum ACT_ErrorCodes
{
	ACT_SUCCESS,                    // 0
	ACT_GENERAL_FAILURE,            // 1
	ACT_RESOURCE_INACTIVE,          // 2
	ACT_INTERRUPTED,                // 3
	ACT_CANT_FIND_PATH,             // 4
	ACT_IRREVERSIBLY_OFF_COURSE,    // 5
	ACT_TIME_LIMIT_EXCEEDED,        // 6
	ACT_INVALID_PARAMETERS,         // 7
	ACT_CANT_REACH_DESTINATION,     // 8
	ACT_ALL_RESOURCES_DIED,         // 9
	ACT_REQUIRED_RESOURCE_STOLEN,   // 10
	ACT_INSUFFICIENT_RESOURCES_AVAILABLE,// 11
	ACT_NO_COVER_FOUND,             // 12
	ACT_NO_LONGER_THREATENED,       // 13
	ACT_WILL_NOT_COMPLY,            // 14
	ACT_NO_WEAPONS_AVAILABLE,       // 15
	ACT_NOBODY_HAS_EQUIPMENT,       // 16
	ACT_TOO_CLOSE_TO_OFFICERS,      // 17
	ACT_DOOR_BLOCKED                // 18
};

var bool bIdle;
var bool bCompleted;
var bool bWasTicked;
var bool bDeleted;
var bool bSensorAction;

function cleanup()
{
	return;
}

function removeAction()
{
	return;
}

function removeGoal()
{
	return;
}

function bool IsIdle()
{
	return bIdle;
	return;
}

function bool IsRunning()
{
	return Not_PreBool(bIdle);
	return;
}

function bool hasCompleted()
{
	return bCompleted;
	return;
}

function bool wasTicked()
{
	return bWasTicked;
	return;
}

function pauseAction()
{
	return;
}

event runAction()
{
	return;
}

function PawnDied(Pawn Pawn)
{
	return;
}

event instantFail(ActionBase.ACT_ErrorCodes errorCode, optional bool bRemoveGoal)
{
	removeAction();
	return;
}

latent function yield()
{
	Sleep(0.0000000);
	return;
}

latent function Pause()
{
	pauseAction();
	yield();
	return;
}

latent function sleepForever()
{
	J0x00:
	if(true)
	{
		Pause();
		// [Loop Continue]
		goto J0x00;
	}
	return;
}

defaultproperties
{
	bIdle=true
}