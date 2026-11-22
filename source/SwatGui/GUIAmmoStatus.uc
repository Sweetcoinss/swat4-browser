class GUIAmmoStatus extends GUIAmmoStatusBase
	config(SwatGui)
	perobjectconfig
	instanced
	hidecategories(Menu,Object,Menu,Object);

const MAX_CLIP_ROUNDS_REMAINING = 10;

var() export editinline config GUILabel LoadedAmmoLabel "Text that displays the current rounds remaining in the magazine/clip.";
var() export editinline config GUILabel MagazineSizeLabel "Text that displays how many rounds fit in the magazine/clip.";
var() export editinline config GUILabel ExtraAmmoLabel "Text that displays the current (unloaded) rounds remaining.";
var() export editinline config GUIProgressBar RoundsRemainingBar "Progress bar that displays the current (unloaded) rounds remaining.";
var() export editinline config GUIProgressBar ClipRoundsRemainingBar[10] "Progress bars that displays the current (unloaded) rounds remaining in the other clips.";
var() config Color ActiveClipColor "Progress bar that displays the current (loaded) rounds remainings color.";
var() config Color InActiveClipColor "Progress bar that displays the current (unloaded) rounds remainings color.";

function OnConstruct(GUIController MyController)
{
	local int i;

	super(GUIMultiComponent).OnConstruct(MyController);
	LoadedAmmoLabel = GUILabel(AddComponent("GUI.GUILabel", Concat_StrStr(string(self.Name), "_LoadedAmmoLabel")));
	MagazineSizeLabel = GUILabel(AddComponent("GUI.GUILabel", Concat_StrStr(string(self.Name), "_MagazineSizeLabel")));
	ExtraAmmoLabel = GUILabel(AddComponent("GUI.GUILabel", Concat_StrStr(string(self.Name), "_ExtraAmmoLabel")));
	RoundsRemainingBar = GUIProgressBar(AddComponent("GUI.GUIProgressBar", Concat_StrStr(string(self.Name), "_RoundsRemainingBar")));
	i = 0;
	J0x118:

	if(Less_IntInt(i, 10))
	{
		ClipRoundsRemainingBar[i] = GUIProgressBar(AddComponent("GUI.GUIProgressBar", Concat_StrStr(Concat_StrStr(Concat_StrStr(string(self.Name), "_"), string(i)), "_ClipRoundsRemainingBar")));
		AddAdd_Int(i);
		// [Loop Continue]
		goto J0x118;
	}
	return;
}

function InitComponent(GUIComponent Owner)
{
	super(GUIMultiComponent).InitComponent(Owner);
	return;
}

function SetWeaponStatus(Ammunition Ammo)
{
	local ClipBasedAmmo ClipAmmo;
	local RoundBasedAmmo RoundAmmo;

	ClipAmmo = ClipBasedAmmo(Ammo);
	RoundAmmo = RoundBasedAmmo(Ammo);
	if(NotEqual_ObjectObject(ClipAmmo, none))
	{
		SetClipBasedWeaponStatus(ClipAmmo);
	}
	else
	{
		if(NotEqual_ObjectObject(RoundAmmo, none))
		{
			SetRoundBasedWeaponStatus(RoundAmmo);
		}
		else
		{
			AssertWithDescription(false, Concat_StrStr(Concat_StrStr("[dkaplan] Could not Set the Weapon Status hud display for Ammunition ", string(Ammo)), " as it was neither ClipBased nor RoundBased."));
		}
	}
	return;
}

private function SetRoundBasedWeaponStatus(RoundBasedAmmo Ammo)
{
	local int i, loadedAmmo, MagazineSize, extraRounds, initialExtraRounds;

	loadedAmmo = Ammo.GetCurrentRounds();
	MagazineSize = Ammo.GetMagazineSize();
	extraRounds = Ammo.GetReserveRounds();
	initialExtraRounds = Ammo.GetInitialReserveRounds();
	LoadedAmmoLabel.SetCaption(string(loadedAmmo));
	LoadedAmmoLabel.Show();
	MagazineSizeLabel.SetCaption(Concat_StrStr("/", string(MagazineSize)));
	MagazineSizeLabel.Show();
	ExtraAmmoLabel.SetCaption(Concat_StrStr("+", string(extraRounds)));
	ExtraAmmoLabel.Show();
	RoundsRemainingBar.Value = Divide_FloatFloat(float(loadedAmmo), float(MagazineSize));
	RoundsRemainingBar.Show();
	i = 0;
	J0x102:

	if(Less_IntInt(i, 10))
	{
		ClipRoundsRemainingBar[i].Hide();
		AddAdd_Int(i);
		// [Loop Continue]
		goto J0x102;
	}
	return;
}

private function SetClipBasedWeaponStatus(ClipBasedAmmo Ammo)
{
	local int i, ClipCount, CurrentClip, MagazineSize;

	ClipCount = Ammo.GetClipCount();
	MagazineSize = Ammo.GetMagazineSize();
	CurrentClip = Ammo.GetCurrentClip();
	LoadedAmmoLabel.SetCaption(string(Ammo.GetClip(CurrentClip)));
	LoadedAmmoLabel.Show();
	MagazineSizeLabel.SetCaption(Concat_StrStr("/", string(MagazineSize)));
	MagazineSizeLabel.Show();
	ExtraAmmoLabel.Hide();
	RoundsRemainingBar.Hide();
	i = 0;
	J0xC2:

	if(Less_IntInt(i, 10))
	{
		if(Less_IntInt(i, ClipCount))
		{
			ClipRoundsRemainingBar[i].Value = Divide_FloatFloat(float(Ammo.GetClip(i)), float(MagazineSize));
			if(EqualEqual_IntInt(i, CurrentClip))
			{
				ClipRoundsRemainingBar[i].BarColor = ActiveClipColor;
			}
			else
			{
				ClipRoundsRemainingBar[i].BarColor = InActiveClipColor;
			}
			ClipRoundsRemainingBar[i].SetEnabled(EqualEqual_IntInt(i, CurrentClip));
			ClipRoundsRemainingBar[i].Show();
			// [Explicit Continue]
			goto J0x1A5;
		}
		ClipRoundsRemainingBar[i].Hide();
		J0x1A5:

		AddAdd_Int(i);
		// [Loop Continue]
		goto J0xC2;
	}
	return;
}

defaultproperties
{
	ActiveClipColor=(R=255,G=255,B=255,A=255)
	InActiveClipColor=(R=155,G=155,B=155,A=255)
	PropagateVisibility=false
	PropagateActivity=false
	PropagateState=false
}