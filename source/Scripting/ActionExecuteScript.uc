class ActionExecuteScript extends Action
	abstract
	editinlinenew
	collapsecategories
	hidecategories(Object);

var name targetScript;
var bool block;

latent function Variable execute()
{
	local Script scriptToExecute;

	super.execute();
	scriptToExecute = Script(findByLabel(Class'Scripting.Script', targetScript));
	if(NotEqual_ObjectObject(scriptToExecute, none))
	{
		scriptToExecute.executeScriptFromScriptAction(block);
	}
	else
	{
		logError(Concat_StrStr(Concat_StrStr("Could find script ", string(targetScript)), " to execute"));
	}
	return none;
	return;
}

function editorDisplayString(out string S)
{
	if(block)
	{
		S = "Blocking";
	}
	else
	{
		S = "Non-blocking";
	}
	S = Concat_StrStr(Concat_StrStr(S, " execute script "), propertyDisplayString('targetScript'));
	return;
}

defaultproperties
{
	category="Script"
}