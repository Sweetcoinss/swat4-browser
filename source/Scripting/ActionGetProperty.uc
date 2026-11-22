class ActionGetProperty extends Action
	editinlinenew
	collapsecategories
	hidecategories(Object);

var name Object;
var name Property;

latent function Variable execute()
{
	local Actor A;
	local string val;
	local Class<Variable> bestClass;

	super.execute();
	A = findByLabel(Class'Engine.Actor', Object);
	if(EqualEqual_ObjectObject(A, none))
	{
		logError(Concat_StrStr(Concat_StrStr("object ", string(Object)), " not found"));
	}
	else
	{
		val = A.GetPropertyText(string(Property));
		Class'Scripting.Variable'.static.bestVariableClass(val, bestClass);
		return newTemporaryVariable(bestClass, val);
	}
	return none;
	return;
}

function editorDisplayString(out string S)
{
	S = Concat_StrStr(Concat_StrStr(Concat_StrStr("Get ", propertyDisplayString('Object')), "."), propertyDisplayString('Property'));
	return;
}

function enumObjectProperties(LevelInfo L, out array<name> S)
{
	local Actor A;
	local name PropName;

	A = findByLabel(Class'Engine.Actor', Object);
	if(NotEqual_ObjectObject(A, none))
	{
		foreach AllProperties(A.Class, A.Class, PropName)
		{
			S[S.Length] = PropName;
		}
		if(EqualEqual_IntInt(S.Length, 0))
		{
			foreach AllProperties(A.Class, Class'Core.Object', PropName)
			{
				S[S.Length] = PropName;
			}
		}
	}
	return;
}

defaultproperties
{
	actionDisplayName="Get Object Property"
	actionHelp="Returns the value of a given object's property"
	returnType=Class'Scripting.Variable'
	category="Actor"
}