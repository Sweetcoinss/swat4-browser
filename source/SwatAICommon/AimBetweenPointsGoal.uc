class AimBetweenPointsGoal extends SwatWeaponGoal
	collapsecategories
	hidecategories(Object,InternalParameters);

var array<Vector> Points;

function int GetNumberOfPoints()
{
	return Points.Length;
	return;
}

function Vector GetPoint(int Index)
{
	assert(GreaterEqual_IntInt(Index, 0));
	assert(Less_IntInt(Index, GetNumberOfPoints()));
	return Points[Index];
	return;
}

function AddPoint(Vector Point)
{
	Points[Points.Length] = Point;
	return;
}

defaultproperties
{
	goalName="AimBetweenPoints"
}