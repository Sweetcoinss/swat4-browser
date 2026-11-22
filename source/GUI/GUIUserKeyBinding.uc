class GUIUserKeyBinding extends GUI
	instanced;

struct KeyInfo
{
	var string Alias;
	var string KeyLabel;
	var bool bIsSection;
};

var array<KeyInfo> KeyData;
