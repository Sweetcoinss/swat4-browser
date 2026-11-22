class Hands extends Actor implements ICanHoldEquipment, ICanThrowWeapons, ICanHoldEquipment, ICanThrowWeapons
	native
	config(SwatGame)
	notplaceable
	hidecategories(Karma);

cpptext
{
    // Automatically updates the correct value of bOwnerNoSee based on
    // the current view.
    virtual UBOOL Tick( FLOAT DeltaSeconds, ELevelTick TickType );
    virtual void PreRenderCallback(UBOOL MainScene, FLevelSceneNode* SceneNode, FRenderInterface* RI);

}

var config Vector PlayerViewOffset;
var config array<string> AnimationGroups;
var config float MinimumLongThrowSpeed;
var config name ThrowShortAnimation;
var config name ThrowLongAnimation;
var config name PreThrowAnimation;
var config float PreThrowTweenTime;
var config float PreThrowRootBone;
var private bool bIsLowReady;
var private float NextIdleTweenTime;

simulated function PreBeginPlay()
{
	AssertWithDescription(Greater_IntInt(AnimationGroups.Length, 0), "[tcohen] The Hands' AnimationGroups list is empty.  Check SwatGame.ini, [Engine.Hands].");
	AssertWithDescription(NotEqual_ObjectObject(Mesh, none), "[ckline] The Hands' mesh wasn't correctly loaded(1). Mesh == None.");
	LoadAnimationSets(AnimationGroups);
	SetTweenMode(0, 1);
	AssertWithDescription(NotEqual_ObjectObject(Mesh, none), "[ckline] The Hands' mesh wasn't correctly loaded(2). Mesh == None.");
	SetCollision(false, false, false);
	return;
}

simulated event PostNetBeginPlay()
{
	super.PostNetBeginPlay();
	AssertWithDescription(NotEqual_NameName(Level.Label, 'None'), "[mjames] Every level must have its label set. The current level's label is None.");
	registerClientMessage(Class'Engine.MessagePreRender', string(Level.Label));
	return;
}

simulated function onMessage(Message M)
{
	UpdateHandsForRendering();
	return;
}

simulated function UpdateHandsForRendering()
{
	local Pawn PawnOwner;
	local Vector NewLocation;
	local Rotator NewRotation;
	local HandheldEquipmentModel EquippedFirstPersonModel;
	local HandheldEquipment EquippedItem;

	PawnOwner = Pawn(Owner);
	if(EqualEqual_ObjectObject(PawnOwner, none))
	{
		AssertWithDescription(false, "[tcohen] Hands.UpdateHandsForRendering() was called, but its Owner wasn't a Pawn.");
	}
	NewRotation = PawnOwner.GetViewRotation();
	NewLocation = Add_VectorVector(Add_VectorVector(PawnOwner.Location, PawnOwner.CalcDrawOffset()), PawnOwner.ViewLocationOffset(NewRotation));
	EquippedItem = PawnOwner.GetActiveItem();
	if(NotEqual_ObjectObject(EquippedItem, none))
	{
		EquippedFirstPersonModel = EquippedItem.FirstPersonModel;
		if(NotEqual_ObjectObject(EquippedFirstPersonModel, none))
		{
			EquippedFirstPersonModel.bOwnerNoSee = Not_PreBool(PawnOwner.bRenderHands);
		}
	}
	bOwnerNoSee = Not_PreBool(PawnOwner.bRenderHands);
	if(AndAnd_BoolBool(bOwnerNoSee, EquippedItem.IsA('optiwand')))
	{
		if(NotEqual_ObjectObject(EquippedFirstPersonModel, none))
		{
			EquippedFirstPersonModel.bOwnerNoSee = false;
		}
		bOwnerNoSee = false;
	}
	SetLocation(NewLocation);
	SetRotation(NewRotation);
	return;
}

simulated function OnEquipKeyFrame()
{
	Pawn(Owner).super(Hands).OnEquipKeyFrame();
	return;
}

simulated function OnUnequipKeyFrame()
{
	Pawn(Owner).OnUnequipKeyFrame();
	return;
}

simulated function OnUseKeyFrame()
{
	Pawn(Owner).OnUseKeyFrame();
	return;
}

simulated function OnReloadKeyFrame()
{
	Pawn(Owner).OnReloadKeyFrame();
	return;
}

event AnimEnd(int Channel)
{
	if(Level.GetLocalPlayerController().HandsShouldIdle())
	{
		IdleHoldingEquipment();
	}
	return;
}

simulated function IdleHoldingEquipment()
{
	local int RandChance, AccumulatedChance, i;
	local HandheldEquipmentModel Model;
	local HandheldEquipment theActiveItem;
	local float SavedTweenTime;

	SavedTweenTime = NextIdleTweenTime;
	SetNextIdleTweenTime(0.0000000);
	theActiveItem = GetActiveItem();
	if(EqualEqual_ObjectObject(theActiveItem, none))
	{
		return;
	}
	Model = theActiveItem.GetFirstPersonModel();
	if(AndAnd_BoolBool(bIsLowReady, NotEqual_NameName(Model.HolderLowReadyIdleAnimation, 'None')))
	{
		if(AndAnd_BoolBool(NotEqual_NameName(Model.HolderDisorientedLowReadyIdleAnimation, 'None'), ICanBeArrested(Owner).CanBeArrestedNow()))
		{
			PlayNewAnim(Model.HolderDisorientedLowReadyIdleAnimation, 0.0000000, 0.2000000);
		}
		else
		{
			PlayNewAnim(Model.HolderLowReadyIdleAnimation, 0.0000000, 0.2000000);
		}
	}
	else
	{
		if(EqualEqual_IntInt(Model.HolderIdleAnimations.Length, 0))
		{
			return;
		}
		RandChance = Rand(Model.IdleChanceSum);
		i = 0;
		J0x10E:

		if(Less_IntInt(i, Model.HolderIdleAnimations.Length))
		{
			AddEqual_IntInt(AccumulatedChance, Model.HolderIdleAnimations[i].Chance);
			if(GreaterEqual_IntInt(AccumulatedChance, RandChance))
			{
				PlayNewAnim(Model.HolderIdleAnimations[i].Animation, 1.0000000, SavedTweenTime);
				return;
			}
			AddAdd_PreInt(i);
			// [Loop Continue]
			goto J0x10E;
		}
		assert(false);
	}
	return;
}

function PlayNewAnim(name Sequence, float Rate, float TweenTime)
{
	if(OrOr_BoolBool(Not_PreBool(IsAnimating()), NotEqual_NameName(GetAnimName(), Sequence)))
	{
		PlayAnim(Sequence, Rate, TweenTime);
	}
	return;
}

function SetLowReady(bool bEnable)
{
	if(EqualEqual_BoolBool(bIsLowReady, bEnable))
	{
		return;
	}
	bIsLowReady = bEnable;
	if(Level.GetLocalPlayerController().HandsShouldIdle())
	{
		SetNextIdleTweenTime(0.2000000);
		IdleHoldingEquipment();
	}
	return;
}

function SetNextIdleTweenTime(float inNextIdleTweenTime)
{
	NextIdleTweenTime = inNextIdleTweenTime;
	return;
}

simulated function HandheldEquipment GetActiveItem()
{
	return Pawn(Owner).GetActiveItem();
	return;
}

simulated function HandheldEquipment GetPendingItem()
{
	return Pawn(Owner).GetPendingItem();
	return;
}

function GetThrownProjectileParams(out Vector outLocation, out Rotator outRotation)
{
	assert(false);
	return;
}

function name GetPawnThrowRootBone()
{
	assert(false);
	return 'None';
	return;
}

simulated function float GetPawnThrowTweenTime()
{
	assert(false);
	return 0.0000000;
	return;
}

simulated function name GetPreThrowAnimation()
{
	return PreThrowAnimation;
	return;
}

simulated function name GetThrowAnimation(float ThrowSpeed)
{
	if(Less_FloatFloat(ThrowSpeed, MinimumLongThrowSpeed))
	{
		return ThrowShortAnimation;
	}
	else
	{
		return ThrowLongAnimation;
	}
	return;
}

simulated function SetMaterialForHands(Material NewMaterial)
{
	assert(NotEqual_IntInt(int(Level.NetMode), int(NM_Standalone)));
	Skins[0] = NewMaterial;
	return;
}

defaultproperties
{
	bNeedPostRenderCallback=true
	bNeverDrawIfPlayerIsDrawn=true
	DrawType=2
	RemoteRole=0
	Mesh=SkeletalMesh'FP_Hand.1stPersonHand'
	MaxLights=5
}