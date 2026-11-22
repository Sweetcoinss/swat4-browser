class GUIGraphicCommandInterfaceMenuPad extends GUIButton
	native
	config(SwatGui)
	perobjectconfig
	instanced
	hidecategories(Menu,Object,Menu,Object,Menu,Object);

var Command Command;
var GUI.eMenuState UnselectedState;

function MoveTo(float X, float Y, float W, float H, float Time)
{
	local sDynamicPositionSpec Position;

	Position.WinTop = Subtract_FloatFloat(Y, Divide_FloatFloat(H, 2.0000000));
	Position.WinLeft = X;
	Position.WinWidth = W;
	Position.WinHeight = H;
	Position.TransitionTime = Time;
	Position.KeyName = 'temp';
	Position.Transparency = 1.0000000;
	RePositionTo(Position);
	return;
}

function OnSelected()
{
	Watched();
	return;
}

function OnUnselected()
{
	switch(UnselectedState)
	{
		case 0:
			EnableComponent();
			break;
		case 4:
			DisableComponent();
			break;
		default:
			break;
	}
	return;
}

function bool HideInGCI(GUIGraphicCommandInterface GCI)
{
	return OrOr_BoolBool(EqualEqual_ObjectObject(Command, none), AndAnd_BoolBool(Command.IsCancel, Not_PreBool(GCI.bUseExitPad)));
	return;
}

defaultproperties
{
	bAllowHTMLTextFormatting=true
}