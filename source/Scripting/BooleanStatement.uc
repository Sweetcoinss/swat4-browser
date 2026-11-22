class BooleanStatement extends ActionBool
	editinlinenew
	collapsecategories
	hidecategories(Object);

enum ELogicOp
{
	LOGICOP_LESS,                   // 0
	LOGICOP_LESSEQUAL,              // 1
	LOGICOP_EQUALS,                 // 2
	LOGICOP_NOTEQUAL,               // 3
	LOGICOP_GREATEREQUAL,           // 4
	LOGICOP_GREATER                 // 5
};

var BooleanStatement.ELogicOp logicOp;
var name lhs;
var name rhs;

latent function Variable execute()
{
	local Variable lhsVAR, returnVar;
	local bool B;

	super(Action).execute();
	lhsVAR = tryFindVariable(string(lhs));
	if(EqualEqual_ObjectObject(lhsVAR, none))
	{
		lhsVAR = makeVariable(string(lhs));
	}
	switch(logicOp)
	{
		case 0:
			B = lhsVAR.less(string(rhs));
			break;
		case 1:
			B = lhsVAR.lessEqual(string(rhs));
			break;
		case 2:
			B = lhsVAR.equal(string(rhs));
			break;
		case 3:
			B = lhsVAR.notEqual(string(rhs));
			break;
		case 4:
			B = lhsVAR.greaterEqual(string(rhs));
			break;
		case 5:
			B = lhsVAR.greater(string(rhs));
			break;
		default:
			break;
	}
	returnVar = newTemporaryVariable(Class'Scripting.VariableBool');
	returnVar.SetPropertyText("value", string(B));
	return returnVar;
	return;
}

function string logicOpDisplayString()
{
	switch(logicOp)
	{
		case 0:
			return "<";
			break;
		case 1:
			return "<=";
			break;
		case 2:
			return "==";
			break;
		case 3:
			return "!=";
			break;
		case 4:
			return ">=";
			break;
		case 5:
			return ">";
			break;
		default:
			break;
	}
	return;
}

function editorDisplayString(out string S)
{
	S = Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr(propertyDisplayString('lhs'), " "), logicOpDisplayString()), " "), propertyDisplayString('rhs'));
	return;
}

defaultproperties
{
	logicOp=2
	actionDisplayName="Boolean Statement"
	actionHelp="Returns the result of a logical evaluation"
	category="Logic"
}