class GUIReticle extends GUIImage
	config(SwatGui)
	perobjectconfig
	instanced
	hidecategories(Menu,Object,Menu,Object);

var() config Material UpImage;
var() config Material DownImage;
var() config Material LeftImage;
var() config Material RightImage;
var() config Material CenterDotImage;
var() config int TickSize;
var() config int CenterDotSize;
var() config Color TickColor;
var() config Material CenterNonFiredImage;
var() config Material CenterFiredImage;
var() Material CenterPreviewImage;
var() config Material CenterNonlethaledImage;
var() config Material CenterArrestedImage;
var byte CenterPreviewAlpha;

function InitComponent(GUIComponent Owner)
{
	super.InitComponent(Owner);
	return;
}

private function bool RenderReticle(Canvas Canvas)
{
	local HandheldEquipment ActiveItem;
	local Vector Center;
	local float aimerror, ReticleRadius;
	local FiredWeapon ActiveFiredWeapon;
	local PlayerController Player;

	Image = none;
	Player = PlayerOwner();
	if(EqualEqual_ObjectObject(Player.Pawn, none))
	{
		return false;
	}
	ActiveItem = SwatPlayer(Player.Pawn).GetActiveItem();
	if(EqualEqual_ObjectObject(ActiveItem, none))
	{
		return false;
	}
	ActiveFiredWeapon = FiredWeapon(ActiveItem);
	if(AndAnd_BoolBool(EqualEqual_ObjectObject(none, ActiveFiredWeapon), Not_PreBool(ActiveItem.IsIdle())))
	{
		return false;
	}
	if(NotEqual_ObjectObject(Player.ActiveViewport, none))
	{
		return false;
	}
	Canvas.bNoSmooth = false;
	Canvas.Style = ImageRenderStyle;
	Canvas.DrawColor = TickColor;
	GetTickMarkCenter(Center, Canvas);
	if(AndAnd_BoolBool(NotEqual_IntInt(int(Player.Level.NetMode), int(NM_Standalone)), SwatPlayer(Player.Pawn).IsArrested()))
	{
		Image = CenterArrestedImage;
		ImageColor.A = byte(255);
	}
	else
	{
		if(AndAnd_BoolBool(NotEqual_IntInt(int(Player.Level.NetMode), int(NM_Standalone)), SwatPlayer(Player.Pawn).CanBeArrestedNow()))
		{
			Image = CenterNonlethaledImage;
			ImageColor.A = byte(255);
		}
		else
		{
			if(NotEqual_ObjectObject(CenterPreviewImage, none))
			{
				Image = CenterPreviewImage;
				ImageColor.A = CenterPreviewAlpha;
			}
			else
			{
				if(NotEqual_ObjectObject(ActiveFiredWeapon, none))
				{
					Image = CenterFiredImage;
					ImageColor.A = byte(255);
					aimerror = ActiveFiredWeapon.GetAimError();
					ReticleRadius = Divide_FloatFloat(Multiply_FloatFloat(Canvas.ClipX, Tan(Divide_FloatFloat(Multiply_FloatFloat(0.0174533, aimerror), 2.0000000))), Tan(Divide_FloatFloat(Multiply_FloatFloat(0.0174533, Player.FovAngle), 2.0000000)));
					Canvas.SetPos(Subtract_FloatFloat(Center.X, float(Divide_IntInt(TickSize, 2))), Subtract_FloatFloat(Subtract_FloatFloat(Center.Y, ReticleRadius), float(TickSize)));
					Canvas.DrawTile(UpImage, float(TickSize), float(TickSize), 0.0000000, 0.0000000, float(TickSize), float(TickSize));
					Canvas.SetPos(Subtract_FloatFloat(Center.X, float(Divide_IntInt(TickSize, 2))), Subtract_FloatFloat(Add_FloatFloat(Center.Y, ReticleRadius), float(1)));
					Canvas.DrawTile(DownImage, float(TickSize), float(TickSize), 0.0000000, 0.0000000, float(TickSize), float(TickSize));
					Canvas.SetPos(Add_FloatFloat(Subtract_FloatFloat(Subtract_FloatFloat(Center.X, ReticleRadius), float(TickSize)), float(1)), Subtract_FloatFloat(Center.Y, float(Divide_IntInt(TickSize, 2))));
					Canvas.DrawTile(LeftImage, float(TickSize), float(TickSize), 0.0000000, 0.0000000, float(TickSize), float(TickSize));
					Canvas.SetPos(Add_FloatFloat(Center.X, ReticleRadius), Subtract_FloatFloat(Center.Y, float(Divide_IntInt(TickSize, 2))));
					Canvas.DrawTile(RightImage, float(TickSize), float(TickSize), 0.0000000, 0.0000000, float(TickSize), float(TickSize));
					Canvas.SetPos(Center.X, Subtract_FloatFloat(Center.Y, float(1)));
					Canvas.DrawTile(CenterDotImage, float(CenterDotSize), float(CenterDotSize), 0.0000000, 0.0000000, float(CenterDotSize), float(CenterDotSize));
				}
				else
				{
					Image = CenterNonFiredImage;
					ImageColor.A = byte(255);
				}
			}
		}
	}
	return false;
	return;
}

private function GetTickMarkCenter(out Vector Center, Canvas Canvas)
{
	if(AndAnd_BoolBool(NotEqual_ObjectObject(GUIPage(MenuOwner), none), GUIPage(MenuOwner).bIsHUD))
	{
		Center.X = Multiply_FloatFloat(0.5000000, Canvas.ClipX);
		Center.Y = Multiply_FloatFloat(0.5000000, Canvas.ClipY);
	}
	else
	{
		Center.X = Add_FloatFloat(ClientBounds[0], Multiply_FloatFloat(0.5000000, Subtract_FloatFloat(ClientBounds[2], ClientBounds[0])));
		Center.Y = Add_FloatFloat(ClientBounds[1], Multiply_FloatFloat(0.5000000, Subtract_FloatFloat(ClientBounds[3], ClientBounds[1])));
	}
	return;
}

defaultproperties
{
	UpImage=Texture'HUD.TopReticle'
	DownImage=Texture'HUD.BottomReticle'
	LeftImage=Texture'HUD.LeftReticle'
	RightImage=Texture'HUD.RightReticle'
	CenterDotImage=Texture'HUD.centerreticle'
	TickSize=16
	CenterDotSize=4
	TickColor=(R=255,G=255,B=255,A=255)
	CenterNonFiredImage=Texture'HUD.ToolReticle'
	CenterNonlethaledImage=Texture'HUD.NonLethaledReticle'
	CenterArrestedImage=Texture'HUD.ArrestedReticle'
	bPersistent=true
	OnDraw=GUIReticle.RenderReticle
}