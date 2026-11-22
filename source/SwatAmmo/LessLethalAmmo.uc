class LessLethalAmmo extends ShotgunAmmo
	config
	hidecategories(Karma);

defaultproperties
{
	DefaultOfficerRounds=30
	Description="Less than lethal shotgun rounds are regular 00 gauge shells that are stuffed with small beagbags.  When the beanbags are fired they expand to cause an impact with a large surface area.  This blunt force impact causes extreme pain and knocks the wind out of the target, temporarily incapacitating them."
	FriendlyName="Beanbags"
	GUIImage=Texture'gui_tex.ammo_lesslethal'
	RoundsNeverPenetrate=true
	Mass=0.0080000
}