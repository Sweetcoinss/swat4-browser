class Message extends Object
	abstract
	native;

var Class<Actor> specificTo;

// Export UMessage::execAllocate(FFrame&, void* const)
native static function Object Allocate(optional Object Context, optional Object Outer, optional string n, optional int flags, optional Object Template);

static function string editorDisplay(name Instigator, Message filter)
{
	return Concat_StrStr("All messages from ", string(Instigator));
	return;
}

function bool passesFilter(Message filterMsg)
{
	local name PropName;
	local string filterProp;
	local bool passed;

	passed = true;
	foreach AllEditableProperties(Class, Class'Engine.Message', PropName)
	{
		filterProp = filterMsg.GetPropertyText(string(PropName));
		if(Not_PreBool(OrOr_BoolBool(OrOr_BoolBool(OrOr_BoolBool(EqualEqual_StrStr(filterProp, ""), EqualEqual_StrStr(filterProp, "None")), EqualEqual_StrStr(filterProp, "0")), EqualEqual_StrStr(filterProp, "0.00"))))
		{
			if(NotEqual_StrStr(filterProp, GetPropertyText(string(PropName))))
			{
				passed = false;
			}
		}
	}
	return passed;
	return;
}

defaultproperties
{
	specificTo=Class'Engine.Actor'
}