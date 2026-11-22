class HandheldEquipment extends Equipment implements ICanBeSelectedInTheGUI
	abstract
	native
	config(SwatEquipment)
	notplaceable
	hidecategories(Karma);

cpptext
{
    // Automatically updates the correct value of bOwnerNoSee based on
    // the current view and what this equipment is attached to.
    virtual UBOOL Tick( FLOAT DeltaSeconds, ELevelTick TickType );

    // Returns true if this weapon is currently being rendered in 1st person view,
    // otherwise returns false to indicate 3rd person view
    UBOOL InFirstPersonView();

}

enum EquipmentSlot
{
	Slot_Invalid,                   // 0
	Slot_PrimaryWeapon,             // 1
	Slot_SecondaryWeapon,           // 2
	Slot_Flashbang,                 // 3
	Slot_CSGasGrenade,              // 4
	Slot_StingGrenade,              // 5
	Slot_PepperSpray,               // 6
	Slot_Breaching,                 // 7
	Slot_Toolkit,                   // 8
	Slot_Optiwand,                  // 9
	Slot_Wedge,                     // 10
	Slot_Cuffs,                     // 11
	Slot_Detonator,                 // 12
	Slot_IAmCuffed,                 // 13
	kNumEquipmentSlots              // 14
};

enum Pocket
{
	Pocket_PrimaryWeapon,           // 0
	Pocket_PrimaryAmmo,             // 1
	Pocket_SecondaryWeapon,         // 2
	Pocket_SecondaryAmmo,           // 3
	Pocket_EquipOne,                // 4
	Pocket_EquipTwo,                // 5
	Pocket_EquipThree,              // 6
	Pocket_EquipFour,               // 7
	Pocket_EquipFive,               // 8
	Pocket_Breaching,               // 9
	Pocket_BodyArmor,               // 10
	Pocket_HeadArmor,               // 11
	Pocket_Toolkit,                 // 12
	Pocket_Detonator,               // 13
	Pocket_Cuffs,                   // 14
	Pocket_IAmCuffed,               // 15
	Pocket_HiddenC2Charge1,         // 16
	Pocket_HiddenC2Charge2,         // 17
	Pocket_SimpleBackPouch,         // 18
	Pocket_SimpleHipPouch,          // 19
	Pocket_SimpleHolster,           // 20
	Pocket_SimplePepperSprayPouch,  // 21
	Pocket_SimpleRadioPouch,        // 22
	Pocket_HeadEffectProtection,    // 23
	Pocket_Invalid                  // 24
};

enum ActionStatus
{
	ActionStatus_Idle,              // 0
	ActionStatus_Started,           // 1
	ActionStatus_HitKeyFrame        // 2
};

var config int Range;
var config Class<HandheldEquipmentModel> FirstPersonModelClass;
var config Class<HandheldEquipmentModel> ThirdPersonModelClass;
var config Class<HandheldEquipmentModel> MPFirstPersonModelClass;
var config Class<HandheldEquipmentModel> MPThirdPersonModelClass;
var config localized string Description;
var config localized string FriendlyName;
var config Material GUIImage;
var bool ShouldLowReady;
var config float ZoomedFOV;
var config float ZoomTime;
var config Material ZoomBlurOverlay;
var private HandheldEquipment.EquipmentSlot Slot;
var private HandheldEquipment.Pocket ThePocket;
var HandheldEquipmentModel FirstPersonModel;
var HandheldEquipmentModel ThirdPersonModel;
var private HandheldEquipment.ActionStatus EquippingStatus;
var private HandheldEquipment.ActionStatus UnequippingStatus;
var private HandheldEquipment.ActionStatus UsingStatus;
var config float EquipAnimationRate;
var config float UnequipAnimationRate;
var config float UseAnimationRate;
var private bool Available;
var bool UnavailableAfterUsed;
var bool EquipOtherAfterUsed;
var bool PlayerCanUnequip;
var config bool ShouldHaveFirstPersonModel;
var config bool ShouldHaveThirdPersonModel;
var float FramerateCompensationDelay;
var HandheldEquipmentPickup Pickup;

function PostBeginPlay()
{
	super(Actor).PostBeginPlay();
	return;
}

simulated event PostNetBeginPlay()
{
	super(Actor).PostNetBeginPlay();
	AssertWithDescription(NotEqual_ObjectObject(Owner, none), Concat_StrStr(Concat_StrStr("[tcohen] The HandheldEquipment ", string(Name)), " is not owned by any Pawn."));
	CreateModels();
	return;
}

simulated function CreateModels()
{
	local Class<HandheldEquipmentModel> SelectedFirstPersonModelClass, SelectedThirdPersonModelClass;

	SelectModelClasses(SelectedFirstPersonModelClass, SelectedThirdPersonModelClass);
	if(ShouldHaveFirstPersonModel)
	{
		AssertWithDescription(NotEqual_ObjectObject(SelectedFirstPersonModelClass, none), Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr("[tcohen] The class ", string(Class.Name)), " should have a valid FirstPersonModelClass, but it doesn't.  In SwatEquipment.ini, [SwatEquipment."), string(Class.Name)), ", please specify a valid FirstPersonModelClass, or set ShouldHaveFirstPersonModel=false."));
	}
	else
	{
		AssertWithDescription(EqualEqual_ObjectObject(SelectedFirstPersonModelClass, none), Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr("[tcohen] The class ", string(Class.Name)), " should not have a valid FirstPersonModelClass, but it does.  In SwatEquipment.ini, [SwatEquipment."), string(Class.Name)), ", please specify FirstPersonModelClass=None, or set ShouldHaveFirstPersonModel=true."));
	}
	if(AndAnd_BoolBool(ShouldHaveFirstPersonModel, NotEqual_ObjectObject(GetHands(), none)))
	{
		FirstPersonModel = Spawn(SelectedFirstPersonModelClass, Pawn(Owner).GetHands(),,,, true);
		AssertWithDescription(NotEqual_ObjectObject(FirstPersonModel, none), Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr("[tcohen] ", string(Name)), " failed to spawn its FirstPersonModel of class "), string(SelectedFirstPersonModelClass)), "."));
		FirstPersonModel.SetHandHeldEquipment(self);
		FirstPersonModel.Show();
		FirstPersonModel.OnUnequipKeyFrame();
		if(NotEqual_NameName(FirstPersonModel.HolderLowReadyIdleAnimation, 'None'))
		{
			ShouldLowReady = true;
		}
	}
	if(ShouldHaveThirdPersonModel)
	{
		AssertWithDescription(NotEqual_ObjectObject(SelectedThirdPersonModelClass, none), Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr("[tcohen] The class ", string(Class.Name)), " should have a valid ThirdPersonModelClass, but it doesn't.  In SwatEquipment.ini, [SwatEquipment."), string(Class.Name)), ", please specify a valid ThirdPersonModelClass, or set ShouldHaveThirdPersonModel=false."));
		ThirdPersonModel = Spawn(SelectedThirdPersonModelClass, Owner,,,, true);
		AssertWithDescription(NotEqual_ObjectObject(ThirdPersonModel, none), Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr("[tcohen] ", string(Name)), " failed to spawn its ThirdPersonModel of class "), string(ThirdPersonModelClass)), "."));
		ThirdPersonModel.SetHandHeldEquipment(self);
		ThirdPersonModel.Show();
		ThirdPersonModel.OnUnequipKeyFrame();
	}
	else
	{
		AssertWithDescription(EqualEqual_ObjectObject(SelectedThirdPersonModelClass, none), Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr("[tcohen] The class ", string(Class.Name)), " should not have a valid ThirdPersonModelClass, but it does.  In SwatEquipment.ini, [SwatEquipment."), string(Class.Name)), ", please specify ThirdPersonModelClass=None, or set ShouldHaveThirdPersonModel=true."));
	}
	return;
}

simulated function SelectModelClasses(out Class<HandheldEquipmentModel> SelectedFirstPersonModelClass, out Class<HandheldEquipmentModel> SelectedThirdPersonModelClass)
{
	if(OrOr_BoolBool(OrOr_BoolBool(EqualEqual_IntInt(int(Level.NetMode), int(NM_Standalone)), Level.IsPlayingCOOP), EqualEqual_ObjectObject(MPFirstPersonModelClass, none)))
	{
		SelectedFirstPersonModelClass = FirstPersonModelClass;
	}
	else
	{
		SelectedFirstPersonModelClass = MPFirstPersonModelClass;
	}
	if(OrOr_BoolBool(OrOr_BoolBool(EqualEqual_IntInt(int(Level.NetMode), int(NM_Standalone)), Level.IsPlayingCOOP), EqualEqual_ObjectObject(MPThirdPersonModelClass, none)))
	{
		SelectedThirdPersonModelClass = ThirdPersonModelClass;
	}
	else
	{
		SelectedThirdPersonModelClass = MPThirdPersonModelClass;
	}
	return;
}

// Export UHandheldEquipment::execInFirstPersonView(FFrame&, void* const)
protected native function bool InFirstPersonView();

simulated function Hands GetHands()
{
	return Pawn(Owner).super(HandheldEquipment).GetHands();
	return;
}

simulated function HandheldEquipment.EquipmentSlot GetSlot()
{
	return Slot;
	return;
}

simulated function SetSlot(HandheldEquipment.EquipmentSlot NewSlot)
{
	Slot = NewSlot;
	return;
}

static simulated function HandheldEquipment.EquipmentSlot GetDefaultSlot()
{
	return default.Slot;
	return;
}

simulated function HandheldEquipment.Pocket GetPocket()
{
	return ThePocket;
	return;
}

simulated function SetPocket(HandheldEquipment.Pocket NewPocket)
{
	AssertWithDescription(EqualEqual_IntInt(int(ThePocket), int(24)), Concat_StrStr("[mcj] Trying to set an invalid pocket value for ", string(self)));
	ThePocket = NewPocket;
	return;
}

// Export UHandheldEquipment::execGetFirstPersonModel(FFrame&, void* const)
native final simulated function HandheldEquipmentModel GetFirstPersonModel();

// Export UHandheldEquipment::execGetThirdPersonModel(FFrame&, void* const)
native final simulated event HandheldEquipmentModel GetThirdPersonModel();

simulated function bool IsEquipped()
{
	return EqualEqual_ObjectObject(Pawn(Owner).GetActiveItem(), self);
	return;
}

final simulated function bool IsBeingUsed()
{
	return NotEqual_IntInt(int(UsingStatus), int(0));
	return;
}

final simulated function bool IsBeingEquipped()
{
	return NotEqual_IntInt(int(EquippingStatus), int(0));
	return;
}

final simulated function bool IsBeingUnequipped()
{
	return NotEqual_IntInt(int(UnequippingStatus), int(0));
	return;
}

final simulated function bool IsIdle()
{
	local bool Result;

	Result = AndAnd_BoolBool(AndAnd_BoolBool(AndAnd_BoolBool(EqualEqual_IntInt(int(EquippingStatus), int(0)), EqualEqual_IntInt(int(UnequippingStatus), int(0))), EqualEqual_IntInt(int(UsingStatus), int(0))), IsHandheldEquipmentIdleHook());
	return Result;
	return;
}

protected simulated function bool IsHandheldEquipmentIdleHook()
{
	return true;
	return;
}

final simulated function LogIdleInfo()
{
	Log(Concat_StrStr("In HandheldEquipment::IsIdle(). IsHandheldEquipmentIdleHook()=", string(IsHandheldEquipmentIdleHook())));
	Log(Concat_StrStr("   EquippingStatus=", string(EquippingStatus)));
	Log(Concat_StrStr("   UnequippingStatus=", string(UnequippingStatus)));
	Log(Concat_StrStr("   UsingStatus=", string(UsingStatus)));
	Log(Concat_StrStr("   GetStateName()=", string(GetStateName())));
	return;
}

final simulated function Equip()
{
	ValidateEquip();
	PreEquip();
	GotoState('BeingEquipped');
	return;
}

simulated function PreEquip()
{
	EquippingStatus = 1;
	return;
}

final latent simulated function LatentEquip()
{
	ValidateEquip();
	PreEquip();
	DoEquipping();
	return;
}

final latent simulated function LatentWaitForIdleAndEquip()
{
	Pawn(Owner).AIInterruptEquipment();
	if(Not_PreBool(IsIdle()))
	{
		AIInterrupt();
	}
	LatentEquip();
	return;
}

final simulated function AIInstantEquip()
{
	Pawn(Owner).AIInterruptEquipment();
	if(Not_PreBool(IsIdle()))
	{
		AIInterrupt();
	}
	Equip();
	return;
}

simulated function ValidateEquip()
{
	local HandheldEquipment CurrentItem;

	CurrentItem = Pawn(Owner).GetActiveItem();
	if(AndAnd_BoolBool(NotEqual_ObjectObject(CurrentItem, none), Not_PreBool(CurrentItem.IsIdle())))
	{
		AssertWithDescription(false, Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr("[tcohen] The HandheldEquipment ", string(Name)), " was called to Equip(), but it's owner's ActiveItem "), string(CurrentItem)), " is busy doing something else. (EquippingStatus="), string(CurrentItem.EquippingStatus)), ", UnequippingStatus="), string(CurrentItem.UnequippingStatus)), ", UsingStatus="), string(CurrentItem.UsingStatus)), HandheldEquipmentStatusString()), ")"));
	}
	return;
}

private latent simulated function DoEquipping()
{
	local HandheldEquipment OwnersActiveItem, OwnersPendingItem;

	if(IsEquipped())
	{
		EquippingStatus = 0;
		return;
	}
	Pawn(Owner).SetPendingItem(self);
	OwnersActiveItem = Pawn(Owner).GetActiveItem();
	if(AndAnd_BoolBool(NotEqual_ObjectObject(OwnersActiveItem, none), NotEqual_ObjectObject(OwnersActiveItem, self)))
	{
		if(OwnersActiveItem.Available)
		{
			OwnersActiveItem.UnEquip();
			if(NotEqual_ObjectObject(Pickup, none))
			{
				Pickup.OnUnequipToEquipFinished();
			}
			OwnersPendingItem = Pawn(Owner).GetPendingItem();
			if(NotEqual_ObjectObject(OwnersPendingItem, self))
			{
				if(NotEqual_ObjectObject(OwnersPendingItem, none))
				{
					OwnersPendingItem.LatentEquip();
				}
				return;
			}
		}
		else
		{
			OwnersActiveItem.OnForgotten();
		}
	}
	OnPreEquipped();
	if(NotEqual_ObjectObject(FirstPersonModel, none))
	{
		FirstPersonModel.PlayEquip();
	}
	if(NotEqual_ObjectObject(ThirdPersonModel, none))
	{
		ThirdPersonModel.PlayEquip();
	}
	if(NotEqual_ObjectObject(FirstPersonModel, none))
	{
		FirstPersonModel.FinishEquip();
	}
	if(NotEqual_ObjectObject(ThirdPersonModel, none))
	{
		ThirdPersonModel.FinishEquip();
	}
	EquippingStatus = 0;
	Pawn(Owner).SetPendingItem(none);
	if(NotEqual_ObjectObject(GetHands(), none))
	{
		GetHands().IdleHoldingEquipment();
	}
	if(AndAnd_BoolBool(AndAnd_BoolBool(EqualEqual_IntInt(int(Level.NetMode), int(NM_Client)), NotEqual_ObjectObject(Pawn(Owner).Controller, none)), NotEqual_IntInt(int(Pawn(Owner).Controller.GetEquipmentSlotForQualify()), int(0))))
	{
		Sleep(FramerateCompensationDelay);
	}
	Pawn(Owner).OnEquippingFinished();
	return;
}

simulated function OnPreEquipped()
{
	return;
}

final simulated function OnEquipKeyFrame()
{
	if(EqualEqual_IntInt(int(EquippingStatus), int(1)))
	{
		if(NotEqual_ObjectObject(ThirdPersonModel, none))
		{
			ThirdPersonModel.OnEquipKeyFrame();
			if(Pawn(Owner).HasEquippedFirstItemYet)
			{
				ThirdPersonModel.TriggerEffectEvent('Equipped');
			}
		}
		if(NotEqual_ObjectObject(GetHands(), none))
		{
			FirstPersonModel.OnEquipKeyFrame();
			FirstPersonModel.TriggerEffectEvent('Equipped');
			FirstPersonModel.bNeedPostRenderCallback = true;
		}
		EquippedHook();
		EquippingStatus = 2;
	}
	return;
}

simulated function EquippedHook()
{
	return;
}

final latent simulated function UnEquip()
{
	AssertWithDescription(IsEquipped(), Concat_StrStr(Concat_StrStr("[tcohen] The HandheldEquipment ", string(Name)), " was called to UnEquip().  But it doesn't think its equipped."));
	UnequippingStatus = 1;
	if(NotEqual_ObjectObject(FirstPersonModel, none))
	{
		FirstPersonModel.PlayUnequip();
	}
	if(NotEqual_ObjectObject(ThirdPersonModel, none))
	{
		ThirdPersonModel.PlayUnequip();
	}
	if(NotEqual_ObjectObject(FirstPersonModel, none))
	{
		FirstPersonModel.FinishUnequip();
	}
	if(NotEqual_ObjectObject(ThirdPersonModel, none))
	{
		ThirdPersonModel.FinishUnequip();
	}
	AssertWithDescription(OrOr_BoolBool(Not_PreBool(IsEquipped()), Class'Engine.Pawn'.static.checkDead(Pawn(Owner))), Concat_StrStr(Concat_StrStr("[tcohen] The HandheldEquipment ", string(Name)), " should have been unequipped, but wasn't."));
	UnequippingStatus = 0;
	if(NotEqual_ObjectObject(GetHands(), none))
	{
		GetHands().IdleHoldingEquipment();
	}
	return;
}

final simulated function OnUnequipKeyFrame()
{
	if(EqualEqual_IntInt(int(UnequippingStatus), int(1)))
	{
		ThirdPersonModel.OnUnequipKeyFrame();
		ThirdPersonModel.TriggerEffectEvent('UnEquipped');
		if(NotEqual_ObjectObject(GetHands(), none))
		{
			FirstPersonModel.OnUnequipKeyFrame();
			FirstPersonModel.TriggerEffectEvent('UnEquipped');
			FirstPersonModel.bNeedPostRenderCallback = false;
		}
		UnequippedHook();
		UnequippingStatus = 2;
	}
	return;
}

simulated function UnequippedHook()
{
	return;
}

simulated function HACK_QuickUnequipForAIDropWeapon()
{
	assert(NotEqual_ObjectObject(ThirdPersonModel, none));
	UnequippedHook();
	ThirdPersonModel.OnUnequipKeyFrame();
	SetAvailable(false);
	ThirdPersonModel.Show();
	return;
}

simulated function OnPlayerViewChanged()
{
	return;
}

simulated function OnPlayerUse()
{
	if(Not_PreBool(HandleMultiplayerUse()))
	{
		Use();
	}
	return;
}

simulated function bool ShouldUseWhileLowReady()
{
	return true;
	return;
}

simulated function bool ShouldLowReadyOnOfficers()
{
	return true;
	return;
}

simulated function bool ShouldLowReadyOnArrestable()
{
	return true;
	return;
}

simulated function bool HandleMultiplayerUse()
{
	return false;
	return;
}

final simulated function Use()
{
	ValidateUse();
	PreUse();
	GotoState('BeingUsed');
	return;
}

simulated function PreUse()
{
	UsingStatus = 1;
	return;
}

final latent simulated function LatentUse()
{
	ValidateUse();
	PreUse();
	DoUsing();
	return;
}

simulated function bool PrevalidateUse()
{
	assert(NotEqual_IntInt(int(Level.NetMode), int(NM_Standalone)));
	return ValidateUse(true);
	return;
}

simulated function bool ValidateUse(optional bool Prevalidate)
{
	if(Not_PreBool(Prevalidate))
	{
		AssertWithDescription(IsEquipped(), Concat_StrStr(Concat_StrStr("[tcohen] The HandheldEquipment ", string(Name)), " was called to Use().  But it doesn't think it is equipped."));
		AssertWithDescription(IsIdle(), Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr("[tcohen] The HandheldEquipment ", string(Name)), " was called to Use(), but it is busy doing something else. (EquippingStatus="), string(EquippingStatus)), ", UnequippingStatus="), string(UnequippingStatus)), ", UsingStatus="), string(UsingStatus)), HandheldEquipmentStatusString()), ")"));
	}
	return AndAnd_BoolBool(IsEquipped(), IsIdle());
	return;
}

private final latent simulated function DoUsing()
{
	Pawn(Owner).OnUsingBegan();
	PreUsed();
	DoUsingHook();
	OnUsingFinished();
	return;
}

protected latent simulated function PreUsed()
{
	return;
}

protected latent simulated function DoUsingHook()
{
	if(NotEqual_ObjectObject(FirstPersonModel, none))
	{
		FirstPersonModel.PlayUse(0.0000000);
	}
	if(NotEqual_ObjectObject(ThirdPersonModel, none))
	{
		ThirdPersonModel.PlayUse(0.0000000);
	}
	OnUsingBegan();
	if(NotEqual_ObjectObject(FirstPersonModel, none))
	{
		FirstPersonModel.FinishUse();
	}
	if(NotEqual_ObjectObject(ThirdPersonModel, none))
	{
		ThirdPersonModel.FinishUse();
	}
	return;
}

protected latent simulated function OnUsingBegan()
{
	return;
}

final simulated function OnUseKeyFrame(optional bool ForceUse)
{
	if(OrOr_BoolBool(EqualEqual_IntInt(int(UsingStatus), int(1)), ForceUse))
	{
		ThirdPersonModel.OnUseKeyFrame();
		ThirdPersonModel.TriggerEffectEvent('used');
		if(NotEqual_ObjectObject(GetHands(), none))
		{
			FirstPersonModel.OnUseKeyFrame();
			FirstPersonModel.TriggerEffectEvent('used');
		}
		UsedHook();
		UpdateAvailability();
		UsingStatus = 2;
	}
	return;
}

simulated function UsedHook()
{
	return;
}

simulated function UpdateAvailability()
{
	if(AndAnd_BoolBool(UnavailableAfterUsed, Not_PreBool(Level.IsTraining)))
	{
		SetAvailable(false);
	}
	return;
}

protected final simulated function OnUsingFinished()
{
	UsingStatus = 0;
	if(NotEqual_ObjectObject(GetHands(), none))
	{
		GetHands().IdleHoldingEquipment();
	}
	OnUsingFinishedHook();
	Pawn(Owner).OnUsingFinished();
	return;
}

simulated function OnUsingFinishedHook()
{
	return;
}

final simulated function bool IsAvailable()
{
	return Available;
	return;
}

final simulated function SetAvailable(bool inAvailable)
{
	Available = inAvailable;
	if(Not_PreBool(inAvailable))
	{
		if(NotEqual_ObjectObject(FirstPersonModel, none))
		{
			if(NotEqual_ObjectObject(GetHands(), none))
			{
				GetHands().DetachFromBone(FirstPersonModel);
			}
			FirstPersonModel.Hide();
			FirstPersonModel.SetEquipped(false);
		}
		if(NotEqual_ObjectObject(ThirdPersonModel, none))
		{
			Pawn(Owner).DetachFromBone(ThirdPersonModel);
			ThirdPersonModel.Hide();
			ThirdPersonModel.SetEquipped(false);
		}
	}
	return;
}

simulated function OnForgotten()
{
	return;
}

simulated function string HandheldEquipmentStatusString()
{
	return;
}

simulated function DisplayDebug(Canvas Canvas, out float YL, out float YPos)
{
	local name OutSeqName;
	local float OutAnimFrame, OutAnimRate;

	Canvas.SetDrawColor(0, 0, byte(255));
	AddEqual_FloatFloat(YPos, YL);
	AddEqual_FloatFloat(YPos, YL);
	Canvas.SetPos(4.0000000, YPos);
	Canvas.DrawText(Concat_StrStr("-> HandheldEquipment: ", string(Class.Name)));
	GetHands().GetAnimParams(0, OutSeqName, OutAnimFrame, OutAnimRate);
	AddEqual_FloatFloat(YPos, YL);
	Canvas.SetPos(4.0000000, YPos);
	Canvas.DrawText(Concat_StrStr(Concat_StrStr(Concat_StrStr("Hands: Anim=", string(OutSeqName)), ", Frame="), string(OutAnimFrame)));
	GetFirstPersonModel().GetAnimParams(0, OutSeqName, OutAnimFrame, OutAnimRate);
	AddEqual_FloatFloat(YPos, YL);
	Canvas.SetPos(4.0000000, YPos);
	Canvas.DrawText(Concat_StrStr(Concat_StrStr(Concat_StrStr("FirstPersonModel: Anim=", string(OutSeqName)), ", Frame="), string(OutAnimFrame)));
	Owner.GetAnimParams(0, OutSeqName, OutAnimFrame, OutAnimRate);
	AddEqual_FloatFloat(YPos, YL);
	Canvas.SetPos(4.0000000, YPos);
	Canvas.DrawText(Concat_StrStr(Concat_StrStr(Concat_StrStr("Pawn: Anim=", string(OutSeqName)), ", Frame="), string(OutAnimFrame)));
	GetThirdPersonModel().GetAnimParams(0, OutSeqName, OutAnimFrame, OutAnimRate);
	AddEqual_FloatFloat(YPos, YL);
	Canvas.SetPos(4.0000000, YPos);
	Canvas.DrawText(Concat_StrStr(Concat_StrStr(Concat_StrStr("ThirdPersonModel: Anim=", string(OutSeqName)), ", Frame="), string(OutAnimFrame)));
	return;
}

static function string GetDescription()
{
	return default.Description;
	return;
}

static function string GetFriendlyName()
{
	return default.FriendlyName;
	return;
}

static function Material GetGUIImage()
{
	return default.GUIImage;
	return;
}

static function Class<Actor> GetRenderableActorClass()
{
	return default.ThirdPersonModelClass;
	return;
}

event Destroyed()
{
	if(NotEqual_ObjectObject(FirstPersonModel, none))
	{
		FirstPersonModel.Destroy();
	}
	if(NotEqual_ObjectObject(ThirdPersonModel, none))
	{
		ThirdPersonModel.Destroy();
	}
	super(Actor).Destroyed();
	return;
}

simulated function HandheldEquipment.EquipmentSlot GetSlotForReequip()
{
	return Slot;
	return;
}

function AIInterrupt()
{
	if(Greater_IntInt(int(EquippingStatus), int(0)))
	{
		AIInterrupt_Equipping();
	}
	else
	{
		if(Greater_IntInt(int(UnequippingStatus), int(0)))
		{
			AIInterrupt_Unequipping();
		}
		else
		{
			if(Greater_IntInt(int(UsingStatus), int(0)))
			{
				AIInterrupt_Using();
			}
			else
			{
				AIInterruptHandheldEquipmentHook();
			}
		}
	}
	Pawn(Owner).AnimStopEquipment();
	return;
}

protected function AIInterruptHandheldEquipmentHook()
{
	return;
}

protected function AIInterrupt_Equipping()
{
	GotoState('None');
	EquippingStatus = 0;
	return;
}

protected function AIInterrupt_Unequipping()
{
	GotoState('None');
	UnequippingStatus = 0;
	return;
}

protected function AIInterrupt_Using()
{
	GotoState('None');
	UsingStatus = 0;
	return;
}

simulated function InterruptUsing()
{
	return;
}

simulated function string UniqueID()
{
	return Concat_StrStr(Concat_StrStr(Owner.UniqueID(), "_"), string(GetEnum(Enum'Engine.HandheldEquipment.EquipmentSlot', int(Slot))));
	return;
}

simulated state BeingEquipped
{Begin:

	DoEquipping();
	GotoState('None');
	stop;
}

simulated state BeingUsed
{Begin:

	DoUsing();
	GotoState('None');
	stop;
}

defaultproperties
{
	Range=100
	ZoomBlurOverlay=Texture'HUD.DefaultZoomBlurOverlay'
	ThePocket=24
	EquipAnimationRate=1.0000000
	UnequipAnimationRate=1.0000000
	UseAnimationRate=1.0000000
	Available=true
	PlayerCanUnequip=true
	ShouldHaveFirstPersonModel=true
	ShouldHaveThirdPersonModel=true
	FramerateCompensationDelay=0.2000000
	DrawType=0
}