class GUIOverlay extends GUIImage
	config(SwatGui)
	perobjectconfig
	instanced
	hidecategories(Menu,Object,Menu,Object);

function InitComponent(GUIComponent Owner)
{
	super.InitComponent(Owner);
	bCanBeShown = true;
	return;
}

event Show()
{
	UpdateImage();
	super(GUIComponent).Show();
	return;
}

event Hide()
{
	Image = none;
	super(GUIComponent).Hide();
	return;
}

event UpdateImage()
{
	local SwatPlayer PlayerPawn;

	PlayerPawn = SwatPlayer(PlayerOwner().Pawn);
	WinLeft = 0.0000000;
	WinTop = 0.0000000;
	WinWidth = 1.0000000;
	WinHeight = 1.0000000;
	Transparency = 1.0000000;
	Image = none;
	if(AndAnd_BoolBool(NotEqual_ObjectObject(PlayerPawn, none), PlayerPawn.IsA('ICanUseProtectiveEquipment')))
	{
		if(NotEqual_ObjectObject(PlayerPawn.GetSkeletalRegionProtection(1), none))
		{
			Image = PlayerPawn.GetSkeletalRegionProtection(1).FirstPersonOverlay;
		}
		else
		{
			if(NotEqual_ObjectObject(PlayerPawn.GetSkeletalRegionProtection(0), none))
			{
				Image = PlayerPawn.GetSkeletalRegionProtection(0).FirstPersonOverlay;
			}
		}
	}
	return;
}

defaultproperties
{
	WinTop=0.0000000
	WinLeft=0.0000000
	WinWidth=1.0000000
	WinHeight=1.0000000
	RenderWeight=0.0001000
	bPersistent=true
}