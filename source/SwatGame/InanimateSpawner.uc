class InanimateSpawner extends Spawner
	config
	hidecategories(Karma);

function ValidateSpawningFromLocalProperties(bool bTesting)
{
	return;
}

defaultproperties
{
	ArchetypeClass=Class'SwatGame.InanimateArchetype'
	ProfileArrayIndex=2
	SpawnerSprites[0]=Texture'EditorSprites.Spawner_Inanimate'
	SpawnerSprites[1]=Texture'EditorSprites.Spawner_Inanimate_Slave'
	SpawnerSprites[2]=Texture'EditorSprites.Spawner_Inanimate_SlaveOnly'
	SpawnerSprites[3]=Texture'EditorSprites.Spawner_Inanimate_Custom'
	Texture=Texture'EditorSprites.Spawner_Inanimate'
}