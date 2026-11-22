class HandheldEquipmentModel extends Actor implements IEvidence
	abstract
	native
	config(SwatGame)
	notplaceable
	hidecategories(Karma,Advanced,Events,Force,LightColor,Lighting,Movement,Object,Sound);

cpptext
{
    virtual void PreRenderCallback(UBOOL MainScene, FLevelSceneNode* SceneNode, FRenderInterface* RI);
    virtual void TickSpecial(FLOAT deltaSeconds);

}

struct native IdleAnimation
{
	var() int Chance;
	var() name Animation;
};

var(HandheldEquipmentModelAnimations) name EquipAnimation;
var(HandheldEquipmentModelAnimations) name UnequipAnimation;
var(HandheldEquipmentModelAnimations) name UseAnimation;
var(HandheldEquipmentModelAnimations) array<IdleAnimation> HolderIdleAnimations;
var int IdleChanceSum;
var(HandheldEquipmentModelAnimations) name HolderLowReadyIdleAnimation;
var(HandheldEquipmentModelAnimations) name HolderDisorientedLowReadyIdleAnimation;
var(HandheldEquipmentModelAnimations) name HolderEquipAnimation;
var(HandheldEquipmentModelAnimations) name HolderUnequipAnimation;
var(HandheldEquipmentModelAnimations) name HolderUseAnimation;
var(HandheldEquipmentModelAnimations) float HolderEquipTweenTime;
var config name HolderUnequipFromMPCuffedAnimation;
var name EquippedSocket;
var name UnequippedSocket;
var(ExtraAnimationSets) array<string> ExtraAnimationSets "If you want this HandheldEquipmentModel to play any animations that are not in the default (first) Animation Set for the selected Mesh, then you must add to this list any other Animation Sets that you will use.  Each entry should look like {AnimationPackageName}.{AnimationSetName}";
var int HolderEquipAnimationChannel;
var int HolderUnEquipAnimationChannel;
var int HolderUseAnimationChannel;
var private bool bIsEquipped;
var HandheldEquipment HandheldEquipment;
var private bool IsBusy;
var config name HolderAnimationRootBone;
var name SelectedUseAnimation;
var name SelectedHolderUseAnimation;
var float SelectedUseAnimationRate;
var float SelectedHolderUseAnimationRate;
var StaticMesh DroppedStaticMesh;
var bool bIsDropped;
var private bool WasPrimary;
var private Vector MostRecentLocation;
var private bool bNotifiedOfWeaponAtRest;
var private int AtRestCountdown;
var private Vector AtRestLocation;
var private Rotator AtRestRotation;
var private string PrecomputedUniqueID;

simulated function PostNetBeginPlay()
{
	local int i;

	super.PostNetBeginPlay();
	LoadAnimationSets(ExtraAnimationSets);
	i = 0;
	J0x18:

	if(Less_IntInt(i, HolderIdleAnimations.Length))
	{
		AddEqual_IntInt(IdleChanceSum, HolderIdleAnimations[i].Chance);
		AddAdd_PreInt(i);
		// [Loop Continue]
		goto J0x18;
	}
	return;
}

simulated event FellOutOfWorld(Actor.eKillZType KillType)
{
	local Controller i, theLocalPlayerController;
	local PlayerController Current;
	local Vector MovementDelta;

	SetPhysics(0);
	if(Level.GetEngine().EnableDevTools)
	{
		Log(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr("!!!! WARNING !!!!! Destroying actor ", string(self)), " because it fell out of world at location "), string(Location.X)), ", "), string(Location.Y)), ", "), string(Location.Z)));
		MPLog("...setting physics to PHYS_None.");
	}
	if(NotEqual_IntInt(int(Level.NetMode), int(NM_Client)))
	{
		if(Level.GetEngine().EnableDevTools)
		{
			AssertWithDescription(false, Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr("!!!! WARNING !!!!! Destroying actor ", string(self)), " because it fell out of world at location "), string(Location.X)), ", "), string(Location.Y)), ", "), string(Location.Z)));
			MPLog("...on server");
		}
		if(NotEqual_IntInt(int(Level.NetMode), int(NM_Standalone)))
		{
			theLocalPlayerController = Level.GetLocalPlayerController();
			i = Level.ControllerList;
			J0x1FB:

			if(NotEqual_ObjectObject(i, none))
			{
				Current = PlayerController(i);
				if(AndAnd_BoolBool(NotEqual_ObjectObject(Current, none), NotEqual_ObjectObject(Current, theLocalPlayerController)))
				{
					Current.ClientWeaponFellOutOfWorld(UniqueID());
				}
				i = i.nextController;
				// [Loop Continue]
				goto J0x1FB;
			}
		}
		if(Level.GetEngine().EnableDevTools)
		{
			MPLog("...destroying.");
		}
		Destroy();
	}
	else
	{
		if(Level.GetEngine().EnableDevTools)
		{
			MPLog("...on client");
		}
		if(bNotifiedOfWeaponAtRest)
		{
			if(Level.GetEngine().EnableDevTools)
			{
				MPLog(Concat_StrStr(Concat_StrStr("...bNotifiedOfWeaponAtRest=", string(bNotifiedOfWeaponAtRest)), ", using AtRest values."));
			}
			SetRotation(AtRestRotation);
			MovementDelta = Subtract_VectorVector(AtRestLocation, Location);
			Move(MovementDelta);
		}
	}
	return;
}

simulated function ProcessAtRestValuesFromServer(Vector ServerLocation, Rotator ServerRotation)
{
	local Vector MovementDelta;

	if(Level.GetEngine().EnableDevTools)
	{
		MPLog(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr(string(self), "HEM::ProcessAtRestValuesFromServer(). ServerLocation="), string(ServerLocation)), ", ServerRotation="), string(ServerRotation)));
	}
	AtRestLocation = ServerLocation;
	AtRestRotation = ServerRotation;
	if(EqualEqual_IntInt(int(Physics), int(0)))
	{
		if(Level.GetEngine().EnableDevTools)
		{
			MPLog("...Physics=PHYS_None, so using AtRest values.");
		}
		SetRotation(AtRestRotation);
		MovementDelta = Subtract_VectorVector(AtRestLocation, Location);
		Move(MovementDelta);
	}
	return;
}

simulated function SetHandHeldEquipment(HandheldEquipment HHE)
{
	AssertWithDescription(NotEqual_ObjectObject(HHE, none), Concat_StrStr("[tcohen] You cannot assign None as the HandheldEquipment of HandheldEquipmentModel ", string(Class.Name)));
	self.HandheldEquipment = HHE;
	if(NotEqual_IntInt(int(DrawType), int(2)))
	{
		AssertWithDescription(EqualEqual_NameName(EquipAnimation, 'None'), Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr("[tcohen] The ", string(HandheldEquipment.Class.Name)), "'s Model "), string(Class.Name)), " specifies an EquipAnimation, but its DrawType is not DT_Mesh.  Shawn should fix this."));
		AssertWithDescription(EqualEqual_NameName(UnequipAnimation, 'None'), Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr("[tcohen] The ", string(HandheldEquipment.Class.Name)), "'s Model "), string(Class.Name)), " specifies an UnEquipAnimation, but its DrawType is not DT_Mesh.  Shawn should fix this."));
		AssertWithDescription(EqualEqual_NameName(UseAnimation, 'None'), Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr("[tcohen] The ", string(HandheldEquipment.Class.Name)), "'s Model "), string(Class.Name)), " specifies a UeAnimation, but its DrawType is not DT_Mesh.  Shawn should fix this."));
	}
	return;
}

simulated function bool IsEquipped()
{
	return bIsEquipped;
	return;
}

simulated function SetEquipped(bool Equipped)
{
	bIsEquipped = Equipped;
	return;
}

simulated function PlayEquip()
{
	AssertWithDescription(Not_PreBool(IsEquipped()), Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr("[tcohen] ", string(Name)), " (of class "), string(Class.Name)), ") was called to PlayEquip().  But it thinks its already equipped."));
	if(NotEqual_NameName(EquipAnimation, 'None'))
	{
		PlayAnim(EquipAnimation, HandheldEquipment.EquipAnimationRate);
	}
	if(NotEqual_NameName(HolderEquipAnimation, 'None'))
	{
		if(Owner.IsA('SwatPawn'))
		{
			HolderEquipAnimationChannel = Pawn(Owner).AnimPlayEquipment(0, HolderEquipAnimation, HolderEquipTweenTime, HolderAnimationRootBone, HandheldEquipment.EquipAnimationRate);
		}
		else
		{
			Owner.PlayAnim(HolderEquipAnimation, HandheldEquipment.EquipAnimationRate, HolderEquipTweenTime);
			HolderEquipAnimationChannel = 0;
		}
	}
	return;
}

latent simulated function FinishEquip()
{
	if(NotEqual_NameName(EquipAnimation, 'None'))
	{
		FinishAnim();
	}
	if(NotEqual_NameName(HolderEquipAnimation, 'None'))
	{
		Owner.FinishAnim(HolderEquipAnimationChannel);
	}
	if(AndAnd_BoolBool(Not_PreBool(IsEquipped()), Not_PreBool(Class'Engine.Pawn'.static.checkDead(Pawn(Owner)))))
	{
		Log(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr("[WARNING] ", string(Name)), " (of class"), string(Class.Name)), ") finished playing any equip animations.  But it doesn't think its equipped.  Check that 1) the HolderEquipAnimation is specified (currently "), string(HolderEquipAnimation)), "), 2) that has an AnimNotify_Equip, and 3) the animation group is listed in SwatGame.ini section [Engine.Hands]."), " (This can also happen during normal gameplay if a pawn interrupts equipping before it completes.)"));
	}
	return;
}

simulated function OnEquipKeyFrame()
{
	AssertWithDescription(NotEqual_NameName(EquippedSocket, 'None'), Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr("[tcohen] ", string(Name)), " was just equipped, but it doesn't know which socket on its owner ("), string(Owner)), ") to attach to.  Please specify an EquippedSocket for class "), string(Class.Name)), "."));
	Owner.DetachFromBone(self);
	Show();
	Owner.AttachToBone(self, EquippedSocket);
	SetEquipped(true);
	return;
}

simulated function PlayUnequip()
{
	local name HolderUnequipAnimationForContext;

	AssertWithDescription(IsEquipped(), Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr("[tcohen] ", string(Name)), " (of class "), string(Class.Name)), ") was called to PlayUnequip().  But it doesn't think its equipped."));
	if(NotEqual_NameName(UnequipAnimation, 'None'))
	{
		PlayAnim(UnequipAnimation, HandheldEquipment.UnequipAnimationRate);
	}
	HolderUnequipAnimationForContext = GetHolderUnequipAnimationForContext();
	if(NotEqual_NameName(HolderUnequipAnimationForContext, 'None'))
	{
		if(Owner.IsA('SwatPawn'))
		{
			HolderUnEquipAnimationChannel = Pawn(Owner).AnimPlayEquipment(0, HolderUnequipAnimationForContext,, HolderAnimationRootBone, HandheldEquipment.UnequipAnimationRate);
		}
		else
		{
			Owner.PlayAnim(HolderUnequipAnimationForContext, HandheldEquipment.UnequipAnimationRate, 0.5000000);
			HolderUnEquipAnimationChannel = 0;
		}
	}
	return;
}

latent simulated function FinishUnequip()
{
	if(NotEqual_NameName(UnequipAnimation, 'None'))
	{
		FinishAnim();
	}
	if(NotEqual_NameName(GetHolderUnequipAnimationForContext(), 'None'))
	{
		Owner.FinishAnim(HolderUnEquipAnimationChannel);
	}
	AssertWithDescription(OrOr_BoolBool(Not_PreBool(IsEquipped()), Class'Engine.Pawn'.static.checkDead(Pawn(Owner))), Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr("[tcohen] ", string(Name)), " (of class"), string(Class.Name)), ") finished playing any unequip animations.  But it still thinks its equipped.  Check that 1) the HolderUnEquipAnimation is specified (currently "), string(HolderUnequipAnimation)), "), 2) that has an AnimNotify_UnEquip, and 3) the animation group is listed in SwatGame.ini section [Engine.Hands]."));
	return;
}

private simulated function name GetHolderUnequipAnimationForContext()
{
	local Pawn PawnOwner;
	local name HolderUnequipAnimationForContext;
	local HandheldEquipment PendingItem;

	if(NotEqual_IntInt(int(Level.NetMode), int(NM_Standalone)))
	{
		PawnOwner = Pawn(Owner);
		if(NotEqual_ObjectObject(PawnOwner, none))
		{
			PendingItem = PawnOwner.GetPendingItem();
			if(AndAnd_BoolBool(NotEqual_ObjectObject(PendingItem, none), PendingItem.IsA('IAmCuffed')))
			{
				HolderUnequipAnimationForContext = HolderUnequipFromMPCuffedAnimation;
			}
		}
	}
	if(EqualEqual_NameName(HolderUnequipAnimationForContext, 'None'))
	{
		HolderUnequipAnimationForContext = HolderUnequipAnimation;
	}
	return HolderUnequipAnimationForContext;
	return;
}

simulated function OnUnequipKeyFrame()
{
	Owner.DetachFromBone(self);
	if(NotEqual_NameName(UnequippedSocket, 'None'))
	{
		Owner.AttachToBone(self, UnequippedSocket);
	}
	else
	{
		Hide();
	}
	SetEquipped(false);
	return;
}

simulated function PlayUse(float TweenTime)
{
	local Pawn.EAnimPlayType AnimPlayType;

	SelectUseAnimations(SelectedUseAnimation, SelectedUseAnimationRate, SelectedHolderUseAnimation, SelectedHolderUseAnimationRate, AnimPlayType);
	if(NotEqual_NameName(SelectedUseAnimation, 'None'))
	{
		PlayAnim(SelectedUseAnimation, SelectedUseAnimationRate, TweenTime);
	}
	if(NotEqual_NameName(SelectedHolderUseAnimation, 'None'))
	{
		if(Owner.IsA('SwatPawn'))
		{
			if(EqualEqual_ObjectObject(self, HandheldEquipment.FirstPersonModel))
			{
				HolderUseAnimationChannel = Pawn(Owner).AnimPlayEquipment(0, SelectedHolderUseAnimation,, HolderAnimationRootBone, SelectedHolderUseAnimationRate);
			}
			else
			{
				HolderUseAnimationChannel = Pawn(Owner).AnimPlayEquipment(AnimPlayType, SelectedHolderUseAnimation,, HolderAnimationRootBone, SelectedHolderUseAnimationRate);
			}
		}
		else
		{
			Owner.PlayAnim(SelectedHolderUseAnimation, SelectedHolderUseAnimationRate);
			HolderUseAnimationChannel = 0;
		}
	}
	return;
}

latent simulated function FinishUse()
{
	if(NotEqual_NameName(SelectedUseAnimation, 'None'))
	{
		FinishAnim();
	}
	if(NotEqual_NameName(SelectedHolderUseAnimation, 'None'))
	{
		Owner.FinishAnim(HolderUseAnimationChannel);
	}
	return;
}

simulated function OnUseKeyFrame()
{
	return;
}

protected simulated function SelectUseAnimations(out name outSelectedUseAnimation, out float outSelectedUseAnimationRate, out name outSelectedHolderUseAnimation, out float outSelectedHolderUseAnimationRate, out Pawn.EAnimPlayType outAnimPlayType)
{
	outSelectedUseAnimation = UseAnimation;
	outSelectedUseAnimationRate = HandheldEquipment.UseAnimationRate;
	outSelectedHolderUseAnimation = HolderUseAnimation;
	outSelectedHolderUseAnimationRate = HandheldEquipment.UseAnimationRate;
	outAnimPlayType = 0;
	return;
}

simulated function OnDropped(bool bPrimary)
{
	if(Level.GetEngine().EnableDevTools)
	{
		MPLog(Concat_StrStr(string(self), "---HandheldEquipmentModel::OnDropped()."));
	}
	WasPrimary = bPrimary;
	bIsDropped = true;
	if(Level.IsCOOPServer)
	{
		MostRecentLocation = vect(0.0000000, 0.0000000, 0.0000000);
	}
	return;
}

event NotifyClientsDroppedWeaponAtRest()
{
	local Controller i, theLocalPlayerController;
	local PlayerController Current;

	assert(Level.IsCOOPServer);
	if(Level.GetEngine().EnableDevTools)
	{
		MPLog(Concat_StrStr(string(self), "---HandheldEquipmentModel::NotifyClientsDroppedWeaponAtRest()."));
		MPLog(Concat_StrStr("...UniqueID()=", UniqueID()));
		MPLog(Concat_StrStr("...Location=", string(Location)));
		MPLog(Concat_StrStr("...Rotation=", string(Rotation)));
	}
	theLocalPlayerController = Level.GetLocalPlayerController();
	i = Level.ControllerList;
	J0xFA:

	if(NotEqual_ObjectObject(i, none))
	{
		Current = PlayerController(i);
		if(AndAnd_BoolBool(NotEqual_ObjectObject(Current, none), NotEqual_ObjectObject(Current, theLocalPlayerController)))
		{
			Current.ClientDroppedWeaponAtRest(UniqueID(), Location.X, Location.Y, Location.Z, Rotation);
		}
		i = i.nextController;
		// [Loop Continue]
		goto J0xFA;
	}
	return;
}

function NotifyClientsAIDroppedWeapon(Vector ThrowDirectionImpulse)
{
	local Controller i, theLocalPlayerController;
	local PlayerController Current;

	assert(Level.IsCOOPServer);
	if(Level.GetEngine().EnableDevTools)
	{
		MPLog(Concat_StrStr(string(self), "---HandheldEquipmentModel::NotifyClientsAIDroppedWeapon()."));
		MPLog(Concat_StrStr("...UniqueID()=", UniqueID()));
		MPLog(Concat_StrStr("...Location=", string(Location)));
		MPLog(Concat_StrStr("...Rotation=", string(Rotation)));
		MPLog(Concat_StrStr("...ThrowDirectionImpulse=", string(ThrowDirectionImpulse)));
		MPLog(Concat_StrStr("...class=", string(Class)));
	}
	theLocalPlayerController = Level.GetLocalPlayerController();
	i = Level.ControllerList;
	J0x13A:

	if(NotEqual_ObjectObject(i, none))
	{
		Current = PlayerController(i);
		if(AndAnd_BoolBool(NotEqual_ObjectObject(Current, none), NotEqual_ObjectObject(Current, theLocalPlayerController)))
		{
			Current.ClientAIDroppedWeapon(UniqueID(), Location, Rotation, ThrowDirectionImpulse, Class);
		}
		i = i.nextController;
		// [Loop Continue]
		goto J0x13A;
	}
	return;
}

simulated function bool IsDropped()
{
	return bIsDropped;
	return;
}

simulated function OnUsed(Pawn SecurerPawn)
{
	TriggerEffectEvent('Secured');
	SecurerPawn.OnEvidenceSecured(self);
	return;
}

simulated function bool CanBeUsedNow()
{
	return AndAnd_BoolBool(bIsDropped, Not_PreBool(bHidden));
	return;
}

simulated function PostUsed()
{
	Hide();
	return;
}

simulated function SetUniqueID(string NewValue)
{
	assert(EqualEqual_StrStr(PrecomputedUniqueID, ""));
	assert(NotEqual_StrStr(NewValue, ""));
	if(Level.GetEngine().EnableDevTools)
	{
		MPLog(Concat_StrStr("...caching UniqueID: ", NewValue));
	}
	PrecomputedUniqueID = NewValue;
	return;
}

simulated function string UniqueID()
{
	local string PrimaryString, NewUniqueID;
	local bool CacheUniqueID;

	if(NotEqual_StrStr(PrecomputedUniqueID, ""))
	{
		return PrecomputedUniqueID;
	}
	CacheUniqueID = false;
	if(EqualEqual_ObjectObject(ICanBeUsed(Owner), none))
	{
		return "InvalidUniqueID-OwnerWasNone";
	}
	if(bIsDropped)
	{
		if(WasPrimary)
		{
			PrimaryString = "Pocket_PrimaryWeapon";
		}
		else
		{
			PrimaryString = "Pocket_SecondaryWeapon";
		}
		CacheUniqueID = true;
	}
	else
	{
		if(AndAnd_BoolBool(Owner.IsA('SwatEnemy'), NotEqual_ObjectObject(FiredWeapon(HandheldEquipment), none)))
		{
			if(Level.GetEngine().EnableDevTools)
			{
				MPLog(Concat_StrStr("......IsPrimaryWeapon()=", string(Pawn(Owner).IsPrimaryWeapon(HandheldEquipment))));
			}
			if(Pawn(Owner).IsPrimaryWeapon(HandheldEquipment))
			{
				PrimaryString = "Pocket_PrimaryWeapon";
			}
			else
			{
				PrimaryString = "Pocket_SecondaryWeapon";
			}
			CacheUniqueID = true;
		}
		else
		{
			PrimaryString = string(GetEnum(Enum'Engine.HandheldEquipment.Pocket', int(HandheldEquipment.GetPocket())));
			if(NotEqual_StrStr(PrimaryString, "Pocket_Invalid"))
			{
				CacheUniqueID = true;
			}
			else
			{
				if(Level.GetEngine().EnableDevTools)
				{
					MPLog("...cannot compute UniqueID. HandheldEquipment's pocket=Pocket_Invalid.");
				}
			}
		}
	}
	NewUniqueID = Concat_StrStr(ICanBeUsed(Owner).UniqueID(), PrimaryString);
	if(CacheUniqueID)
	{
		SetUniqueID(NewUniqueID);
	}
	return NewUniqueID;
	return;
}

defaultproperties
{
	HolderUnequipFromMPCuffedAnimation="sGetCuffedStartMP"
	HolderAnimationRootBone="Bip01_Spine1"
	AtRestCountdown=5
	DrawType=2
	bActorShadows=true
	bHidden=true
	bAcceptsShadowProjectors=false
	RemoteRole=0
}