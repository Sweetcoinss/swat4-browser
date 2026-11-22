class ActionLoop extends Action
	native
	editinlinenew
	collapsecategories
	hidecategories(Object);

cpptext
{
	virtual void CleanupDestroyed();

}

var export editinline array<export editinline Action> loopActions;

function setParentScript(Script S)
{
	local int i;

	super.setParentScript(S);
	i = 0;
	J0x12:

	if(Less_IntInt(i, loopActions.Length))
	{
		loopActions[i].setParentScript(S);
		AddAdd_PreInt(i);
		// [Loop Continue]
		goto J0x12;
	}
	return;
}

latent function Variable execute()
{
	local int i;

	super.execute();
	parentScript.enterLoop();
	J0x15:

	if(true)
	{
		i = 0;
		J0x20:

		if(Less_IntInt(i, loopActions.Length))
		{
			if(parentScript.keepLooping())
			{
				loopActions[i].execute();
				// [Explicit Continue]
				goto J0x5D;
			}
			goto J0x6A;
			J0x5D:

			AddAdd_PreInt(i);
			// [Loop Continue]
			goto J0x20;
		}
		// [Loop Continue]
		goto J0x15;
	}
	J0x6A:

	return none;
	return;
}

function editorDisplayString(out string S)
{
	S = "Loop";
	return;
}

defaultproperties
{
	actionDisplayName="Loop Statement"
	actionHelp="Continually loop over loopActions until ActionExitLoop is executed."
	category="Script"
}