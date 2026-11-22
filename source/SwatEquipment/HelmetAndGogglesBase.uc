class HelmetAndGogglesBase extends ProtectiveEquipment implements IProtectFromFlashbang
	config(SwatEquipment)
	hidecategories(Karma);

function QualifyProtectedRegion()
{
	AssertWithDescription(Less_IntInt(int(ProtectedRegion), int(7)), Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr("[Carlos] The HelmetAndGogglesBase class ", string(Class.Name)), " specifies ProtectedRegion="), string(GetEnum(Enum'Engine.Actor.ESkeletalRegion', int(ProtectedRegion)))), ".  ProtectiveEquipment may only protect body regions or Region_None."));
	return;
}
