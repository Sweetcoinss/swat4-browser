class ReloadAction extends SwatWeaponAction
	collapsecategories
	hidecategories(Object,InternalParameters);

function float selectionHeuristic(AI_Goal Goal)
{
	local FiredWeapon CurrentWeapon;

	CurrentWeapon = FiredWeapon(Goal.resource.Pawn().GetActiveItem());
	if(NotEqual_ObjectObject(CurrentWeapon, none))
	{
		if(AndAnd_BoolBool(CurrentWeapon.NeedsReload(), CurrentWeapon.CanReload()))
		{
			return 1.0000000;
		}
	}
	return 0.0000000;
	return;
}

latent function ReloadWeapon()
{
	local FiredWeapon CurrentWeapon;

	CurrentWeapon = FiredWeapon(m_pawn.GetActiveItem());
	CurrentWeapon.LatentReload();
	return;
}

state Running
{Begin:

	ReloadWeapon();
	succeed();
	stop;
}

defaultproperties
{
	satisfiesGoal=Class'SwatAICommon.ReloadGoal'
}