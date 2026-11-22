class SwatCharacterResource extends AI_CharacterResource
	editinlinenew;

var ThreatenedSensorAction ThreatenedSensorAction;
var CommonSensorAction CommonSensorAction;
var CompliantSensorAction CompliantSensorAction;
var TargetSensorAction TargetSensorAction;
var DistanceSensorAction DistanceSensorAction;
var DistanceToOfficersSensorAction DistanceToOfficersSensorAction;
var DistanceToUncomplaintCharactersSensorAction DistanceToUncomplaintCharactersSensorAction;
var ArrestedSensorAction ArrestedSensorAction;
var DoorSideSensorAction DoorSideSensorAction;

event Init()
{
	super.Init();
	CommonSensorAction = CommonSensorAction(addSensorActionClass(Class'SwatAICommon.CommonSensorAction'));
	ThreatenedSensorAction = ThreatenedSensorAction(addSensorActionClass(Class'SwatAICommon.ThreatenedSensorAction'));
	CompliantSensorAction = CompliantSensorAction(addSensorActionClass(Class'SwatAICommon.CompliantSensorAction'));
	TargetSensorAction = TargetSensorAction(addSensorActionClass(Class'SwatAICommon.TargetSensorAction'));
	DistanceSensorAction = DistanceSensorAction(addSensorActionClass(Class'SwatAICommon.DistanceSensorAction'));
	DistanceToOfficersSensorAction = DistanceToOfficersSensorAction(addSensorActionClass(Class'SwatAICommon.DistanceToOfficersSensorAction'));
	DistanceToUncomplaintCharactersSensorAction = DistanceToUncomplaintCharactersSensorAction(addSensorActionClass(Class'SwatAICommon.DistanceToUncomplaintCharactersSensorAction'));
	ArrestedSensorAction = ArrestedSensorAction(addSensorActionClass(Class'SwatAICommon.ArrestedSensorAction'));
	DoorSideSensorAction = DoorSideSensorAction(addSensorActionClass(Class'SwatAICommon.DoorSideSensorAction'));
	return;
}

function cleanup()
{
	CommonSensorAction = none;
	ThreatenedSensorAction = none;
	CompliantSensorAction = none;
	TargetSensorAction = none;
	DistanceSensorAction = none;
	DistanceToOfficersSensorAction = none;
	DistanceToUncomplaintCharactersSensorAction = none;
	ArrestedSensorAction = none;
	DoorSideSensorAction = none;
	super.cleanup();
	return;
}
