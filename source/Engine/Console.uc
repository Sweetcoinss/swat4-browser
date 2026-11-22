class Console extends Interaction
	config;

const MaxHistory = 16;

var globalconfig byte ConsoleKey;
var int HistoryTop;
var int HistoryBot;
var int HistoryCur;
var string TypedStr;
var string History[16];
var bool bTyping;
var bool bIgnoreKeys;
var Font ConsoleFont;
var Texture BackgroundTexture;

function Initialize()
{
	super.Initialize();
	ConsoleFont = Font(DynamicLoadObject("Engine_res.ConsoleFont", Class'Engine.Font'));
	BackgroundTexture = Texture(DynamicLoadObject("Engine_res.MenuBlack", Class'Engine.Texture'));
	return;
}

event NativeConsoleOpen()
{
	return;
}

exec function Type()
{
	TypedStr = "";
	GotoState('Typing');
	return;
}

exec function Talk()
{
	TypedStr = "Say ";
	GotoState('Typing');
	return;
}

exec function TeamTalk()
{
	TypedStr = "TeamSay ";
	GotoState('Typing');
	return;
}

event NotifyLevelChange()
{
	return;
}

event Message(coerce string msg, float MsgLife)
{
	return;
}

function bool KeyEvent(Interactions.EInputKey Key, Interactions.EInputAction Action, float Delta)
{
	if(NotEqual_IntInt(int(Action), int(1)))
	{
		return false;
	}
	else
	{
		if(EqualEqual_IntInt(int(Key), int(ConsoleKey)))
		{
			GotoState('Typing');
			return true;
		}
		else
		{
			return false;
		}
	}
	return;
}

state Typing
{
	exec function Type()
	{
		TypedStr = "";
		GotoState('None');
		return;
	}

	function int GetPrevHistoryIndex(int Cur)
	{
		local int Prev;

		Prev = -1;
		if(GreaterEqual_IntInt(HistoryBot, 0))
		{
			if(EqualEqual_IntInt(Cur, HistoryBot))
			{
				Prev = HistoryTop;
			}
			else
			{
				Prev = Subtract_IntInt(Cur, 1);
				if(Less_IntInt(Prev, 0))
				{
					Prev = Subtract_IntInt(16, 1);
				}
			}
		}
		return Prev;
		return;
	}

	function bool KeyType(Interactions.EInputKey Key, optional string Unicode)
	{
		if(bIgnoreKeys)
		{
			return true;
		}
		if(AndAnd_BoolBool(AndAnd_BoolBool(AndAnd_BoolBool(GreaterEqual_IntInt(int(Key), 32), Less_IntInt(int(Key), 256)), NotEqual_IntInt(int(Key), Asc("~"))), NotEqual_IntInt(int(Key), Asc("`"))))
		{
			if(NotEqual_StrStr(Unicode, ""))
			{
				TypedStr = Concat_StrStr(TypedStr, Unicode);
			}
			else
			{
				TypedStr = Concat_StrStr(TypedStr, Chr(int(Key)));
			}
			return true;
		}
		return;
	}

	function bool KeyEvent(Interactions.EInputKey Key, Interactions.EInputAction Action, float Delta)
	{
		local string temp;
		local int PrevInd;

		if(EqualEqual_IntInt(int(Action), int(1)))
		{
			bIgnoreKeys = false;
		}
		if(EqualEqual_IntInt(int(Key), int(27)))
		{
			if(NotEqual_StrStr(TypedStr, ""))
			{
				TypedStr = "";
				HistoryCur = HistoryTop;
				return true;
			}
			else
			{
				GotoState('None');
			}
		}
		else
		{
			if(global.KeyEvent(Key, Action, Delta))
			{
				return true;
			}
			else
			{
				if(NotEqual_IntInt(int(Action), int(1)))
				{
					return false;
				}
				else
				{
					if(EqualEqual_IntInt(int(Key), int(13)))
					{
						if(NotEqual_StrStr(TypedStr, ""))
						{
							Message(TypedStr, 6.0000000);
							PrevInd = GetPrevHistoryIndex(HistoryTop);
							if(OrOr_BoolBool(Less_IntInt(PrevInd, 0), NotEqual_StrStr(TypedStr, History[PrevInd])))
							{
								History[HistoryTop] = TypedStr;
								HistoryTop = int(Percent_FloatFloat(float(Add_IntInt(HistoryTop, 1)), float(16)));
								if(OrOr_BoolBool(EqualEqual_IntInt(HistoryBot, -1), EqualEqual_IntInt(HistoryBot, HistoryTop)))
								{
									HistoryBot = int(Percent_FloatFloat(float(Add_IntInt(HistoryBot, 1)), float(16)));
								}
								HistoryCur = HistoryTop;
							}
							temp = TypedStr;
							TypedStr = "";
							if(Not_PreBool(ConsoleCommand(temp)))
							{
								Message(Localize("Errors", "Exec", "Core"), 6.0000000);
							}
							Message("", 6.0000000);
							GotoState('None');
						}
						else
						{
							GotoState('None');
						}
						return true;
					}
					else
					{
						if(EqualEqual_IntInt(int(Key), int(38)))
						{
							PrevInd = GetPrevHistoryIndex(HistoryCur);
							if(GreaterEqual_IntInt(PrevInd, 0))
							{
								HistoryCur = PrevInd;
								TypedStr = History[HistoryCur];
							}
							return true;
						}
						else
						{
							if(EqualEqual_IntInt(int(Key), int(40)))
							{
								if(GreaterEqual_IntInt(HistoryBot, 0))
								{
									if(EqualEqual_IntInt(HistoryCur, HistoryTop))
									{
										HistoryCur = HistoryBot;
									}
									else
									{
										HistoryCur = int(Percent_FloatFloat(float(Add_IntInt(HistoryCur, 1)), float(16)));
									}
									TypedStr = History[HistoryCur];
								}
							}
							else
							{
								if(OrOr_BoolBool(EqualEqual_IntInt(int(Key), int(8)), EqualEqual_IntInt(int(Key), int(37))))
								{
									if(Greater_IntInt(Len(TypedStr), 0))
									{
										TypedStr = Left(TypedStr, Subtract_IntInt(Len(TypedStr), 1));
									}
									return true;
								}
							}
						}
					}
				}
			}
		}
		return true;
		return;
	}

	function PostRender(Canvas Canvas)
	{
		local float XL, YL;
		local string OutStr;

		Canvas.Style = 1;
		Canvas.Font = ConsoleFont;
		OutStr = Concat_StrStr(At_StrStr("(>", TypedStr), "_");
		Canvas.StrLen(OutStr, XL, YL);
		Canvas.SetPos(0.0000000, Subtract_FloatFloat(Subtract_FloatFloat(Canvas.ClipY, float(6)), YL));
		Canvas.DrawTile(BackgroundTexture, Canvas.ClipX, Add_FloatFloat(YL, float(6)), 0.0000000, 0.0000000, 32.0000000, 32.0000000);
		Canvas.SetPos(0.0000000, Subtract_FloatFloat(Subtract_FloatFloat(Canvas.ClipY, float(8)), YL));
		Canvas.SetDrawColor(0, byte(255), 0);
		Canvas.SetPos(0.0000000, Subtract_FloatFloat(Subtract_FloatFloat(Canvas.ClipY, float(3)), YL));
		Canvas.bCenter = false;
		Canvas.DrawText(OutStr, false);
		return;
	}

	function BeginState()
	{
		bTyping = true;
		bVisible = true;
		bIgnoreKeys = true;
		HistoryCur = HistoryTop;
		return;
	}

	function EndState()
	{
		bTyping = false;
		bVisible = false;
		return;
	}
	stop;
}

defaultproperties
{
	ConsoleKey=192
	HistoryBot=-1
	bRequiresTick=true
}