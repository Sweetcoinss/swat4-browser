class ActionIf extends Action
	native
	editinlinenew
	collapsecategories
	hidecategories(Object);

cpptext
{
	virtual void CleanupDestroyed();

}

var export editinline array<export editinline ActionBool> testsOr;
var export editinline array<export editinline Action> trueActions;
var export editinline array<export editinline Action> elseActions;

function setParentScript(Script S)
{
	local int i;

	super.setParentScript(S);
	i = 0;
	J0x12:

	if(Less_IntInt(i, testsOr.Length))
	{
		testsOr[i].setParentScript(S);
		AddAdd_PreInt(i);
		// [Loop Continue]
		goto J0x12;
	}
	i = 0;
	J0x4D:

	if(Less_IntInt(i, trueActions.Length))
	{
		trueActions[i].setParentScript(S);
		AddAdd_PreInt(i);
		// [Loop Continue]
		goto J0x4D;
	}
	i = 0;
	J0x88:

	if(Less_IntInt(i, elseActions.Length))
	{
		elseActions[i].setParentScript(S);
		AddAdd_PreInt(i);
		// [Loop Continue]
		goto J0x88;
	}
	return;
}

latent function Variable execute()
{
	local int i;
	local Variable temp;
	local VariableBool Result;

	super.execute();
	if(EqualEqual_IntInt(testsOr.Length, 0))
	{
		return none;
	}
	i = 0;
	J0x1B:

	if(Less_IntInt(i, testsOr.Length))
	{
		testsOr[i].execute();
		temp = ;
		return Result = VariableBool(temp);
		if(AndAnd_BoolBool(NotEqual_ObjectObject(Result, none), Result.Value))
		{
			i = 0;
			J0x7E:

			if(AndAnd_BoolBool(Less_IntInt(i, trueActions.Length), parentScript.continueExecution()))
			{
				trueActions[i].execute();
				AddAdd_Int(i);
				// [Loop Continue]
				goto J0x7E;
			}
			return none;
		}
		AddAdd_Int(i);
		// [Loop Continue]
		goto J0x1B;
	}
	i = 0;
	J0xD4:

	if(AndAnd_BoolBool(Less_IntInt(i, elseActions.Length), parentScript.continueExecution()))
	{
		elseActions[i].execute();
		AddAdd_Int(i);
		// [Loop Continue]
		goto J0xD4;
	}
	return none;
	return;
}

function editorDisplayString(out string S)
{
	local int i;
	local string actionString;

	S = "If ";
	if(EqualEqual_IntInt(testsOr.Length, 0))
	{
		S = Concat_StrStr(S, "nothing");
	}
	else
	{
		i = 0;
		J0x37:

		if(Less_IntInt(i, testsOr.Length))
		{
			testsOr[i].editorDisplayString(actionString);
			S = Concat_StrStr(S, actionString);
			if(Less_IntInt(i, Subtract_IntInt(testsOr.Length, 1)))
			{
				S = Concat_StrStr(S, " OR ");
			}
			AddAdd_Int(i);
			// [Loop Continue]
			goto J0x37;
		}
	}
	S = Concat_StrStr(S, " Then ");
	if(EqualEqual_IntInt(trueActions.Length, 0))
	{
		S = Concat_StrStr(S, "do nothing");
	}
	else
	{
		if(Greater_IntInt(trueActions.Length, 2))
		{
			S = Concat_StrStr(Concat_StrStr(Concat_StrStr(S, "do "), string(trueActions.Length)), " actions");
		}
		else
		{
			i = 0;
			J0x11F:

			if(Less_IntInt(i, trueActions.Length))
			{
				trueActions[i].editorDisplayString(actionString);
				S = Concat_StrStr(S, actionString);
				if(Less_IntInt(i, Subtract_IntInt(trueActions.Length, 1)))
				{
					S = Concat_StrStr(S, ", ");
				}
				AddAdd_Int(i);
				// [Loop Continue]
				goto J0x11F;
			}
		}
	}
	if(EqualEqual_IntInt(elseActions.Length, 0))
	{
		return;
	}
	S = Concat_StrStr(S, ", Else ");
	if(Greater_IntInt(elseActions.Length, 2))
	{
		S = Concat_StrStr(Concat_StrStr(Concat_StrStr(S, "do "), string(elseActions.Length)), " actions");
	}
	else
	{
		i = 0;
		J0x1EC:

		if(Less_IntInt(i, elseActions.Length))
		{
			elseActions[i].editorDisplayString(actionString);
			S = Concat_StrStr(S, actionString);
			if(Less_IntInt(i, Subtract_IntInt(elseActions.Length, 1)))
			{
				S = Concat_StrStr(S, ", ");
			}
			AddAdd_Int(i);
			// [Loop Continue]
			goto J0x1EC;
		}
	}
	return;
}

defaultproperties
{
	actionDisplayName="If Statement"
	actionHelp="If one of the boolean statements in the 'testsOr' array is true, executes the Actions in 'trueActions', else executes the Actions in 'elseActions'."
	category="Script"
}