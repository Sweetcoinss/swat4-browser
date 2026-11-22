class ActionFor extends Action
	native
	editinlinenew
	collapsecategories
	hidecategories(Object);

cpptext
{
	virtual void CleanupDestroyed();

}

var /*0x00000000-0x00100000*/ name counterName;
var float beginValue;
var float endValue;
var export editinline array<export editinline Action> forActions;

function setParentScript(Script S)
{
	local int i;

	super.setParentScript(S);
	i = 0;
	J0x12:

	if(Less_IntInt(i, forActions.Length))
	{
		forActions[i].setParentScript(S);
		AddAdd_PreInt(i);
		// [Loop Continue]
		goto J0x12;
	}
	return;
}

latent function Variable execute()
{
	local int i;
	local VariableFloat counterVar;
	local float End;

	super.execute();
	counterVar = VariableFloat(newVariable(counterName, Class'Scripting.VariableFloat'));
	if(EqualEqual_ObjectObject(counterVar, none))
	{
		logError("The counter variable must be a float variable");
		return none;
	}
	counterVar.Value = beginValue;
	End = endValue;
	J0x82:

	if(LessEqual_FloatFloat(counterVar.Value, End))
	{
		i = 0;
		J0xA1:

		if(AndAnd_BoolBool(Less_IntInt(i, forActions.Length), parentScript.keepLooping()))
		{
			forActions[i].execute();
			AddAdd_PreInt(i);
			// [Loop Continue]
			goto J0xA1;
		}
		counterVar.Add("1");
		// [Loop Continue]
		goto J0x82;
	}
	return none;
	return;
}

function editorDisplayString(out string S)
{
	S = Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr("For ", string(counterName)), " = "), propertyDisplayString('beginValue')), " to "), propertyDisplayString('endValue'));
	return;
}

defaultproperties
{
	counterName="forCounter"
	actionDisplayName="For Statement"
	actionHelp="Executes a list of actions n times."
	category="Script"
}