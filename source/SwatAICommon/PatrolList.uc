class PatrolList extends Object
	native
	editinlinenew;

struct native PatrolEntry
{
	var() name PatrolPointName;
	var() Range IdleTime;
	var() int IdleChance;
	var() name IdleCategory;
	var PatrolPoint PatrolPoint;
};

var editinline array<editinline PatrolEntry> PatrolEntries;
var array<Vector> PatrolPathLocations;

function PatrolEntry GetPatrolEntry(int PatrolEntryIndex)
{
	assert(GreaterEqual_IntInt(PatrolEntryIndex, 0));
	assert(Less_IntInt(PatrolEntryIndex, PatrolEntries.Length));
	return PatrolEntries[PatrolEntryIndex];
	return;
}

function int GetNumPatrolEntries()
{
	return PatrolEntries.Length;
	return;
}
