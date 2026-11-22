class HUD extends Actor
	transient
	native
	config(User)
	notplaceable
	hidecategories(Karma);

struct HUDLocalizedMessage
{
	var Class<LocalMessage> Message;
	var int Switch;
	var PlayerReplicationInfo RelatedPRI;
	var Object OptionalObject;
	var float EndOfLife;
	var float Lifetime;
	var bool bDrawing;
	var int numLines;
	var string StringMessage;
	var Color DrawColor;
	var Font StringFont;
	var float XL;
	var float YL;
	var float YPos;
};

struct native ConsoleMessage
{
	var string Text;
	var Color TextColor;
	var float MessageLife;
	var PlayerReplicationInfo PRI;
};

var Font SmallFont;
var Font MedFont;
var Font BigFont;
var Font LargeFont;
var string HUDConfigWindowType;
var HUD nextHUD;
var PlayerController PlayerOwner;
var localized string ProgressFontName;
var Font ProgressFontFont;
var float ProgressFadeTime;
var Color MOTDColor;
var ScoreBoard ScoreBoard;
var bool bHideHUD;
var bool bShowScores;
var bool bShowDebugInfo;
var bool bHideCenterMessages;
var bool bBadConnectionAlert;
var config bool bMessageBeep;
var globalconfig float HudCanvasScale;
var localized string LoadingMessage;
var localized string SavingMessage;
var localized string ConnectingMessage;
var localized string PausedMessage;
var localized string PrecachingMessage;
var const transient Movie Movie;
var int MoviePosX;
var int MoviePosY;
var float TexMovieTop;
var float TexMovieLeft;
var float TexMovieBottom;
var float TexMovieRight;
var bool TexMovieTranslucent;
var MovieTexture TextureMovie;
var Color ConsoleColor;
var globalconfig int ConsoleMessageCount;
var globalconfig int ConsoleFontSize;
var globalconfig int MessageFontOffset;
var ConsoleMessage TextMessages[8];
var float ConsoleMessagePosX;
var float ConsoleMessagePosY;
var localized string FontArrayNames[9];
var Font FontArrayFonts[9];
var int FontScreenWidthMedium[9];
var int FontScreenWidthSmall[9];

// Export UHUD::execDraw3DLine(FFrame&, void* const)
native final function Draw3DLine(Vector Start, Vector End, Color LineColor);

// Export UHUD::execDraw3DCircle(FFrame&, void* const)
native final function Draw3DCircle(Vector Origin, Vector PlaneXAxis, Vector PlaneYAxis, float Radius, Color Color, optional int NumSides);

// Export UHUD::execDraw3DCylinder(FFrame&, void* const)
native final function Draw3DCylinder(Vector Base, Vector X, Vector Y, Vector Z, float Radius, float HalfHeight, Color Color, optional int NumSides);

// Export UHUD::execDraw3DCone(FFrame&, void* const)
native final function Draw3DCone(Vector Origin, Vector direction, float Length, float HalfAngle, Color Color, optional int NumSides);

simulated event PostBeginPlay()
{
	super.PostBeginPlay();
	PlayerOwner = PlayerController(Owner);
	SmallFont = Font(DynamicLoadObject("Engine_res.SmallFont", Class'Engine.Font'));
	MedFont = Font(DynamicLoadObject("Engine_res.MediumFont", Class'Engine.Font'));
	BigFont = Font(DynamicLoadObject("Engine_res.MediumFont", Class'Engine.Font'));
	LargeFont = Font(DynamicLoadObject("Engine_res.MediumFont", Class'Engine.Font'));
	return;
}

function SpawnScoreBoard(Class<ScoreBoard> ScoringType)
{
	if(NotEqual_ObjectObject(ScoringType, none))
	{
		ScoreBoard = Spawn(ScoringType, PlayerOwner);
	}
	return;
}

simulated event Destroyed()
{
	if(NotEqual_ObjectObject(ScoreBoard, none))
	{
		ScoreBoard.Destroy();
		ScoreBoard = none;
	}
	super.Destroyed();
	return;
}

exec function ShowScores()
{
	bShowScores = Not_PreBool(bShowScores);
	return;
}

exec function ShowDebug()
{
	bShowDebugInfo = Not_PreBool(bShowDebugInfo);
	return;
}

simulated event WorldSpaceOverlays()
{
	if(AndAnd_BoolBool(bShowDebugInfo, NotEqual_ObjectObject(Pawn(PlayerOwner.ViewTarget), none)))
	{
		DrawRoute();
	}
	return;
}

function CheckCountdown(GameReplicationInfo GRI)
{
	return;
}

event ConnectFailure(string FailCode, string URL)
{
	PlayerOwner.ReceiveLocalizedMessage(Class'Engine.FailedConnect', Class'Engine.FailedConnect'.static.GetFailSwitch(FailCode));
	return;
}

event ShowUpgradeMenu()
{
	return;
}

function PlayStartupMessage(byte Stage)
{
	return;
}

function ClearMessage(out HUDLocalizedMessage M)
{
	M.Message = none;
	M.Switch = 0;
	M.RelatedPRI = none;
	M.OptionalObject = none;
	M.EndOfLife = 0.0000000;
	M.StringMessage = "";
	M.DrawColor = Class'Engine.Canvas'.static.MakeColor(byte(255), byte(255), byte(255));
	M.XL = 0.0000000;
	M.bDrawing = false;
	return;
}

function CopyMessage(out HUDLocalizedMessage M1, HUDLocalizedMessage M2)
{
	M1.Message = M2.Message;
	M1.Switch = M2.Switch;
	M1.RelatedPRI = M2.RelatedPRI;
	M1.OptionalObject = M2.OptionalObject;
	M1.EndOfLife = M2.EndOfLife;
	M1.StringMessage = M2.StringMessage;
	M1.DrawColor = M2.DrawColor;
	M1.XL = M2.XL;
	M1.YL = M2.YL;
	M1.YPos = M2.YPos;
	M1.bDrawing = M2.bDrawing;
	M1.Lifetime = M2.Lifetime;
	M1.numLines = M2.numLines;
	return;
}

simulated event PostRender(Canvas Canvas)
{
	local float XPos, YPos;
	local Pawn P;

	CheckCountdown(PlayerOwner.GameReplicationInfo);
	P = Pawn(PlayerOwner.ViewTarget);
	if(Not_PreBool(PlayerOwner.bBehindView))
	{
		if(NotEqual_ObjectObject(P, none))
		{
			P.RenderOverlays(Canvas);
		}
	}
	if(Not_PreBool(bHideHUD))
	{
		DisplayMessages(Canvas);
		bHideCenterMessages = DrawLevelAction(Canvas);
		if(AndAnd_BoolBool(Not_PreBool(bHideCenterMessages), Greater_FloatFloat(PlayerOwner.ProgressTimeOut, Level.TimeSeconds)))
		{
			DisplayProgressMessage(Canvas);
		}
		if(bBadConnectionAlert)
		{
			DisplayBadConnectionAlert();
		}
		if(AndAnd_BoolBool(NotEqual_ObjectObject(P, none), P.bSpecialHUD))
		{
			P.DrawHUD(Canvas);
		}
		if(bShowDebugInfo)
		{
			Canvas.Font = GetConsoleFont(Canvas);
			Canvas.Style = 5;
			Canvas.DrawColor = ConsoleColor;
			PlayerOwner.ViewTarget.DisplayDebug(Canvas, XPos, YPos);
		}
		else
		{
			if(Not_PreBool(bHideHUD))
			{
				if(bShowScores)
				{
					if(NotEqual_ObjectObject(ScoreBoard, none))
					{
						ScoreBoard.DrawScoreboard(Canvas);
						if(ScoreBoard.bDisplayMessages)
						{
							DisplayMessages(Canvas);
						}
					}
				}
				else
				{
					if(OrOr_BoolBool(OrOr_BoolBool(OrOr_BoolBool(EqualEqual_ObjectObject(PlayerOwner, none), EqualEqual_ObjectObject(P, none)), EqualEqual_ObjectObject(P.PlayerReplicationInfo, none)), PlayerOwner.IsSpectating()))
					{
						DrawSpectatingHud(Canvas);
					}
					else
					{
						if(Not_PreBool(P.bHideRegularHUD))
						{
							DrawHUD(Canvas);
						}
					}
					if(Not_PreBool(DrawLevelAction(Canvas)))
					{
						if(AndAnd_BoolBool(NotEqual_ObjectObject(PlayerOwner, none), Greater_FloatFloat(PlayerOwner.ProgressTimeOut, Level.TimeSeconds)))
						{
							DisplayProgressMessage(Canvas);
						}
					}
					DisplayMessages(Canvas);
				}
			}
		}
	}
	PlayerOwner.RenderOverlays(Canvas);
	dispatchMessage(Class'Engine.MessagePostRender'.static.Allocate(self)., construct_Canvas(Canvas));
	if(AndAnd_BoolBool(AndAnd_BoolBool(NotEqual_ObjectObject(TextureMovie, none), NotEqual_ObjectObject(TextureMovie.Movie, none)), TextureMovie.Movie.IsPlaying()))
	{
		if(TexMovieTranslucent)
		{
			Canvas.Style = 3;
		}
		else
		{
			Canvas.Style = 1;
		}
		Canvas.SetDrawColor(byte(255), byte(255), byte(255));
		Canvas.SetPos(Multiply_FloatFloat(TexMovieLeft, float(Canvas.SizeX)), Multiply_FloatFloat(TexMovieTop, float(Canvas.SizeY)));
		Canvas.DrawTile(TextureMovie, Multiply_FloatFloat(Subtract_FloatFloat(TexMovieRight, TexMovieLeft), float(Canvas.SizeX)), Multiply_FloatFloat(Subtract_FloatFloat(TexMovieBottom, TexMovieTop), float(Canvas.SizeY)), 0.0000000, 0.0000000, float(TextureMovie.Movie.GetWidth()), float(TextureMovie.Movie.GetHeight()));
	}
	return;
}

function DrawSpectatingHud(Canvas C)
{
	return;
}

simulated function DrawRoute()
{
	local int i;
	local Controller C;
	local Vector Start, End, RealStart;
	local bool bPath;

	C = Pawn(PlayerOwner.ViewTarget).Controller;
	if(EqualEqual_ObjectObject(C, none))
	{
		return;
	}
	if(NotEqual_ObjectObject(C.CurrentPath, none))
	{
		Start = C.CurrentPath.Start.Location;
	}
	else
	{
		Start = PlayerOwner.ViewTarget.Location;
	}
	RealStart = Start;
	if(C.bAdjusting)
	{
		Draw3DLine(C.Pawn.Location, C.AdjustLoc, Class'Engine.Canvas'.static.MakeColor(byte(255), 0, byte(255)));
		Start = C.AdjustLoc;
	}
	if(OrOr_BoolBool(EqualEqual_ObjectObject(C, PlayerOwner), AndAnd_BoolBool(EqualEqual_ObjectObject(C.MoveTarget, C.RouteCache[0]), NotEqual_ObjectObject(C.MoveTarget, none))))
	{
		if(AndAnd_BoolBool(EqualEqual_ObjectObject(C, PlayerOwner), NotEqual_VectorVector(C.Destination, vect(0.0000000, 0.0000000, 0.0000000))))
		{
			if(C.Pawn.IsLocationReachable(C.Destination))
			{
				Draw3DLine(C.Pawn.Location, C.Destination, Class'Engine.Canvas'.static.MakeColor(byte(255), byte(255), byte(255)));
				return;
			}
		}
		i = 0;
		J0x1F1:

		if(Less_IntInt(i, 16))
		{
			if(EqualEqual_ObjectObject(C.RouteCache[i], none))
			{
				// [Explicit Break]
				goto J0x28E;
			}
			bPath = true;
			Draw3DLine(Start, C.RouteCache[i].Location, Class'Engine.Canvas'.static.MakeColor(0, byte(255), 0));
			Start = C.RouteCache[i].Location;
			AddAdd_Int(i);
			// [Loop Continue]
			goto J0x1F1;
		}
		J0x28E:

		if(bPath)
		{
			Draw3DLine(RealStart, C.Destination, Class'Engine.Canvas'.static.MakeColor(byte(255), byte(255), byte(255)));
		}
	}
	else
	{
		if(NotEqual_VectorVector(PlayerOwner.ViewTarget.Velocity, vect(0.0000000, 0.0000000, 0.0000000)))
		{
			Draw3DLine(RealStart, C.Destination, Class'Engine.Canvas'.static.MakeColor(byte(255), byte(255), byte(255)));
		}
	}
	if(EqualEqual_ObjectObject(C, PlayerOwner))
	{
		return;
	}
	if(NotEqual_ObjectObject(C.Focus, none))
	{
		End = C.Focus.Location;
	}
	else
	{
		End = C.FocalPoint;
	}
	Draw3DLine(Add_VectorVector(PlayerOwner.ViewTarget.Location, Multiply_FloatVector(Pawn(PlayerOwner.ViewTarget).BaseEyeHeight, vect(0.0000000, 0.0000000, 1.0000000))), End, Class'Engine.Canvas'.static.MakeColor(byte(255), 0, 0));
	return;
}

function DrawHUD(Canvas Canvas)
{
	return;
}

function PrintActionMessage(Canvas C, string BigMessage)
{
	local float XL, YL;

	if(Greater_IntInt(Len(BigMessage), 10))
	{
		UseLargeFont(C);
	}
	else
	{
		UseHugeFont(C);
	}
	C.bCenter = false;
	C.StrLen(BigMessage, XL, YL);
	C.SetPos(Add_FloatFloat(Multiply_FloatFloat(0.5000000, Subtract_FloatFloat(C.ClipX, XL)), float(1)), Add_FloatFloat(Subtract_FloatFloat(Multiply_FloatFloat(0.6600000, C.ClipY), Multiply_FloatFloat(YL, 0.5000000)), float(1)));
	C.SetDrawColor(0, 0, 0);
	C.DrawText(BigMessage, false);
	C.SetPos(Multiply_FloatFloat(0.5000000, Subtract_FloatFloat(C.ClipX, XL)), Subtract_FloatFloat(Multiply_FloatFloat(0.6600000, C.ClipY), Multiply_FloatFloat(YL, 0.5000000)));
	C.SetDrawColor(0, 0, byte(255));
	C.DrawText(BigMessage, false);
	return;
}

simulated function DisplayProgressMessage(Canvas C)
{
	local int i, LineCount;
	local GameReplicationInfo GRI;
	local float FontDX, FontDY, X, Y;
	local int Alpha;
	local float TimeLeft;

	TimeLeft = Subtract_FloatFloat(PlayerOwner.ProgressTimeOut, Level.TimeSeconds);
	if(GreaterEqual_FloatFloat(TimeLeft, ProgressFadeTime))
	{
		Alpha = 255;
	}
	else
	{
		Alpha = int(Divide_FloatFloat(float(int(Multiply_FloatFloat(float(255), TimeLeft))), ProgressFadeTime));
	}
	GRI = PlayerOwner.GameReplicationInfo;
	LineCount = 0;
	i = 0;
	J0x7E:

	if(Less_IntInt(i, 4))
	{
		if(EqualEqual_StrStr(PlayerOwner.ProgressMessage[i], ""))
		{
			// [Explicit Continue]
			goto J0xAF;
		}
		AddAdd_Int(LineCount);
		J0xAF:

		AddAdd_Int(i);
		// [Loop Continue]
		goto J0x7E;
	}
	if(NotEqual_ObjectObject(GRI, none))
	{
		if(NotEqual_StrStr(GRI.MOTDLine1, ""))
		{
			AddAdd_Int(LineCount);
		}
		if(NotEqual_StrStr(GRI.MOTDLine2, ""))
		{
			AddAdd_Int(LineCount);
		}
		if(NotEqual_StrStr(GRI.MOTDLine3, ""))
		{
			AddAdd_Int(LineCount);
		}
		if(NotEqual_StrStr(GRI.MOTDLine4, ""))
		{
			AddAdd_Int(LineCount);
		}
	}
	C.Font = LoadProgressFont();
	C.Style = 5;
	C.TextSize("A", FontDX, FontDY);
	X = Add_FloatFloat(Multiply_FloatFloat(Multiply_FloatFloat(0.5000000, HudCanvasScale), float(C.SizeX)), Multiply_FloatFloat(Divide_FloatFloat(Subtract_FloatFloat(1.0000000, HudCanvasScale), 2.0000000), float(C.SizeX)));
	Y = Add_FloatFloat(Multiply_FloatFloat(Multiply_FloatFloat(0.5000000, HudCanvasScale), float(C.SizeY)), Multiply_FloatFloat(Divide_FloatFloat(Subtract_FloatFloat(1.0000000, HudCanvasScale), 2.0000000), float(C.SizeY)));
	SubtractEqual_FloatFloat(Y, Multiply_FloatFloat(FontDY, Divide_FloatFloat(float(LineCount), 2.0000000)));
	i = 0;
	J0x22C:

	if(Less_IntInt(i, 4))
	{
		if(EqualEqual_StrStr(PlayerOwner.ProgressMessage[i], ""))
		{
			// [Explicit Continue]
			goto J0x311;
		}
		C.DrawColor = PlayerOwner.ProgressColor[i];
		C.DrawColor.A = byte(Alpha);
		C.TextSize(PlayerOwner.ProgressMessage[i], FontDX, FontDY);
		C.SetPos(Subtract_FloatFloat(X, Divide_FloatFloat(FontDX, 2.0000000)), Y);
		C.DrawText(PlayerOwner.ProgressMessage[i]);
		AddEqual_FloatFloat(Y, FontDY);
		J0x311:

		AddAdd_Int(i);
		// [Loop Continue]
		goto J0x22C;
	}
	if(AndAnd_BoolBool(NotEqual_ObjectObject(GRI, none), NotEqual_IntInt(int(Level.NetMode), int(NM_Standalone))))
	{
		C.DrawColor = MOTDColor;
		C.DrawColor.A = byte(Alpha);
		if(NotEqual_StrStr(GRI.MOTDLine1, ""))
		{
			C.TextSize(GRI.MOTDLine1, FontDX, FontDY);
			C.SetPos(Subtract_FloatFloat(X, Divide_FloatFloat(FontDX, 2.0000000)), Y);
			C.DrawText(GRI.MOTDLine1);
			AddEqual_FloatFloat(Y, FontDY);
		}
		if(NotEqual_StrStr(GRI.MOTDLine2, ""))
		{
			C.TextSize(GRI.MOTDLine2, FontDX, FontDY);
			C.SetPos(Subtract_FloatFloat(X, Divide_FloatFloat(FontDX, 2.0000000)), Y);
			C.DrawText(GRI.MOTDLine2);
			AddEqual_FloatFloat(Y, FontDY);
		}
		if(NotEqual_StrStr(GRI.MOTDLine3, ""))
		{
			C.TextSize(GRI.MOTDLine3, FontDX, FontDY);
			C.SetPos(Subtract_FloatFloat(X, Divide_FloatFloat(FontDX, 2.0000000)), Y);
			C.DrawText(GRI.MOTDLine3);
			AddEqual_FloatFloat(Y, FontDY);
		}
		if(NotEqual_StrStr(GRI.MOTDLine4, ""))
		{
			C.TextSize(GRI.MOTDLine4, FontDX, FontDY);
			C.SetPos(Subtract_FloatFloat(X, Divide_FloatFloat(FontDX, 2.0000000)), Y);
			C.DrawText(GRI.MOTDLine4);
			AddEqual_FloatFloat(Y, FontDY);
		}
	}
	return;
}

function bool DrawLevelAction(Canvas C)
{
	local string BigMessage;

	if(EqualEqual_IntInt(int(Level.LevelAction), int(0)))
	{
		if(AndAnd_BoolBool(NotEqual_ObjectObject(Level.Pauser, none), Greater_FloatFloat(Level.TimeSeconds, Add_FloatFloat(Level.PauseDelay, 0.2000000))))
		{
			BigMessage = PausedMessage;
		}
		else
		{
			BigMessage = "";
			return false;
		}
	}
	else
	{
		if(EqualEqual_IntInt(int(Level.LevelAction), int(1)))
		{
			BigMessage = LoadingMessage;
		}
		else
		{
			if(EqualEqual_IntInt(int(Level.LevelAction), int(2)))
			{
				BigMessage = SavingMessage;
			}
			else
			{
				if(EqualEqual_IntInt(int(Level.LevelAction), int(3)))
				{
					BigMessage = ConnectingMessage;
				}
				else
				{
					if(EqualEqual_IntInt(int(Level.LevelAction), int(4)))
					{
						BigMessage = PrecachingMessage;
					}
				}
			}
		}
	}
	if(NotEqual_StrStr(BigMessage, ""))
	{
		C.Style = 1;
		UseLargeFont(C);
		PrintActionMessage(C, BigMessage);
		return true;
	}
	return false;
	return;
}

function DisplayBadConnectionAlert()
{
	return;
}

function PlayMovieDirect(string MovieFilename, int XPos, int YPos, bool UseSound, bool LoopMovie)
{
	StopMovie();
	MoviePosX = XPos;
	MoviePosY = YPos;
	Movie.Play(MovieFilename, UseSound, LoopMovie);
	return;
}

function PlayMovieScaled(MovieTexture InMovie, float Left, float Top, float Right, float Bottom, bool UseSound, bool LoopMovie, optional bool Translucent)
{
	StopMovie();
	if(Less_FloatFloat(Top, float(0)))
	{
		Top = 0.0000000;
	}
	if(Greater_FloatFloat(Top, float(1)))
	{
		Top = 1.0000000;
	}
	if(Less_FloatFloat(Left, float(0)))
	{
		Left = 0.0000000;
	}
	if(Greater_FloatFloat(Left, float(1)))
	{
		Left = 1.0000000;
	}
	if(Less_FloatFloat(Bottom, float(0)))
	{
		Bottom = 0.0000000;
	}
	if(Greater_FloatFloat(Bottom, float(1)))
	{
		Bottom = 1.0000000;
	}
	if(Less_FloatFloat(Right, float(0)))
	{
		Right = 0.0000000;
	}
	if(Greater_FloatFloat(Right, float(1)))
	{
		Right = 1.0000000;
	}
	TexMovieTop = Top;
	TexMovieLeft = Left;
	TexMovieBottom = Bottom;
	TexMovieRight = Right;
	TexMovieTranslucent = Translucent;
	TextureMovie = InMovie;
	TextureMovie.InitializeMovie();
	return;
}

function bool IsMoviePlaying()
{
	return OrOr_BoolBool(Movie.IsPlaying(), TextureMovie.Movie.IsPlaying());
	return;
}

function PauseMovie(bool Pause)
{
	Movie.Pause(Pause);
	TextureMovie.Movie.Pause(Pause);
	return;
}

function bool IsMoviePaused()
{
	if(Movie.IsPlaying())
	{
		return Movie.IsPaused();
	}
	if(TextureMovie.Movie.IsPlaying())
	{
		return TextureMovie.Movie.IsPaused();
	}
	return false;
	return;
}

function StopMovie()
{
	Movie.StopNow();
	TextureMovie.Movie.StopNow();
	return;
}

simulated function Message(PlayerReplicationInfo PRI, coerce string msg, name MsgType)
{
	if(bMessageBeep)
	{
		PlayerOwner.PlayBeepSound();
	}
	if(OrOr_BoolBool(EqualEqual_NameName(MsgType, 'Say'), EqualEqual_NameName(MsgType, 'TeamSay')))
	{
		msg = Concat_StrStr(Concat_StrStr(PRI.PlayerName, ": "), msg);
	}
	AddTextMessage(msg, Class'Engine.LocalMessage', PRI);
	return;
}

function DisplayPortrait(PlayerReplicationInfo PRI)
{
	return;
}

simulated function LocalizedMessage(Class<LocalMessage> Message, optional int Switch, optional PlayerReplicationInfo RelatedPRI_1, optional PlayerReplicationInfo RelatedPRI_2, optional Object OptionalObject, optional string CriticalString)
{
	return;
}

simulated function PlayReceivedMessage(string S, string PName, ZoneInfo PZone)
{
	PlayerOwner.ClientMessage(S);
	if(bMessageBeep)
	{
		PlayerOwner.PlayBeepSound();
	}
	return;
}

function bool ProcessKeyEvent(int Key, int Action, float Delta)
{
	if(NotEqual_ObjectObject(nextHUD, none))
	{
		return nextHUD.ProcessKeyEvent(Key, Action, Delta);
	}
	return false;
	return;
}

function DisplayMessages(Canvas C)
{
	local int i, j, XPos, YPos, MessageCount;

	local float XL, YL;

	i = 0;
	J0x07:

	if(Less_IntInt(i, ConsoleMessageCount))
	{
		if(EqualEqual_StrStr(TextMessages[i].Text, ""))
		{
			// [Explicit Break]
			goto J0xE6;
			// [Explicit Continue]
			goto J0xDC;
		}
		if(Less_FloatFloat(TextMessages[i].MessageLife, Level.TimeSeconds))
		{
			TextMessages[i].Text = "";
			if(Less_IntInt(i, Subtract_IntInt(ConsoleMessageCount, 1)))
			{
				j = i;
				J0x86:

				if(Less_IntInt(j, Subtract_IntInt(ConsoleMessageCount, 1)))
				{
					TextMessages[j] = TextMessages[Add_IntInt(j, 1)];
					AddAdd_Int(j);
					// [Loop Continue]
					goto J0x86;
				}
			}
			TextMessages[j].Text = "";
			// [Explicit Break]
			goto J0xE6;
			// [Explicit Continue]
			goto J0xDC;
		}
		AddAdd_Int(MessageCount);
		J0xDC:

		AddAdd_Int(i);
		// [Loop Continue]
		goto J0x07;
	}
	J0xE6:

	XPos = int(Add_FloatFloat(float(int(Multiply_FloatFloat(Multiply_FloatFloat(ConsoleMessagePosX, HudCanvasScale), float(C.SizeX)))), Multiply_FloatFloat(Divide_FloatFloat(Subtract_FloatFloat(1.0000000, HudCanvasScale), 2.0000000), float(C.SizeX))));
	YPos = int(Add_FloatFloat(float(int(Multiply_FloatFloat(Multiply_FloatFloat(ConsoleMessagePosY, HudCanvasScale), float(C.SizeY)))), Multiply_FloatFloat(Divide_FloatFloat(Subtract_FloatFloat(1.0000000, HudCanvasScale), 2.0000000), float(C.SizeY))));
	C.Font = GetConsoleFont(C);
	C.DrawColor = ConsoleColor;
	C.TextSize("A", XL, YL);
	i = 0;
	J0x1D6:

	if(Less_IntInt(i, MessageCount))
	{
		if(EqualEqual_StrStr(TextMessages[i].Text, ""))
		{
			// [Explicit Break]
			goto J0x296;
		}
		C.StrLen(TextMessages[i].Text, XL, YL);
		C.SetPos(float(XPos), float(YPos));
		C.DrawColor = TextMessages[i].TextColor;
		C.DrawText(TextMessages[i].Text, false);
		AddEqual_IntInt(YPos, int(YL));
		AddAdd_Int(i);
		// [Loop Continue]
		goto J0x1D6;
	}
	J0x296:

	return;
}

function AddTextMessage(string M, Class<LocalMessage> MessageClass, PlayerReplicationInfo PRI)
{
	local int i;

	if(AndAnd_BoolBool(bMessageBeep, MessageClass.default.bBeep))
	{
		PlayerOwner.PlayBeepSound();
	}
	i = 0;
	J0x33:

	if(Less_IntInt(i, ConsoleMessageCount))
	{
		if(EqualEqual_StrStr(TextMessages[i].Text, ""))
		{
			// [Explicit Break]
			goto J0x66;
		}
		AddAdd_Int(i);
		// [Loop Continue]
		goto J0x33;
	}
	J0x66:

	if(EqualEqual_IntInt(i, ConsoleMessageCount))
	{
		i = 0;
		J0x7C:

		if(Less_IntInt(i, Subtract_IntInt(ConsoleMessageCount, 1)))
		{
			TextMessages[i] = TextMessages[Add_IntInt(i, 1)];
			AddAdd_Int(i);
			// [Loop Continue]
			goto J0x7C;
		}
	}
	TextMessages[i].Text = M;
	TextMessages[i].MessageLife = Add_FloatFloat(Level.TimeSeconds, float(MessageClass.default.Lifetime));
	TextMessages[i].TextColor = MessageClass.static.GetConsoleColor(PRI);
	TextMessages[i].PRI = PRI;
	return;
}

function UseSmallFont(Canvas Canvas)
{
	if(LessEqual_FloatFloat(Canvas.ClipX, float(640)))
	{
		Canvas.Font = SmallFont;
	}
	else
	{
		Canvas.Font = MedFont;
	}
	return;
}

function UseMediumFont(Canvas Canvas)
{
	if(LessEqual_FloatFloat(Canvas.ClipX, float(640)))
	{
		Canvas.Font = MedFont;
	}
	else
	{
		Canvas.Font = BigFont;
	}
	return;
}

function UseLargeFont(Canvas Canvas)
{
	if(LessEqual_FloatFloat(Canvas.ClipX, float(640)))
	{
		Canvas.Font = BigFont;
	}
	else
	{
		Canvas.Font = LargeFont;
	}
	return;
}

function UseHugeFont(Canvas Canvas)
{
	Canvas.Font = LargeFont;
	return;
}

static function Font LoadFontStatic(int i)
{
	if(EqualEqual_ObjectObject(default.FontArrayFonts[i], none))
	{
		default.FontArrayFonts[i] = Font(DynamicLoadObject(default.FontArrayNames[i], Class'Engine.Font'));
		if(EqualEqual_ObjectObject(default.FontArrayFonts[i], none))
		{
			Log(Concat_StrStr(Concat_StrStr(Concat_StrStr("Warning: ", string(default.Class)), " Couldn't dynamically load font "), default.FontArrayNames[i]));
		}
	}
	return default.FontArrayFonts[i];
	return;
}

simulated function Font LoadFont(int i)
{
	if(EqualEqual_ObjectObject(FontArrayFonts[i], none))
	{
		FontArrayFonts[i] = Font(DynamicLoadObject(FontArrayNames[i], Class'Engine.Font'));
		if(EqualEqual_ObjectObject(FontArrayFonts[i], none))
		{
			Log(Concat_StrStr(Concat_StrStr(Concat_StrStr("Warning: ", string(self)), " Couldn't dynamically load font "), FontArrayNames[i]));
		}
	}
	return FontArrayFonts[i];
	return;
}

static function Font GetConsoleFont(Canvas C)
{
	local int FontSize;

	FontSize = default.ConsoleFontSize;
	if(Less_FloatFloat(C.ClipX, float(640)))
	{
		AddAdd_Int(FontSize);
	}
	if(Less_FloatFloat(C.ClipX, float(800)))
	{
		AddAdd_Int(FontSize);
	}
	if(Less_FloatFloat(C.ClipX, float(1024)))
	{
		AddAdd_Int(FontSize);
	}
	if(Less_FloatFloat(C.ClipX, float(1280)))
	{
		AddAdd_Int(FontSize);
	}
	if(Less_FloatFloat(C.ClipX, float(1600)))
	{
		AddAdd_Int(FontSize);
	}
	return LoadFontStatic(Min(8, FontSize));
	return;
}

static function Font GetMediumFontFor(Canvas Canvas)
{
	local int i;

	i = 0;
	J0x07:

	if(Less_IntInt(i, 8))
	{
		if(LessEqual_FloatFloat(float(default.FontScreenWidthMedium[i]), Canvas.ClipX))
		{
			return LoadFontStatic(i);
		}
		AddAdd_Int(i);
		// [Loop Continue]
		goto J0x07;
	}
	return LoadFontStatic(8);
	return;
}

static function Font LargerFontThan(Font aFont)
{
	local int i;

	i = 0;
	J0x07:

	if(Less_IntInt(i, 7))
	{
		if(EqualEqual_ObjectObject(LoadFontStatic(i), aFont))
		{
			return LoadFontStatic(Max(0, Subtract_IntInt(i, 4)));
		}
		AddAdd_Int(i);
		// [Loop Continue]
		goto J0x07;
	}
	return LoadFontStatic(5);
	return;
}

simulated function Font LoadProgressFont()
{
	if(EqualEqual_ObjectObject(ProgressFontFont, none))
	{
		ProgressFontFont = Font(DynamicLoadObject(ProgressFontName, Class'Engine.Font'));
		if(EqualEqual_ObjectObject(ProgressFontFont, none))
		{
			Log(Concat_StrStr(Concat_StrStr(Concat_StrStr("Warning: ", string(self)), " Couldn't dynamically load font "), ProgressFontName));
			ProgressFontFont = SmallFont;
		}
	}
	return ProgressFontFont;
	return;
}

event int AddDebugLine(Vector EndA, Vector EndB, Color Color, optional float LifeSpan)
{
	return;
}

event RemoveDebugLine(int Index)
{
	return;
}

exec event ClearDebugLines()
{
	return;
}

event AddDebugBox(Vector Center, float Diameter, Color Color, optional float LifeSpan)
{
	return;
}

simulated function int AddDebugCone(Vector Origin, Vector direction, float Length, float HalfAngle, Color Color, float LifeSpan)
{
	return;
}

defaultproperties
{
	ProgressFontName="Engine_res.Res_DefaultFont"
	ProgressFadeTime=1.0000000
	MOTDColor=(R=255,G=255,B=255,A=255)
	bHideHUD=true
	bMessageBeep=true
	HudCanvasScale=0.9500000
	LoadingMessage="LOADING"
	SavingMessage="SAVING"
	ConnectingMessage="CONNECTING"
	PausedMessage="PAUSED"
	MoviePosX=100
	MoviePosY=100
	TexMovieBottom=1.0000000
	TexMovieRight=1.0000000
	ConsoleColor=(R=153,G=216,B=253,A=255)
	ConsoleMessageCount=4
	ConsoleFontSize=5
	FontArrayNames[0]="Engine_res.Res_DefaultFont"
	FontArrayNames[1]="Engine_res.Res_DefaultFont"
	FontArrayNames[2]="Engine_res.Res_DefaultFont"
	FontArrayNames[3]="Engine_res.Res_DefaultFont"
	FontArrayNames[4]="Engine_res.Res_DefaultFont"
	FontArrayNames[5]="Engine_res.Res_DefaultFont"
	FontArrayNames[6]="Engine_res.Res_DefaultFont"
	FontArrayNames[7]="Engine_res.Res_DefaultFont"
	FontArrayNames[8]="Engine_res.Res_DefaultFont"
	bHidden=true
	RemoteRole=0
}