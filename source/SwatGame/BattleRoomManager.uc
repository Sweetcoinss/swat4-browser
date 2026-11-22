class BattleRoomManager extends Actor
	config
	notplaceable
	hidecategories(Karma);

var array<Pawn> SelectedPawns;
var ColorModifier ColorBar;
var export editinline GUIBattleRoom GUIParent;
var Texture PauseTex;
var Texture BarTex;

function Open()
{
	GUIParent = SwatGamePlayerController(Owner).GetHUDPage().BattleRoom;
	GUIParent.ScreenCanvas.__OnClientDraw__Delegate = RenderBattleRoom;
	GUIParent.ScreenCanvas.__OnMouseRelease__Delegate = ClickBattleRoom;
	GUIParent.FillOwner();
	GUIParent.Open();
	return;
}

function bool IsSelected(Pawn inPawn, out int Index)
{
	local int ct;

	ct = 0;
	J0x07:

	if(Less_IntInt(ct, SelectedPawns.Length))
	{
		if(EqualEqual_ObjectObject(SelectedPawns[ct], inPawn))
		{
			Index = ct;
			return true;
		}
		AddAdd_Int(ct);
		// [Loop Continue]
		goto J0x07;
	}
	return false;
	return;
}

function Vector GetMouseLookDir()
{
	local Vector Screen;

	Screen.X = GUIParent.Controller.MouseX;
	Screen.Y = GUIParent.Controller.MouseY;
	return GUIParent.Controller.ScreenToWorld(Screen);
	return;
}

function RightClickBattleRoom()
{
	local Vector Screen, StartDir, EndTrace, HitLoc, HitNorm;

	local Actor HitActor;

	Screen.X = GUIParent.Controller.MouseX;
	Screen.Y = GUIParent.Controller.MouseY;
	StartDir = GUIParent.Controller.ScreenToWorld(Screen);
	EndTrace = Add_VectorVector(Owner.Location, Multiply_VectorFloat(StartDir, float(1000)));
	HitActor = Trace(HitLoc, HitNorm, EndTrace, Owner.Location, true,,,,, true);
	Log(string(HitActor));
	if(NotEqual_ObjectObject(HitActor, none))
	{
		if(HitActor.IsA('Pawn'))
		{
			SelectedPawns.Remove(0, SelectedPawns.Length);
			SelectedPawns[0] = Pawn(HitActor);
			GUIParent.OpenMenu(SelectedPawns[0]);
		}
	}
	return;
}

function ClickBattleRoom(GUIComponent Sender)
{
	local Vector Screen, StartDir, EndTrace, HitLoc, HitNorm;

	local Actor HitActor;
	local int Index;

	Screen.X = GUIParent.Controller.MouseX;
	Screen.Y = GUIParent.Controller.MouseY;
	StartDir = GUIParent.Controller.ScreenToWorld(Screen);
	EndTrace = Add_VectorVector(Owner.Location, Multiply_VectorFloat(StartDir, float(1000)));
	HitActor = Trace(HitLoc, HitNorm, EndTrace, Owner.Location, true,,,,, true);
	Log(string(HitActor));
	if(NotEqual_ObjectObject(HitActor, none))
	{
		if(HitActor.IsA('Pawn'))
		{
			if(NotEqual_IntInt(int(SwatGamePlayerController(Owner).bBattleRoomControl), 0))
			{
				if(Not_PreBool(IsSelected(Pawn(HitActor), Index)))
				{
					SelectedPawns[SelectedPawns.Length] = Pawn(HitActor);
				}
				else
				{
					SelectedPawns.Remove(Index, 1);
				}
			}
			else
			{
				if(Not_PreBool(IsSelected(Pawn(HitActor), Index)))
				{
					SelectedPawns.Remove(0, SelectedPawns.Length);
					SelectedPawns[0] = Pawn(HitActor);
				}
				else
				{
					SelectedPawns.Remove(0, SelectedPawns.Length);
				}
			}
		}
		else
		{
			if(HitActor.IsA('LevelInfo'))
			{
				MoveSelectedToLocation(HitLoc);
			}
		}
	}
	return;
}

function MoveSelectedToLocation(Vector NewLocation)
{
	if(EqualEqual_IntInt(SelectedPawns.Length, 1))
	{
		SelectedPawns[0].SetLocation(Add_VectorVector(NewLocation, Multiply_VectorFloat(vect(0.0000000, 0.0000000, 1.0000000), SelectedPawns[0].CollisionHeight)));
		Log(Concat_StrStr(Concat_StrStr(Concat_StrStr("Moving pawn: ", string(SelectedPawns[0])), ", to location: "), string(NewLocation)));
	}
	return;
}

function SetSelectedHealth(int Health)
{
	local int ct;

	ct = 0;
	J0x07:

	if(Less_IntInt(ct, SelectedPawns.Length))
	{
		SelectedPawns[ct].Health = Health;
		SelectedPawns[ct].default.Health = Health;
		AddAdd_Int(ct);
		// [Loop Continue]
		goto J0x07;
	}
	return;
}

function GetActiveCharacterActionNameForPawn(Pawn inPawn, out string Goal, out string Action)
{
	local int i;
	local AI_Goal IterGoal;

	i = 0;
	J0x07:

	if(Less_IntInt(i, inPawn.CharacterAI.goals.Length))
	{
		IterGoal = AI_Goal(inPawn.CharacterAI.goals[i]);
		if(AndAnd_BoolBool(NotEqual_ObjectObject(IterGoal.achievingAction, none), EqualEqual_IntInt(IterGoal.achievingAction.resourceUsage, 8)))
		{
			Action = string(IterGoal.achievingAction.Name);
			Goal = IterGoal.goalName;
		}
		AddAdd_PreInt(i);
		// [Loop Continue]
		goto J0x07;
	}
	return;
}

function RenderAIInfo(Canvas inCanvas, SwatAI AiPawn, Vector inPawnScreen)
{
	local int PawnLeft, PawnTop;
	local string Goal, Action;
	local name Anim;
	local float frame, Rate;

	if(Not_PreBool(AiPawn.bDisplayBattleDebug))
	{
		return;
	}
	PawnLeft = int(Subtract_FloatFloat(inPawnScreen.X, float(50)));
	PawnTop = int(Subtract_FloatFloat(inPawnScreen.Y, float(50)));
	inCanvas.SetPos(float(Add_IntInt(PawnLeft, 5)), float(Add_IntInt(PawnTop, 5)));
	inCanvas.SetDrawColor(200, 200, 200, byte(255));
	inCanvas.DrawTextClipped(Concat_StrStr("Morale: ", string(AiPawn.GetCommanderAction().GetCurrentMorale())));
	GetActiveCharacterActionNameForPawn(AiPawn, Goal, Action);
	inCanvas.SetDrawColor(200, 200, 200, byte(255));
	inCanvas.SetPos(float(Add_IntInt(PawnLeft, 5)), float(Add_IntInt(PawnTop, 15)));
	inCanvas.DrawTextClipped(Goal);
	inCanvas.SetPos(float(Add_IntInt(PawnLeft, 5)), float(Add_IntInt(PawnTop, 25)));
	inCanvas.DrawTextClipped(Action);
	inCanvas.SetPos(float(Add_IntInt(PawnLeft, 5)), float(Add_IntInt(PawnTop, 35)));
	AiPawn.GetAnimParams(0, Anim, frame, Rate);
	inCanvas.DrawTextClipped(string(Anim));
	return;
}

function SelectAllPawns()
{
	local Pawn NewPawn;

	SelectedPawns.Remove(0, SelectedPawns.Length);
	foreach DynamicActors(Class'Engine.Pawn', NewPawn)
	{
		SelectedPawns[SelectedPawns.Length] = NewPawn;
	}
	return;
}

function RenderSelectionReticle(Canvas inCanvas, Pawn inPawn, Vector inPawnScreen)
{
	local float BoxXL, BoxYL, BoxX, BoxY, Distance;

	inCanvas.SetDrawColor(byte(255), byte(255), byte(255), byte(255));
	Distance = VSize(Subtract_VectorVector(inPawn.Location, Owner.Location));
	BoxXL = Multiply_FloatFloat(30000.0000000, Divide_FloatFloat(1.0000000, Distance));
	BoxYL = Multiply_FloatFloat(40000.0000000, Divide_FloatFloat(1.0000000, Distance));
	BoxX = Subtract_FloatFloat(inPawnScreen.X, Multiply_FloatFloat(float(17000), Divide_FloatFloat(1.0000000, Distance)));
	BoxY = Subtract_FloatFloat(inPawnScreen.Y, Multiply_FloatFloat(float(21000), Divide_FloatFloat(1.0000000, Distance)));
	inCanvas.SetPos(BoxX, BoxY);
	inCanvas.DrawBracket(BoxXL, BoxYL, 6.0000000);
	RenderHealthInfo(inCanvas, inPawn, inPawnScreen, int(BoxX), int(Subtract_FloatFloat(Add_FloatFloat(BoxY, BoxYL), float(20))), int(BoxXL), int(BoxYL));
	return;
}

function RenderHealthInfo(Canvas inCanvas, Pawn inPawn, Vector inPawnScreen, int X, int Y, int XL, int YL)
{
	local float TextX, TextXL, TextYL, HealthX;
	local int PawnLeft, PawnTop;
	local float HealthRatio;

	PawnLeft = int(Subtract_FloatFloat(inPawnScreen.X, float(50)));
	PawnTop = int(Subtract_FloatFloat(inPawnScreen.Y, float(50)));
	HealthRatio = FClamp(Divide_FloatFloat(float(inPawn.Health), float(inPawn.default.Health)), 0.0000000, 1.0000000);
	inCanvas.TextSize(string(inPawn.Name), TextXL, TextYL);
	HealthX = 86.0000000;
	TextX = float(Add_IntInt(PawnLeft, 5));
	inCanvas.SetPos(float(X), float(Y));
	inCanvas.SetDrawColor(0, 0, 0, byte(255));
	inCanvas.DrawTile(BarTex, float(XL), 10.0000000, 0.0000000, 0.0000000, float(BarTex.USize), float(BarTex.VSize));
	inCanvas.SetPos(float(X), float(Y));
	if(inPawn.Controller.bGodMode)
	{
		inCanvas.SetDrawColor(0, 0, byte(255), byte(255));
	}
	else
	{
		inCanvas.SetDrawColor(byte(Subtract_FloatFloat(255.0000000, Multiply_FloatFloat(255.0000000, HealthRatio))), byte(Multiply_FloatFloat(255.0000000, HealthRatio)), 0, 200);
	}
	inCanvas.DrawTile(BarTex, Multiply_FloatFloat(float(XL), HealthRatio), 10.0000000, 0.0000000, 0.0000000, float(BarTex.USize), float(BarTex.VSize));
	inCanvas.SetDrawColor(200, 200, 200, byte(255));
	inCanvas.SetPos(float(Add_IntInt(X, 2)), float(Add_IntInt(Y, 10)));
	inCanvas.DrawTextClipped(string(inPawn.Name));
	return;
}

function RenderBattleRoom(Canvas inCanvas)
{
	local Vector ScreenLoc, DirToPawn;
	local float DotToPawn;
	local int ct;

	inCanvas.Font = inCanvas.TinyFont;
	ct = 0;
	J0x24:

	if(Less_IntInt(ct, SelectedPawns.Length))
	{
		if(OrOr_BoolBool(EqualEqual_ObjectObject(SelectedPawns[ct], none), LessEqual_IntInt(SelectedPawns[ct].Health, 0)))
		{
			SelectedPawns.Remove(ct, 1);
			// [Explicit Continue]
			goto J0x171;
		}
		ScreenLoc = GUIParent.Controller.WorldToScreen(SelectedPawns[ct].Location);
		DirToPawn = Subtract_VectorVector(SelectedPawns[ct].Location, Owner.Location);
		DotToPawn = Dot_VectorVector(Normal(DirToPawn), Vector(Owner.Rotation));
		if(Less_FloatFloat(DotToPawn, float(0)))
		{
			// [Explicit Continue]
			goto J0x171;
		}
		RenderSelectionReticle(inCanvas, SelectedPawns[ct], ScreenLoc);
		if(SelectedPawns[ct].IsA('SwatAI'))
		{
			RenderAIInfo(inCanvas, SwatAI(SelectedPawns[ct]), ScreenLoc);
		}
		if(GUIParent.bMenuOpen)
		{
			GUIParent.MenuReposition();
		}
		J0x171:

		AddAdd_Int(ct);
		// [Loop Continue]
		goto J0x24;
	}
	if(Level.bPlayersOnly)
	{
		inCanvas.SetPos(Subtract_FloatFloat(inCanvas.ClipX, float(64)), Subtract_FloatFloat(inCanvas.ClipY, float(80)));
		inCanvas.DrawTile(PauseTex, 48.0000000, 48.0000000, 0.0000000, 0.0000000, float(PauseTex.USize), float(PauseTex.VSize));
	}
	return;
}

defaultproperties
{
	ColorBar=ColorModifier'ProgrammerTestObjectsTex.whitebarmod'
	PauseTex=Texture'UWindow_res.Icons.MouseWait'
	BarTex=Texture'ProgrammerTestObjectsTex.ColorBar'
	DrawType=0
	bHidden=true
	bStasis=true
}