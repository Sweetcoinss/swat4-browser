interface ISwatEnemy implements ISwatAICharacter
	native
	parseconfig;

enum EnemySkill
{
	EnemySkill_Low,                 // 0
	EnemySkill_Medium,              // 1
	EnemySkill_High                 // 2
};

enum EnemyState
{
	EnemyState_Unaware,             // 0
	EnemyState_Suspicious,          // 1
	EnemyState_Aware                // 2
};

function bool IsAnInvestigator()
{
	return;
}

function ISwatEnemy.EnemyState GetCurrentState()
{
	return;
}

function SetCurrentState(ISwatEnemy.EnemyState NewState)
{
	return;
}

function BecomeAware()
{
	return;
}

function ISwatEnemy.EnemySkill GetEnemySkill()
{
	return;
}

function StartSprinting()
{
	return;
}

function StopSprinting()
{
	return;
}

function EnemyCommanderAction GetEnemyCommanderAction()
{
	return;
}

function EnemySpeechManagerAction GetEnemySpeechManagerAction()
{
	return;
}

function bool IsAThreat()
{
	return;
}

function BecomeAThreat()
{
	return;
}

function FiredWeapon GetPrimaryWeapon()
{
	return;
}

function FiredWeapon GetBackupWeapon()
{
	return;
}

function DropAllWeapons(optional Vector WeaponSpaceDropDirection, optional float DropImpulseMagnitude)
{
	return;
}

function ThrowWeaponDown()
{
	return;
}

function name SpawnedFromGroup()
{
	return;
}
