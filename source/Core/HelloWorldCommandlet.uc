class HelloWorldCommandlet extends Commandlet
	transient;

var int intparm;
var string strparm;

function int Main(string Parms)
{
	Log("Hello, world!");
	if(NotEqual_StrStr(Parms, ""))
	{
		Log(Concat_StrStr("Command line parameters=", Parms));
	}
	if(NotEqual_IntInt(intparm, 0))
	{
		Log(Concat_StrStr("You specified intparm=", string(intparm)));
	}
	if(NotEqual_StrStr(strparm, ""))
	{
		Log(Concat_StrStr("You specified strparm=", strparm));
	}
	return 0;
	return;
}

defaultproperties
{
	HelpCmd="HelloWorld"
	HelpOneLiner="Sample 'hello world' commandlet"
	HelpUsage="HelloWorld (no parameters)"
	HelpParm[0]="IntParm"
	HelpParm[1]="StrParm"
	HelpDesc[0]="An integer parameter"
	HelpDesc[1]="A string parameter"
}