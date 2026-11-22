class SwatStartPointBase extends PlayerStart
	abstract
	native
	config
	hidecategories(Karma,Lighting,LightColor,Karma,Force);

enum EEntryType
{
	ET_Primary,                     // 0
	ET_Secondary                    // 1
};

var SwatStartPointBase.EEntryType EntryType "The entry point type designation for single player games";

defaultproperties
{
	bSinglePlayerStart=false
}