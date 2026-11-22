class MaterialTrigger extends Triggers
	config
	placeable
	hidecategories(Karma);

var array<Material> MaterialsToTrigger;

function PostBeginPlay()
{
	local int i;

	i = 0;
	J0x07:

	if(Less_IntInt(i, MaterialsToTrigger.Length))
	{
		if(NotEqual_ObjectObject(MaterialsToTrigger[i], none))
		{
			MaterialsToTrigger[i].Reset();
		}
		AddAdd_Int(i);
		// [Loop Continue]
		goto J0x07;
	}
	return;
}

function Trigger(Actor Other, Pawn EventInstigator)
{
	local int i;

	if(EqualEqual_ObjectObject(Other, none))
	{
		Other = self;
	}
	i = 0;
	J0x19:

	if(Less_IntInt(i, MaterialsToTrigger.Length))
	{
		if(NotEqual_ObjectObject(MaterialsToTrigger[i], none))
		{
			MaterialsToTrigger[i].Trigger(Other, EventInstigator);
		}
		AddAdd_Int(i);
		// [Loop Continue]
		goto J0x19;
	}
	return;
}

defaultproperties
{
	Texture=Texture'Engine_res.S_MaterialTrigger'
	bCollideActors=false
}