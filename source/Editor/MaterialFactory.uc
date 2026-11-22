class MaterialFactory extends Object
	abstract
	native
	hidecategories(Object);

const RF_Standalone = 0x00080000;

var string Description;

event Material CreateMaterial(Object InOuter, string InPackage, string InGroup, string InName)
{
	return;
}

// Export UMaterialFactory::execConsoleCommand(FFrame&, void* const)
native function ConsoleCommand(string Cmd);
