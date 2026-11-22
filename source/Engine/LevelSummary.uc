class LevelSummary extends Object
	native;

var localized string Title;
var string Author;
var localized string LevelEnterText;
var Material Screenshot "Screenshot of the level to be displayed on the server setup menu";
var localized string Description "Description of the level to be displayed on the server setup menu";
var array<Repo.EMPMode> SupportedModes "Multiplayer game modes supported by this map. If none are specified this map will not be available for multiplayer games.";
var int IdealPlayerCountMin "Recommended minimum number of players for this level.";
var int IdealPlayerCountMax "Recommended maximum number of players for this level.";
