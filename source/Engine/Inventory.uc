class Inventory extends Actor
	abstract
	native
	nativereplication
	config
	notplaceable
	hidecategories(Karma);

var byte InventoryGroup;
var byte GroupOffset;
var bool bDisplayableInv;
var(FirstPerson) Vector PlayerViewOffset;
var(FirstPerson) Rotator PlayerViewPivot;
var bool bDrawingFirstPerson;
var float BobDamping;
var localized string ItemName;

exec function updaterelative(int Pitch, int Yaw, int Roll)
{
	local Rotator NewRot;

	NewRot.Pitch = Pitch;
	NewRot.Yaw = Yaw;
	NewRot.Roll = Roll;
	return;
}

simulated function string GetHumanReadableName()
{
	if(EqualEqual_StrStr(ItemName, ""))
	{
		ItemName = GetItemName(string(Class));
	}
	return ItemName;
	return;
}

simulated function Weapon RecommendWeapon(out float rating)
{
	if(NotEqual_ObjectObject(Inventory, none))
	{
		return Inventory.RecommendWeapon(rating);
	}
	else
	{
		rating = -1.0000000;
		return none;
	}
	return;
}

event TravelPreAccept()
{
	super.TravelPreAccept();
	GiveTo(Pawn(Owner));
	return;
}

function TravelPostAccept()
{
	super.TravelPostAccept();
	return;
}

function Destroyed()
{
	return;
}

function GiveTo(Pawn Other)
{
	assert(false);
	return;
}

function Use(float Value)
{
	return;
}

simulated function Weapon WeaponChange(byte F, bool bSilent)
{
	if(EqualEqual_ObjectObject(Inventory, none))
	{
		return none;
	}
	else
	{
		return Inventory.WeaponChange(F, bSilent);
	}
	return;
}

simulated function Weapon PrevWeapon(Weapon CurrentChoice, Weapon CurrentWeapon)
{
	if(EqualEqual_ObjectObject(Inventory, none))
	{
		return CurrentChoice;
	}
	else
	{
		return Inventory.PrevWeapon(CurrentChoice, CurrentWeapon);
	}
	return;
}

simulated function Weapon NextWeapon(Weapon CurrentChoice, Weapon CurrentWeapon)
{
	if(EqualEqual_ObjectObject(Inventory, none))
	{
		return CurrentChoice;
	}
	else
	{
		return Inventory.NextWeapon(CurrentChoice, CurrentWeapon);
	}
	return;
}

function OwnerEvent(name EventName)
{
	if(NotEqual_ObjectObject(Inventory, none))
	{
		Inventory.OwnerEvent(EventName);
	}
	return;
}

function SetOwnerDisplay()
{
	if(NotEqual_ObjectObject(Inventory, none))
	{
		Inventory.SetOwnerDisplay();
	}
	return;
}

static function string StaticItemName()
{
	return default.ItemName;
	return;
}

defaultproperties
{
	BobDamping=0.9600000
	DrawType=0
	bHidden=true
	bOnlyOwnerSee=true
	bOnlyRelevantToOwner=true
	bReplicateMovement=false
	bOnlyDirtyReplication=true
	RemoteRole=2
	NetPriority=1.4000000
	bTravel=true
	bClientAnim=true
}