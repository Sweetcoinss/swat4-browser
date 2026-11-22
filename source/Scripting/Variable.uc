class Variable extends Object
	native
	editinlinenew
	collapsecategories
	hidecategories(Object);

var Script ownerScript;

overloaded function Construct(Script Owner)
{
	ownerScript = Owner;
	return;
}

static function logError(string rval, string Reason)
{
	SLog(Concat_StrStr(Concat_StrStr(Concat_StrStr("ERROR: Could not resolve rval ", rval), ", no variable of that name or "), Reason));
	return;
}

static function Variable findVariable(coerce string Name, Script requestingScript)
{
	local Script S;
	local int dotPos;

	dotPos = InStr(Name, ".");
	if(EqualEqual_IntInt(dotPos, -1))
	{
		S = requestingScript;
	}
	else
	{
		S = Script(requestingScript.findByLabel(Class'Scripting.Script', string(Left(Name, dotPos))));
		if(EqualEqual_ObjectObject(S, none))
		{
			return none;
		}
	}
	return S.findVariable(string(Mid(Name, Add_IntInt(dotPos, 1))));
	return;
}

static event nativeClassToVariableClass(string nativeClass, out Class<Variable> varClass)
{
	if(EqualEqual_StrStr(nativeClass, "NameProperty"))
	{
		varClass = Class'Scripting.VariableName';
	}
	else
	{
		if(EqualEqual_StrStr(nativeClass, "FloatProperty"))
		{
			varClass = Class'Scripting.VariableFloat';
		}
		else
		{
			if(EqualEqual_StrStr(nativeClass, "BoolProperty"))
			{
				varClass = Class'Scripting.VariableBool';
			}
			else
			{
				varClass = none;
			}
		}
	}
	return;
}

static event variableClassToNativeClass(Class<Variable> varClass, out string nativeClass)
{
	if(EqualEqual_ObjectObject(varClass, Class'Scripting.VariableName'))
	{
		nativeClass = "NameProperty";
	}
	else
	{
		if(EqualEqual_ObjectObject(varClass, Class'Scripting.VariableFloat'))
		{
			nativeClass = "FloatProperty";
		}
		else
		{
			if(EqualEqual_ObjectObject(varClass, Class'Scripting.VariableBool'))
			{
				nativeClass = "BoolProperty";
			}
			else
			{
				nativeClass = "None";
			}
		}
	}
	return;
}

static event bestVariableClass(string val, out Class<Variable> varClass)
{
	local int i, C;

	if(OrOr_BoolBool(EqualEqual_StrStr(val, "True"), EqualEqual_StrStr(val, "False")))
	{
		varClass = Class'Scripting.VariableBool';
		return;
	}
	i = 0;
	J0x37:

	if(Less_IntInt(i, Len(val)))
	{
		C = Asc(Mid(val, i, 1));
		if(AndAnd_BoolBool(AndAnd_BoolBool(OrOr_BoolBool(Greater_IntInt(C, Asc("9")), Less_IntInt(C, Asc("0"))), NotEqual_IntInt(C, Asc("-"))), NotEqual_IntInt(C, Asc("."))))
		{
			// [Explicit Break]
			goto J0xB9;
		}
		varClass = Class'Scripting.VariableFloat';
		return;
		AddAdd_Int(i);
		// [Loop Continue]
		goto J0x37;
	}
	J0xB9:

	varClass = Class'Scripting.VariableName';
	return;
}

function Add(string rhs)
{
	return;
}

function subtract(string rhs)
{
	return;
}

function multiply(string rhs)
{
	return;
}

function divide(string rhs)
{
	return;
}

function bool less(string rhs)
{
	return false;
	return;
}

function bool lessEqual(string rhs)
{
	return false;
	return;
}

function bool equal(string rhs)
{
	return false;
	return;
}

function bool notEqual(string rhs)
{
	return false;
	return;
}

function bool greaterEqual(string rhs)
{
	return false;
	return;
}

function bool greater(string rhs)
{
	return false;
	return;
}

function bool and(string rhs)
{
	return false;
	return;
}

function bool or(string rhs)
{
	return false;
	return;
}

function bool not()
{
	return false;
	return;
}

function bool truth()
{
	return false;
	return;
}
