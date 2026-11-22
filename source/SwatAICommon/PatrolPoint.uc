class PatrolPoint extends PathNode
	native
	config
	hidecategories(Karma,Lighting,LightColor,Karma,Force);

var array<SpawnerBase> ReferringSpawners;

defaultproperties
{
	bPropagatesSound=false
	Texture=Texture'SWAT4editorTex.EnemyPatrolPoint'
	bDirectional=true
}