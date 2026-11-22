class MaterialSwitch extends Modifier
	native
	editinlinenew
	collapsecategories
	hidecategories(Object,Material,Modifier);

cpptext
{
	virtual void PostEditChange();
	virtual UBOOL CheckCircularReferences( TArray<class UMaterial*>& History );

}

var transient int Current;
var editinlineuse array<editinlineuse Material> Materials;

function Reset()
{
	Current = 0;
	if(Greater_IntInt(Materials.Length, 0))
	{
		Material = Materials[0];
	}
	else
	{
		Material = none;
	}
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

function bool Set(int Index)
{
	if(AndAnd_BoolBool(GreaterEqual_IntInt(Index, 0), Less_IntInt(Index, Materials.Length)))
	{
		Current = Index;
		Material = Materials[Current];
		return true;
	}
	return false;
	return;
}

function Trigger(Actor Other, Actor EventInstigator)
{
	AddAdd_Int(Current);
	if(GreaterEqual_IntInt(Current, Materials.Length))
	{
		Current = 0;
	}
	if(Greater_IntInt(Materials.Length, 0))
	{
		Material = Materials[Current];
	}
	else
	{
		Material = none;
	}
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
	MaterialType=9
}