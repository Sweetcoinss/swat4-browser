class ActionLog extends Action
	editinlinenew
	collapsecategories
	hidecategories(Object);

var /*0x00000000-0x00100000*/ string Text;

latent function Variable execute()
{
	local string Result;
	local int Current, Left, Right, NextInterval;
	local string VariableName;
	local Variable Variable;
	local string VariableValue;

	super.execute();
	Left = InStr(Mid(Text, Current, Subtract_IntInt(Len(Text), Current)), "[");
	if(Less_IntInt(Left, 0))
	{
		Result = Text;
	}
	else
	{
		J0x44:

		if(GreaterEqual_IntInt(NextInterval, 0))
		{
			Result = Concat_StrStr(Result, Mid(Text, Current, Subtract_IntInt(Left, Current)));
			Right = Add_IntInt(Left, InStr(Mid(Text, Add_IntInt(Left, 1), Subtract_IntInt(Len(Text), Left)), "]"));
			if(LessEqual_IntInt(Right, Left))
			{
				logError("Syntax error in log string: unterminated square bracket");
				// [Explicit Break]
				goto J0x1D3;
			}
			VariableName = Mid(Text, Add_IntInt(Left, 1), Subtract_IntInt(Right, Left));
			Variable = tryFindVariable(VariableName);
			if(EqualEqual_ObjectObject(Variable, none))
			{
				VariableValue = Concat_StrStr(Concat_StrStr("(variable ", VariableName), " not found)");
			}
			else
			{
				VariableValue = Variable.GetPropertyText("value");
			}
			Result = Concat_StrStr(Result, VariableValue);
			Current = Add_IntInt(Right, 2);
			NextInterval = InStr(Mid(Text, Current, Subtract_IntInt(Len(Text), Current)), "[");
			Left = Add_IntInt(Current, NextInterval);
			// [Loop Continue]
			goto J0x44;
		}
		J0x1D3:

		Result = Concat_StrStr(Result, Mid(Text, Current, Subtract_IntInt(Len(Text), Current)));
	}
	SLog(Result);
	if(CanSLog())
	{
		parentScript.Level.Game.Broadcast(parentScript, Concat_StrStr("GUI SCRIPT LOG: ", Result));
	}
	return none;
	return;
}

function editorDisplayString(out string S)
{
	S = Concat_StrStr(Concat_StrStr("Log '", Text), "'");
	return;
}

defaultproperties
{
	actionDisplayName="Log"
	actionHelp="Outputs to the Unreal log file. Use [<varname>] to output variables, i.e. 'The value of MyCounter is [MyCounter]'"
	category="Other"
}