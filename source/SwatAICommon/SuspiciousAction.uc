class SuspiciousAction extends SwatCharacterAction
	config(AI)
	collapsecategories
	hidecategories(Object,InternalParameters);

protected latent function CheckWeaponStatus()
{
	local FiredWeapon CurrentWeapon, BackupWeapon;

	if(NotEqual_ObjectObject(m_pawn.GetActiveItem(), none))
	{
		CurrentWeapon = FiredWeapon(m_pawn.GetActiveItem());
		BackupWeapon = ISwatEnemy(m_pawn).GetBackupWeapon();
		if(NotEqual_ObjectObject(CurrentWeapon, none))
		{
			if(AndAnd_BoolBool(CurrentWeapon.NeedsReload(), CurrentWeapon.CanReload()))
			{
				CurrentWeapon.LatentReload();
			}
			else
			{
				if(AndAnd_BoolBool(CurrentWeapon.IsEmpty(), NotEqual_ObjectObject(BackupWeapon, none)))
				{
					BackupWeapon.LatentEquip();
				}
			}
		}
	}
	return;
}
