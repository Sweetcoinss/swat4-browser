class ActionPropertyTest extends ActionBool
	native
	editinlinenew
	collapsecategories
	hidecategories(Object);

enum EOpTest
{
	OPTEST_LESS,                    // 0
	OPTEST_LESSEQUAL,               // 1
	OPTEST_EQUALS,                  // 2
	OPTEST_NOTEQUAL,                // 3
	OPTEST_GREATEREQUAL,            // 4
	OPTEST_GREATER                  // 5
};

var name Label;
var /*0x00000000-0x00100000*/ Class<Actor> actorClass;
var /*0x00000000-0x00100000*/ string propertyPath;
var string Value;
var int maxPasses "The number of actors with a matching label that must pass the test (-1 means all)";
var /*0x00000000-0x00100000*/ private transient Object testProperty;
var /*0x00000000-0x00100000*/ transient array<int> offsets;
var /*0x00000000-0x00100000*/ ActionPropertyTest.EOpTest opTest;

latent function Variable execute()
{
	local VariableBool retVar;

	retVar = Class'Scripting.VariableBool'.static.Allocate(self).;
	Construct_Void();
	super(Action).execute();
	if(EqualEqual_ObjectObject(testProperty, none))
	{
		findTestProperty();
	}
	retVar.Value = doPropertyTest();
	return retVar;
	return;
}

function editorDisplayString(out string S)
{
	if(NotEqual_IntInt(maxPasses, -1))
	{
		S = Concat_StrStr(string(maxPasses), " ");
	}
	else
	{
		S = "all ";
	}
	S = Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr(S, string(Label)), "."), propertyPath), " "), getOperatorText()), " "), Value);
	return;
}

function string getOperatorText()
{
	switch(opTest)
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

// Export UActionPropertyTest::execfindTestProperty(FFrame&, void* const)
private native function findTestProperty();

// Export UActionPropertyTest::execdoPropertyTest(FFrame&, void* const)
private native function bool doPropertyTest();

defaultproperties
{
	maxPasses=-1
	actionDisplayName="Test Property"
	actionHelp="Returns true if the property passes the operator test against value"
	category="Watch"
}