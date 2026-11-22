class GUIScrollBarBase extends GUIMultiComponent
	native
	config(SwatGui)
	perobjectconfig
	instanced
	hidecategories(Menu,Object,Menu,Object);

var export editinline GUIListBase MyList;

function UpdateGripPosition(float NewPos)
{
	return;
}

function MoveGripBy(int Items)
{
	return;
}

event AlignThumb()
{
	return;
}

function Refocus(GUIComponent Who)
{
	local int i;

	if(AndAnd_BoolBool(NotEqual_ObjectObject(Who, none), Greater_IntInt(Controls.Length, 0)))
	{
		i = 0;
		J0x20:

		if(Less_IntInt(i, Controls.Length))
		{
			Controls[i].SetFocusInstead(Who);
			Controls[i].bNeverFocus = true;
			AddAdd_Int(i);
			// [Loop Continue]
			goto J0x20;
		}
	}
	return;
}

defaultproperties
{
	bTabStop=false
}