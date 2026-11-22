class GUIImageList extends GUIImage
	config(SwatGui)
	perobjectconfig
	instanced
	hidecategories(Menu,Object,Menu,Object,Menu,Object);

var() editinline config array<editinline string> MatNames "Names of the materials to use";
var() editinline config array<editinline Material> Materials "Materials to use";
var int CurIndex;
var() config bool bWrap "Is this list wraparound";

function InitComponent(GUIComponent MyOwner)
{
	super.InitComponent(MyOwner);
	__OnKeyEvent__Delegate = internalKeyEvent;
	return;
}

function AddMaterial(string MatName, out Material Mat)
{
	local int i;

	if(NotEqual_ObjectObject(Mat, none))
	{
		i = Materials.Length;
		Materials[i] = Mat;
		MatNames[i] = MatName;
	}
	return;
}

function string GetCurMatName()
{
	if(AndAnd_BoolBool(GreaterEqual_IntInt(CurIndex, 0), Less_IntInt(CurIndex, Materials.Length)))
	{
		return MatNames[CurIndex];
	}
	return "";
	return;
}

function setIndex(int Index)
{
	if(AndAnd_BoolBool(GreaterEqual_IntInt(Index, 0), Less_IntInt(Index, Materials.Length)))
	{
		CurIndex = Index;
		Image = Materials[Index];
	}
	else
	{
		Image = none;
		CurIndex = -1;
	}
	SetDirty();
	return;
}

function bool internalKeyEvent(out byte Key, out byte State, float Delta)
{
	if(OrOr_BoolBool(AndAnd_BoolBool(OrOr_BoolBool(OrOr_BoolBool(OrOr_BoolBool(EqualEqual_IntInt(int(Key), 38), EqualEqual_IntInt(int(Key), 104)), EqualEqual_IntInt(int(Key), 37)), EqualEqual_IntInt(int(Key), 100)), EqualEqual_IntInt(int(State), 1)), AndAnd_BoolBool(EqualEqual_IntInt(int(Key), 236), EqualEqual_IntInt(int(State), 3))))
	{
		PrevImage();
		return true;
	}
	if(OrOr_BoolBool(AndAnd_BoolBool(OrOr_BoolBool(OrOr_BoolBool(OrOr_BoolBool(EqualEqual_IntInt(int(Key), 40), EqualEqual_IntInt(int(Key), 98)), EqualEqual_IntInt(int(Key), 39)), EqualEqual_IntInt(int(Key), 102)), EqualEqual_IntInt(int(State), 1)), AndAnd_BoolBool(EqualEqual_IntInt(int(Key), 237), EqualEqual_IntInt(int(State), 3))))
	{
		NextImage();
		return true;
	}
	if(AndAnd_BoolBool(OrOr_BoolBool(EqualEqual_IntInt(int(Key), 36), EqualEqual_IntInt(int(Key), 103)), EqualEqual_IntInt(int(State), 1)))
	{
		FirstImage();
		return true;
	}
	if(AndAnd_BoolBool(OrOr_BoolBool(EqualEqual_IntInt(int(Key), 35), EqualEqual_IntInt(int(Key), 97)), EqualEqual_IntInt(int(State), 1)))
	{
		LastImage();
		return true;
	}
	return false;
	return;
}

function PrevImage()
{
	if(Less_IntInt(CurIndex, 1))
	{
		if(bWrap)
		{
			setIndex(Subtract_IntInt(Materials.Length, 1));
		}
	}
	else
	{
		setIndex(Subtract_IntInt(CurIndex, 1));
	}
	return;
}

function NextImage()
{
	if(Less_IntInt(CurIndex, 0))
	{
		setIndex(0);
	}
	else
	{
		if(GreaterEqual_IntInt(Add_IntInt(CurIndex, 1), Materials.Length))
		{
			if(bWrap)
			{
				setIndex(0);
			}
		}
		else
		{
			setIndex(Add_IntInt(CurIndex, 1));
		}
	}
	return;
}

function FirstImage()
{
	if(Greater_IntInt(Materials.Length, 0))
	{
		setIndex(0);
	}
	return;
}

function LastImage()
{
	if(Greater_IntInt(Materials.Length, 0))
	{
		setIndex(Subtract_IntInt(Materials.Length, 1));
	}
	return;
}

defaultproperties
{
	StyleName="STY_NoBackground"
	bAcceptsInput=true
	bCaptureMouse=true
	bTabStop=true
}