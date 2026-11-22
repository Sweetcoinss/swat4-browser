class TyrionResourcesTest extends TyrionUnitTest
	config
	placeable
	hidecategories(Karma);

var name pawnName;
var AI_CharacterResource characterResource;
var AI_MovementResource movementResource;
var AI_WeaponResource weaponResource;
var AI_Goal goal1;
var AI_Goal goal2;
var AI_Goal goal3;

state UnitTestState
{
	function BeginState()
	{
		workPawn = getPawn(string(pawnName));
		if(EqualEqual_ObjectObject(workPawn, none))
		{
			signalFailed(Concat_StrStr(Concat_StrStr("Failed to find Pawn named ", string(pawnName)), "."));
			return;
		}
		characterResource = AI_CharacterResource(workPawn.CharacterAI);
		movementResource = AI_MovementResource(workPawn.MovementAI);
		weaponResource = AI_WeaponResource(workPawn.WeaponAI);
		workController = AI_Controller(workPawn.Controller);
		if(EqualEqual_ObjectObject(workController, none))
		{
			signalFailed(Concat_StrStr(string(pawnName), " does not have an AI_Controller."));
			return;
		}
		characterResource.addAbility(Class'Tyrion.AI_TestCharacterD'.static.Allocate(self)., Construct_Void());
		characterResource.addAbility(Class'Tyrion.AI_TestCharacterE'.static.Allocate(self)., Construct_Void());
		movementResource.addAbility(Class'Tyrion.AI_TestMovementA'.static.Allocate(self)., Construct_Void());
		movementResource.addAbility(Class'Tyrion.AI_TestMovementB'.static.Allocate(self)., Construct_Void());
		weaponResource.addAbility(Class'Tyrion.AI_TestWeaponA'.static.Allocate(self)., Construct_Void());
		return;
	}
Begin:

	logTest("Tyrion Resources Test started");
	Log("1. Starting a character action (AI_TestCharacterD) that uses arms and legs");
	/* Statement decompilation error: Index was out of range. Must be non-negative and less than the size of the collection.
Parameter name: index

	*/

	/*@Error*/
	Sleep(3.0000000);
	Log("2. Posting a high priority goal for the legs");
	goal2 = Class'Tyrion.AI_TestMovementGoalA'.static.Allocate(self)..;
	default.sensors
	/* Statement decompilation error: Index was out of range. Must be non-negative and less than the size of the collection.
Parameter name: index

	*/

	/*@Error*/
	if(Not_PreBool(goal1.hasCompleted()))
	{
		Sleep(0.5000000);
		goto 'loop1';
		if(Not_PreBool(goal1.wasAchieved()))
		{
		}
		Log("   AI_TestCharacterD was 'unposted'");
		goal1.unPostGoal(none);
		Log("3. Starting another character action (AI_TestCharacterE) that uses only weapons");
	}
	/* Statement decompilation error: Index was out of range. Must be non-negative and less than the size of the collection.
Parameter name: index

	*/

	/*@Error*/
loop2:

	if(OrOr_BoolBool(Not_PreBool(goal2.hasCompleted()), Not_PreBool(goal3.hasCompleted())))
	{
		Sleep(1.0000000);
		goto 'loop2';
	}
	logTest("Tyrion Resources Test finished");
	if(AndAnd_BoolBool(AndAnd_BoolBool(Not_PreBool(goal1.wasAchieved()), goal2.wasAchieved()), goal3.wasAchieved()))
	{
		signalPassed();
	}
	else
	{
		signalFailed(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr(string(pawnName), " achieved "), string(goal1)), " or didn't achieve "), string(goal2)), " and "), string(goal3)));
	}
	stop;
	@NULL
	@NULL
	@NULL
	@NULL
	/* Statement decompilation error: Index was out of range. Must be non-negative and less than the size of the collection.
Parameter name: index

	*/

	/*@Error*/
}
