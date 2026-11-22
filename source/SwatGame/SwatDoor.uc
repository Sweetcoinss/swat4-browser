class SwatDoor extends Door implements ISwatDoor, IAmUsedByToolkit, IAmUsedByWedge, IAmUsedByC2Charge, IHaveSkeletalRegions, ISwatDoor, IAmUsedByToolkit, IAmUsedByWedge, IAmUsedByC2Charge, IHaveSkeletalRegions
	abstract
	native
	config(SwatGame)
	hidecategories(Karma,Lighting,LightColor,Karma,Force);

enum ECommandDirection
{
	CD_BothSides,                   // 0
	CD_LeftSide,                    // 1
	CD_RightSide,                   // 2
	CD_NeitherSide                  // 3
};

enum EExternalSide
{
	ES_NeitherSide,                 // 0
	ES_LeftSide,                    // 1
	ES_RightSide                    // 2
};

enum EMoveReason
{
	MR_Interacted,                  // 0
	MR_Breached,                    // 1
	MR_Blasted                      // 2
};

struct native DoorAttachmentSpec
{
	var() StaticMesh StaticMesh;
	var() name AttachSocket;
	var() Vector AttachLocationOffset;
	var() Rotator AttachRotationOffset;
};

var bool bIsMissionExit "If true, when the player tries to open this door during a single-player mission he will be given the option to end the mission";
var private bool bIsLocked;
var private bool bCanBeLocked;
var private bool bWasInitiallyLocked;
var private bool bWasInitiallyOpen;
var bool bIsBroken;
var bool bIsAntiPortal "If true, this door will become an antiportal when closed";
var Vector AntiPortalScaleFactor "Determines the scale of the door's antiportal relative to the door model's collision geometry. Don't change unless you know what you are doing!";
var private AntiPortalActor DoorAntiPortal;
var bool bIsPushable "If true, this AIs will treat this door like it doesn't have a doorknob.";
var bool bPlayerCanUse "If false, then a Player is unable to interact with the door.";
var private bool bIsBoobyTrapped;
var private BoobyTrap BoobyTrap;
var array<DoorAttachmentSpec> Attachments;
var StaticMesh BrokenStaticMesh "This is the StaticMesh that will be used when the Door is broken";
var private Door.DoorPosition InitialPosition "The DoorPosition that the Door should start in";
var private Door.DoorPosition CurrentPosition;
var config float QualifyTimeForToolkit;
var config float QualifyTimeForWedge;
var config float QualifyTimeForC2Charge;
var DoorWay DoorWay;
var /*0x00000000-0x00080000*/ array<LeftStackupPoint> LeftStackupPoints;
var /*0x00000000-0x00080000*/ array<RightStackupPoint> RightStackupPoints;
var /*0x00000000-0x00080000*/ array<LeftClearPoint> LeftClearPoints;
var /*0x00000000-0x00080000*/ array<RightClearPoint> RightClearPoints;
var /*0x00000000-0x00080000*/ array<StackupPoint> AlternateLeftStackupPoints;
var /*0x00000000-0x00080000*/ array<StackupPoint> AlternateRightStackupPoints;
var /*0x00000000-0x00080000*/ edfindable AlternateStackupPoint LeftAlternatePlacedStackupPoints[4];
var /*0x00000000-0x00080000*/ edfindable AlternateStackupPoint RightAlternatePlacedStackupPoints[4];
var float LeftAdditionalGrenadeThrowDistance;
var float RightAdditionalGrenadeThrowDistance;
var string LeftRoomName "Name of the room to the right of this door (if looking from the hinge side of the door to the opposite side)";
var string RightRoomName "Name of the room to the left of this door (if looking from the hinge side of the door to the opposite side)";
var name LeftInternalRoomName;
var name RightInternalRoomName;
var private Pawn LastInteractor;
var private Pawn PendingInteractor;
var edfindable PlacedThrowPoint LeftPlacedThrowPoint;
var edfindable PlacedThrowPoint RightPlacedThrowPoint;
var private config name LeftSideBackOpenPointBoneName;
var private config name LeftSideFrontOpenPointBoneName;
var private config name LeftSideCenterOpenPointBoneName;
var private config name RightSideBackOpenPointBoneName;
var private config name RightSideFrontOpenPointBoneName;
var private config name RightSideCenterOpenPointBoneName;
var private config name OpenLeftAwayClosePointBoneName;
var private config name OpenLeftTowardsClosePointBoneName;
var private config name OpenRightAwayClosePointBoneName;
var private config name OpenRightTowardsClosePointBoneName;
var private config name RightSideKnobBreachPointBoneName;
var private config name RightSideHingeBreachPointBoneName;
var private config name LeftSideKnobBreachPointBoneName;
var private config name LeftSideHingeBreachPointBoneName;
var private bool bLeftSideBackOpenPointUsable;
var private bool bLeftSideFrontOpenPointUsable;
var private bool bLeftSideCenterOpenPointUsable;
var private bool bRightSideBackOpenPointUsable;
var private bool bRightSideFrontOpenPointUsable;
var private bool bRightSideCenterOpenPointUsable;
var private bool bRightSideKnobBreachPointUsable;
var private bool bRightSideHingeBreachPointUsable;
var private bool bLeftSideKnobBreachPointUsable;
var private bool bLeftSideHingeBreachPointUsable;
var private Vector LeftSideBackOpenPoint;
var private Vector LeftSideFrontOpenPoint;
var private Vector LeftSideCenterOpenPoint;
var private Vector RightSideBackOpenPoint;
var private Vector RightSideFrontOpenPoint;
var private Vector RightSideCenterOpenPoint;
var private Vector RightSideKnobBreachPoint;
var private Vector RightSideHingeBreachPoint;
var private Vector LeftSideKnobBreachPoint;
var private Vector LeftSideHingeBreachPoint;
var private Vector OpenLeftAwayClosePoint;
var private Vector OpenLeftTowardsClosePoint;
var private Vector OpenRightAwayClosePoint;
var private Vector OpenRightTowardsClosePoint;
var private config name LeftSideBackKnobOpenAnimation;
var private config name LeftSideFrontKnobOpenAnimation;
var private config name LeftSideCenterKnobOpenAnimation;
var private config name LeftSideBackPushOpenAnimation;
var private config name LeftSideFrontPushOpenAnimation;
var private config name LeftSideCenterPushOpenAnimation;
var private config name RightSideBackKnobOpenAnimation;
var private config name RightSideFrontKnobOpenAnimation;
var private config name RightSideCenterKnobOpenAnimation;
var private config name RightSideBackPushOpenAnimation;
var private config name RightSideFrontPushOpenAnimation;
var private config name RightSideCenterPushOpenAnimation;
var private config name LeftSideBackKnobTryAnimation;
var private config name LeftSideFrontKnobTryAnimation;
var private config name LeftSideCenterKnobTryAnimation;
var private config name LeftSideBackPushTryAnimation;
var private config name LeftSideFrontPushTryAnimation;
var private config name LeftSideCenterPushTryAnimation;
var private config name RightSideBackKnobTryAnimation;
var private config name RightSideFrontKnobTryAnimation;
var private config name RightSideCenterKnobTryAnimation;
var private config name RightSideBackPushTryAnimation;
var private config name RightSideFrontPushTryAnimation;
var private config name RightSideCenterPushTryAnimation;
var private config name LeftSideCenterFranticKnobOpenAnimation;
var private config name RightSideCenterFranticKnobOpenAnimation;
var private config name LeftSideCenterFranticPushOpenAnimation;
var private config name RightSideCenterFranticPushOpenAnimation;
var private config name OLBackTowardsKnobCloseAnimation;
var private config name OLBackTowardsPushCloseAnimation;
var private config name OLFrontTowardsKnobCloseAnimation;
var private config name OLFrontTowardsPushCloseAnimation;
var private config name OLFrontAwayKnobCloseAnimation;
var private config name OLFrontAwayPushCloseAnimation;
var private config name ORBackTowardsKnobCloseAnimation;
var private config name ORBackTowardsPushCloseAnimation;
var private config name ORFrontTowardsKnobCloseAnimation;
var private config name ORFrontTowardsPushCloseAnimation;
var private config name ORFrontAwayKnobCloseAnimation;
var private config name ORFrontAwayPushCloseAnimation;
var private config float MoveAndClearPauseThreshold;
var DoorBufferVolume DoorBufferVolume;
var StaticMesh DoorBufferVolumeCollisionMesh;
var string DeployedWedgeClassName;
var Class<Actor> DeployedWedgeClass;
var string DeployedC2ChargeClassName;
var Class<Actor> DeployedC2ChargeClass;
var private DeployedWedgeBase DeployedWedge;
var private DeployedC2ChargeBase DeployedC2ChargeLeft;
var private DeployedC2ChargeBase DeployedC2ChargeRight;
var SwatDoor.ECommandDirection AcceptsCommandsFrom "Only applies in single-player.  Designates the side from which squad commands can be given on this door. The side is determined by drawing an imaginary line from the door hinge to the doorknob; if the player is standing to the right of this line, then he/she is on the right side of the door. Doors which can be commanded from NeitherSide are only used for non-coop multiplayer maps.";
var SwatDoor.EExternalSide ExternalFacingSide "Designates which side of the door is facing the \"outside\". Hence if the door is ES_LeftSide and you are on the left side of the door, then \"Breach and Clear\" becomes \"Breach and Make Entry\" because you are going from the outside to the inside of the level.";
var private const transient SwatDoor.ECommandDirection PreviousAcceptsCommandsFrom;
var array<IInterestedInDoorOpening> InterestedInDoorOpeningRegistrants;
var array<Pawn> BlockingPawns;
var private int LockedKnowledge[2];
var private SwatDoor.EMoveReason ReasonForMove;
var private int RemainingUpdateAttachmentLocationsCounter;

replication
{
	// Pos:0x000
	reliable if(EqualEqual_IntInt(int(Role), int(ROLE_Authority)))
		DeployedC2ChargeLeft, DeployedC2ChargeRight,
		DeployedWedge, LockedKnowledge,
		ReasonForMove, bIsBroken,
		bIsLocked;
}

simulated function Door.DoorPosition GetPosition()
{
	return CurrentPosition;
	return;
}

simulated function bool IsChargePlacedOnLeft()
{
	return DeployedC2ChargeLeft.IsDeployed();
	return;
}

simulated function bool IsChargePlacedOnRight()
{
	return DeployedC2ChargeRight.IsDeployed();
	return;
}

simulated function bool WasDoorInitiallyLocked()
{
	return bWasInitiallyLocked;
	return;
}

simulated function bool WasDoorInitiallyOpen()
{
	return bWasInitiallyOpen;
	return;
}

simulated function PreBeginPlay()
{
	local int i;
	local DoorAttachment Attachment;

	super(Actor).PreBeginPlay();
	AssertWithDescription(NotEqual_ObjectObject(Mesh, none), Concat_StrStr(Concat_StrStr("[tcohen] The class ", string(Class.Name)), " has no Mesh set.  Terry should fix this."));
	SetDrawType(2);
	i = 0;
	J0x77:

	if(Less_IntInt(i, Attachments.Length))
	{
		Attachment = Spawn(Class'SwatGame.DoorAttachment', self);
		assert(NotEqual_ObjectObject(Attachment, none));
		Attachment.SetStaticMesh(Attachments[i].StaticMesh);
		AttachToBone(Attachment, Attachments[i].AttachSocket);
		Attachment.SetRelativeLocation(Attachments[i].AttachLocationOffset);
		Attachment.SetRelativeRotation(Attachments[i].AttachRotationOffset);
		AddAdd_PreInt(i);
		// [Loop Continue]
		goto J0x77;
	}
	AssertWithDescription(OrOr_BoolBool(Not_PreBool(IsLocked()), EqualEqual_IntInt(int(InitialPosition), int(0))), Concat_StrStr(Concat_StrStr("[tcohen] The SwatDoor named ", string(Name)), " is set to start Locked but not Closed."));
	CurrentPosition = 0;
	SetPositionForMove(GetInitialPosition(), 0);
	Moved(true);
	AssertWithDescription(OrOr_BoolBool(Not_PreBool(bIsLocked), bCanBeLocked), Concat_StrStr(string(Name), " is locked, but bCanBeLocked is false!  This is bad, set either bIsLocked to false or bCanBeLocked to true in UnrealEd!  (In the meantime this door will be set to be unlocked.)"));
	if(AndAnd_BoolBool(bIsLocked, Not_PreBool(bCanBeLocked)))
	{
		bIsLocked = false;
	}
	bWasInitiallyLocked = bIsLocked;
	bWasInitiallyOpen = IsOpen();
	if(NotEqual_ObjectObject(DoorBufferVolume, none))
	{
		if(Not_PreBool(IsOpen()))
		{
			DoorBufferVolume.EnableRepulsion();
		}
		else
		{
			DoorBufferVolume.DisableRepulsion();
		}
	}
	DeployedWedgeClass = Class<Actor>(DynamicLoadObject(DeployedWedgeClassName, Class'Core.Class'));
	DeployedC2ChargeClass = Class<Actor>(DynamicLoadObject(DeployedC2ChargeClassName, Class'Core.Class'));
	SpawnDeployedWedge();
	SpawnDeployedC2ChargeLeft();
	SpawnDeployedC2ChargeRight();
	SetCollision(true);
	SetCollisionSize(default.CollisionRadius, default.CollisionHeight);
	LockedKnowledge[0] = 0;
	LockedKnowledge[1] = 0;
	return;
}

simulated function PostBeginPlay()
{
	local Vector DoorWayDrawScale3D;

	super(NavigationPoint).PostBeginPlay();
	DoorWay = Spawn(Class'SwatGame.DoorWay', self);
	assert(NotEqual_ObjectObject(DoorWay, none));
	DoorWay.SetStaticMesh(StaticMesh);
	DoorWay.SetDrawScale(DrawScale);
	DoorWayDrawScale3D = DrawScale3D;
	MultiplyEqual_FloatFloat(DoorWayDrawScale3D.Y, 1.1000000);
	DoorWay.SetDrawScale3D(DoorWayDrawScale3D);
	return;
}

simulated function PostNetBeginPlay()
{
	if(Level.GetEngine().EnableDevTools)
	{
		MPLog(Concat_StrStr(string(self), "---SwatDoor::PostNetBeginPlay()."));
	}
	super(Actor).PostNetBeginPlay();
	return;
}

function Tick(float dTime)
{
	super(Actor).Tick(dTime);
	if(Greater_IntInt(RemainingUpdateAttachmentLocationsCounter, 0))
	{
		SubtractSubtract_Int(RemainingUpdateAttachmentLocationsCounter);
		if(OrOr_BoolBool(EqualEqual_IntInt(int(Level.NetMode), int(NM_ListenServer)), EqualEqual_IntInt(int(Level.NetMode), int(NM_DedicatedServer))))
		{
			if(Level.GetEngine().EnableDevTools)
			{
				MPLog("on server, updating attachment locations for door.");
			}
			UpdateAttachmentLocations();
		}
	}
	return;
}

simulated function Door.DoorPosition GetInitialPosition()
{
	return InitialPosition;
	return;
}

simulated function bool IsBoobyTrapped()
{
	return bIsBoobyTrapped;
	return;
}

simulated function SetBoobyTrap(BoobyTrap Trap)
{
	BoobyTrap = Trap;
	if(NotEqual_ObjectObject(Trap, none))
	{
		bIsBoobyTrapped = true;
	}
	else
	{
		bIsBoobyTrapped = false;
	}
	return;
}

private function bool IsInterestedInDoorOpeningRegistrant(IInterestedInDoorOpening Registrant)
{
	local int i;

	i = 0;
	J0x07:

	if(Less_IntInt(i, InterestedInDoorOpeningRegistrants.Length))
	{
		if(EqualEqual_ObjectObject(InterestedInDoorOpeningRegistrants[i], Registrant))
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

function RegisterInterestedInDoorOpening(IInterestedInDoorOpening Registrant)
{
	assert(Not_PreBool(IsInterestedInDoorOpeningRegistrant(Registrant)));
	InterestedInDoorOpeningRegistrants[InterestedInDoorOpeningRegistrants.Length] = Registrant;
	return;
}

function UnRegisterInterestedInDoorOpening(IInterestedInDoorOpening Registrant)
{
	local int i;

	i = 0;
	J0x07:

	if(Less_IntInt(i, InterestedInDoorOpeningRegistrants.Length))
	{
		if(EqualEqual_ObjectObject(InterestedInDoorOpeningRegistrants[i], Registrant))
		{
			InterestedInDoorOpeningRegistrants.Remove(i, 1);
			// [Explicit Break]
			goto J0x45;
		}
		AddAdd_PreInt(i);
		// [Loop Continue]
		goto J0x07;
	}
	J0x45:

	return;
}

private function NotifyRegistrantsDoorOpening()
{
	local int i;

	i = 0;
	J0x07:

	if(Less_IntInt(i, InterestedInDoorOpeningRegistrants.Length))
	{
		InterestedInDoorOpeningRegistrants[i].NotifyDoorOpening(self);
		AddAdd_PreInt(i);
		// [Loop Continue]
		goto J0x07;
	}
	return;
}

simulated function bool CanInteract()
{
	return AndAnd_BoolBool(Not_PreBool(IsBroken()), Not_PreBool(IsWedged()));
	return;
}

simulated function Interact(Pawn Other, optional bool Force)
{
	local SwatPawn PlayerPawn;
	local NetPlayer NetPlayerPawn;
	local SwatGamePlayerController PC;

	assert(NotEqual_IntInt(int(Level.NetMode), int(NM_Client)));
	AssertWithDescription(CanInteract(), Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr("[tcohen] SwatDoor::Interact() ", string(Other)), " tried to interact with "), string(Name)), ", but CanInteract() is false.  IsBroken()="), string(IsBroken())), ", IsWedged()="), string(IsWedged())));
	dispatchMessage(Class'Gameplay.MessageUsed'.static.Allocate(self)., construct_NameName(Other.Label, self.Label));
	if(AndAnd_BoolBool(bIsMissionExit, EqualEqual_IntInt(int(Level.NetMode), int(NM_Standalone))))
	{
		PC = SwatGamePlayerController(Level.GetLocalPlayerController());
		if(NotEqual_ObjectObject(PC, none))
		{
			PC.OnMissionExitDoorUsed();
		}
		return;
	}
	LastInteractor = Other;
	if(AndAnd_BoolBool(AndAnd_BoolBool(IsClosed(), bIsLocked), Not_PreBool(Force)))
	{
		BroadcastEffectEvent('LockedDoorTried');
		if(NotEqual_ObjectObject(Level.GetLocalPlayerController(), none))
		{
			PlayerPawn = SwatPawn(Level.GetLocalPlayerController().Pawn);
		}
		if(AndAnd_BoolBool(NotEqual_ObjectObject(PlayerPawn, none), EqualEqual_ObjectObject(Other, PlayerPawn)))
		{
			PlayerPawn.SetDoorLockedBelief(self, true);
		}
		if(OrOr_BoolBool(EqualEqual_IntInt(int(Level.NetMode), int(NM_ListenServer)), EqualEqual_IntInt(int(Level.NetMode), int(NM_DedicatedServer))))
		{
			NetPlayerPawn = NetPlayer(Other);
			LockedKnowledge[NetPlayerPawn.GetTeamNumber()] = 1;
			if(Level.GetEngine().EnableDevTools)
			{
				MPLog(Concat_StrStr(Concat_StrStr(Concat_StrStr("Saving locked door knowledge for pawn: ", string(NetPlayerPawn)), ", team number: "), string(NetPlayerPawn.GetTeamNumber())));
			}
		}
	}
	else
	{
		if(AndAnd_BoolBool(AndAnd_BoolBool(Force, bIsLocked), IsClosed()))
		{
			bIsLocked = false;
		}
		switch(CurrentPosition)
		{
			case 0:
				if(ActorIsToMyLeft(Other))
				{
					SetPositionForMove(2, 0);
				}
				else
				{
					SetPositionForMove(1, 0);
				}
				break;
			case 1:
			case 2:
				SetPositionForMove(0, 0);
				break;
			default:
				assert(false);
				break;
		}
		Moved();
	}
	return;
}

simulated function OnWedged()
{
	TriggerEffectEvent('Wedged');
	return;
}

simulated function OnUnwedged()
{
	TriggerEffectEvent('UnWedged');
	return;
}

simulated function OnUnlocked()
{
	local Controller i, theLocalPlayerController;
	local SwatGamePlayerController Current;
	local NetPlayer CurrentNetPlayer;

	if(Level.GetEngine().EnableDevTools)
	{
		MPLog(Concat_StrStr(string(self), "---SwatDoor::OnUnlocked()."));
	}
	if(Not_PreBool(bIsLocked))
	{
		return;
	}
	bIsLocked = false;
	TriggerEffectEvent('Unlocked');
	UpdateOfficerDoorKnowledge();
	if(OrOr_BoolBool(EqualEqual_IntInt(int(Level.NetMode), int(NM_ListenServer)), EqualEqual_IntInt(int(Level.NetMode), int(NM_DedicatedServer))))
	{
		LockedKnowledge[0] = 0;
		LockedKnowledge[1] = 0;
		theLocalPlayerController = Level.GetLocalPlayerController();
		i = Level.ControllerList;
		J0xD8:

		if(NotEqual_ObjectObject(i, none))
		{
			Current = SwatGamePlayerController(i);
			if(NotEqual_ObjectObject(Current, none))
			{
				CurrentNetPlayer = NetPlayer(Current.SwatPlayer);
				if(NotEqual_ObjectObject(Current, theLocalPlayerController))
				{
					if(Level.GetEngine().EnableDevTools)
					{
						MPLog(Concat_StrStr("...on server: calling OnDoorUnlocked() on ", string(CurrentNetPlayer)));
					}
					CurrentNetPlayer.OnDoorUnlocked(self);
				}
			}
			i = i.nextController;
			// [Loop Continue]
			goto J0xD8;
		}
	}
	return;
}

simulated function bool KnowsDoorIsLocked(int TeamNumber)
{
	assert(NotEqual_IntInt(int(Level.NetMode), int(NM_Standalone)));
	assert(Less_IntInt(TeamNumber, 2));
	return EqualEqual_IntInt(LockedKnowledge[TeamNumber], 1);
	return;
}

private simulated function bool IsAntiPortalOn()
{
	if(Not_PreBool(bIsAntiPortal))
	{
		return false;
	}
	if(EqualEqual_ObjectObject(DoorAntiPortal, none))
	{
		if(Level.GetEngine().EnableDevTools)
		{
			Log(Concat_StrStr(Concat_StrStr("InIsAntiPortalOn(): Door '", string(self)), "' is bIsAntiPortal=true but has no DoorAntiPortal associated with it! Did you make sure to rebuild the map before running? If so, contact a programmer."));
		}
		return false;
	}
	return EqualEqual_IntInt(int(DoorAntiPortal.DrawType), int(11));
	return;
}

private simulated function ReactivateNearbyRagdolls()
{
	local SwatRagdollPawn SwatRagdollPawn;

	foreach VisibleCollidingActors(Class'SwatGame.SwatRagdollPawn', SwatRagdollPawn, CollisionRadius, Location)
	{
		if(AndAnd_BoolBool(Not_PreBool(SwatRagdollPawn.IsConscious()), NotEqual_IntInt(int(SwatRagdollPawn.Physics), int(16))))
		{
			SwatRagdollPawn.BecomeRagdoll();
			SwatRagdollPawn.SetTimer(SwatRagdollPawn.GetRagdollSimulationTimeout(), false);
		}
	}
	return;
}

private simulated function SetAntiPortalAndMPBlockingVolume(bool Enabled)
{
	if(AndAnd_BoolBool(bIsAntiPortal, NotEqual_ObjectObject(DoorAntiPortal, none)))
	{
		if(Enabled)
		{
			DoorAntiPortal.SetDrawType(11);
		}
		else
		{
			DoorAntiPortal.SetDrawType(0);
		}
		AssertWithDescription(OrOr_BoolBool(Not_PreBool(bIsAntiPortal), EqualEqual_BoolBool(Enabled, IsAntiPortalOn())), Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr("[ckline] After SetAntiPortalAndMPBlockingVolume(", string(Enabled)), ") on Door '"), string(self)), "', IsAntiPortalOn() == "), string(Not_PreBool(Enabled))), " -- this is not right."));
	}
	if(NotEqual_ObjectObject(DoorBufferVolume, none))
	{
		if(Enabled)
		{
			DoorBufferVolume.EnableRepulsion();
		}
		else
		{
			DoorBufferVolume.DisableRepulsion();
		}
	}
	return;
}

simulated function SetPositionForMove(Door.DoorPosition inPositionForMove, SwatDoor.EMoveReason inReasonForMove, optional bool bDontUpdateDesired)
{
	PendingPosition = inPositionForMove;
	ReasonForMove = inReasonForMove;
	return;
}

simulated function Moved(optional bool Instantly, optional bool Force)
{
	if(Level.GetEngine().EnableDevTools)
	{
		Log(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr("TMC T", string(Level.TimeSeconds)), " SwatDoor::Moved() Instantly="), string(Instantly)), ", CurrentPosition="), string(GetEnum(Enum'Engine.Door.DoorPosition', int(CurrentPosition)))), ", PendingPosition="), string(GetEnum(Enum'Engine.Door.DoorPosition', int(PendingPosition)))));
	}
	if(AndAnd_BoolBool(EqualEqual_IntInt(int(CurrentPosition), int(PendingPosition)), Not_PreBool(Force)))
	{
		return;
	}
	if(Instantly)
	{
		if(NotEqual_IntInt(int(Level.NetMode), int(NM_Client)))
		{
			DesiredPosition = PendingPosition;
		}
		switch(PendingPosition)
		{
			case 0:
				PlayAnim('AtClosed');
				break;
			case 1:
				PlayAnim('AtOpenLeft');
				break;
			case 2:
				PlayAnim('AtOpenRight');
				break;
			default:
				assert(false);
				break;
		}
		CurrentPosition = PendingPosition;
		InitializeRemainingUpdateAttachmentLocationsCounter();
		if(EqualEqual_IntInt(int(CurrentPosition), int(0)))
		{
			SetAntiPortalAndMPBlockingVolume(true);
		}
		else
		{
			SetAntiPortalAndMPBlockingVolume(false);
		}
	}
	else
	{
		if(EqualEqual_IntInt(int(PendingPosition), int(0)))
		{
			if(PositionIsBlocked(CurrentPosition))
			{
				NotifyAIsBlockingDoorClose();
				NotifyClientsOfDoorBlocked(false);
				GotoState('ClosingBlocked');
			}
			else
			{
				if(NotEqual_IntInt(int(Level.NetMode), int(NM_Client)))
				{
					DesiredPosition = PendingPosition;
				}
				GotoState('Closing');
			}
		}
		else
		{
			switch(ReasonForMove)
			{
				case 0:
					if(PositionIsBlocked(PendingPosition))
					{
						NotifyAIsBlockingDoorOpen();
						NotifyClientsOfDoorBlocked(true);
						GotoState('OpeningBlocked');
					}
					else
					{
						if(NotEqual_IntInt(int(Level.NetMode), int(NM_Client)))
						{
							DesiredPosition = PendingPosition;
						}
						GotoState('Opening');
					}
					break;
				case 1:
					if(NotEqual_IntInt(int(Level.NetMode), int(NM_Client)))
					{
						DesiredPosition = PendingPosition;
					}
					GotoState('BeingBreached');
					break;
				case 2:
					if(NotEqual_IntInt(int(Level.NetMode), int(NM_Client)))
					{
						DesiredPosition = PendingPosition;
					}
					GotoState('BeingBlasted');
					break;
				default:
					break;
			}
		}
	}
	return;
}

private function NotifyAIsBlockingDoorClose()
{
	local int i;
	local SwatAI IterAI;

	i = 0;
	J0x07:

	if(Less_IntInt(i, BlockingPawns.Length))
	{
		IterAI = SwatAI(BlockingPawns[i]);
		if(AndAnd_BoolBool(NotEqual_ObjectObject(IterAI, GetPendingInteractor()), Class'Engine.Pawn'.static.checkConscious(IterAI)))
		{
			IterAI.NotifyBlockingDoorClose(self);
		}
		AddAdd_PreInt(i);
		// [Loop Continue]
		goto J0x07;
	}
	return;
}

private function NotifyAIsBlockingDoorOpen()
{
	local int i;
	local SwatAI IterAI;

	i = 0;
	J0x07:

	if(Less_IntInt(i, BlockingPawns.Length))
	{
		IterAI = SwatAI(BlockingPawns[i]);
		if(AndAnd_BoolBool(NotEqual_ObjectObject(IterAI, GetPendingInteractor()), Class'Engine.Pawn'.static.checkConscious(IterAI)))
		{
			IterAI.NotifyBlockingDoorOpen(self);
		}
		AddAdd_PreInt(i);
		// [Loop Continue]
		goto J0x07;
	}
	return;
}

function NotifyClientsOfDoorBlocked(bool OpeningBlocked)
{
	local Controller i, theLocalPlayerController;
	local SwatGamePlayerController Current;

	if(OrOr_BoolBool(EqualEqual_IntInt(int(Level.NetMode), int(NM_ListenServer)), EqualEqual_IntInt(int(Level.NetMode), int(NM_DedicatedServer))))
	{
		if(Level.GetEngine().EnableDevTools)
		{
			MPLog(Concat_StrStr(Concat_StrStr(string(self), "---SwatDoor::NotifyClientsOfDoorBlocked(). OpeningBlocked="), string(OpeningBlocked)));
		}
		theLocalPlayerController = Level.GetLocalPlayerController();
		i = Level.ControllerList;
		J0xCA:

		if(NotEqual_ObjectObject(i, none))
		{
			Current = SwatGamePlayerController(i);
			if(NotEqual_ObjectObject(Current, none))
			{
				if(NotEqual_ObjectObject(Current, theLocalPlayerController))
				{
					if(Level.GetEngine().EnableDevTools)
					{
						MPLog(Concat_StrStr(Concat_StrStr(Concat_StrStr("...on server: calling ClientPlayDoorIsBlocked() on ", string(Current)), ", SwatDoor="), string(self)));
					}
					Current.ClientPlayDoorBlocked(self, OpeningBlocked, PendingPosition);
				}
			}
			i = i.nextController;
			// [Loop Continue]
			goto J0xCA;
		}
	}
	return;
}

function Blasted(Pawn Instigator)
{
	if(OrOr_BoolBool(IsClosed(), IsClosing()))
	{
		if(ActorIsToMyLeft(Instigator))
		{
			SetPositionForMove(2, 2);
		}
		else
		{
			SetPositionForMove(1, 2);
		}
		Moved(false, true);
	}
	return;
}

function Breached(DeployedC2ChargeBase Charge)
{
	if(OrOr_BoolBool(IsClosed(), IsClosing()))
	{
		if(ActorIsToMyLeft(Charge))
		{
			SetPositionForMove(2, 1);
		}
		else
		{
			SetPositionForMove(1, 1);
		}
		Moved(false, true);
	}
	else
	{
		PlayBreachedEffects();
		Broken();
	}
	return;
}

// Export USwatDoor::execPointIsToMyLeft(FFrame&, void* const)
native function bool PointIsToMyLeft(Vector Point);

function bool PointIsOnSideThatDoorIsOpenTo(Vector Point, optional bool TreatOpeningDoorsAsClosed)
{
	if(IsClosed())
	{
		return false;
	}
	if(PointIsToMyLeft(Point))
	{
		return OrOr_BoolBool(IsOpenLeft(), AndAnd_BoolBool(Not_PreBool(TreatOpeningDoorsAsClosed), IsOpeningLeft()));
	}
	else
	{
		return OrOr_BoolBool(IsOpenRight(), AndAnd_BoolBool(Not_PreBool(TreatOpeningDoorsAsClosed), IsOpeningRight()));
	}
	return;
}

simulated function bool ActorIsToMyLeft(Actor Other)
{
	return PointIsToMyLeft(Other.Location);
	return;
}

simulated event bool LocalPlayerIsToMyLeft()
{
	return ActorIsToMyLeft(Level.GetLocalPlayerController().Pawn);
	return;
}

simulated event bool PointIsOnExternalSide(Vector Point)
{
	if(EqualEqual_IntInt(int(ExternalFacingSide), int(0)))
	{
		return false;
	}
	else
	{
		if(EqualEqual_IntInt(int(ExternalFacingSide), int(1)))
		{
			return PointIsToMyLeft(Point);
		}
		else
		{
			return Not_PreBool(PointIsToMyLeft(Point));
		}
	}
	return;
}

simulated function bool PositionIsBlocked(Door.DoorPosition TestPosition)
{
	local Pawn Candidate;
	local Vector PivotLocation;
	local Door.DoorPosition TestSide;

	if(EqualEqual_IntInt(int(Level.NetMode), int(NM_Client)))
	{
		return false;
	}
	if(OrOr_BoolBool(EqualEqual_IntInt(int(TestPosition), int(2)), EqualEqual_IntInt(int(CurrentPosition), int(2))))
	{
		TestSide = 2;
	}
	else
	{
		TestSide = 1;
	}
	PivotLocation = GetPivotLocation();
	BlockingPawns.Remove(0, BlockingPawns.Length);
	foreach RadiusActors(Class'Engine.Pawn', Candidate, 200.0000000, PivotLocation)
	{
		if(AndAnd_BoolBool(Class'Engine.Pawn'.static.checkConscious(Candidate), LocationIsInSweep(PivotLocation, Candidate.Location, Candidate.CollisionRadius, TestSide)))
		{
			BlockingPawns[BlockingPawns.Length] = Candidate;
		}
	}
	return Greater_IntInt(BlockingPawns.Length, 0);
	return;
}

simulated function Vector GetPivotLocation()
{
	return Subtract_VectorVector(Location, Divide_VectorFloat(Multiply_VectorFloat(Normal(Vector(Rotation)), CollisionRadius), 2.0000000));
	return;
}

simulated function bool LocationIsInSweep(Vector DoorPivot, Vector testLocation, float TestLocationCollisionRadius, Door.DoorPosition Side)
{
	local bool LocationIsToMyLeft;
	local Rotator OffsetRotation;
	local Vector ConeOrigin, ConeDirection, ConeTarget;

	if(Greater_FloatFloat(Subtract_FloatFloat(testLocation.Z, DoorPivot.Z), CollisionHeight))
	{
		return false;
	}
	if(Greater_FloatFloat(VSize(Subtract_VectorVector(testLocation, DoorPivot)), Add_FloatFloat(CollisionRadius, TestLocationCollisionRadius)))
	{
		return false;
	}
	LocationIsToMyLeft = PointIsToMyLeft(testLocation);
	if(OrOr_BoolBool(AndAnd_BoolBool(LocationIsToMyLeft, EqualEqual_IntInt(int(Side), int(2))), AndAnd_BoolBool(Not_PreBool(LocationIsToMyLeft), EqualEqual_IntInt(int(Side), int(1)))))
	{
		return false;
	}
	if(EqualEqual_IntInt(int(Side), int(1)))
	{
		OffsetRotation = Subtract_RotatorRotator(Rotation, rot(0, 8192, 0));
	}
	else
	{
		OffsetRotation = Add_RotatorRotator(Rotation, rot(0, 8192, 0));
	}
	ConeDirection = Vector(OffsetRotation);
	ConeDirection.Z = 0.0000000;
	ConeOrigin = DoorPivot;
	ConeOrigin.Z = 0.0000000;
	ConeTarget = testLocation;
	ConeTarget.Z = 0.0000000;
	if(Not_PreBool(PointWithinInfiniteCone(ConeOrigin, ConeDirection, ConeTarget, Divide_FloatFloat(3.1415930, 2.0000000))))
	{
		return false;
	}
	return true;
	return;
}

simulated function UpdateOfficerDoorKnowledge()
{
	local SwatAIRepository AIRepo;
	local SwatPawn PlayerPawn;

	if(EqualEqual_IntInt(int(Level.NetMode), int(NM_Standalone)))
	{
		PlayerPawn = SwatPawn(Level.GetLocalPlayerController().Pawn);
		AIRepo = SwatAIRepository(Level.AIRepo);
		if(NotEqual_ObjectObject(AIRepo, none))
		{
			AIRepo.UpdateDoorKnowledgeForOfficers(self);
		}
		else
		{
			PlayerPawn.SetDoorLockedBelief(self, false);
		}
	}
	return;
}

simulated event bool PawnBelievesDoorLocked(SwatPawn Pawn)
{
	local PawnDoorKnowledge Info;
	local NetPlayer NetPawn;

	Info = Pawn.GetDoorKnowledge(self);
	assert(NotEqual_ObjectObject(Info, none));
	if(NotEqual_IntInt(int(Level.NetMode), int(NM_Standalone)))
	{
		NetPawn = NetPlayer(Pawn);
		return KnowsDoorIsLocked(NetPawn.GetTeamNumber());
	}
	else
	{
		return Info.DoesBelieveDoorLocked();
	}
	return;
}

simulated function Broken()
{
	if(Not_PreBool(IsBroken()))
	{
		bIsBroken = true;
		if(IsWedged())
		{
			DeployedWedge.OnRemoved();
		}
		UpdateOfficerDoorKnowledge();
		LockedKnowledge[0] = 0;
		LockedKnowledge[1] = 0;
		PostBroken();
	}
	return;
}

simulated function PostBroken()
{
	return;
}

simulated function PlayBreachedEffects()
{
	return;
}

simulated function PlayDoorBreached(DeployedC2ChargeBase TheCharge)
{
	assert(EqualEqual_IntInt(int(Level.NetMode), int(NM_Client)));
	TheCharge.OnDetonated();
	return;
}

private function bool IsDoorOpenTowardsRequesterLocation(Vector RequesterLocation)
{
	local bool bStackUpOnLeft, bDoorOpenLeft;

	if(AndAnd_BoolBool(Not_PreBool(IsEmptyDoorway()), IsOpen()))
	{
		bStackUpOnLeft = PointIsToMyLeft(RequesterLocation);
		bDoorOpenLeft = IsOpenLeft();
		if(EqualEqual_BoolBool(bStackUpOnLeft, bDoorOpenLeft))
		{
			return true;
		}
	}
	return false;
	return;
}

simulated function array<StackupPoint> GetStackupPoints(Vector RequesterLocation)
{
	if(PointIsToMyLeft(RequesterLocation))
	{
		if(IsDoorOpenTowardsRequesterLocation(RequesterLocation))
		{
			return AlternateLeftStackupPoints;
		}
		else
		{
			return LeftStackupPoints;
		}
	}
	else
	{
		if(IsDoorOpenTowardsRequesterLocation(RequesterLocation))
		{
			return AlternateRightStackupPoints;
		}
		else
		{
			return RightStackupPoints;
		}
	}
	return;
}

simulated function array<ClearPoint> GetClearPoints(Vector RequesterLocation)
{
	if(PointIsToMyLeft(RequesterLocation))
	{
		return RightClearPoints;
	}
	else
	{
		return LeftClearPoints;
	}
	return;
}

simulated function AddSelfToRoomList()
{
	if(AndAnd_BoolBool(EqualEqual_NameName(LeftInternalRoomName, 'None'), NotEqual_StrStr(LeftRoomName, "")))
	{
		LeftInternalRoomName = string(LeftRoomName);
	}
	if(AndAnd_BoolBool(EqualEqual_NameName(RightInternalRoomName, 'None'), NotEqual_StrStr(RightRoomName, "")))
	{
		RightInternalRoomName = string(RightRoomName);
	}
	if(NotEqual_NameName(LeftInternalRoomName, 'None'))
	{
		Level.AIRepo.AddNavigationPointToRoomList(self, LeftInternalRoomName);
	}
	if(NotEqual_NameName(RightInternalRoomName, 'None'))
	{
		Level.AIRepo.AddNavigationPointToRoomList(self, RightInternalRoomName);
	}
	return;
}

// Export USwatDoor::execGetLeftRoomName(FFrame&, void* const)
native simulated function name GetLeftRoomName();

// Export USwatDoor::execGetRightRoomName(FFrame&, void* const)
native simulated function name GetRightRoomName();

simulated function array<Actor> GetDoorModels()
{
	local array<Actor> Empty;

	return Empty;
	return;
}

private simulated function bool IsLeftSideFrontOpenPointUsable()
{
	return AndAnd_BoolBool(bLeftSideFrontOpenPointUsable, OrOr_BoolBool(Not_PreBool(IsOpen()), Not_PreBool(IsOpenLeft())));
	return;
}

private simulated function bool IsRightSideFrontOpenPointUsable()
{
	return AndAnd_BoolBool(bRightSideFrontOpenPointUsable, OrOr_BoolBool(Not_PreBool(IsOpen()), IsOpenLeft()));
	return;
}

private simulated function bool AreSideOpenPointsUsableFromSide(bool bOnLeftSideOfDoor)
{
	if(bOnLeftSideOfDoor)
	{
		return OrOr_BoolBool(bLeftSideBackOpenPointUsable, IsLeftSideFrontOpenPointUsable());
	}
	else
	{
		return OrOr_BoolBool(bRightSideBackOpenPointUsable, IsRightSideFrontOpenPointUsable());
	}
	return;
}

simulated function bool AreSideOpenPointsUsable(Pawn Other)
{
	if(ActorIsToMyLeft(Other))
	{
		return AreSideOpenPointsUsableFromSide(true);
	}
	else
	{
		return AreSideOpenPointsUsableFromSide(false);
	}
	return;
}

simulated function bool IsOfficerAtSideOpenPoint(Pawn Officer, bool bOnLeftSide)
{
	local ISwatAI.AIDoorUsageSide DoorUsageSide;
	local Vector OpenPoint;

	if(AreSideOpenPointsUsableFromSide(bOnLeftSide))
	{
		if(bOnLeftSide)
		{
			OpenPoint = GetClosestLeftOpenPointTo(Officer.Location, DoorUsageSide);
		}
		else
		{
			OpenPoint = GetClosestRightOpenPointTo(Officer.Location, DoorUsageSide);
		}
		return Officer.ReachedLocation(OpenPoint);
	}
	return false;
	return;
}

private simulated function bool AreSideBreachPointsUsableFromSide(bool bOnLeftSideOfDoor)
{
	if(bOnLeftSideOfDoor)
	{
		return OrOr_BoolBool(bLeftSideKnobBreachPointUsable, bLeftSideHingeBreachPointUsable);
	}
	else
	{
		return OrOr_BoolBool(bRightSideKnobBreachPointUsable, bRightSideHingeBreachPointUsable);
	}
	return;
}

simulated function bool AreSideBreachPointsUsable(Pawn Other)
{
	if(ActorIsToMyLeft(Other))
	{
		return AreSideBreachPointsUsableFromSide(true);
	}
	else
	{
		return AreSideBreachPointsUsableFromSide(false);
	}
	return;
}

private simulated function Vector GetClosestLeftBreachPointTo(Vector TargetLocation)
{
	local float KnobDistance, HingeDistance;

	KnobDistance = VSize(Subtract_VectorVector(LeftSideKnobBreachPoint, TargetLocation));
	HingeDistance = VSize(Subtract_VectorVector(LeftSideHingeBreachPoint, TargetLocation));
	assert(OrOr_BoolBool(bLeftSideKnobBreachPointUsable, bLeftSideHingeBreachPointUsable));
	if(AndAnd_BoolBool(bLeftSideKnobBreachPointUsable, OrOr_BoolBool(Less_FloatFloat(KnobDistance, HingeDistance), Not_PreBool(bLeftSideHingeBreachPointUsable))))
	{
		return LeftSideKnobBreachPoint;
	}
	else
	{
		return LeftSideHingeBreachPoint;
	}
	return;
}

private simulated function Vector GetClosestRightBreachPointTo(Vector TargetLocation)
{
	local float KnobDistance, HingeDistance;

	KnobDistance = VSize(Subtract_VectorVector(RightSideKnobBreachPoint, TargetLocation));
	HingeDistance = VSize(Subtract_VectorVector(RightSideHingeBreachPoint, TargetLocation));
	assert(OrOr_BoolBool(bRightSideKnobBreachPointUsable, bRightSideHingeBreachPointUsable));
	if(AndAnd_BoolBool(bRightSideKnobBreachPointUsable, OrOr_BoolBool(Less_FloatFloat(KnobDistance, HingeDistance), Not_PreBool(bRightSideHingeBreachPointUsable))))
	{
		return RightSideKnobBreachPoint;
	}
	else
	{
		return RightSideHingeBreachPoint;
	}
	return;
}

simulated function Vector GetSideBreachPoint(Pawn Other)
{
	if(ActorIsToMyLeft(Other))
	{
		return GetClosestLeftBreachPointTo(Other.Location);
	}
	else
	{
		return GetClosestRightBreachPointTo(Other.Location);
	}
	return;
}

simulated function Vector GetBreachFromPoint(Pawn Other)
{
	local ISwatAI.AIDoorUsageSide DummyUsageSide;
	local Vector BreachPoint;

	if(Not_PreBool(AreSideBreachPointsUsable(Other)))
	{
		BreachPoint = GetCenterOpenPoint(Other, DummyUsageSide);
	}
	else
	{
		BreachPoint = GetSideBreachPoint(Other);
	}
	return BreachPoint;
	return;
}

simulated function Vector GetBreachAimPoint(Pawn Other)
{
	local Vector BreachAimPoint;

	if(ActorIsToMyLeft(Other))
	{
		BreachAimPoint = GetBoneCoords('BreachAimLeft', true).Origin;
	}
	else
	{
		BreachAimPoint = GetBoneCoords('BreachAimRight', true).Origin;
	}
	return BreachAimPoint;
	return;
}

simulated function ISwatAI.AIDoorUsageSide GetOpenPositions(Pawn Other, bool bPreferSides, out Vector OpenPoint, out Rotator PawnOpenRotation)
{
	local ISwatAI.AIDoorUsageSide DoorUsageSide;

	assert(NotEqual_ObjectObject(Other, none));
	if(OrOr_BoolBool(Not_PreBool(bPreferSides), Not_PreBool(AreSideOpenPointsUsable(Other))))
	{
		OpenPoint = GetCenterOpenPoint(Other, DoorUsageSide);
		PawnOpenRotation = GetCenterOpenRotation(OpenPoint);
	}
	else
	{
		OpenPoint = GetSidesOpenPoint(Other, DoorUsageSide);
		PawnOpenRotation = GetSidesOpenRotation(OpenPoint);
	}
	return DoorUsageSide;
	return;
}

private simulated function Rotator GetCenterOpenRotation(Vector CenterOpenPoint)
{
	return Rotator(Subtract_VectorVector(Location, CenterOpenPoint));
	return;
}

simulated function Rotator GetSidesOpenRotation(Vector OpenPoint)
{
	if(Greater_FloatFloat(Dot_VectorVector(Vector(Rotation), Normal(Subtract_VectorVector(Location, OpenPoint))), float(0)))
	{
		return Rotation;
	}
	else
	{
		return Inverse(Rotation);
	}
	return;
}

private simulated function Vector GetClosestLeftOpenPointTo(Vector TargetLocation, out ISwatAI.AIDoorUsageSide DoorUsageSide)
{
	local float BackDistance, FrontDistance;

	BackDistance = VSize(Subtract_VectorVector(LeftSideBackOpenPoint, TargetLocation));
	FrontDistance = VSize(Subtract_VectorVector(LeftSideFrontOpenPoint, TargetLocation));
	assert(OrOr_BoolBool(bLeftSideBackOpenPointUsable, IsLeftSideFrontOpenPointUsable()));
	if(AndAnd_BoolBool(bLeftSideBackOpenPointUsable, OrOr_BoolBool(Less_FloatFloat(BackDistance, FrontDistance), Not_PreBool(IsLeftSideFrontOpenPointUsable()))))
	{
		assert(bLeftSideBackOpenPointUsable);
		DoorUsageSide = 1;
		return LeftSideBackOpenPoint;
	}
	else
	{
		assert(IsLeftSideFrontOpenPointUsable());
		DoorUsageSide = 0;
		return LeftSideFrontOpenPoint;
	}
	return;
}

private simulated function Vector GetClosestRightOpenPointTo(Vector TargetLocation, out ISwatAI.AIDoorUsageSide DoorUsageSide)
{
	local float BackDistance, FrontDistance;

	BackDistance = VSize(Subtract_VectorVector(RightSideBackOpenPoint, TargetLocation));
	FrontDistance = VSize(Subtract_VectorVector(RightSideFrontOpenPoint, TargetLocation));
	assert(OrOr_BoolBool(bRightSideBackOpenPointUsable, IsRightSideFrontOpenPointUsable()));
	if(AndAnd_BoolBool(bRightSideBackOpenPointUsable, OrOr_BoolBool(Less_FloatFloat(BackDistance, FrontDistance), Not_PreBool(IsRightSideFrontOpenPointUsable()))))
	{
		assert(bRightSideBackOpenPointUsable);
		DoorUsageSide = 1;
		return RightSideBackOpenPoint;
	}
	else
	{
		assert(IsRightSideFrontOpenPointUsable());
		DoorUsageSide = 0;
		return RightSideFrontOpenPoint;
	}
	return;
}

private simulated function Vector GetSidesOpenPoint(Pawn Officer, out ISwatAI.AIDoorUsageSide DoorUsageSide)
{
	assert(Officer.IsA('SwatOfficer'));
	if(ActorIsToMyLeft(Officer))
	{
		return GetClosestLeftOpenPointTo(Officer.Location, DoorUsageSide);
	}
	else
	{
		return GetClosestRightOpenPointTo(Officer.Location, DoorUsageSide);
	}
	return;
}

simulated function Vector GetCenterOpenPoint(Pawn Other, out ISwatAI.AIDoorUsageSide DoorUsageSide)
{
	DoorUsageSide = 2;
	if(ActorIsToMyLeft(Other))
	{
		return LeftSideCenterOpenPoint;
	}
	else
	{
		return RightSideCenterOpenPoint;
	}
	return;
}

simulated function Vector GetClosePoint(bool bCloseFromLeft)
{
	if(bCloseFromLeft)
	{
		if(EqualEqual_IntInt(int(CurrentPosition), int(1)))
		{
			return OpenLeftTowardsClosePoint;
		}
		else
		{
			return OpenRightAwayClosePoint;
		}
	}
	else
	{
		if(EqualEqual_IntInt(int(CurrentPosition), int(1)))
		{
			return OpenLeftAwayClosePoint;
		}
		else
		{
			return OpenRightTowardsClosePoint;
		}
	}
	return;
}

simulated function name GetLeftSideFrontOpenAnimation()
{
	if(bIsPushable)
	{
		return LeftSideFrontPushOpenAnimation;
	}
	else
	{
		return LeftSideFrontKnobOpenAnimation;
	}
	return;
}

simulated function name GetLeftSideBackOpenAnimation()
{
	if(bIsPushable)
	{
		return LeftSideBackPushOpenAnimation;
	}
	else
	{
		return LeftSideBackKnobOpenAnimation;
	}
	return;
}

simulated function name GetLeftSideCenterFranticOpenAnimation()
{
	if(bIsPushable)
	{
		return LeftSideCenterFranticPushOpenAnimation;
	}
	else
	{
		return LeftSideCenterFranticKnobOpenAnimation;
	}
	return;
}

simulated function name GetLeftSideCenterOpenAnimation()
{
	if(bIsPushable)
	{
		return LeftSideCenterPushOpenAnimation;
	}
	else
	{
		return LeftSideCenterKnobOpenAnimation;
	}
	return;
}

simulated function name GetRightSideFrontOpenAnimation()
{
	if(bIsPushable)
	{
		return RightSideFrontPushOpenAnimation;
	}
	else
	{
		return RightSideFrontKnobOpenAnimation;
	}
	return;
}

simulated function name GetRightSideBackOpenAnimation()
{
	if(bIsPushable)
	{
		return RightSideBackPushOpenAnimation;
	}
	else
	{
		return RightSideBackKnobOpenAnimation;
	}
	return;
}

simulated function name GetRightSideCenterFranticOpenAnimation()
{
	if(bIsPushable)
	{
		return RightSideCenterFranticPushOpenAnimation;
	}
	else
	{
		return RightSideCenterFranticKnobOpenAnimation;
	}
	return;
}

simulated function name GetRightSideCenterOpenAnimation()
{
	if(bIsPushable)
	{
		return RightSideCenterPushOpenAnimation;
	}
	else
	{
		return RightSideCenterKnobOpenAnimation;
	}
	return;
}

simulated function name GetOpenAnimation(Pawn Other, ISwatAI.AIDoorUsageSide DoorUsageSide, optional bool bIsFranticOpen)
{
	if(ActorIsToMyLeft(Other))
	{
		if(EqualEqual_IntInt(int(DoorUsageSide), int(0)))
		{
			return GetLeftSideFrontOpenAnimation();
		}
		else
		{
			if(EqualEqual_IntInt(int(DoorUsageSide), int(1)))
			{
				return GetLeftSideBackOpenAnimation();
			}
			else
			{
				if(bIsFranticOpen)
				{
					assert(EqualEqual_IntInt(int(DoorUsageSide), int(2)));
					return GetLeftSideCenterFranticOpenAnimation();
				}
				else
				{
					return GetLeftSideCenterOpenAnimation();
				}
			}
		}
	}
	else
	{
		if(EqualEqual_IntInt(int(DoorUsageSide), int(0)))
		{
			return GetRightSideFrontOpenAnimation();
		}
		else
		{
			if(EqualEqual_IntInt(int(DoorUsageSide), int(1)))
			{
				return GetRightSideBackOpenAnimation();
			}
			else
			{
				if(bIsFranticOpen)
				{
					assert(EqualEqual_IntInt(int(DoorUsageSide), int(2)));
					return GetRightSideCenterFranticOpenAnimation();
				}
				else
				{
					return GetRightSideCenterOpenAnimation();
				}
			}
		}
	}
	return;
}

simulated function name GetOLBackTowardsCloseAnimation()
{
	if(bIsPushable)
	{
		return OLBackTowardsPushCloseAnimation;
	}
	else
	{
		return OLBackTowardsKnobCloseAnimation;
	}
	return;
}

simulated function name GetOLFrontTowardsCloseAnimation()
{
	if(bIsPushable)
	{
		return OLFrontTowardsPushCloseAnimation;
	}
	else
	{
		return OLFrontTowardsKnobCloseAnimation;
	}
	return;
}

simulated function name GetOLFrontAwayCloseAnimation()
{
	if(bIsPushable)
	{
		return OLFrontAwayPushCloseAnimation;
	}
	else
	{
		return OLFrontAwayKnobCloseAnimation;
	}
	return;
}

simulated function name GetORBackTowardsCloseAnimation()
{
	if(bIsPushable)
	{
		return ORBackTowardsPushCloseAnimation;
	}
	else
	{
		return ORBackTowardsKnobCloseAnimation;
	}
	return;
}

simulated function name GetORFrontTowardsCloseAnimation()
{
	if(bIsPushable)
	{
		return ORFrontTowardsPushCloseAnimation;
	}
	else
	{
		return ORFrontTowardsKnobCloseAnimation;
	}
	return;
}

simulated function name GetORFrontAwayCloseAnimation()
{
	if(bIsPushable)
	{
		return ORFrontAwayPushCloseAnimation;
	}
	else
	{
		return ORFrontAwayKnobCloseAnimation;
	}
	return;
}

simulated function name GetCloseAnimation(Pawn Other, bool bCloseFromBehind)
{
	if(EqualEqual_IntInt(int(CurrentPosition), int(1)))
	{
		if(ActorIsToMyLeft(Other))
		{
			if(bCloseFromBehind)
			{
				return GetOLBackTowardsCloseAnimation();
			}
			else
			{
				return GetOLFrontTowardsCloseAnimation();
			}
		}
		else
		{
			return GetOLFrontAwayCloseAnimation();
		}
	}
	else
	{
		assert(EqualEqual_IntInt(int(CurrentPosition), int(2)));
		if(ActorIsToMyLeft(Other))
		{
			return GetORBackTowardsCloseAnimation();
		}
		else
		{
			if(bCloseFromBehind)
			{
				return GetORFrontTowardsCloseAnimation();
			}
			else
			{
				return GetORFrontAwayCloseAnimation();
			}
		}
	}
	return;
}

simulated function name GetLeftSideFrontTryAnimation()
{
	if(bIsPushable)
	{
		return LeftSideFrontPushTryAnimation;
	}
	else
	{
		return LeftSideFrontKnobTryAnimation;
	}
	return;
}

simulated function name GetLeftSideBackTryAnimation()
{
	if(bIsPushable)
	{
		return LeftSideBackPushTryAnimation;
	}
	else
	{
		return LeftSideBackKnobTryAnimation;
	}
	return;
}

simulated function name GetLeftSideCenterTryAnimation()
{
	if(bIsPushable)
	{
		return LeftSideCenterPushTryAnimation;
	}
	else
	{
		return LeftSideCenterKnobTryAnimation;
	}
	return;
}

simulated function name GetRightSideFrontTryAnimation()
{
	if(bIsPushable)
	{
		return RightSideFrontPushTryAnimation;
	}
	else
	{
		return RightSideFrontKnobTryAnimation;
	}
	return;
}

simulated function name GetRightSideBackTryAnimation()
{
	if(bIsPushable)
	{
		return RightSideBackPushTryAnimation;
	}
	else
	{
		return RightSideBackKnobTryAnimation;
	}
	return;
}

simulated function name GetRightSideCenterTryAnimation()
{
	if(bIsPushable)
	{
		return RightSideCenterPushTryAnimation;
	}
	else
	{
		return RightSideCenterKnobTryAnimation;
	}
	return;
}

simulated function name GetTryDoorAnimation(Pawn Other, ISwatAI.AIDoorUsageSide DoorUsageSide)
{
	if(ActorIsToMyLeft(Other))
	{
		if(EqualEqual_IntInt(int(DoorUsageSide), int(0)))
		{
			return GetLeftSideFrontTryAnimation();
		}
		else
		{
			if(EqualEqual_IntInt(int(DoorUsageSide), int(1)))
			{
				return GetLeftSideBackTryAnimation();
			}
			else
			{
				return GetLeftSideCenterTryAnimation();
			}
		}
	}
	else
	{
		if(EqualEqual_IntInt(int(DoorUsageSide), int(0)))
		{
			return GetRightSideFrontTryAnimation();
		}
		else
		{
			if(EqualEqual_IntInt(int(DoorUsageSide), int(1)))
			{
				return GetRightSideBackTryAnimation();
			}
			else
			{
				return GetRightSideCenterTryAnimation();
			}
		}
	}
	return;
}

simulated function Pawn GetLastInteractor()
{
	return LastInteractor;
	return;
}

simulated function Pawn GetPendingInteractor()
{
	if(OrOr_BoolBool(Not_PreBool(Class'Engine.Pawn'.static.checkConscious(PendingInteractor)), AndAnd_BoolBool(EqualEqual_ObjectObject(AI_Resource(PendingInteractor.MovementAI).findGoalByName("OpenDoor"), none), EqualEqual_ObjectObject(AI_Resource(PendingInteractor.MovementAI).findGoalByName("CloseDoor"), none))))
	{
		PendingInteractor = none;
	}
	return PendingInteractor;
	return;
}

simulated function SetPendingInteractor(Pawn Interactor)
{
	PendingInteractor = Interactor;
	return;
}

simulated function bool IsBlockedFor(Pawn Other)
{
	if(ActorIsToMyLeft(Other))
	{
		return PositionIsBlocked(2);
	}
	else
	{
		return PositionIsBlocked(1);
	}
	return;
}

simulated function bool WasBlockedBy(name BlockedClassName)
{
	local int i;

	i = 0;
	J0x07:

	if(Less_IntInt(i, BlockingPawns.Length))
	{
		if(AndAnd_BoolBool(Class'Engine.Pawn'.static.checkConscious(BlockingPawns[i]), BlockingPawns[i].IsA(BlockedClassName)))
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

simulated function PlacedThrowPoint GetPlacedThrowPoint(Vector Origin)
{
	if(PointIsToMyLeft(Origin))
	{
		return LeftPlacedThrowPoint;
	}
	else
	{
		return RightPlacedThrowPoint;
	}
	return;
}

simulated function float GetAdditionalGrenadeThrowDistance(Vector Origin)
{
	if(PointIsToMyLeft(Origin))
	{
		return LeftAdditionalGrenadeThrowDistance;
	}
	else
	{
		return RightAdditionalGrenadeThrowDistance;
	}
	return;
}

simulated function bool CanBeLocked()
{
	return AndAnd_BoolBool(AndAnd_BoolBool(AndAnd_BoolBool(AndAnd_BoolBool(bCanBeLocked, IsClosed()), Not_PreBool(IsOpening())), Not_PreBool(IsBroken())), Not_PreBool(IsEmptyDoorway()));
	return;
}

simulated function Lock()
{
	AssertWithDescription(CanBeLocked(), "SwatDoor::Lock - CanBeLocked return false!");
	if(NotEqual_IntInt(int(Level.NetMode), int(NM_Client)))
	{
		bIsLocked = true;
	}
	return;
}

simulated function float GetMoveAndClearPauseThreshold()
{
	return MoveAndClearPauseThreshold;
	return;
}

function SpawnDeployedWedge()
{
	assert(NotEqual_IntInt(int(Level.NetMode), int(NM_Client)));
	assert(EqualEqual_ObjectObject(DeployedWedge, none));
	DeployedWedge = DeployedWedgeBase(Spawn(DeployedWedgeClass));
	AssertWithDescription(NotEqual_ObjectObject(DeployedWedge, none), Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr("[tcohen] SwatDoor couldn't Spawn a DeployedWedge.  DeployedWedgeClassName=", DeployedWedgeClassName), ", which resolves to DeployedWedgeClass="), string(DeployedWedgeClass)), "."));
	DeployedWedge.SetAssociatedDoor(self);
	DeployedWedge.SetLocation(GetBoneCoords('DoorWedge', true).Origin);
	return;
}

function SpawnDeployedC2ChargeLeft()
{
	assert(NotEqual_IntInt(int(Level.NetMode), int(NM_Client)));
	assert(EqualEqual_ObjectObject(DeployedC2ChargeLeft, none));
	DeployedC2ChargeLeft = DeployedC2ChargeBase(Spawn(DeployedC2ChargeClass));
	AssertWithDescription(NotEqual_ObjectObject(DeployedC2ChargeLeft, none), Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr("[tcohen] SwatDoor couldn't Spawn a DeployedC2ChargeLeft.  DeployedC2ChargeClassName=", DeployedC2ChargeClassName), ", which resolves to DeployedC2ChargeClass="), string(DeployedC2ChargeClass)), "."));
	DeployedC2ChargeLeft.SetAssociatedDoor(self);
	AttachToBone(DeployedC2ChargeLeft, 'C2ChargeLeft');
	return;
}

function SpawnDeployedC2ChargeRight()
{
	assert(NotEqual_IntInt(int(Level.NetMode), int(NM_Client)));
	assert(EqualEqual_ObjectObject(DeployedC2ChargeRight, none));
	DeployedC2ChargeRight = DeployedC2ChargeBase(Spawn(DeployedC2ChargeClass));
	AssertWithDescription(NotEqual_ObjectObject(DeployedC2ChargeRight, none), Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr("[tcohen] SwatDoor couldn't Spawn a DeployedC2ChargeRight.  DeployedC2ChargeClassName=", DeployedC2ChargeClassName), ", which resolves to DeployedC2ChargeClass="), string(DeployedC2ChargeClass)), "."));
	DeployedC2ChargeRight.SetAssociatedDoor(self);
	AttachToBone(DeployedC2ChargeRight, 'C2ChargeRight');
	return;
}

simulated function DeployedWedgeBase GetDeployedWedge()
{
	if(DeployedWedge.IsDeployed())
	{
		return DeployedWedge;
	}
	else
	{
		return none;
	}
	return;
}

simulated function DeployedC2ChargeBase GetDeployedC2ChargeLeft()
{
	if(DeployedC2ChargeLeft.IsDeployed())
	{
		return DeployedC2ChargeLeft;
	}
	else
	{
		return none;
	}
	return;
}

simulated function DeployedC2ChargeBase GetDeployedC2ChargeRight()
{
	if(DeployedC2ChargeRight.IsDeployed())
	{
		return DeployedC2ChargeRight;
	}
	else
	{
		return none;
	}
	return;
}

simulated event bool IsC2ChargeOnPlayersSide()
{
	if(ActorIsToMyLeft(Level.GetLocalPlayerController().Pawn))
	{
		return IsChargePlacedOnLeft();
	}
	else
	{
		return IsChargePlacedOnRight();
	}
	return;
}

simulated function bool CanBeUsedByToolkitNow()
{
	return IsLocked();
	return;
}

function OnUsingByToolkitBegan(Pawn User)
{
	return;
}

simulated function OnUsedByToolkit(Pawn User)
{
	OnUnlocked();
	return;
}

function OnUsingByToolkitInterrupted(Pawn User)
{
	return;
}

simulated function float GetQualifyTimeForToolkit()
{
	return QualifyTimeForToolkit;
	return;
}

// Export USwatDoor::execGetSkeletalRegionCenter(FFrame&, void* const)
native function Vector GetSkeletalRegionCenter(Actor.ESkeletalRegion Region);

simulated function OnUsedByWedge()
{
	local bool CanDoorBeWedgedNow;

	if(Level.GetEngine().EnableDevTools)
	{
		MPLog(Concat_StrStr(string(self), "---SwatDoor::OnUsedByWedge()."));
	}
	CanDoorBeWedgedNow = AndAnd_BoolBool(AndAnd_BoolBool(IsClosed(), Not_PreBool(IsOpening())), Not_PreBool(IsBroken()));
	if(Not_PreBool(CanDoorBeWedgedNow))
	{
		if(Level.GetEngine().EnableDevTools)
		{
			MPLog("...door was not closed and stationary and not broken. Doing nothing...");
		}
		return;
	}
	if(Level.GetEngine().EnableDevTools)
	{
		MPLog("...door was closed and stationary and not broken. Deploying wedge...");
	}
	DeployedWedge.OnDeployed();
	OnWedged();
	return;
}

simulated function float GetQualifyTimeForWedge()
{
	return QualifyTimeForWedge;
	return;
}

simulated function OnUsedByC2Charge(ICanUseC2Charge Instigator)
{
	local DeployedC2ChargeBase Charge;

	if(ActorIsToMyLeft(Pawn(Instigator)))
	{
		Charge = DeployedC2ChargeLeft;
	}
	else
	{
		Charge = DeployedC2ChargeRight;
	}
	Instigator.SetDeployedC2Charge(Charge);
	Charge.OnDeployed(SwatPawn(Instigator));
	return;
}

simulated function float GetQualifyTimeForC2Charge()
{
	return QualifyTimeForC2Charge;
	return;
}

simulated function OnSkeletalRegionHit(Actor.ESkeletalRegion RegionHit, Vector HitLocation, Vector HitNormal, int Damage, Class<DamageType> DamageType, Actor Instigator)
{
	if(AndAnd_BoolBool(EqualEqual_IntInt(int(RegionHit), int(11)), ClassIsChildOf(DamageType, Class'SwatGame.IFrangibleBreachingDamageType')))
	{
		AssertWithDescription(Instigator.IsA('SwatPawn'), "[tcohen] SwatDoor::OnSkeletalRegionHit() RegionHit is REGION_Door_BreachingSpot and DamageType is FrangibleBreachingAmmo, but Instigator is not a SwatPawn.");
		Blasted(SwatPawn(Instigator));
	}
	return;
}

simulated event DesiredPositionChanged()
{
	if(Level.GetEngine().EnableDevTools)
	{
		MPLog(Concat_StrStr(Concat_StrStr(string(self), "---SwatDoor::DesiredPositionChanged(). DesiredPosition="), string(DesiredPosition)));
		MPLog(Concat_StrStr("...CurrentPosition=", string(CurrentPosition)));
		MPLog(Concat_StrStr("...PendingPosition=", string(PendingPosition)));
		MPLog(Concat_StrStr("...DesiredPosition=", string(DesiredPosition)));
	}
	if(Not_PreBool(IsEmptyDoorway()))
	{
		PendingPosition = DesiredPosition;
		Moved(false, true);
	}
	return;
}

simulated function float GetDoorwayWidth()
{
	assert(false);
	return 0.0000000;
	return;
}

simulated function Vector GetPushAwayDirection(SwatRagdollPawn thePawn)
{
	assert(false);
	return vect(0.0000000, 0.0000000, 0.0000000);
	return;
}

simulated function InitializeRemainingUpdateAttachmentLocationsCounter()
{
	RemainingUpdateAttachmentLocationsCounter = 2;
	return;
}

simulated state Moving
{
	simulated function bool CanInteract()
	{
		return false;
		return;
	}

	simulated function Interact(Pawn Other, optional bool Force)
	{
		AssertWithDescription(false, Concat_StrStr(Concat_StrStr("[tcohen] ", string(Name)), " was called to Interact() but it is busy Moving."));
		return;
	}

	simulated function MoveToPosition(Door.DoorPosition NewPosition, optional bool Instantly)
	{
		AssertWithDescription(false, Concat_StrStr(Concat_StrStr("[tcohen] ", string(Name)), " was called to MoveToPosition() but it is already Moving."));
		return;
	}

	simulated function StartMoving()
	{
		assert(false);
		return;
	}

	simulated function bool MoveSucceeds()
	{
		return true;
		return;
	}

	simulated function OnMoveEnded()
	{
		return;
	}

	function Tick(float dTime)
	{
		super(Actor).Tick(dTime);
		UpdateAttachmentLocations();
		return;
	}
Begin:

	if(NotEqual_IntInt(int(PendingPosition), int(0)))
	{
		SetAntiPortalAndMPBlockingVolume(false);
	}
	ReactivateNearbyRagdolls();
	StartMoving();
	FinishAnim();
	if(MoveSucceeds())
	{
		CurrentPosition = PendingPosition;
	}
	if(EqualEqual_IntInt(int(CurrentPosition), int(0)))
	{
		SetAntiPortalAndMPBlockingVolume(true);
	}
	OnMoveEnded();
	GotoState('None');
	stop;
}

simulated state Opening extends Moving
{
	simulated function StartMoving()
	{
		NotifyRegistrantsDoorOpening();
		if(AndAnd_BoolBool(IsBoobyTrapped(), Not_PreBool(GetLastInteractor().IsA('SwatEnemy'))))
		{
			assert(NotEqual_ObjectObject(BoobyTrap, none));
			BoobyTrap.OnTriggeredByDoor();
		}
		if(EqualEqual_IntInt(int(PendingPosition), int(1)))
		{
			PlayAnim('OpenLeft');
		}
		else
		{
			PlayAnim('OpenRight');
		}
		return;
	}

	simulated function OnMoveEnded()
	{
		return;
	}
	stop;
}

simulated state Closing extends Moving
{
	simulated function StartMoving()
	{
		if(EqualEqual_IntInt(int(CurrentPosition), int(1)))
		{
			PlayAnim('CloseFromLeft');
		}
		else
		{
			PlayAnim('CloseFromRight');
		}
		return;
	}
	stop;
}

simulated state bLocked extends Moving
{
	simulated function bool MoveSucceeds()
	{
		return false;
		return;
	}
	stop;
}

simulated state OpeningBlocked extends bLocked
{
	simulated function StartMoving()
	{
		if(EqualEqual_IntInt(int(PendingPosition), int(1)))
		{
			PlayAnim('CloseBlockedLeft');
		}
		else
		{
			PlayAnim('CloseBlockedRight');
		}
		return;
	}
	stop;
}

simulated state ClosingBlocked extends bLocked
{
	simulated function StartMoving()
	{
		if(EqualEqual_IntInt(int(CurrentPosition), int(1)))
		{
			PlayAnim('OpenBlockedLeft');
		}
		else
		{
			PlayAnim('OpenBlockedRight');
		}
		return;
	}
	stop;
}

simulated state BeingBlasted extends Moving
{
	simulated function BeginState()
	{
		if(Not_PreBool(IsBroken()))
		{
			PlayBlastedEffects();
			Broken();
		}
		return;
	}

	simulated function StartMoving()
	{
		NotifyRegistrantsDoorOpening();
		if(EqualEqual_IntInt(int(PendingPosition), int(1)))
		{
			PlayAnim('BlastedLeft');
		}
		else
		{
			PlayAnim('BlastedRight');
		}
		return;
	}
	stop;
}

simulated state BeingBreached extends Moving
{
	simulated function BeginState()
	{
		if(Not_PreBool(IsBroken()))
		{
			PlayBreachedEffects();
			Broken();
		}
		return;
	}

	simulated function StartMoving()
	{
		NotifyRegistrantsDoorOpening();
		if(EqualEqual_IntInt(int(PendingPosition), int(1)))
		{
			PlayAnim('BreachedLeft');
		}
		else
		{
			PlayAnim('BreachedRight');
		}
		return;
	}
	stop;
}

defaultproperties
{
	bCanBeLocked=true
	bIsAntiPortal=true
	AntiPortalScaleFactor=(X=1.0500000,Y=0.1000000,Z=1.0500000)
	bPlayerCanUse=true
	LeftAdditionalGrenadeThrowDistance=100.0000000
	RightAdditionalGrenadeThrowDistance=100.0000000
	MoveAndClearPauseThreshold=128.0000000
	DoorBufferVolumeCollisionMesh=StaticMesh'Doors_sm.door_phys_singleref'
	DeployedWedgeClassName="SwatDesignerClasses.DeployedWedge"
	DeployedC2ChargeClassName="SwatDesignerClasses.DeployedC2Charge"
	Physics=8
	DrawType=8
	StaticMesh=StaticMesh'Doors_sm.TestDoorKarma78Wide'
	bStatic=false
	bHidden=false
	bAlwaysRelevant=true
	RemoteRole=2
	bCollideWhenPlacing=false
	bDirectional=true
	bEdShouldSnap=true
	bPathColliding=true
}