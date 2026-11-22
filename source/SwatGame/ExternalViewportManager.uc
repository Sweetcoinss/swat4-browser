class ExternalViewportManager extends Actor implements IInterested_GameEvent_GameStarted, IInterested_GameEvent_MissionEnded, IControllableViewport
	config(SwatGame)
	notplaceable
	hidecategories(Karma);

const ViewLerpAlpha = 8;
const LocLerpAlpha = 6;

var private const config float kDefaultSizeX;
var private const config float kDefaultSizeY;
var private const config float kActiveSizeX;
var private const config float kActiveSizeY;
var private const config float kZoomRate;
var private const config float kViewportFOV;
var private const config float kViewportRightPadding;
var private const config float kViewportTopPadding;
var private const config string OfficerFontName;
var private const config float kNegativeFontYOffset;
var private const config float kNegativeFontXOffset;
var private int iCurrentControllable;
var array<IControllableThroughViewport> AllControllable;
var array<IControllableThroughViewport> CurrentControllables;
var private string filter;
var private string InitialControllable;
var private float CurrentSizeX;
var private float CurrentSizeY;
var private float CurrentWidth;
var private float CurrentHeight;
var private float LastDeltaTime;
var private Class<Actor> BaseControllableClass;
var private export editinline GUIExternalViewport GUIParent;
var private Material DeadTexture;
var private Rotator LastViewRotation;
var private Vector LastViewLocation;
var private Material ReticleTexture;
var private Vector MouseAccel;
var private Rotator OriginalRotation;

simulated function PostBeginPlay()
{
	super.PostBeginPlay();
	if(EqualEqual_IntInt(int(Level.NetMode), int(NM_Standalone)))
	{
		assert(NotEqual_ObjectObject(SwatGameInfo(Level.Game), none));
		SwatGameInfo(Level.Game).GameEvents.GameStarted.Register(self);
		SwatGameInfo(Level.Game).GameEvents.MissionEnded.Register(self);
	}
	else
	{
		Initialize();
	}
	return;
}

simulated function OnGameStarted()
{
	Initialize();
	return;
}

simulated function OnMissionEnded()
{
	GUIParent.__OnClientDraw__Delegate = GUIParent.InternalRender;
	return;
}

simulated function ShowViewport(string inFilter, optional string inSpecificControllableFilter)
{
	if(OrOr_BoolBool(Not_PreBool(SetFilter(inFilter)), NotEqual_StrStr(inSpecificControllableFilter, "")))
	{
		CycleControllableViewport(inSpecificControllableFilter);
	}
	if(NotEqual_ObjectObject(GetCurrentControllable(), none))
	{
		OriginalRotation = GetCurrentControllable().GetOriginalDirection();
		LastViewRotation = OriginalRotation;
		LastViewLocation = GetCurrentControllable().GetViewportLocation();
		GUIParent.__OnClientDraw__Delegate = Render;
	}
	return;
}

simulated function bool SetFilter(string inFilter)
{
	local int ct;

	if(NotEqual_StrStr(filter, inFilter))
	{
		filter = inFilter;
		iCurrentControllable = 0;
		CurrentControllables.Remove(0, CurrentControllables.Length);
		if(NotEqual_StrStr(filter, ""))
		{
			ct = 0;
			J0x41:

			if(Less_IntInt(ct, AllControllable.Length))
			{
				if(ControllableMatchesFilter(AllControllable[ct], filter))
				{
					CurrentControllables.Insert(CurrentControllables.Length, 1);
					CurrentControllables[Subtract_IntInt(CurrentControllables.Length, 1)] = AllControllable[ct];
				}
				AddAdd_PreInt(ct);
				// [Loop Continue]
				goto J0x41;
			}
		}
		return true;
	}
	return false;
	return;
}

simulated function string GetFilter()
{
	return filter;
	return;
}

simulated function bool ShouldControlViewport()
{
	return AndAnd_BoolBool(AndAnd_BoolBool(AndAnd_BoolBool(EqualEqual_IntInt(int(Level.NetMode), int(NM_Standalone)), NotEqual_ObjectObject(SwatGamePlayerController(Owner), none)), NotEqual_IntInt(int(SwatGamePlayerController(Owner).bControlViewport), 0)), GetCurrentControllable().ShouldDrawViewport());
	return;
}

simulated function Initialize()
{
	local Actor TestControllable;
	local int NumOfficers;

	AllControllable.Length = 0;
	foreach DynamicActors(BaseControllableClass, TestControllable)
	{
		if(AndAnd_BoolBool(NotEqual_ObjectObject(IControllableThroughViewport(TestControllable), none), NotEqual_ObjectObject(IControllableThroughViewport(TestControllable).GetViewportOwner(), Controller(Owner).Pawn)))
		{
			AllControllable.Insert(NumOfficers, 1);
			AllControllable[NumOfficers] = IControllableThroughViewport(TestControllable);
			AddAdd_Int(NumOfficers);
		}
	}
	if(EqualEqual_IntInt(0, NumOfficers))
	{
		Log("!! No officers in the level, stopping initialization of ExternalViewportManager");
		return;
	}
	if(OrOr_BoolBool(EqualEqual_IntInt(int(Level.NetMode), int(NM_Standalone)), EqualEqual_ObjectObject(Level.GetLocalPlayerController(), Owner)))
	{
		GUIParent = SwatGamePlayerController(Owner).GetHUDPage().ExternalViewport;
		GUIParent.__OnClientDraw__Delegate = Render;
		GUIParent.Hide();
	}
	return;
}

simulated function bool HasOfficers(string ViewportType)
{
	local int ct;

	ct = 0;
	J0x07:

	if(Less_IntInt(ct, AllControllable.Length))
	{
		if(GreaterEqual_IntInt(InStr(Caps(AllControllable[ct].GetViewportType()), Caps(ViewportType)), 0))
		{
			MPLog("ExternalViewportManager::HasOfficers returning true ");
			return true;
		}
		AddAdd_PreInt(ct);
		// [Loop Continue]
		goto J0x07;
	}
	return false;
	return;
}

simulated function SetCurrentControllable(IControllableThroughViewport NewControllable)
{
	iCurrentControllable = 0;
	if(NotEqual_ObjectObject(NewControllable, none))
	{
		CurrentControllables.Length = 0;
		CurrentControllables.Insert(0, 1);
		CurrentControllables[0] = NewControllable;
	}
	else
	{
		CurrentControllables.Length = 0;
	}
	if(NotEqual_ObjectObject(GetCurrentControllable(), none))
	{
		OriginalRotation = GetCurrentControllable().GetOriginalDirection();
		LastViewRotation = OriginalRotation;
		LastViewLocation = GetCurrentControllable().GetViewportLocation();
		GUIParent.__OnClientDraw__Delegate = Render;
	}
	return;
}

simulated function IControllableThroughViewport GetCurrentControllable()
{
	local IControllableThroughViewport Controllable;

	if(Less_IntInt(iCurrentControllable, CurrentControllables.Length))
	{
		Controllable = CurrentControllables[iCurrentControllable];
	}
	else
	{
		Controllable = none;
	}
	return Controllable;
	return;
}

simulated function SetInput(int dMouseX, int dMouseY)
{
	MouseAccel.X = float(dMouseX);
	MouseAccel.Y = float(dMouseY);
	return;
}

simulated function bool ControllableMatchesFilter(IControllableThroughViewport Controllable, string filter)
{
	return GreaterEqual_IntInt(InStr(Caps(Controllable.GetViewportType()), Caps(filter)), 0);
	return;
}

simulated function bool IncrementControllableAndTestValidity()
{
	AddAdd_PreInt(iCurrentControllable);
	if(GreaterEqual_IntInt(iCurrentControllable, CurrentControllables.Length))
	{
		SwatGamePlayerController(Owner).HideViewport();
		return false;
	}
	return true;
	return;
}

simulated function CycleControllableViewport(optional string SpecificControllableFilter)
{
	if(NotEqual_StrStr(SpecificControllableFilter, ""))
	{
		J0x0C:

		if(Not_PreBool(ControllableMatchesFilter(GetCurrentControllable(), SpecificControllableFilter)))
		{
			if(Not_PreBool(IncrementControllableAndTestValidity()))
			{
				return;
			}
			// [Loop Continue]
			goto J0x0C;
		}
	}
	else
	{
		if(Not_PreBool(IncrementControllableAndTestValidity()))
		{
			return;
		}
	}
	return;
}

private simulated function UpdateGUIComponent(Canvas inCanvas, int X, int Y, int W, int H)
{
	GUIParent.WinLeft = Divide_FloatFloat(float(X), float(inCanvas.SizeX));
	GUIParent.WinTop = Divide_FloatFloat(float(Y), float(inCanvas.SizeY));
	GUIParent.WinWidth = Divide_FloatFloat(float(W), float(inCanvas.SizeX));
	GUIParent.WinHeight = Divide_FloatFloat(float(H), float(inCanvas.SizeY));
	return;
}

simulated function InstantMinimize()
{
	CurrentSizeX = kDefaultSizeX;
	CurrentSizeY = kDefaultSizeY;
	return;
}

private simulated function UpdateGeometry(Canvas inCanvas, float inDeltaTime, out int X, out int Y, out int W, out int H)
{
	if(ShouldControlViewport())
	{
		CurrentSizeX = Lerp(Multiply_FloatFloat(inDeltaTime, kZoomRate), CurrentSizeX, kActiveSizeX);
		CurrentSizeY = Lerp(Multiply_FloatFloat(inDeltaTime, kZoomRate), CurrentSizeY, kActiveSizeY);
	}
	else
	{
		CurrentSizeX = Lerp(Multiply_FloatFloat(inDeltaTime, kZoomRate), CurrentSizeX, kDefaultSizeX);
		CurrentSizeY = Lerp(Multiply_FloatFloat(inDeltaTime, kZoomRate), CurrentSizeY, kDefaultSizeY);
	}
	CurrentWidth = Multiply_FloatFloat(float(inCanvas.SizeX), CurrentSizeX);
	CurrentHeight = Multiply_FloatFloat(inCanvas.ClipY, CurrentSizeY);
	X = int(Subtract_FloatFloat(float(int(Subtract_FloatFloat(float(inCanvas.SizeX), CurrentWidth))), Multiply_FloatFloat(float(inCanvas.SizeX), kViewportRightPadding)));
	Y = int(Multiply_FloatFloat(inCanvas.ClipY, kViewportTopPadding));
	W = int(CurrentWidth);
	H = int(CurrentHeight);
	UpdateGUIComponent(inCanvas, X, Y, W, H);
	return;
}

private simulated function DrawOfficerName(Canvas inCanvas)
{
	if(EqualEqual_ObjectObject(GetCurrentControllable(), none))
	{
		return;
	}
	if(Less_FloatFloat(CurrentHeight, float(100)))
	{
		return;
	}
	inCanvas.SetPos(float(int(Divide_FloatFloat(Multiply_FloatFloat(kNegativeFontXOffset, float(inCanvas.SizeX)), 800.0000000))), Subtract_FloatFloat(CurrentHeight, float(int(Divide_FloatFloat(Multiply_FloatFloat(kNegativeFontYOffset, float(inCanvas.SizeY)), 600.0000000)))));
	inCanvas.Font = GUIParent.Controller.GetMenuFont(OfficerFontName).GetFont(inCanvas.SizeX);
	if(GreaterEqual_IntInt(InStr(Caps(GetCurrentControllable().GetViewportName()), "BLUE"), 0))
	{
		inCanvas.SetDrawColor(0, 0, 135);
	}
	else
	{
		if(GreaterEqual_IntInt(InStr(Caps(GetCurrentControllable().GetViewportName()), "RED"), 0))
		{
			inCanvas.SetDrawColor(175, 0, 0);
		}
		else
		{
			inCanvas.SetDrawColor(byte(255), byte(255), byte(255));
		}
	}
	inCanvas.DrawText(At_StrStr(Caps(GetCurrentControllable().GetViewportName()), GetCurrentControllable().GetViewportDescription()));
	return;
}

simulated function Render(Canvas inCanvas)
{
	local int X, Y, W, H;

	UpdateGeometry(inCanvas, FClamp(LastDeltaTime, 0.0100000, 0.3000000), X, Y, W, H);
	inCanvas.SetOrigin(float(X), float(Y));
	DrawViewport(inCanvas, X, Y, W, H);
	DrawOfficerName(inCanvas);
	if(AndAnd_BoolBool(ShouldControlViewport(), GetCurrentControllable().ShouldDrawReticle()))
	{
		DrawReticle(inCanvas);
	}
	inCanvas.SetOrigin(0.0000000, 0.0000000);
	inCanvas.ClipX = float(inCanvas.SizeX);
	inCanvas.ClipY = float(inCanvas.SizeY);
	return;
}

simulated function name GetControllingStateName()
{
	return 'ControllingViewport';
	return;
}

simulated function bool CanIssueCommands()
{
	return GetCurrentControllable().CanIssueCommands();
	return;
}

private simulated function DrawReticle(Canvas inCanvas)
{
	inCanvas.bNoSmooth = false;
	inCanvas.Style = 5;
	inCanvas.SetDrawColor(byte(255), byte(255), byte(255));
	inCanvas.SetPos(Multiply_FloatFloat(0.5000000, Subtract_FloatFloat(CurrentWidth, float(96))), Multiply_FloatFloat(0.5000000, Subtract_FloatFloat(CurrentHeight, float(96))));
	inCanvas.DrawTile(ReticleTexture, 96.0000000, 96.0000000, 0.0000000, 0.0000000, 256.0000000, 256.0000000);
	return;
}

simulated function int DegreesToUnreal(int inDegrees)
{
	return Divide_IntInt(Multiply_IntInt(65536, inDegrees), 360);
	return;
}

simulated function ViewportCalcView(out Vector CameraLocation, out Rotator CameraRotation)
{
	local Range YawRange, PitchRange;
	local Rotator ViewRotation;

	if(EqualEqual_ObjectObject(GetCurrentControllable(), none))
	{
		return;
	}
	if(ShouldControlViewport())
	{
		CameraRotation = LastViewRotation;
		GetCurrentControllable().SetRotationToViewport(CameraRotation);
	}
	else
	{
		CameraRotation = GetCurrentControllable().GetViewportDirection();
	}
	CameraLocation = GetCurrentControllable().GetViewportLocation();
	if(ShouldControlViewport())
	{
		if(NotEqual_FloatFloat(VSize(MouseAccel), float(0)))
		{
			GetCurrentControllable().OnMouseAccelerated(MouseAccel);
		}
		if(EqualEqual_FloatFloat(VSize(MouseAccel), float(0)))
		{
			GetCurrentControllable().AdjustMouseAcceleration(MouseAccel);
		}
	}
	if(NotEqual_FloatFloat(VSize(MouseAccel), float(0)))
	{
		AddEqual_IntInt(CameraRotation.Yaw, int(Multiply_FloatFloat(MouseAccel.X, GetCurrentControllable().GetViewportYawSpeed())));
		AddEqual_IntInt(CameraRotation.Pitch, int(Multiply_FloatFloat(MouseAccel.Y, GetCurrentControllable().GetViewportPitchSpeed())));
		ViewRotation = OriginalRotation;
		if(NotEqual_FloatFloat(GetCurrentControllable().GetViewportYawClamp(), float(0)))
		{
			YawRange.Min = float(Subtract_IntInt(ViewRotation.Yaw, DegreesToUnreal(int(GetCurrentControllable().GetViewportYawClamp()))));
			YawRange.Max = float(Add_IntInt(ViewRotation.Yaw, DegreesToUnreal(int(GetCurrentControllable().GetViewportYawClamp()))));
			CameraRotation.Yaw = Clamp(CameraRotation.Yaw, int(YawRange.Min), int(YawRange.Max));
		}
		if(NotEqual_FloatFloat(GetCurrentControllable().GetViewportPitchClamp(), float(0)))
		{
			PitchRange.Min = float(Subtract_IntInt(ViewRotation.Pitch, DegreesToUnreal(int(GetCurrentControllable().GetViewportPitchClamp()))));
			PitchRange.Max = float(Add_IntInt(ViewRotation.Pitch, DegreesToUnreal(int(GetCurrentControllable().GetViewportPitchClamp()))));
			CameraRotation.Pitch = Clamp(CameraRotation.Pitch, int(PitchRange.Min), int(PitchRange.Max));
		}
	}
	if(ShouldControlViewport())
	{
		GetCurrentControllable().OffsetViewportRotation(CameraRotation);
	}
	CameraRotation = RotatorLerp(LastViewRotation, CameraRotation, Multiply_FloatFloat(8.0000000, LastDeltaTime));
	CameraLocation = Add_VectorVector(LastViewLocation, Multiply_FloatVector(Multiply_FloatFloat(float(6), LastDeltaTime), Subtract_VectorVector(CameraLocation, LastViewLocation)));
	LastViewRotation = CameraRotation;
	LastViewLocation = CameraLocation;
	return;
}

simulated function OnBeginControlling()
{
	GetCurrentControllable().OnBeginControlling();
	return;
}

simulated function OnEndControlling()
{
	GetCurrentControllable().OnEndControlling();
	return;
}

simulated function HandleReload()
{
	GetCurrentControllable().HandleReload();
	return;
}

simulated function HandleFire()
{
	GetCurrentControllable().HandleFire();
	return;
}

simulated function HandleAltFire()
{
	GetCurrentControllable().HandleAltFire();
	return;
}

private simulated function DrawViewport(Canvas inCanvas, int X, int Y, int W, int H)
{
	local Rotator ViewRotation;
	local Vector ViewLocation;
	local float FOV;

	if(NotEqual_ObjectObject(GetCurrentControllable(), none))
	{
		ViewportCalcView(ViewLocation, ViewRotation);
		FOV = GetCurrentControllable().GetFOV();
		if(EqualEqual_FloatFloat(FOV, float(0)))
		{
			FOV = kViewportFOV;
		}
		inCanvas.DrawPortal(X, Y, W, H, GetCurrentControllable().GetViewportOwner(), ViewLocation, ViewRotation, int(FOV), true);
		if(Not_PreBool(GetCurrentControllable().ShouldDrawViewport()))
		{
			inCanvas.SetPos(0.0000000, 0.0000000);
			inCanvas.SetDrawColor(byte(255), byte(255), byte(255), byte(0.1000000));
			inCanvas.DrawTile(DeadTexture, float(W), float(H), 0.0000000, 0.0000000, 256.0000000, 256.0000000);
		}
		if(NotEqual_ObjectObject(GetCurrentControllable().GetViewportOverlay(), none))
		{
			inCanvas.SetPos(0.0000000, 0.0000000);
			inCanvas.SetDrawColor(byte(255), byte(255), byte(255), byte(0.1000000));
			inCanvas.DrawTileClipped(GetCurrentControllable().GetViewportOverlay(), float(W), float(H), 0.0000000, 0.0000000, 512.0000000, 512.0000000);
		}
		inCanvas.SetPos(0.0000000, 0.0000000);
	}
	return;
}

simulated function Tick(float DeltaTime)
{
	LastDeltaTime = FMin(DeltaTime, 0.1000000);
	return;
}

simulated function HideViewport()
{
	return;
}

simulated event Destroyed()
{
	SwatGameInfo(Level.Game).GameEvents.GameStarted.UnRegister(self);
	SwatGameInfo(Level.Game).GameEvents.MissionEnded.UnRegister(self);
	super.Destroyed();
	return;
}

defaultproperties
{
	kDefaultSizeX=0.3000000
	kDefaultSizeY=0.2500000
	kActiveSizeX=0.5500000
	kActiveSizeY=0.5000000
	kZoomRate=0.7000000
	kViewportFOV=109.0000000
	kViewportRightPadding=0.0200000
	kViewportTopPadding=0.0500000
	OfficerFontName="SwatOSBold"
	kNegativeFontYOffset=18.0000000
	kNegativeFontXOffset=8.0000000
	CurrentSizeX=0.3000000
	CurrentSizeY=0.2500000
	BaseControllableClass=Class'SwatGame.SwatPawn'
	DeadTexture=Shader'HUD.DeadOfficerStaticShader'
	ReticleTexture=Texture'HUD.ToolReticle'
	bHidden=true
	RemoteRole=0
}