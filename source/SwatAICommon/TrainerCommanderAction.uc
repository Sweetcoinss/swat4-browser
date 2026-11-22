class TrainerCommanderAction extends CommanderAction
	config(AI)
	collapsecategories
	hidecategories(Object,InternalParameters);

function float GetFlashbangedMoraleModification()
{
	return 0.0000000;
	return;
}

function float GetGassedMoraleModification()
{
	return 0.0000000;
	return;
}

function float GetPepperSprayedMoraleModification()
{
	return 0.0000000;
	return;
}

function float GetStungMoraleModification()
{
	return 0.0000000;
	return;
}

function float GetTasedMoraleModification()
{
	return 0.0000000;
	return;
}

function float GetStunnedByC2DetonationMoraleModification()
{
	return 0.0000000;
	return;
}

function bool ShouldRunWhenFlashBanged()
{
	return false;
	return;
}

function bool ShouldRunWhenGassed()
{
	return false;
	return;
}

function bool ShouldRunWhenPepperSprayed()
{
	return false;
	return;
}

function bool ShouldRunWhenStung()
{
	return false;
	return;
}

function bool ShouldRunWhenTased()
{
	return false;
	return;
}

function bool ShouldRunWhenStunnedByC2()
{
	return false;
	return;
}

protected function bool WillReactToGrenadeBeingThrown()
{
	return false;
	return;
}

defaultproperties
{
	bListeningForCompliance=false
}