class ActionSetProperty extends Action
	editinlinenew
	collapsecategories
	hidecategories(Object);

var name Object;
var name Property;
var string NewValue;

latent function Variable execute()
{
	local Actor A;

	super.execute();
	foreach parentScript.staticActorLabel(Class'Engine.Actor', A, Object)
	{
		A.SetPropertyText(string(Property), NewValue);
	}
	return none;
	return;
}

function editorDisplayString(out string S)
{
	S = Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr("Set ", propertyDisplayString('Object')), "."), propertyDisplayString('Property')), " = "), propertyDisplayString('NewValue'));
	return;
}

function enumObjectProperties(LevelInfo L, out array<name> S)
{
	local Actor A;
	local array< Class > classes;
	local Class commonBaseClass;
	local name PropName;

	foreach parentScript.staticActorLabel(Class'Engine.Actor', A, Object)
	{
		classes[classes.Length] = A.Class;
	}
	commonBaseClass = CommonBase(classes);
	if(NotEqual_ObjectObject(commonBaseClass, none))
	{
		foreach AllProperties(commonBaseClass, Class'Core.Object', PropName)
		{
			S[S.Length] = PropName;
		}
	}
	return;
}

defaultproperties
{
	actionDisplayName="Set Object Property"
	actionHelp="Sets a new value for a given object's property"
	category="Actor"
}