class Modifier extends Material
	abstract
	native
	editinlinenew
	collapsecategories
	hidecategories(Object,Material);

var editinlineuse Material Material;

function Reset()
{
	if(NotEqual_ObjectObject(Material, none))
	{
		Material.Reset();
	}
	if(NotEqual_ObjectObject(FallbackMaterial, none))
	{
		FallbackMaterial.Reset();
	}
	return;
}

function Trigger(Actor Other, Actor EventInstigator)
{
	if(NotEqual_ObjectObject(Material, none))
	{
		Material.Trigger(Other, EventInstigator);
	}
	if(NotEqual_ObjectObject(FallbackMaterial, none))
	{
		FallbackMaterial.Trigger(Other, EventInstigator);
	}
	return;
}

defaultproperties
{
	MaterialType=5
}