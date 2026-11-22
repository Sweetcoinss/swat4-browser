class Weapon extends HandheldEquipment
	abstract
	native
	nativereplication
	config(SwatEquipment)
	notplaceable
	hidecategories(Karma);

simulated function DisplayDebug(Canvas Canvas, out float YL, out float YPos)
{
	local string t;
	local name Anim;
	local float frame, Rate;

	super.DisplayDebug(Canvas, YL, YPos);
	Canvas.SetDrawColor(0, byte(255), 0);
	t = Concat_StrStr(Concat_StrStr(Concat_StrStr("     STATE: ", string(GetStateName())), " Timer: "), string(TimerCounter));
	Canvas.DrawText(t, false);
	AddEqual_FloatFloat(YPos, YL);
	Canvas.SetPos(4.0000000, YPos);
	if(EqualEqual_IntInt(int(DrawType), int(8)))
	{
		Canvas.DrawText("     StaticMesh ", false);
	}
	AddEqual_FloatFloat(YPos, YL);
	Canvas.SetPos(4.0000000, YPos);
	if(NotEqual_ObjectObject(Mesh, none))
	{
		GetAnimParams(0, Anim, frame, Rate);
		t = Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr("     AnimSequence ", string(Anim)), " Frame "), string(frame)), " Rate "), string(Rate));
		if(bAnimByOwner)
		{
			t = Concat_StrStr(t, " Anim by Owner");
		}
		Canvas.DrawText(t, false);
		AddEqual_FloatFloat(YPos, YL);
		Canvas.SetPos(4.0000000, YPos);
	}
	return;
}

defaultproperties
{
	ZoomTime=0.5000000
	bReplicateInstigator=true
}