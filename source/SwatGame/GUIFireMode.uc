class GUIFireMode extends GUILabel
	config(SwatGui)
	perobjectconfig
	instanced
	hidecategories(Menu,Object,Menu,Object,Menu,Object);

var private config localized string FireModeSingleText;
var private config localized string FireModeBurstText;
var private config localized string FireModeAutoText;

function SelectFireMode(FiredWeapon.FireMode Mode)
{
	SetCaption(FireModeText(Mode));
	return;
}

private function string FireModeText(FiredWeapon.FireMode Mode)
{
	switch(Mode)
	{
		case 0:
			return FireModeSingleText;
			break;
		case 1:
			return FireModeBurstText;
			break;
		case 2:
			return FireModeAutoText;
			break;
		default:
			break;
	}
	return;
}

defaultproperties
{
	FireModeSingleText="SEMI"
	FireModeBurstText="BURST"
	FireModeAutoText="AUTO"
	bPersistent=true
}