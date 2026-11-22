class SwatHUD extends HUD
	transient
	native
	config(SwatGame)
	hidecategories(Karma);

struct native DebugLine
{
	var Vector EndA;
	var Vector EndB;
	var Color Color;
	var float LifeSpan;
};

struct native DebugCone
{
	var Vector Origin;
	var Vector direction;
	var float Length;
	var float HalfAngle;
	var Color Color;
	var float LifeSpan;
};

var config float CommandPositionX;
var config float CommandPositionY;
var config int CommandTextureSizeX;
var config int CommandTextureSizeY;
var float ScaleX;
var float ScaleY;
var bool bShowFocusDebug;
var Texture CommandClearTexture;
var Texture CommandFallInTexture;
var Texture CommandStackUpTexture;
var Texture CommandComplyTexture;
var private bool bShowVisionCones;
var private bool bShowAIMovementDebugInfo;
var private bool bShowOfficerAIAssignmentsInfo;
var private bool bShowCoverInfo;
var private Pawn ShowCoverInfoPawn;
var private AICoverFinder.EShowCoverInfoDetail ShowCoverInfoDetail;
var private bool bShowAwarenessInfo;
var private AwarenessProxy Awareness;
var array<DebugLine> DebugLines;
var array<DebugCone> DebugCones;
var private float LastTimeDebugShapesDrawn;

function PostBeginPlay()
{
	super.PostBeginPlay();
	return;
}

function RenderToScale(Canvas C, Texture t)
{
	C.DrawTile(t, Multiply_FloatFloat(float(t.USize), ScaleX), Multiply_FloatFloat(float(t.VSize), ScaleY), 0.0000000, 0.0000000, float(t.USize), float(t.VSize));
	return;
	return;
}

function PostRender(Canvas C)
{
	super.PostRender(C);
	if(bHideHUD)
	{
		return;
	}
	ScaleX = Divide_FloatFloat(float(C.SizeX), 1024.0000000);
	ScaleY = Divide_FloatFloat(float(C.SizeY), 768.0000000);
	if(bShowFocusDebug)
	{
		DebugRenderPlayerInterfaces(C);
	}
	return;
	return;
}

simulated event WorldSpaceOverlays()
{
	if(AndAnd_BoolBool(bShowDebugInfo, NotEqual_ObjectObject(Pawn(PlayerOwner.ViewTarget), none)))
	{
		DrawRoute();
	}
	if(bShowVisionCones)
	{
		DrawVisionCones();
	}
	if(bShowAIMovementDebugInfo)
	{
		DrawDebugAIMovement();
	}
	if(bShowCoverInfo)
	{
		DrawDebugCover();
	}
	if(bShowAwarenessInfo)
	{
		DrawDebugAwareness();
	}
	if(bShowOfficerAIAssignmentsInfo)
	{
		DrawOfficerAIAssignmentsInfo();
	}
	DrawDebugShapes(self);
	return;
}

exec function ShowVC()
{
	bShowVisionCones = true;
	bHideHUD = false;
	return;
}

exec function HideVC()
{
	bShowVisionCones = false;
	return;
}

function DrawVisionCones()
{
	local Pawn Iter;

	Iter = Level.PawnList;
	J0x14:

	if(NotEqual_ObjectObject(Iter, none))
	{
		if(Iter.IsA('SwatAI'))
		{
			SwatAI(Iter).DrawVisionCone(self);
		}
		Iter = Iter.nextPawn;
		// [Loop Continue]
		goto J0x14;
	}
	return;
}

exec function DebugAIMovement()
{
	bShowAIMovementDebugInfo = Not_PreBool(bShowAIMovementDebugInfo);
	bHideHUD = false;
	return;
}

exec function DebugAssignments()
{
	bShowOfficerAIAssignmentsInfo = Not_PreBool(bShowOfficerAIAssignmentsInfo);
	bHideHUD = false;
	return;
}

function DrawDebugAIMovement()
{
	local Pawn Iter;

	Iter = Level.PawnList;
	J0x14:

	if(NotEqual_ObjectObject(Iter, none))
	{
		if(Iter.IsA('SwatAI'))
		{
			SwatAI(Iter).DrawDebugAIMovement(self);
		}
		Iter = Iter.nextPawn;
		// [Loop Continue]
		goto J0x14;
	}
	return;
}

function DrawOfficerAIAssignmentsInfo()
{
	local Pawn Iter;

	Iter = Level.PawnList;
	J0x14:

	if(NotEqual_ObjectObject(Iter, none))
	{
		if(Iter.IsA('SwatOfficer'))
		{
			SwatOfficer(Iter).DrawLineToAssignment(self);
		}
		Iter = Iter.nextPawn;
		// [Loop Continue]
		goto J0x14;
	}
	return;
}

exec function DebugCover(string AINameString)
{
	bHideHUD = false;
	DebugCoverInternal(AINameString);
	return;
}

exec function DebugCover2(string AINameString)
{
	bHideHUD = false;
	if(DebugCoverInternal(AINameString))
	{
		ShowCoverInfoDetail = 1;
	}
	return;
}

exec function DebugCover3(string AINameString)
{
	bHideHUD = false;
	if(DebugCoverInternal(AINameString))
	{
		ShowCoverInfoDetail = 2;
	}
	return;
}

private function bool DebugCoverInternal(string AINameString)
{
	local Pawn Pawn;

	bShowCoverInfo = false;
	ShowCoverInfoPawn = none;
	ShowCoverInfoDetail = 0;
	if(NotEqual_StrStr(AINameString, ""))
	{
		foreach AllActors(Class'Engine.Pawn', Pawn)
		{
			if(EqualEqual_NameName(Pawn.Name, string(AINameString)))
			{
				bShowCoverInfo = true;
				ShowCoverInfoPawn = Pawn;
				return true;
			}
		}
	}
	return false;
	return;
}

// Export USwatHUD::execDrawDebugCover(FFrame&, void* const)
native function DrawDebugCover();

exec function DebugAwareness(string AINameString)
{
	local Pawn Pawn;
	local SwatAI SwatAI;

	bHideHUD = false;
	bShowAwarenessInfo = false;
	Awareness = none;
	if(NotEqual_StrStr(AINameString, ""))
	{
		foreach AllActors(Class'Engine.Pawn', Pawn)
		{
			if(EqualEqual_NameName(Pawn.Name, string(AINameString)))
			{
				SwatAI = SwatAI(Pawn);
				if(NotEqual_ObjectObject(SwatAI, none))
				{
					Awareness = SwatAI.GetAwareness();
					bShowAwarenessInfo = true;
				}
				break;
			}
		}
	}
	return;
}

exec function DebugOfficerAwareness()
{
	bHideHUD = false;
	bShowAwarenessInfo = true;
	Awareness = SwatAIRepository(Level.AIRepo).GetHive().GetAwareness();
	return;
}

private function DrawDebugAwareness()
{
	if(NotEqual_ObjectObject(Awareness, none))
	{
		Awareness.DrawDebugInfo(self);
	}
	return;
}

exec function ToggleGUI()
{
	local PlayerController PC;

	if(NotEqual_IntInt(int(Level.NetMode), int(NM_Standalone)))
	{
		return;
	}
	PC = Level.GetLocalPlayerController();
	PC.Player.GUIController.bHackDoNotRenderGUIPages = Not_PreBool(PC.Player.GUIController.bHackDoNotRenderGUIPages);
	if(Not_PreBool(PC.Player.GUIController.bHackDoNotRenderGUIPages))
	{
		Log("HIDING GUI");
	}
	else
	{
		Log("SHOWING GUI");
	}
	return;
}

exec function ToggleHUD()
{
	if(NotEqual_IntInt(int(Level.NetMode), int(NM_Standalone)))
	{
		return;
	}
	bHideHUD = Not_PreBool(bHideHUD);
	if(bHideHUD)
	{
		Log("HIDING Heads-up Display");
	}
	else
	{
		Log("SHOWING Heads-up Display");
	}
	return;
}

exec function ShowFocus()
{
	bShowFocusDebug = Not_PreBool(bShowFocusDebug);
	bHideHUD = false;
	return;
}

function RenderCommand(Canvas Canvas)
{
	local Texture it;

	Canvas.bNoSmooth = false;
	Canvas.SetPos(Multiply_FloatFloat(CommandPositionX, Subtract_FloatFloat(Canvas.ClipX, float(CommandTextureSizeX))), Multiply_FloatFloat(CommandPositionY, Subtract_FloatFloat(Canvas.ClipY, float(CommandTextureSizeY))));
	Canvas.Style = 5;
	Canvas.SetDrawColor(byte(255), byte(255), byte(255));
	Canvas.DrawTile(it, float(CommandTextureSizeX), float(CommandTextureSizeY), 0.0000000, 0.0000000, float(CommandTextureSizeX), float(CommandTextureSizeY));
	Canvas.bNoSmooth = true;
	return;
}

simulated function DebugRenderPlayerInterfaces(Canvas Canvas)
{
	local SwatGamePlayerController PC;
	local int X, Y;
	local Actor Actor;
	local Vector CameraLocation;
	local Rotator CameraRotation;

	PC = SwatGamePlayerController(Level.GetLocalPlayerController());
	PC.CalcViewForFocus(Actor, CameraLocation, CameraRotation);
	if(bShowFocusDebug)
	{
		Canvas.SetDrawColor(byte(255), byte(255), byte(255));
		X = 20;
		Y = 50;
		PC.GetFocusInterface(0).DrawDebugText(CameraLocation, Canvas, X, Y);
		PC.GetFocusInterface(1).DrawDebugText(CameraLocation, Canvas, X, Y);
		PC.GetCommandInterface().DrawDebugText(CameraLocation, Canvas, X, Y);
		PC.GetFocusInterface(5).DrawDebugText(CameraLocation, Canvas, X, Y);
		if(NotEqual_IntInt(int(Level.NetMode), int(NM_Standalone)))
		{
			PC.GetFocusInterface(4).DrawDebugText(CameraLocation, Canvas, X, Y);
		}
	}
	return;
}

function DrawDebugShapes(HUD DrawTarget)
{
	local int i;

	i = Subtract_IntInt(DebugLines.Length, 1);
	J0x0F:

	if(GreaterEqual_IntInt(i, 0))
	{
		DrawTarget.Draw3DLine(DebugLines[i].EndA, DebugLines[i].EndB, DebugLines[i].Color);
		if(GreaterEqual_FloatFloat(DebugLines[i].LifeSpan, float(0)))
		{
			SubtractEqual_FloatFloat(DebugLines[i].LifeSpan, Subtract_FloatFloat(Level.TimeSeconds, LastTimeDebugShapesDrawn));
		}
		if(LessEqual_FloatFloat(DebugLines[i].LifeSpan, float(0)))
		{
			RemoveDebugLine(i);
		}
		SubtractSubtract_PreInt(i);
		// [Loop Continue]
		goto J0x0F;
	}
	i = Subtract_IntInt(DebugCones.Length, 1);
	J0xD4:

	if(GreaterEqual_IntInt(i, 0))
	{
		DrawTarget.Draw3DCone(DebugCones[i].Origin, DebugCones[i].direction, DebugCones[i].Length, DebugCones[i].HalfAngle, DebugCones[i].Color);
		if(GreaterEqual_FloatFloat(DebugCones[i].LifeSpan, float(0)))
		{
			SubtractEqual_FloatFloat(DebugCones[i].LifeSpan, Subtract_FloatFloat(Level.TimeSeconds, LastTimeDebugShapesDrawn));
		}
		if(LessEqual_FloatFloat(DebugCones[i].LifeSpan, float(0)))
		{
			RemoveDebugCone(i);
		}
		SubtractSubtract_PreInt(i);
		// [Loop Continue]
		goto J0xD4;
	}
	LastTimeDebugShapesDrawn = Level.TimeSeconds;
	return;
}

function int AddDebugLine(Vector EndA, Vector EndB, Color Color, optional float LifeSpan)
{
	local DebugLine Line;
	local int Index;

	bHideHUD = false;
	Line.EndA = EndA;
	Line.EndB = EndB;
	Line.Color = Color;
	if(Greater_FloatFloat(LifeSpan, float(0)))
	{
		Line.LifeSpan = LifeSpan;
	}
	else
	{
		Line.LifeSpan = 10000.0000000;
	}
	Index = DebugLines.Length;
	DebugLines[Index] = Line;
	return Index;
	return;
}

function RemoveDebugLine(int Index)
{
	DebugLines.Remove(Index, 1);
	return;
}

exec function ClearDebugLines()
{
	DebugLines.Remove(0, DebugLines.Length);
	return;
}

function AddDebugBox(Vector Center, float Diameter, Color Color, optional float LifeSpan)
{
	local float HalfSize;
	local Vector PointA, PointB;

	HalfSize = Divide_FloatFloat(Diameter, 2.0000000);
	PointA = Center;
	PointB = Center;
	SubtractEqual_FloatFloat(PointA.X, HalfSize);
	SubtractEqual_FloatFloat(PointA.Y, HalfSize);
	SubtractEqual_FloatFloat(PointA.Z, HalfSize);
	AddEqual_FloatFloat(PointB.X, HalfSize);
	SubtractEqual_FloatFloat(PointB.Y, HalfSize);
	SubtractEqual_FloatFloat(PointB.Z, HalfSize);
	AddDebugLine(PointA, PointB, Color, LifeSpan);
	PointA = Center;
	PointB = Center;
	SubtractEqual_FloatFloat(PointA.X, HalfSize);
	SubtractEqual_FloatFloat(PointA.Y, HalfSize);
	SubtractEqual_FloatFloat(PointA.Z, HalfSize);
	SubtractEqual_FloatFloat(PointB.X, HalfSize);
	AddEqual_FloatFloat(PointB.Y, HalfSize);
	SubtractEqual_FloatFloat(PointB.Z, HalfSize);
	AddDebugLine(PointA, PointB, Color, LifeSpan);
	PointA = Center;
	PointB = Center;
	SubtractEqual_FloatFloat(PointA.X, HalfSize);
	SubtractEqual_FloatFloat(PointA.Y, HalfSize);
	SubtractEqual_FloatFloat(PointA.Z, HalfSize);
	SubtractEqual_FloatFloat(PointB.X, HalfSize);
	SubtractEqual_FloatFloat(PointB.Y, HalfSize);
	AddEqual_FloatFloat(PointB.Z, HalfSize);
	AddDebugLine(PointA, PointB, Color, LifeSpan);
	PointA = Center;
	PointB = Center;
	AddEqual_FloatFloat(PointA.X, HalfSize);
	SubtractEqual_FloatFloat(PointA.Y, HalfSize);
	AddEqual_FloatFloat(PointA.Z, HalfSize);
	SubtractEqual_FloatFloat(PointB.X, HalfSize);
	SubtractEqual_FloatFloat(PointB.Y, HalfSize);
	AddEqual_FloatFloat(PointB.Z, HalfSize);
	AddDebugLine(PointA, PointB, Color, LifeSpan);
	PointA = Center;
	PointB = Center;
	AddEqual_FloatFloat(PointA.X, HalfSize);
	SubtractEqual_FloatFloat(PointA.Y, HalfSize);
	AddEqual_FloatFloat(PointA.Z, HalfSize);
	AddEqual_FloatFloat(PointB.X, HalfSize);
	AddEqual_FloatFloat(PointB.Y, HalfSize);
	AddEqual_FloatFloat(PointB.Z, HalfSize);
	AddDebugLine(PointA, PointB, Color, LifeSpan);
	PointA = Center;
	PointB = Center;
	AddEqual_FloatFloat(PointA.X, HalfSize);
	SubtractEqual_FloatFloat(PointA.Y, HalfSize);
	AddEqual_FloatFloat(PointA.Z, HalfSize);
	AddEqual_FloatFloat(PointB.X, HalfSize);
	SubtractEqual_FloatFloat(PointB.Y, HalfSize);
	SubtractEqual_FloatFloat(PointB.Z, HalfSize);
	AddDebugLine(PointA, PointB, Color, LifeSpan);
	PointA = Center;
	PointB = Center;
	AddEqual_FloatFloat(PointA.X, HalfSize);
	AddEqual_FloatFloat(PointA.Y, HalfSize);
	SubtractEqual_FloatFloat(PointA.Z, HalfSize);
	SubtractEqual_FloatFloat(PointB.X, HalfSize);
	AddEqual_FloatFloat(PointB.Y, HalfSize);
	SubtractEqual_FloatFloat(PointB.Z, HalfSize);
	AddDebugLine(PointA, PointB, Color, LifeSpan);
	PointA = Center;
	PointB = Center;
	AddEqual_FloatFloat(PointA.X, HalfSize);
	AddEqual_FloatFloat(PointA.Y, HalfSize);
	SubtractEqual_FloatFloat(PointA.Z, HalfSize);
	AddEqual_FloatFloat(PointB.X, HalfSize);
	SubtractEqual_FloatFloat(PointB.Y, HalfSize);
	SubtractEqual_FloatFloat(PointB.Z, HalfSize);
	AddDebugLine(PointA, PointB, Color, LifeSpan);
	PointA = Center;
	PointB = Center;
	AddEqual_FloatFloat(PointA.X, HalfSize);
	AddEqual_FloatFloat(PointA.Y, HalfSize);
	SubtractEqual_FloatFloat(PointA.Z, HalfSize);
	AddEqual_FloatFloat(PointB.X, HalfSize);
	AddEqual_FloatFloat(PointB.Y, HalfSize);
	AddEqual_FloatFloat(PointB.Z, HalfSize);
	AddDebugLine(PointA, PointB, Color, LifeSpan);
	PointA = Center;
	PointB = Center;
	SubtractEqual_FloatFloat(PointA.X, HalfSize);
	AddEqual_FloatFloat(PointA.Y, HalfSize);
	SubtractEqual_FloatFloat(PointA.Z, HalfSize);
	AddEqual_FloatFloat(PointB.X, HalfSize);
	AddEqual_FloatFloat(PointB.Y, HalfSize);
	SubtractEqual_FloatFloat(PointB.Z, HalfSize);
	AddDebugLine(PointA, PointB, Color, LifeSpan);
	PointA = Center;
	PointB = Center;
	SubtractEqual_FloatFloat(PointA.X, HalfSize);
	AddEqual_FloatFloat(PointA.Y, HalfSize);
	SubtractEqual_FloatFloat(PointA.Z, HalfSize);
	SubtractEqual_FloatFloat(PointB.X, HalfSize);
	SubtractEqual_FloatFloat(PointB.Y, HalfSize);
	SubtractEqual_FloatFloat(PointB.Z, HalfSize);
	AddDebugLine(PointA, PointB, Color, LifeSpan);
	PointA = Center;
	PointB = Center;
	SubtractEqual_FloatFloat(PointA.X, HalfSize);
	AddEqual_FloatFloat(PointA.Y, HalfSize);
	SubtractEqual_FloatFloat(PointA.Z, HalfSize);
	SubtractEqual_FloatFloat(PointB.X, HalfSize);
	AddEqual_FloatFloat(PointB.Y, HalfSize);
	AddEqual_FloatFloat(PointB.Z, HalfSize);
	AddDebugLine(PointA, PointB, Color, LifeSpan);
	return;
}

simulated function int AddDebugCone(Vector Origin, Vector direction, float Length, float HalfAngle, Color Color, float LifeSpan)
{
	local DebugCone Cone;
	local int Index;

	bHideHUD = false;
	Cone.Origin = Origin;
	Cone.direction = direction;
	Cone.Length = Length;
	Cone.HalfAngle = HalfAngle;
	Cone.Color = Color;
	if(Greater_FloatFloat(LifeSpan, float(0)))
	{
		Cone.LifeSpan = LifeSpan;
	}
	else
	{
		Cone.LifeSpan = 10000.0000000;
	}
	Index = DebugCones.Length;
	DebugCones[Index] = Cone;
	return Index;
	return;
}

function RemoveDebugCone(int Index)
{
	DebugCones.Remove(Index, 1);
	return;
}

exec function ClearDebugCones()
{
	DebugCones.Remove(0, DebugCones.Length);
	return;
}
