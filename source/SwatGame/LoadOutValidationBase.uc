class LoadOutValidationBase extends Actor
	abstract
	native
	config
	perobjectconfig
	notplaceable
	hidecategories(Karma);

enum MaterialPocket
{
	MATERIAL_Pants,                 // 0
	MATERIAL_Face,                  // 1
	MATERIAL_Name,                  // 2
	MATERIAL_Vest,                  // 3
	MATERIAL_HeavyPants,            // 4
	MATERIAL_HeavyVest              // 5
};

var(DEBUG) config Class<Actor> LoadOutSpec[25];
var(DEBUG) config Material MaterialSpec[6];

simulated function PrintLoadOutSpecToMPLog()
{
	local int i;

	Log(Concat_StrStr(Concat_StrStr("LoadOut ", string(self)), " contains spec:"));
	i = 0;
	J0x2B:

	if(Less_IntInt(i, int(25)))
	{
		Log(Concat_StrStr(Concat_StrStr(Concat_StrStr("...LoadOutSpec[", string(GetEnum(Enum'Engine.HandheldEquipment.Pocket', i))), "]="), string(LoadOutSpec[i])));
		AddAdd_Int(i);
		// [Loop Continue]
		goto J0x2B;
	}
	i = 0;
	J0x86:

	if(Less_IntInt(i, int(6)))
	{
		Log(Concat_StrStr(Concat_StrStr(Concat_StrStr("...MaterialSpec[", string(GetEnum(Enum'SwatGame.LoadOutValidationBase.MaterialPocket', i))), "]="), string(MaterialSpec[i])));
		AddAdd_Int(i);
		// [Loop Continue]
		goto J0x86;
	}
	return;
}

function bool ValidForLoadoutSpec(Class<Actor> newEquip, HandheldEquipment.Pocket pock)
{
	local Class<FiredWeapon> Weap;
	local Class OptiwandClass, C2Class;
	local int i;

	switch(pock)
	{
		case 1:
			Weap = Class<FiredWeapon>(LoadOutSpec[int(0)]);
			if(EqualEqual_ObjectObject(Weap, none))
			{
				return true;
			}
			i = 0;
			J0x35:

			if(Less_IntInt(i, Weap.default.PlayerAmmoOption.Length))
			{
				if(EqualEqual_ObjectObject(DynamicFindObject(Weap.default.PlayerAmmoOption[i], Class'Core.Class'), newEquip))
				{
					return true;
				}
				AddAdd_Int(i);
				// [Loop Continue]
				goto J0x35;
			}
			return false;
			break;
		case 3:
			Weap = Class<FiredWeapon>(LoadOutSpec[int(2)]);
			if(EqualEqual_ObjectObject(Weap, none))
			{
				return true;
			}
			i = 0;
			J0xB6:

			if(Less_IntInt(i, Weap.default.PlayerAmmoOption.Length))
			{
				if(EqualEqual_ObjectObject(DynamicFindObject(Weap.default.PlayerAmmoOption[i], Class'Core.Class'), newEquip))
				{
					return true;
				}
				AddAdd_Int(i);
				// [Loop Continue]
				goto J0xB6;
			}
			return false;
			break;
		case 4:
		case 5:
		case 6:
		case 7:
		case 8:
			OptiwandClass = Class<Object>(DynamicLoadObject("SwatEquipment.Optiwand", Class'Core.Class'));
			if(ClassIsChildOf(newEquip, OptiwandClass))
			{
				i = 0;
				J0x167:

				if(Less_IntInt(i, int(pock)))
				{
					if(AndAnd_BoolBool(NotEqual_ObjectObject(LoadOutSpec[i], none), ClassIsChildOf(LoadOutSpec[i], OptiwandClass)))
					{
						return false;
					}
					AddAdd_Int(i);
					// [Loop Continue]
					goto J0x167;
				}
			}
			break;
		case 16:
		case 17:
			C2Class = Class<Object>(DynamicLoadObject("SwatEquipment.C2Charge", Class'Core.Class'));
			if(ClassIsChildOf(newEquip, C2Class))
			{
				if(OrOr_BoolBool(EqualEqual_ObjectObject(LoadOutSpec[int(9)], none), Not_PreBool(ClassIsChildOf(LoadOutSpec[int(9)], C2Class))))
				{
					return false;
				}
			}
			else
			{
				if(NotEqual_ObjectObject(newEquip, none))
				{
					return false;
				}
			}
		default:
			break;
	}
	return true;
	return;
}
