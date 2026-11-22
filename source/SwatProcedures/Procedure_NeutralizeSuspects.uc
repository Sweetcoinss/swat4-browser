class Procedure_NeutralizeSuspects extends Procedure implements IInterested_GameEvent_GameStarted
	abstract
	config(Leadership);

var config int TotalBonus;
var config float PerEnemyBonusFraction;
var int TotalEnemies;
var float BonusPerEnemy;
var array<SwatEnemy> NeutralizedEnemies;

function PostInitHook()
{
	super.PostInitHook();
	GetGame().GameEvents.GameStarted.Register(self);
	return;
}

function OnGameStarted()
{
	local SwatEnemy Enemy;

	foreach GetGame().DynamicActors(Class'SwatGame.SwatEnemy', Enemy)
	{
		AddAdd_Int(TotalEnemies);
	}
	BonusPerEnemy = Multiply_FloatFloat(Divide_FloatFloat(float(TotalBonus), float(TotalEnemies)), PerEnemyBonusFraction);
	if(GetGame().DebugLeadership)
	{
		Log(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr("[LEADERSHIP] ", string(Class.Name)), " calculated BonusPerEnemy = ( float(TotalBonus) / float(TotalEnemies) ) * PerEnemyBonusFraction\n"), "                          = ( "), string(TotalBonus)), " / "), string(TotalEnemies)), " ) * "), string(PerEnemyBonusFraction)), "\n"), "                          = "), string(BonusPerEnemy)));
	}
	return;
}

function string Status()
{
	return Concat_StrStr(Concat_StrStr(string(NeutralizedEnemies.Length), "/"), string(TotalEnemies));
	return;
}

function int GetCurrentValue()
{
	if(GetGame().DebugLeadershipStatus)
	{
		Log(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr("[LEADERSHIP] ", string(Class.Name)), " is returning CurrentValue = BonusPerEnemy * NeutralizedEnemies.length\n"), "                           = "), string(BonusPerEnemy)), " * "), string(NeutralizedEnemies.Length)), "\n"), "                           = "), string(Multiply_FloatFloat(BonusPerEnemy, float(NeutralizedEnemies.Length)))), "\n"), "         AdditionalBonus() = "), string(AdditionalBonus())));
	}
	return Add_IntInt(int(Multiply_FloatFloat(BonusPerEnemy, float(NeutralizedEnemies.Length))), AdditionalBonus());
	return;
}

function int AdditionalBonus()
{
	return 0;
	return;
}
