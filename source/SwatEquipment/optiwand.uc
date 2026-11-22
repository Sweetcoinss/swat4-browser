class optiwand extends HandheldEquipment implements IControllableViewport
	config(SwatEquipment)
	hidecategories(Karma);

const kOptiwandLength = 90.0;

var private config ScriptedTexture LCDScreen;
var private config float RefreshRate;
var private config Texture ReticleTexture;
var private config Material BlankScreen;
var private config Material LCDShader;
var private config Material GunShader;
var private const config int SizeX;
var private const config int SizeY;
var private const config int FOV;
var private const config float LensTurnAlpha;
var private const config float LensTurnSpeed;
var private const config float LensFinishSpeed;
var private const config int ClampYawAngle;
var private const config int ClampPitchAngle;
var private config name BoneName;
var private Vector MouseAccel;
var private Rotator DesiredViewRotation;
var private Rotator BoneRotation;
var private Vector LastViewLocation;
var private float TimerFreq;
var private bool bMirroring;
var private SwatDoor MirroringDoor;
var private bool CompletedUsing;
var private float LastDeltaTime;

simulated function PostBeginPlay()
{
	super.PostBeginPlay();
	Disable('Tick');
	return;
}

simulated function int DegreesToUnreal(int inDegrees)
{
	return Divide_IntInt(Multiply_IntInt(65536, inDegrees), 360);
	return;
}

simulated function EquippedHook()
{
	super.EquippedHook();
	FirstPersonModel.SetBoneDirection(BoneName, rot(0, 0, 0),, 1.0000000, 0);
	return;
}

simulated function OnGivenToOwner()
{
	MPLog(Concat_StrStr(string(self), "---Optiwand::OnGivenToOwner()."));
	if(AndAnd_BoolBool(NotEqual_ObjectObject(Pawn(Owner), none), EqualEqual_ObjectObject(Pawn(Owner).Controller, Level.GetLocalPlayerController())))
	{
		MPLog(Concat_StrStr(string(self), " assigning gunshader and blankshader."));
		LCDScreen.Client = self;
		LCDScreen.SetSize(SizeX, SizeY);
		assert(NotEqual_ObjectObject(FirstPersonModel, none));
		FirstPersonModel.Skins[0] = GunShader;
		FirstPersonModel.Skins[1] = BlankScreen;
		TimerFreq = Divide_FloatFloat(1.0000000, RefreshRate);
	}
	return;
}

simulated event Destroyed()
{
	if(AndAnd_BoolBool(NotEqual_ObjectObject(LCDScreen, none), EqualEqual_ObjectObject(LCDScreen.Client, self)))
	{
		LCDScreen.Client = none;
	}
	super.Destroyed();
	return;
}

simulated function SetInput(int dMouseX, int dMouseY)
{
	MouseAccel.X = float(dMouseX);
	MouseAccel.Y = float(dMouseY);
	return;
}

simulated function bool CanIssueCommands()
{
	return false;
	return;
}

simulated function OnBeginControlling()
{
	AssertWithDescription(NotEqual_ObjectObject(FirstPersonModel, none), Concat_StrStr(string(self), ", does not have a firstpersonmodel!!"));
	return;
}

simulated function OnEndControlling()
{
	AssertWithDescription(NotEqual_ObjectObject(FirstPersonModel, none), Concat_StrStr(string(self), ", does not have a firstpersonmodel!!"));
	FirstPersonModel.Skins[1] = BlankScreen;
	FirstPersonModel.SetBoneDirection(BoneName, rot(0, 0, 0),, 0.0000000, 1);
	return;
}

simulated function name GetControllingStateName()
{
	return 'ControllingOptiwandViewport';
	return;
}

simulated function bool ShouldControlViewport()
{
	return NotEqual_IntInt(int(PlayerController(Pawn(Owner).Controller).bFire), 0);
	return;
}

simulated function ResolveInitialLocationAndRotation(out Vector CameraLocation, out Rotator PlayerViewRot)
{
	local name DoorBoneName;
	local Vector X, Y, Z;

	if(AndAnd_BoolBool(NotEqual_IntInt(int(Level.NetMode), int(NM_Standalone)), EqualEqual_ObjectObject(FirstPersonModel, none)))
	{
		GetAxes(Owner.Rotation, X, Y, Z);
		CameraLocation = Add_VectorVector(Add_VectorVector(Owner.Location, Multiply_VectorFloat(X, 90.0000000)), Multiply_VectorFloat(Z, float(20)));
	}
	else
	{
		if(bMirroring)
		{
			if(MirroringDoor.ActorIsToMyLeft(Owner))
			{
				DoorBoneName = 'OptiwandRIGHT';
			}
			else
			{
				DoorBoneName = 'OptiwandLEFT';
			}
			CameraLocation = MirroringDoor.GetBoneCoords(DoorBoneName, true).Origin;
			PlayerViewRot = Owner.Rotation;
		}
		else
		{
			if(NotEqual_ObjectObject(FirstPersonModel, none))
			{
				CameraLocation = FirstPersonModel.GetBoneCoords(BoneName, true).Origin;
			}
			else
			{
				CameraLocation = Owner.Location;
			}
			PlayerViewRot = Pawn(Owner).GetViewRotation();
		}
	}
	return;
}

simulated function ViewportCalcView(out Vector CameraLocation, out Rotator CameraRotation)
{
	local Rotator PlayerViewRot;
	local Quat OldQuat, NewQuat;
	local Range YawRange, PitchRange;

	ResolveInitialLocationAndRotation(CameraLocation, PlayerViewRot);
	if(NotEqual_FloatFloat(VSize(MouseAccel), float(0)))
	{
		AddEqual_IntInt(DesiredViewRotation.Yaw, int(Multiply_FloatFloat(Multiply_FloatFloat(MouseAccel.X, LensTurnSpeed), LastDeltaTime)));
		AddEqual_IntInt(DesiredViewRotation.Pitch, int(Multiply_FloatFloat(Multiply_FloatFloat(MouseAccel.Y, LensTurnSpeed), LastDeltaTime)));
		YawRange.Min = float(Subtract_IntInt(PlayerViewRot.Yaw, DegreesToUnreal(ClampYawAngle)));
		YawRange.Max = float(Add_IntInt(PlayerViewRot.Yaw, DegreesToUnreal(ClampYawAngle)));
		PitchRange.Min = float(Subtract_IntInt(PlayerViewRot.Pitch, DegreesToUnreal(ClampPitchAngle)));
		PitchRange.Max = float(Add_IntInt(PlayerViewRot.Pitch, DegreesToUnreal(ClampPitchAngle)));
		DesiredViewRotation.Yaw = Clamp(DesiredViewRotation.Yaw, int(YawRange.Min), int(YawRange.Max));
		DesiredViewRotation.Pitch = Clamp(DesiredViewRotation.Pitch, int(PitchRange.Min), int(PitchRange.Max));
	}
	if(EqualEqual_ObjectObject(FirstPersonModel, none))
	{
		CameraRotation = DesiredViewRotation;
	}
	else
	{
		OldQuat = QuatFromRotator(FirstPersonModel.GetBoneRotation(BoneName, 1));
		NewQuat = QuatFromRotator(DesiredViewRotation);
		BoneRotation = QuatToRotator(QuatSlerp(OldQuat, NewQuat, LensTurnAlpha));
		FirstPersonModel.SetBoneDirection(BoneName, BoneRotation,,, 1);
		CameraRotation = BoneRotation;
	}
	return;
}

simulated function HandleFire()
{
	return;
}

simulated function HandleAltFire()
{
	return;
}

simulated function HandleReload()
{
	return;
}

simulated function IControllableThroughViewport GetCurrentControllable()
{
	return;
}

simulated function bool ShouldUseWhileLowReady()
{
	return CanUseNow();
	return;
}

simulated function bool ShouldLowReadyOnOfficers()
{
	return false;
	return;
}

simulated function bool ShouldLowReadyOnArrestable()
{
	return false;
	return;
}

simulated function bool CanUseNow()
{
	local SwatGamePlayerController PC;
	local FireInterface FireInterface;
	local Vector X, Y, Z;

	if(AndAnd_BoolBool(NotEqual_ObjectObject(FirstPersonModel, none), EqualEqual_ObjectObject(MirroringDoor, none)))
	{
		GetAxes(Owner.Rotation, X, Y, Z);
		if(Not_PreBool(FastTrace(Add_VectorVector(Owner.Location, Multiply_VectorFloat(X, 90.0000000)), Owner.Location)))
		{
			Log("fast trace blocked!");
			return false;
		}
	}
	if(AndAnd_BoolBool(NotEqual_ObjectObject(SwatPawn(Owner), none), Not_PreBool(SwatPawn(Owner).IsLowReady())))
	{
		return true;
	}
	PC = SwatGamePlayerController(Pawn(Owner).Controller);
	if(EqualEqual_ObjectObject(PC, none))
	{
		return false;
	}
	FireInterface = FireInterface(PC.GetFocusInterface(1));
	if(EqualEqual_ObjectObject(FireInterface, none))
	{
		return false;
	}
	return FireInterface.HasContext('OptiwandOnDoor');
	return;
}

simulated function InterruptUsing()
{
	local name EndAnim;

	if(Not_PreBool(CompletedUsing))
	{
		OnUsingFinished();
		if(bMirroring)
		{
			EndAnim = 'optiwandDoorUseEnd';
		}
		else
		{
			EndAnim = 'optiwandUseEnd';
		}
		SoundEffectsSubsystem(EffectsSystem(Level.EffectsSystem).GetSubsystem('SoundEffectsSubsystem')).StopMySchemas(Pawn(Owner).GetHands());
		Pawn(Owner).GetHands().PlayAnim(EndAnim);
		Disable('Tick');
	}
	return;
}

protected latent simulated function OnUsingBegan()
{
	return;
}

simulated function PreUse()
{
	super.PreUse();
	CompletedUsing = false;
	return;
}

protected latent simulated function DoUsingHook()
{
	local Hands Hands;
	local Pawn PawnOwner;
	local SwatGamePlayerController PC;
	local SwatPlayer PlayerOwner;
	local Quat OldQuat, NewQuat;
	local Rotator ViewRot;
	local name UseAnim, EndAnim;

	AssertWithDescription(NotEqual_ObjectObject(FirstPersonModel, none), Concat_StrStr(string(self), ", does not have a firstpersonmodel!!"));
	AssertWithDescription(Owner.IsA('SwatPawn'), Concat_StrStr(Concat_StrStr(Concat_StrStr(string(self), " has an owner - "), string(Owner)), " that is NOT a swatpawn!"));
	MPLog(Concat_StrStr(string(self), " DoUsingHook() Latent function 1"));
	PawnOwner = Pawn(Owner);
	PlayerOwner = SwatPlayer(Owner);
	PC = SwatGamePlayerController(PlayerOwner.Controller);
	if(NotEqual_ObjectObject(PC, none))
	{
		MirroringDoor = PC.GetDoorInWay();
		bMirroring = NotEqual_ObjectObject(MirroringDoor, none);
	}
	Hands = PawnOwner.GetHands();
	MPLog(Concat_StrStr(string(self), " DoUsingHook() Latent function 2"));
	if(Not_PreBool(CanUseNow()))
	{
		CompletedUsing = true;
		return;
	}
	Enable('Tick');
	MPLog(Concat_StrStr(string(self), " DoUsingHook() Latent function 3"));
	if(NotEqual_ObjectObject(PlayerOwner, none))
	{
		if(bMirroring)
		{
			UseAnim = 'optiwandDoorUse';
			EndAnim = 'optiwandDoorUseEnd';
			DesiredViewRotation = Pawn(Owner).Rotation;
		}
		else
		{
			UseAnim = 'optiwandUse';
			EndAnim = 'optiwandUseEnd';
			DesiredViewRotation = Pawn(Owner).GetViewRotation();
		}
	}
	FirstPersonModel.SetBoneDirection(BoneName, DesiredViewRotation,,, 1);
	MPLog(Concat_StrStr(string(self), " DoUsingHook() Latent function 4"));
	if(NotEqual_ObjectObject(Hands, none))
	{
		Hands.PlayAnim(UseAnim);
		Hands.FinishAnim();
	}
	MPLog(Concat_StrStr(string(self), " DoUsingHook() Latent function 5"));
	if(NotEqual_ObjectObject(PlayerOwner, none))
	{
		AddAdd_Int(LCDScreen.Revision);
		FirstPersonModel.Skins[1] = LCDShader;
	}
	MPLog(Concat_StrStr(string(self), " DoUsingHook() Latent function 6"));
	J0x31E:

	if(ShouldControlViewport())
	{
		Sleep(TimerFreq);
		AddAdd_Int(LCDScreen.Revision);
		// [Loop Continue]
		goto J0x31E;
	}
	if(NotEqual_ObjectObject(PlayerOwner, none))
	{
		FirstPersonModel.Skins[1] = BlankScreen;
	}
	MPLog(Concat_StrStr(string(self), " DoUsingHook() Latent function 7"));
	ViewRot = Pawn(Owner).GetViewRotation();
	J0x3AA:

	if(Greater_FloatFloat(VSize(Subtract_VectorVector(Vector(BoneRotation), Vector(ViewRot))), 0.1000000))
	{
		Sleep(0.0000000);
		OldQuat = QuatFromRotator(FirstPersonModel.GetBoneRotation(BoneName, 1));
		NewQuat = QuatFromRotator(Pawn(Owner).GetViewRotation());
		BoneRotation = QuatToRotator(QuatSlerp(OldQuat, NewQuat, LensFinishSpeed));
		FirstPersonModel.SetBoneDirection(BoneName, BoneRotation,, 1.0000000, 1);
		// [Loop Continue]
		goto J0x3AA;
	}
	MPLog(Concat_StrStr(string(self), " DoUsingHook() Latent function 8"));
	if(NotEqual_ObjectObject(Hands, none))
	{
		Hands.PlayAnim(EndAnim);
		Hands.FinishAnim();
	}
	bMirroring = false;
	MirroringDoor = none;
	CompletedUsing = true;
	Disable('Tick');
	return;
}

simulated event RenderTexture(ScriptedTexture inTexture)
{
	local Vector DrawLoc;
	local Rotator DrawRot;
	local Color White;

	White.R = byte(255);
	White.G = 0;
	White.B = 0;
	ViewportCalcView(DrawLoc, DrawRot);
	LCDScreen.DrawPortal(0, 0, SizeX, SizeY, Level.GetLocalPlayerController(), DrawLoc, DrawRot, FOV);
	return;
}

simulated function Tick(float DeltaTime)
{
	LastDeltaTime = DeltaTime;
	return;
}

defaultproperties
{
	LCDScreen=ScriptedTexture'scripted_tex.lcd_scripted_tex'
	RefreshRate=60.0000000
	ReticleTexture=Texture'HUD.ToolReticle'
	BlankScreen=TexPanner'Hotel.hot_blueroll_panner'
	LCDShader=Shader'scripted_tex.lcd_shader'
	GunShader=Shader'SWAT1stPersonTex.Optiwand1stPersonShader'
	SizeX=256
	SizeY=256
	FOV=60
	LensTurnSpeed=0.0500000
	LensFinishSpeed=0.1000000
	ClampYawAngle=60
	ClampPitchAngle=45
	BoneName="Lens"
	Slot=9
	DrawType=2
}