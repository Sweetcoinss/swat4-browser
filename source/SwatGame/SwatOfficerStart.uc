class SwatOfficerStart extends SwatStartPointBase
	native
	config
	hidecategories(Karma,Lighting,LightColor,Karma,Force);

cpptext
{
	virtual void PostEditChange();
	virtual void PostEditLoad();
	void UpdateIcon();
	virtual void CheckForErrors();
	void CheckNumberOfSwatOfficerStarts();

}

enum EOfficerStartType
{
	RedOneStart,                    // 0
	RedTwoStart,                    // 1
	BlueOneStart,                   // 2
	BlueTwoStart                    // 3
};

var SwatOfficerStart.EOfficerStartType OfficerStartType;
var private Texture OfficerStartPointIcons[4];
var private bool bOfficerStartCheckedForNumberErrors;

private function Class<SwatOfficer> GetOfficerClass()
{
	switch(OfficerStartType)
	{
		case 0:
			return Class'SwatGame.OfficerRedOne';
		case 1:
			return Class'SwatGame.OfficerRedTwo';
		case 2:
			return Class'SwatGame.OfficerBlueOne';
		case 3:
			return Class'SwatGame.OfficerBlueTwo';
		default:
			return;
			break;
	}
}

function SpawnOfficer()
{
	local SwatOfficer SpawnedOfficer;

	SpawnedOfficer = Spawn(GetOfficerClass(),,, Location, Rotation);
	AssertWithDescription(NotEqual_ObjectObject(SpawnedOfficer, none), At_StrStr(At_StrStr(At_StrStr("SwatOfficerStart::SpawnOfficer - ", string(Name)), " could not spawn an officer at location:"), string(Location)));
	return;
}

defaultproperties
{
	OfficerStartPointIcons[0]=Texture'SWAT4editorTex.R1start'
	OfficerStartPointIcons[1]=Texture'SWAT4editorTex.R2start'
	OfficerStartPointIcons[2]=Texture'SWAT4editorTex.B1start'
	OfficerStartPointIcons[3]=Texture'SWAT4editorTex.B2start'
	Texture=Texture'SWAT4editorTex.R1start'
}