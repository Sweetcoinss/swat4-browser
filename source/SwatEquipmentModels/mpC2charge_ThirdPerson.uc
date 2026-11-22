class mpC2charge_ThirdPerson extends QualifiedUseEquipmentModel
	config
	hidecategories(Karma,Advanced,Events,Force,LightColor,Lighting,Movement,Object,Sound);

defaultproperties
{
	HolderBeginQualifyAnimation="sPlaceC2startMP"
	HolderQualifyLoopAnimation="sPlaceC2loopMP"
	HolderEndQualifyAnimation="sPlaceC2endMP"
	FinishQualifyTweenTime=0.3000000
	HolderEquipAnimation="equipC2"
	HolderUnequipAnimation="unequipC2"
	EquippedSocket="MiscGrip"
	DrawType=8
	StaticMesh=StaticMesh'SwatGear_sm.C2Charge'
}