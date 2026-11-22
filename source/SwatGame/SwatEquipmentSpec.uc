class SwatEquipmentSpec extends Object
	config(SwatEquipment)
	perobjectconfig
	hidecategories(Object);

enum eEquipmentType
{
	EQUIP_Weaponry,                 // 0
	EQUIP_Handheld,                 // 1
	EQUIP_Protection,               // 2
	EQUIP_Simple                    // 3
};

var config array<string> EquipmentClassName "Specifies available equipment types for this pocket";
var config array<SwatGUIConfig.eNetworkValidity> Validity "Under what game conditions these pieces of equipment are valid";
var config array<bool> bSelectable "True if equipment in this pocket can be selected from the gui";
var config HandheldEquipment.Pocket DependentPocket "If set, the specified pocket will have its equipment loaded based on the selection in this pocket";
var config SwatGUIConfig.eNetworkValidity DisplayValidity "Under what game conditions this pocket should be displayed in the GUI";
var config localized string PocketFriendlyName "The name of this pocket as displayed in the GUI";
var config SwatEquipmentSpec.eEquipmentType TypeOfEquipment "The type of this pocket: what equipment it holds";
var config bool bSpawnable "True if equipment in this pocket should be spawned";

defaultproperties
{
	DependentPocket=24
}