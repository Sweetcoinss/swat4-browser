class PawnDoorKnowledge extends Object
	native;

cpptext
{
	UBOOL DoesBelieveDoorLocked() { return bBelievesDoorLocked; }
	UBOOL DoesBelieveDoorWedged() { return bBelievesDoorWedged; }

}

var private bool bBelievesDoorLocked;
var private bool bBelievesDoorWedged;

// Export UPawnDoorKnowledge::execDoesBelieveDoorLocked(FFrame&, void* const)
native function bool DoesBelieveDoorLocked();

// Export UPawnDoorKnowledge::execDoesBelieveDoorWedged(FFrame&, void* const)
native function bool DoesBelieveDoorWedged();

function SetBelievesDoorLocked(bool bInBelievesDoorLocked)
{
	bBelievesDoorLocked = bInBelievesDoorLocked;
	return;
}

function SetBelievesDoorWedged(bool bInBelievesDoorWedged)
{
	bBelievesDoorWedged = bInBelievesDoorWedged;
	return;
}
