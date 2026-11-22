class GUIFeedback extends GUIMultiComponent
	config(SwatGui)
	perobjectconfig
	instanced
	hidecategories(Menu,Object,Menu,Object);

var() export editinline config GUILabel OtherLabel "Text that displays the current rounds remaining in the magazine/clip.";
var() export editinline config GUILabel FireLabel "Text that displays the current rounds remaining in the magazine/clip.";
var() export editinline config GUILabel UseLabel "Text that displays the current rounds remaining in the magazine/clip.";
var config localized string UseCaption;
var config localized string FireCaption;
var string UseText;
var string FireText;
var string OtherText;

function OnConstruct(GUIController MyController)
{
	super.OnConstruct(MyController);
	OtherLabel = GUILabel(AddComponent("GUI.GUILabel", Concat_StrStr(string(self.Name), "_OtherLabel")));
	FireLabel = GUILabel(AddComponent("GUI.GUILabel", Concat_StrStr(string(self.Name), "_FireLabel")));
	UseLabel = GUILabel(AddComponent("GUI.GUILabel", Concat_StrStr(string(self.Name), "_UseLabel")));
	return;
}

function UpdateCaption()
{
	local bool bOther, bFire, bUse;

	bOther = Greater_IntInt(Len(OtherText), 0);
	bFire = Greater_IntInt(Len(FireText), 0);
	bUse = Greater_IntInt(Len(UseText), 0);
	OtherLabel.SetCaption(OtherText);
	FireLabel.SetCaption(Concat_StrStr(FireCaption, FireText));
	UseLabel.SetCaption(Concat_StrStr(UseCaption, UseText));
	OtherLabel.SetVisibility(bOther);
	FireLabel.SetVisibility(bFire);
	UseLabel.SetVisibility(bUse);
	if(OrOr_BoolBool(OrOr_BoolBool(bOther, bFire), bUse))
	{
		if(AndAnd_BoolBool(Not_PreBool(AndAnd_BoolBool(bRepositioning, EqualEqual_NameName(TransitionSpec.NewPos.KeyName, 'Up'))), Not_PreBool(IsAtPosition('Up'))))
		{
			RePosition('Down', true);
			RePosition('Up');
		}
	}
	else
	{
		if(AndAnd_BoolBool(Not_PreBool(AndAnd_BoolBool(bRepositioning, EqualEqual_NameName(TransitionSpec.NewPos.KeyName, 'Down'))), Not_PreBool(IsAtPosition('Down'))))
		{
			RePosition('Down');
		}
	}
	return;
}

defaultproperties
{
	bPersistent=true
}