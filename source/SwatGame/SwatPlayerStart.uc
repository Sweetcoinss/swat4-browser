class SwatPlayerStart extends SwatStartPointBase
	native
	config
	hidecategories(Karma,Lighting,LightColor,Karma,Force);

cpptext
{
	virtual void CheckForErrors();
	void CheckNumberOfSwatPlayerStarts();

}

defaultproperties
{
	bSinglePlayerStart=true
}