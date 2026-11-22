class Do_DisableTargetBombs extends Do_DisableTargetInanimates
	config(ObjectiveSpecs)
	perobjectconfig;

function OnTimeExpired()
{
	super(Objective).OnTimeExpired();
	Game.BombExploded();
	return;
}
