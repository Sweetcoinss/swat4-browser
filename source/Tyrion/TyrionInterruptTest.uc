class TyrionInterruptTest extends TyrionUnitTest
	config
	placeable
	hidecategories(Karma);

var name pawnName;
var AI_CharacterResource characterResource;
var AI_MovementResource movementResource;
var AI_WeaponResource weaponResource;
var AI_Goal goal1;
var AI_Goal goal2;

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
		characterResource.addAbility(Class'Tyrion.AI_TestCharacterA'.static.Allocate(self)., Construct_Void());
		characterResource.addAbility(Class'Tyrion.AI_TestCharacterB'.static.Allocate(self)., Construct_Void());
		characterResource.addAbility(Class'Tyrion.AI_TestCharacterC'.static.Allocate(self)., Construct_Void());
		movementResource.addAbility(Class'Tyrion.AI_TestMovementA'.static.Allocate(self)., Construct_Void());
		movementResource.addAbility(Class'Tyrion.AI_TestMovementB'.static.Allocate(self)., Construct_Void());
		weaponResource.addAbility(Class'Tyrion.AI_TestWeaponA'.static.Allocate(self)., Construct_Void());
		return;
	}
Begin:

	logTest("Tyrion Interrupt Test started");
	logTest("First pass: no interruptions");
	goal1 = Class'Tyrion.AI_TestCharacterGoalA'.static.Allocate(self)..characterResource;
	50
	7
	/* Statement decompilation error: Index was out of range. Must be non-negative and less than the size of the collection.
Parameter name: index

	*/

	/*@Error*/
	if(Not_PreBool(goal1.hasCompleted()))
	{
		Sleep(1.0000000);
		goto 'Loop';
		logTest("Second pass: unPost goal after 11 seconds.");
	}
	goal2 = Class'Tyrion.AI_TestCharacterGoalA'.static.Allocate(self)..characterResource;
	50
	7
	/* Statement decompilation error: Index was out of range. Must be non-negative and less than the size of the collection.
Parameter name: index

	*/

	/*@Error*/
	Sleep(11.0000000);
	goal2.unPostGoal(none);
	logTest("Tyrion Interrupt Test finished");
	if(AndAnd_BoolBool(goal1.wasAchieved(), Not_PreBool(goal2.wasAchieved())))
	{
		signalPassed();
		goto J0x1BA;
		signalFailed(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr(string(pawnName), " didn't achieve "), string(goal1)), " or achieved "), string(goal2)));
	}
	stop;
	@NULL
}
