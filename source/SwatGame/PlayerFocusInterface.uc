class PlayerFocusInterface extends Actor
	abstract
	native
	config(PlayerFocusInterface)
	notplaceable
	hidecategories(Karma);

cpptext
{
    virtual UBOOL DoorRelatedContextMatches(UPlayerInterfaceDoorRelatedContext* DoorRelatedContext, ASwatDoor* Door) { return false; }
    virtual UBOOL ContextMatches(UPlayerInterfaceContext* inContext, AActor* Candidate) { return false; }

}

const MAX_FOCI = 3;

enum DoorPart
{
	DoorPart_Animation,             // 0
	DoorPart_Model,                 // 1
	DoorPart_Way,                   // 2
	DoorPart_Any                    // 3
};

struct native Focus
{
	var private name Context;
	var private Actor Actor;
	var private Vector Location;
	var private Vector Normal;
	var private Material Material;
	var private Actor.ESkeletalRegion Region;
};

var const config float Range;
var array<Focus> Foci;
var private int FociLength;
var private bool FocusIsBlocked;
var config array<name> DoorRelatedContext;
var Class<PlayerInterfaceDoorRelatedContext> DoorRelatedContextClass;
var config array<PlayerInterfaceDoorRelatedContext> DoorRelatedContexts;
var config array<name> Context;
var Class<PlayerInterfaceContext> ContextClass;
var config array<PlayerInterfaceContext> Contexts;
var bool AlwaysAddDoor;
var private SwatGamePlayerController PlayerController;
var private SwatPlayer PlayerPawn;
var private name FocusInterfaceType;

simulated function PostBeginPlay()
{
	local Focus Junk;
	local int i;

	super.PostBeginPlay();
	SetFocusInterfaceType();
	Foci[3] = Junk;
	i = 0;
	J0x21:

	if(Less_IntInt(i, Context.Length))
	{
		Contexts[i] = ContextClass.static.Allocate(self, none, string(Context[i])).;
		Construct_Void();
		assert(NotEqual_ObjectObject(Contexts[i], none));
		AddAdd_PreInt(i);
		// [Loop Continue]
		goto J0x21;
	}
	i = 0;
	J0x88:

	if(Less_IntInt(i, DoorRelatedContext.Length))
	{
		DoorRelatedContexts[DoorRelatedContexts.Length] = DoorRelatedContextClass.static.Allocate(self, none, string(DoorRelatedContext[i])).;
		Construct_Void();
		assert(NotEqual_ObjectObject(DoorRelatedContexts[i], none));
		AddAdd_PreInt(i);
		// [Loop Continue]
		goto J0x88;
	}
	return;
}

simulated function SetFocusInterfaceType()
{
	FocusInterfaceType = Class.Name;
	return;
}

final simulated function bool PreUpdate(SwatGamePlayerController Player, HUDPageBase HUDPage)
{
	PlayerController = SwatGamePlayerController(Level.GetLocalPlayerController());
	PlayerPawn = SwatPlayer(SwatGamePlayerController(Level.GetLocalPlayerController()).Pawn);
	return PreUpdateHook(Player, HUDPage);
	return;
}

protected simulated function bool PreUpdateHook(SwatGamePlayerController Player, HUDPageBase HUDPage)
{
	return true;
	return;
}

final simulated function ResetFocus(SwatGamePlayerController Player, HUDPageBase HUDPage)
{
	FociLength = 0;
	FocusIsBlocked = false;
	ResetFocusHook(Player, HUDPage);
	return;
}

protected simulated function ResetFocusHook(SwatGamePlayerController Player, HUDPageBase HUDPage)
{
	return;
}

static final simulated function bool StaticRejectFocus(SwatGamePlayerController Player, Actor CandidateActor, Vector CandidateLocation, Vector CandidateNormal, Material CandidateMaterial, Actor.ESkeletalRegion CandidateSkeletalRegion, float Distance, bool Transparent, bool bAuditFocus)
{
	local IControllableThroughViewport CurrentControllable;

	if(AndAnd_BoolBool(AndAnd_BoolBool(AndAnd_BoolBool(AndAnd_BoolBool(OrOr_BoolBool(CandidateActor.bHidden, EqualEqual_IntInt(int(CandidateActor.DrawType), int(0))), Not_PreBool(CandidateActor.IsA('LevelInfo'))), Not_PreBool(CandidateActor.IsA('DoorWay'))), Not_PreBool(CandidateActor.IsA('MirrorPoint'))), Not_PreBool(CandidateActor.IsA('DoorBufferVolume'))))
	{
		if(bAuditFocus)
		{
			Log(Concat_StrStr(Concat_StrStr("[FOCUS] ... ... PlayerFocusInterface::StaticRejectFocus() ", string(CandidateActor.Class.Name)), " was rejected because it is Invisible."));
		}
		return true;
	}
	if(CandidateActor.IsA('FluidSurfaceInfo'))
	{
		return true;
	}
	if(AndAnd_BoolBool(NotEqual_ObjectObject(Player.ActiveViewport, none), Player.ActiveViewport.CanIssueCommands()))
	{
		CurrentControllable = Player.GetExternalViewportManager().GetCurrentControllable();
		if(EqualEqual_ObjectObject(CandidateActor, CurrentControllable))
		{
			return true;
		}
	}
	else
	{
		if(EqualEqual_ObjectObject(CandidateActor, Player.Pawn))
		{
			return true;
		}
	}
	return false;
	return;
}

// Export UPlayerFocusInterface::execRejectFocus(FFrame&, void* const)
native function bool RejectFocus(PlayerController Player, Actor CandidateActor, Vector CandidateLocation, Vector CandidateNormal, Material CandidateMaterial, Actor.ESkeletalRegion CandidateSkeletalRegion, float Distance, bool Transparent);

// Export UPlayerFocusInterface::execConsiderNewFocus(FFrame&, void* const)
native function ConsiderNewFocus(SwatPlayer Player, Actor CandidateActor, float Distance, Vector CandidateLocation, Vector CandidateNormal, Material CandidateMaterial, Actor.ESkeletalRegion CandidateSkeletalRegion, bool Transparent);

protected simulated event PostContextMatched(PlayerInterfaceContext Context, Actor Target)
{
	return;
}

protected simulated event PostDoorRelatedContextMatched(PlayerInterfaceDoorRelatedContext Context, Actor Target)
{
	return;
}

final simulated event AddFocus(name Context, Actor Actor, Vector Location, Vector Normal, Material Material, optional Actor.ESkeletalRegion Region)
{
	AssertWithDescription(NotEqual_ObjectObject(Actor, none), Concat_StrStr(Concat_StrStr("[tcohen] ", string(Class.Name)), " attempted to AddFocus() with Actor=None"));
	if(GreaterEqual_IntInt(FociLength, 3))
	{
		return;
	}
	Foci[FociLength].Context = Context;
	Foci[FociLength].Actor = Actor;
	Foci[FociLength].Location = Location;
	Foci[FociLength].Normal = Normal;
	Foci[FociLength].Material = Material;
	Foci[FociLength].Region = Region;
	AddAdd_Int(FociLength);
	return;
}

protected simulated event PostFocusAdded(PlayerInterfaceContext Context, Actor Target, Actor.ESkeletalRegion SkeletalRegionHit)
{
	return;
}

protected simulated event PostDoorRelatedFocusAdded(PlayerInterfaceDoorRelatedContext Context, Actor Target, Actor.ESkeletalRegion SkeletalRegionHit)
{
	return;
}

simulated function PostUpdate()
{
	return;
}

final simulated function Actor GetDefaultFocusActor()
{
	if(Greater_IntInt(FociLength, 0))
	{
		return Foci[0].Actor;
	}
	else
	{
		return none;
	}
	return;
}

final simulated function Vector GetDefaultFocusLocation()
{
	if(Greater_IntInt(FociLength, 0))
	{
		return Foci[0].Location;
	}
	else
	{
		return vect(0.0000000, 0.0000000, 0.0000000);
	}
	return;
}

protected final simulated function Actor GetFocusOfClass(name ClassName)
{
	local int i;

	i = 0;
	J0x07:

	if(Less_IntInt(i, FociLength))
	{
		if(AndAnd_BoolBool(NotEqual_ObjectObject(Foci[i].Actor, none), Foci[i].Actor.IsA(ClassName)))
		{
			return Foci[i].Actor;
		}
		AddAdd_PreInt(i);
		// [Loop Continue]
		goto J0x07;
	}
	return none;
	return;
}

private final simulated function int GetFociLength()
{
	return FociLength;
	return;
}

final simulated function bool HasContext(name Context)
{
	local int i;

	i = 0;
	J0x07:

	if(Less_IntInt(i, FociLength))
	{
		if(EqualEqual_NameName(Foci[i].Context, Context))
		{
			return true;
		}
		AddAdd_PreInt(i);
		// [Loop Continue]
		goto J0x07;
	}
	return false;
	return;
}

function DrawDebugText(Vector CameraLocation, Canvas Canvas, out int X, out int Y)
{
	local int i;
	local name materialName;
	local Material.EMaterialVisualType MVT;
	local float MTP;

	Canvas.SetPos(float(X), float(Y));
	if(Greater_IntInt(FociLength, 0))
	{
		Canvas.DrawText(Concat_StrStr(string(Class.Name), ":"));
		AddEqual_IntInt(Y, 15);
		i = 0;
		J0x59:

		if(Less_IntInt(i, FociLength))
		{
			if(NotEqual_IntInt(int(Foci[i].Region), int(0)))
			{
				Canvas.SetPos(float(Add_IntInt(X, 5)), float(Y));
				Canvas.DrawText(Concat_StrStr(Concat_StrStr(string(Add_IntInt(i, 1)), ": "), string(Foci[i].Context)));
				AddEqual_IntInt(Y, 10);
				Canvas.SetPos(float(Add_IntInt(X, 5)), float(Y));
				Canvas.DrawText(Concat_StrStr("   Actor    = ", string(Foci[i].Actor.Class.Name)));
				AddEqual_IntInt(Y, 10);
				Canvas.SetPos(float(Add_IntInt(X, 5)), float(Y));
				Canvas.DrawText(Concat_StrStr("   Distance = ", string(VSize(Subtract_VectorVector(Foci[i].Location, CameraLocation)))));
				AddEqual_IntInt(Y, 10);
				Canvas.SetPos(float(Add_IntInt(X, 5)), float(Y));
				Canvas.DrawText(Concat_StrStr("   Region   = ", string(GetEnum(Enum'Engine.Actor.ESkeletalRegion', int(Foci[i].Region)))));
				AddEqual_IntInt(Y, 10);
				Canvas.SetPos(float(Add_IntInt(X, 5)), float(Y));
				Canvas.DrawText(Concat_StrStr("   Location = ", string(Foci[i].Location)));
			}
			else
			{
				Canvas.SetPos(float(Add_IntInt(X, 5)), float(Y));
				Canvas.DrawText(Concat_StrStr(Concat_StrStr(string(Add_IntInt(i, 1)), ": "), string(Foci[i].Context)));
				AddEqual_IntInt(Y, 10);
				Canvas.SetPos(float(Add_IntInt(X, 5)), float(Y));
				Canvas.DrawText(Concat_StrStr("   Actor      = ", string(Foci[i].Actor.Class.Name)));
				AddEqual_IntInt(Y, 10);
				Canvas.SetPos(float(Add_IntInt(X, 5)), float(Y));
				Canvas.DrawText(Concat_StrStr("   Distance   = ", string(VSize(Subtract_VectorVector(Foci[i].Location, CameraLocation)))));
				AddEqual_IntInt(Y, 10);
				Canvas.SetPos(float(Add_IntInt(X, 5)), float(Y));
				if(EqualEqual_ObjectObject(Foci[i].Material, none))
				{
					materialName = 'None';
					MVT = 0;
					MTP = 0.0000000;
				}
				else
				{
					materialName = Foci[i].Material.Name;
					MVT = Foci[i].Material.MaterialVisualType;
					MTP = Foci[i].Actor.GetMomentumToPenetrate(vect(0.0000000, 0.0000000, 0.0000000), vect(0.0000000, 0.0000000, 0.0000000), Foci[i].Material);
				}
				Canvas.DrawText(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr("   Material   = ", string(materialName)), ", MVT = "), string(GetEnum(Enum'Engine.Material.EMaterialVisualType', int(MVT)))), ", MtP = "), string(MTP)));
				AddEqual_IntInt(Y, 10);
				Canvas.SetPos(float(Add_IntInt(X, 5)), float(Y));
				if(NotEqual_ObjectObject(Foci[i].Actor.StaticMesh, none))
				{
					Canvas.DrawText(Concat_StrStr("   StaticMesh = ", string(Foci[i].Actor.StaticMesh.Name)));
					AddEqual_IntInt(Y, 10);
					Canvas.SetPos(float(Add_IntInt(X, 5)), float(Y));
				}
				Canvas.DrawText(Concat_StrStr("   Location   = ", string(Foci[i].Location)));
			}
			AddEqual_IntInt(Y, 15);
			AddAdd_PreInt(i);
			// [Loop Continue]
			goto J0x59;
		}
	}
	else
	{
		Canvas.DrawText(Concat_StrStr(string(Class.Name), ": (No Focus)"));
		AddEqual_IntInt(Y, 15);
	}
	AddEqual_IntInt(Y, 5);
	return;
}

defaultproperties
{
	bHidden=true
	RemoteRole=0
}