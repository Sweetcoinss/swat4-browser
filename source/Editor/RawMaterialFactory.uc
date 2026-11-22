class RawMaterialFactory extends MaterialFactory
	hidecategories(Object);

var Class<Material> MaterialClass;

function Material CreateMaterial(Object InOuter, string InPackage, string InGroup, string InName)
{
	if(EqualEqual_ObjectObject(MaterialClass, none))
	{
		return none;
	}
	return MaterialClass.static.Allocate(self, InOuter, InName, Add_IntInt(4, 524288)).;
	Construct_Void();
	return;
}

defaultproperties
{
	MaterialClass=Class'Engine.Shader'
	Description="Raw Material"
}