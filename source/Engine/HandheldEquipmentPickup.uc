class HandheldEquipmentPickup extends Actor implements ICanBeUsed
	config(SwatGame)
	placeable
	hidecategories(Karma);

var(Pickup) Class<HandheldEquipment> HandheldEquipmentClass;
var private Class<HandheldEquipment> LastHHEClass;
var private Pawn PickerUpper;
var private HandheldEquipment Item;

event PostEditChange()
{
	super.PostEditChange();
	UpdateAppearance();
	return;
}

function UpdateAppearance()
{
	if(EqualEqual_ObjectObject(HandheldEquipmentClass, none))
	{
		return;
	}
	if(EqualEqual_ObjectObject(LastHHEClass, HandheldEquipmentClass))
	{
		return;
	}
	LastHHEClass = HandheldEquipmentClass;
	if(AndAnd_BoolBool(HandheldEquipmentClass.default.ShouldHaveThirdPersonModel, NotEqual_ObjectObject(HandheldEquipmentClass.default.ThirdPersonModelClass, none)))
	{
		switch(HandheldEquipmentClass.default.ThirdPersonModelClass.default.DrawType)
		{
			case 8:
				SetDrawType(8);
				SetStaticMesh(HandheldEquipmentClass.default.ThirdPersonModelClass.default.StaticMesh);
				break;
			case 2:
				SetDrawType(2);
				LinkMesh(HandheldEquipmentClass.default.ThirdPersonModelClass.default.Mesh);
				break;
			default:
				SetDrawType(8);
				SetStaticMesh(default.StaticMesh);
				break;
		}
	}
	else
	{
		SetDrawType(8);
		SetStaticMesh(default.StaticMesh);
	}
	return;
}

event PostBeginPlay()
{
	super.PostBeginPlay();
	AssertWithDescription(NotEqual_ObjectObject(HandheldEquipmentClass, none), Concat_StrStr(Concat_StrStr("[tcohen] The HandheldEquipmentPickup named ", string(Name)), " has no HandheldEquipmentClass."));
	AssertWithDescription(EqualEqual_IntInt(int(Level.NetMode), int(NM_Standalone)), "[tcohen] HandheldEquipmentPickups are not supported in Multiplayer.");
	return;
}

simulated function bool CanBeUsedNow()
{
	return true;
	return;
}

simulated function OnUsed(Pawn Other)
{
	PickerUpper = Other;
	GotoState('BeingPickedUp');
	return;
}

simulated function PostUsed()
{
	return;
}

function OnUnequipToEquipFinished()
{
	AssertWithDescription(false, "[tcohen] HandheldEquipmentPickup::OnUnequipToEquipFinished() in Global state.  This should only happen in State 'BeingPickedUp'.");
	return;
}

state BeingPickedUp
{
	latent function BePickedUp()
	{
		local HandheldEquipment ActiveItem;

		AssertWithDescription(PickerUpper.IsA('SwatPlayer'), Concat_StrStr(Concat_StrStr("[tcohen] HandheldEquipmentPickup::OnUsed() PickerUpper is ", string(PickerUpper)), ".  I only expect SwatPlayers to pick-up HandheldEquipment."));
		ActiveItem = PickerUpper.GetActiveItem();
		if(OrOr_BoolBool(EqualEqual_ObjectObject(ActiveItem, none), Not_PreBool(ActiveItem.IsIdle())))
		{
			return;
		}
		Item = Spawn(HandheldEquipmentClass, PickerUpper);
		assert(NotEqual_ObjectObject(Item, none));
		AssertWithDescription(NotEqual_IntInt(int(Item.GetSlot()), int(7)), Concat_StrStr("[tcohen] HandheldEquipmentPickup::OnUsed() The Dropped is a breaching Tactical Aid.  ", "HandheldEquipment with SLOT_Breaching cannot be picked-up (because its illegal to have more than one type)."));
		Item.OnGivenToOwner();
		Item.Pickup = self;
		Item.LatentEquip();
		Item.Pickup = none;
		PickerUpper.OnPickedUp(Item);
		return;
	}

	function OnUnequipToEquipFinished()
	{
		local HandheldEquipment OldPocketItem;

		OldPocketItem = PickerUpper.FindItemForPickupToReplace(Item);
		if(NotEqual_ObjectObject(OldPocketItem, none))
		{
			HandheldEquipmentClass = OldPocketItem.Class;
			UpdateAppearance();
		}
		return;
	}
Begin:

	BePickedUp();
	GotoState('None');
	stop;
}

defaultproperties
{
	DrawType=8
	StaticMesh=StaticMesh'SwatGear_sm.Placeholder'
	bCollideActors=true
	bBlockActors=true
}