class HostageSpawner extends Spawner
	native
	config
	hidecategories(Karma);

var /*0x00000000-0x00080000*/ editinline PatrolList HostagePatrol;
var name IdleCategoryOverride;
var bool SpawnIncapacitated;
var Texture IncapacitatedTexture;

defaultproperties
{
	IncapacitatedTexture=Texture'EditorSprites.Spawner_Hostage_Incapacitated'
	ArchetypeClass=Class'SwatGame.HostageArchetype'
	ProfileArrayIndex=1
	SpawnerSprites[0]=Texture'EditorSprites.Spawner_Hostage'
	SpawnerSprites[1]=Texture'EditorSprites.Spawner_Hostage_Slave'
	SpawnerSprites[2]=Texture'EditorSprites.Spawner_Hostage_SlaveOnly'
	SpawnerSprites[3]=Texture'EditorSprites.Spawner_Hostage_Custom'
	Texture=Texture'EditorSprites.Spawner_Hostage'
}