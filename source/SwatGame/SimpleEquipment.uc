class SimpleEquipment extends Equipment
	native
	config(SwatEquipment)
	hidecategories(Karma);

var name AttachmentBone;
var bool AutoEquip;

function PostBeginPlay()
{
	super(Actor).PostBeginPlay();
	AssertWithDescription(NotEqual_NameName(Class.Name, 'SimpleEquipment'), Concat_StrStr(Concat_StrStr("[tcohen] ", string(Name)), " is a SimpleEquipment.  SimpleEquipment cannot be used directly in SWAT.  It is used only as a template to create specific pieces of simple equipment.  Please delete the SimpleEquipment from the map."));
	AssertWithDescription(NotEqual_NameName(AttachmentBone, 'None'), Concat_StrStr(Concat_StrStr("[tcohen] ", string(Class.Name)), " (a SimpleEquipment) does not have an AttachmentBone.  Please give it one."));
	return;
}

function OnGivenToOwner()
{
	local Pawn PawnOwner;

	PawnOwner = Pawn(Owner);
	assert(NotEqual_ObjectObject(PawnOwner, none));
	if(AutoEquip)
	{
		Show();
		PawnOwner.AttachToBone(self, AttachmentBone);
	}
	else
	{
		Hide();
	}
	return;
}

function Equip()
{
	local Pawn PawnOwner;

	PawnOwner = Pawn(Owner);
	assert(NotEqual_ObjectObject(PawnOwner, none));
	Show();
	PawnOwner.AttachToBone(self, AttachmentBone);
	return;
}

function UnEquip()
{
	local Pawn PawnOwner;

	PawnOwner = Pawn(Owner);
	assert(NotEqual_ObjectObject(PawnOwner, none));
	Show();
	PawnOwner.DetachFromBone(self);
	return;
}

defaultproperties
{
	AutoEquip=true
	DrawType=8
	StaticMesh=StaticMesh'SwatGear_sm.Placeholder'
}