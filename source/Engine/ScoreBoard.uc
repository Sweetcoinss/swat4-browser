class ScoreBoard extends Info
	config
	notplaceable
	hidecategories(Karma,Movement,Collision,Lighting,LightColor,Karma,Force);

var GameReplicationInfo GRI;
var Class<HUD> HudClass;
var bool bDisplayMessages;

simulated function PostBeginPlay()
{
	super(Actor).PostBeginPlay();
	InitGRI();
	Init();
	return;
}

function Font GetSmallerFontFor(Canvas Canvas, int Offset)
{
	local int i;

	i = 0;
	J0x07:

	if(Less_IntInt(i, Subtract_IntInt(8, Offset)))
	{
		if(LessEqual_FloatFloat(float(HudClass.default.FontScreenWidthMedium[i]), Canvas.ClipX))
		{
			return HudClass.static.LoadFontStatic(Add_IntInt(i, Offset));
		}
		AddAdd_Int(i);
		// [Loop Continue]
		goto J0x07;
	}
	return HudClass.static.LoadFontStatic(8);
	return;
}

function bool HaveHalfFont(Canvas Canvas, int Offset)
{
	local int i;

	i = 0;
	J0x07:

	if(Less_IntInt(i, Subtract_IntInt(9, Offset)))
	{
		if(LessEqual_FloatFloat(float(HudClass.default.FontScreenWidthSmall[i]), Canvas.ClipX))
		{
			return true;
		}
		AddAdd_Int(i);
		// [Loop Continue]
		goto J0x07;
	}
	return false;
	return;
}

function Font GetSmallFontFor(int ScreenWidth, int Offset)
{
	local int i;

	i = 0;
	J0x07:

	if(Less_IntInt(i, Subtract_IntInt(8, Offset)))
	{
		if(LessEqual_IntInt(HudClass.default.FontScreenWidthSmall[i], ScreenWidth))
		{
			return HudClass.static.LoadFontStatic(Add_IntInt(i, Offset));
		}
		AddAdd_Int(i);
		// [Loop Continue]
		goto J0x07;
	}
	return HudClass.static.LoadFontStatic(8);
	return;
}

simulated function InitGRI()
{
	GRI = PlayerController(Owner).GameReplicationInfo;
	return;
}

simulated function string InitTitle()
{
	return Caps(GRI.GameName);
	return;
}

simulated function Init()
{
	return;
}

simulated event DrawScoreboard(Canvas C)
{
	UpdateGRI();
	UpdateScoreBoard(C);
	return;
}

function bool UpdateGRI()
{
	if(EqualEqual_ObjectObject(GRI, none))
	{
		InitGRI();
		if(EqualEqual_ObjectObject(GRI, none))
		{
			return false;
		}
	}
	SortPRIArray();
	return true;
	return;
}

simulated function string FormatTime(int Seconds)
{
	local int Minutes, Hours;
	local string Time;

	if(Greater_IntInt(Seconds, 3600))
	{
		Hours = Divide_IntInt(Seconds, 3600);
		SubtractEqual_IntInt(Seconds, Multiply_IntInt(Hours, 3600));
		Time = Concat_StrStr(string(Hours), ":");
	}
	Minutes = Divide_IntInt(Seconds, 60);
	SubtractEqual_IntInt(Seconds, Multiply_IntInt(Minutes, 60));
	if(GreaterEqual_IntInt(Minutes, 10))
	{
		Time = Concat_StrStr(Concat_StrStr(Time, string(Minutes)), ":");
	}
	else
	{
		Time = Concat_StrStr(Concat_StrStr(Concat_StrStr(Time, "0"), string(Minutes)), ":");
	}
	if(GreaterEqual_IntInt(Seconds, 10))
	{
		Time = Concat_StrStr(Time, string(Seconds));
	}
	else
	{
		Time = Concat_StrStr(Concat_StrStr(Time, "0"), string(Seconds));
	}
	return Time;
	return;
}

simulated function UpdateScoreBoard(Canvas Canvas)
{
	return;
}

simulated function bool InOrder(PlayerReplicationInfo P1, PlayerReplicationInfo P2)
{
	if(P1.bOnlySpectator)
	{
		if(P2.bOnlySpectator)
		{
			return true;
		}
		else
		{
			return false;
		}
	}
	else
	{
		if(P2.bOnlySpectator)
		{
			return true;
		}
	}
	if(Less_FloatFloat(P1.Score, P2.Score))
	{
		return false;
	}
	if(EqualEqual_FloatFloat(P1.Score, P2.Score))
	{
		if(Greater_FloatFloat(P1.Deaths, P2.Deaths))
		{
			return false;
		}
		if(AndAnd_BoolBool(AndAnd_BoolBool(EqualEqual_FloatFloat(P1.Deaths, P2.Deaths), NotEqual_ObjectObject(PlayerController(P2.Owner), none)), NotEqual_ObjectObject(Viewport(PlayerController(P2.Owner).Player), none)))
		{
			return false;
		}
	}
	return true;
	return;
}

simulated function SortPRIArray()
{
	local int i, j;
	local PlayerReplicationInfo tmp;

	i = 0;
	J0x07:

	if(Less_IntInt(i, Subtract_IntInt(GRI.PRIArray.Length, 1)))
	{
		j = Add_IntInt(i, 1);
		J0x31:

		if(Less_IntInt(j, GRI.PRIArray.Length))
		{
			if(Not_PreBool(InOrder(GRI.PRIArray[i], GRI.PRIArray[j])))
			{
				tmp = GRI.PRIArray[i];
				GRI.PRIArray[i] = GRI.PRIArray[j];
				GRI.PRIArray[j] = tmp;
			}
			AddAdd_Int(j);
			// [Loop Continue]
			goto J0x31;
		}
		AddAdd_Int(i);
		// [Loop Continue]
		goto J0x07;
	}
	return;
}

function NextStats()
{
	return;
}

defaultproperties
{
	HudClass=Class'Engine.HUD'
}