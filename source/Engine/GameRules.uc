class GameRules extends Info
	config
	notplaceable
	hidecategories(Karma,Movement,Collision,Lighting,LightColor,Karma,Force);

var GameRules NextGameRules;

function AddGameRules(GameRules GR)
{
	if(EqualEqual_ObjectObject(NextGameRules, none))
	{
		NextGameRules = GR;
	}
	else
	{
		NextGameRules.AddGameRules(GR);
	}
	return;
}

function NavigationPoint FindPlayerStart(Controller Player, optional byte InTeam, optional string incomingName)
{
	if(NotEqual_ObjectObject(NextGameRules, none))
	{
		return NextGameRules.FindPlayerStart(Player, InTeam, incomingName);
	}
	return none;
	return;
}

function string GetRules()
{
	local string ResultSet;

	if(EqualEqual_ObjectObject(NextGameRules, none))
	{
		ResultSet = Concat_StrStr(ResultSet, NextGameRules.GetRules());
	}
	return ResultSet;
	return;
}

function GetServerDetails(out ServerResponseLine ServerState)
{
	return;
}

function bool HandleRestartGame()
{
	if(AndAnd_BoolBool(NotEqual_ObjectObject(NextGameRules, none), NextGameRules.HandleRestartGame()))
	{
		return true;
	}
	return false;
	return;
}

function bool CheckEndGame(PlayerReplicationInfo Winner, string Reason)
{
	if(NotEqual_ObjectObject(NextGameRules, none))
	{
		return NextGameRules.CheckEndGame(Winner, Reason);
	}
	return true;
	return;
}

function bool CheckScore(PlayerReplicationInfo Scorer)
{
	if(NotEqual_ObjectObject(NextGameRules, none))
	{
		return NextGameRules.CheckScore(Scorer);
	}
	return false;
	return;
}

function bool PreventDeath(Pawn Killed, Controller Killer, Class<DamageType> DamageType, Vector HitLocation)
{
	if(AndAnd_BoolBool(NotEqual_ObjectObject(NextGameRules, none), NextGameRules.PreventDeath(Killed, Killer, DamageType, HitLocation)))
	{
		return true;
	}
	return false;
	return;
}

function bool PreventSever(Pawn Killed, name BoneName, int Damage, Class<DamageType> DamageType)
{
	if(AndAnd_BoolBool(NotEqual_ObjectObject(NextGameRules, none), NextGameRules.PreventSever(Killed, BoneName, Damage, DamageType)))
	{
		return true;
	}
	return false;
	return;
}

function ScoreObjective(PlayerReplicationInfo Scorer, int Score)
{
	if(NotEqual_ObjectObject(NextGameRules, none))
	{
		NextGameRules.ScoreObjective(Scorer, Score);
	}
	return;
}

function ScoreKill(Controller Killer, Controller Killed)
{
	if(NotEqual_ObjectObject(NextGameRules, none))
	{
		NextGameRules.ScoreKill(Killer, Killed);
	}
	return;
}

function bool CriticalPlayer(Controller Other)
{
	if(AndAnd_BoolBool(NotEqual_ObjectObject(NextGameRules, none), NextGameRules.CriticalPlayer(Other)))
	{
		return true;
	}
	return false;
	return;
}

function int NetDamage(int OriginalDamage, int Damage, Pawn injured, Pawn InstigatedBy, Vector HitLocation, out Vector Momentum, Class<DamageType> DamageType)
{
	if(NotEqual_ObjectObject(NextGameRules, none))
	{
		return NextGameRules.NetDamage(OriginalDamage, Damage, injured, InstigatedBy, HitLocation, Momentum, DamageType);
	}
	return Damage;
	return;
}
