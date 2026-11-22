class DemoRecSpectator extends PlayerController
	config(User)
	notplaceable
	hidecategories(Karma);

var bool bTempBehindView;
var bool bFoundPlayer;

event PostBeginPlay()
{
	local Class<HUD> HudClass;
	local Class<ScoreBoard> ScoreboardClass;

	if(AndAnd_BoolBool(EqualEqual_IntInt(int(Role), int(ROLE_Authority)), NotEqual_ObjectObject(Level.Game, none)))
	{
		HudClass = Class<HUD>(DynamicLoadObject(Level.Game.HUDType, Class'Core.Class'));
		if(EqualEqual_ObjectObject(HudClass, none))
		{
			Log(Concat_StrStr("Can't find HUD class ", Level.Game.HUDType), 'Error');
		}
		ScoreboardClass = Class<ScoreBoard>(DynamicLoadObject(Level.Game.ScoreBoardType, Class'Core.Class'));
		if(EqualEqual_ObjectObject(ScoreboardClass, none))
		{
			Log(Concat_StrStr("Can't find HUD class ", Level.Game.ScoreBoardType), 'Error');
		}
		ClientSetHUD(HudClass, ScoreboardClass);
	}
	super.PostBeginPlay();
	if(NotEqual_ObjectObject(PlayerReplicationInfo, none))
	{
		PlayerReplicationInfo.bOutOfLives = true;
	}
	return;
}

function InitPlayerReplicationInfo()
{
	super(Controller).InitPlayerReplicationInfo();
	PlayerReplicationInfo.PlayerName = "DemoRecSpectator";
	PlayerReplicationInfo.bIsSpectator = true;
	PlayerReplicationInfo.bOnlySpectator = true;
	PlayerReplicationInfo.bOutOfLives = true;
	PlayerReplicationInfo.bWaitingPlayer = false;
	return;
}

exec function ViewClass(Class<Actor> aClass, optional bool bQuiet, optional bool bCheat)
{
	local Actor Other, first;
	local bool bFound;

	first = none;
	foreach AllActors(aClass, Other)
	{
		if(OrOr_BoolBool(bFound, EqualEqual_ObjectObject(first, none)))
		{
			first = Other;
			if(bFound)
			{
				break;
			}
		}
		if(EqualEqual_ObjectObject(Other, ViewTarget))
		{
			bFound = true;
		}
	}
	if(NotEqual_ObjectObject(first, none))
	{
		SetViewTarget(first);
		bBehindView = NotEqual_ObjectObject(ViewTarget, self);
		if(bBehindView)
		{
			ViewTarget.BecomeViewTarget();
		}
	}
	else
	{
		SetViewTarget(self);
	}
	return;
}

exec function DemoViewNextPlayer()
{
	local Controller C, Pick;
	local bool bFound;

	if(NotEqual_ObjectObject(PlayerController(RealViewTarget), none))
	{
		PlayerController(RealViewTarget).DemoViewer = none;
	}
	foreach DynamicActors(Class'Engine.Controller', C)
	{
		if(OrOr_BoolBool(OrOr_BoolBool(EqualEqual_ObjectObject(C, self), EqualEqual_ObjectObject(PlayerController(C), none)), Not_PreBool(PlayerController(C).IsSpectating())))
		{
			if(AndAnd_BoolBool(EqualEqual_ObjectObject(GameReplicationInfo, none), NotEqual_ObjectObject(PlayerController(C), none)))
			{
				GameReplicationInfo = PlayerController(C).GameReplicationInfo;
			}
			if(EqualEqual_ObjectObject(Pick, none))
			{
				Pick = C;
			}
			if(bFound)
			{
				Pick = C;
				break;
				continue;
			}
			bFound = OrOr_BoolBool(EqualEqual_ObjectObject(RealViewTarget, C), EqualEqual_ObjectObject(ViewTarget, C));
		}
	}
	SetViewTarget(Pick);
	if(NotEqual_ObjectObject(PlayerController(RealViewTarget), none))
	{
		PlayerController(RealViewTarget).DemoViewer = self;
	}
	return;
}

event PlayerCalcView(out Actor ViewActor, out Vector CameraLocation, out Rotator CameraRotation)
{
	local Rotator R;

	if(NotEqual_ObjectObject(RealViewTarget, none))
	{
		R = RealViewTarget.Rotation;
	}
	super.PlayerCalcView(ViewActor, CameraLocation, CameraRotation);
	if(NotEqual_ObjectObject(RealViewTarget, none))
	{
		if(Not_PreBool(bBehindView))
		{
			CameraRotation = R;
			if(NotEqual_ObjectObject(Pawn(ViewTarget), none))
			{
				AddEqual_FloatFloat(CameraLocation.Z, Pawn(ViewTarget).BaseEyeHeight);
			}
		}
		RealViewTarget.SetRotation(R);
	}
	return;
}

auto state Spectating
{
	exec function Fire()
	{
		bBehindView = false;
		DemoViewNextPlayer();
		return;
	}

	event PlayerTick(float DeltaTime)
	{
		super(PlayerController).PlayerTick(DeltaTime);
		if(AndAnd_BoolBool(AndAnd_BoolBool(EqualEqual_IntInt(int(Role), int(ROLE_AutonomousProxy)), OrOr_BoolBool(EqualEqual_ObjectObject(RealViewTarget, none), EqualEqual_ObjectObject(RealViewTarget, self))), Not_PreBool(bFoundPlayer)))
		{
			DemoViewNextPlayer();
			if(AndAnd_BoolBool(NotEqual_ObjectObject(RealViewTarget, none), NotEqual_ObjectObject(RealViewTarget, self)))
			{
				bFoundPlayer = true;
			}
		}
		if(AndAnd_BoolBool(NotEqual_ObjectObject(RealViewTarget, none), EqualEqual_ObjectObject(RealViewTarget.Pawn, none)))
		{
			if(Not_PreBool(bTempBehindView))
			{
				bTempBehindView = true;
				bBehindView = true;
			}
		}
		else
		{
			if(bTempBehindView)
			{
				bBehindView = false;
				bTempBehindView = false;
			}
		}
		return;
	}
	stop;
}

defaultproperties
{
	RemoteRole=3
	bDemoOwner=true
}