class ProtectiveEquipment extends Equipment implements ICanBeSelectedInTheGUI
	abstract
	config(SwatEquipment)
	notplaceable
	hidecategories(Karma);

var name AttachmentBone "To which Bone of the Wearer does this ProtectiveEquipment attach (if any).";
var Actor.ESkeletalRegion ProtectedRegion "Which SkeletalRegion does this ProtectiveEquipment protect (if any).";
var float MomentumToPenetrate;
var Range PenetratedDamageFactor "If a bullet penetrates this ProtectiveEquipment, then the Damage that it _would_ cause is multiplied by this Factor before being delt to the Wearer.";
var Range BlockedDamageFactor "If a bullet is blocked by this ProtectiveEquipment, then the Damage that it _would_ cause (if it had penetrated) is multiplied by this Factor, and the resulting Damage is given to the Wearer.";
var Mesh WearerMesh "If a Pawn wears this ProtectiveEquipment, then the Pawn should use this Mesh.  Leave None if the ProtectiveEquipment shouldn't affect the Wearer's Mesh.  Note that a WearerMesh must be compatible with the SwatOfficer Mesh, ie. must have all the same animations with the same names.";
var Material FirstPersonOverlay "What overlay if anything will be used on player pawns when worn";
var config localized string Description;
var config localized string FriendlyName;
var config localized Material GUIImage;

function QualifyProtectedRegion()
{
	AssertWithDescription(Greater_IntInt(int(ProtectedRegion), int(0)), Concat_StrStr(Concat_StrStr("[tcohen] The ProtectiveEquipment class ", string(Class.Name)), " does not specify a ProtectedRegion.  Please fix this in UnrealEd."));
	AssertWithDescription(Less_IntInt(int(ProtectedRegion), int(7)), Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr("[tcohen] The ProtectiveEquipment class ", string(Class.Name)), " specifies ProtectedRegion="), string(GetEnum(Enum'Engine.Actor.ESkeletalRegion', int(ProtectedRegion)))), ".  ProtectiveEquipment may only protect body regions."));
	return;
}

function OnGivenToOwner()
{
	local Pawn PawnOwner;

	PawnOwner = Pawn(Owner);
	assert(AndAnd_BoolBool(NotEqual_ObjectObject(PawnOwner, none), PawnOwner.IsA('ICanUseProtectiveEquipment')));
	if(NotEqual_NameName(AttachmentBone, 'None'))
	{
		PawnOwner.AttachToBone(self, AttachmentBone);
	}
	QualifyProtectedRegion();
	PawnOwner.SetProtection(ProtectedRegion, self);
	if(AndAnd_BoolBool(NotEqual_ObjectObject(WearerMesh, none), NotEqual_ObjectObject(WearerMesh, PawnOwner.Mesh)))
	{
		PawnOwner.SwitchToMesh(WearerMesh);
	}
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
	return default.Class;
	return;
}

defaultproperties
{
	DrawType=8
	StaticMesh=StaticMesh'SwatGear_sm.Placeholder'
}