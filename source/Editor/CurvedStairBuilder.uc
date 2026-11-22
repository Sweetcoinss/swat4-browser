class CurvedStairBuilder extends BrushBuilder
	hidecategories(Object,BrushBuilder);

var int InnerRadius;
var int StepHeight;
var int StepWidth;
var int AngleOfCurve;
var int NumSteps;
var int AddToFirstStep;
var name GroupName;
var bool CounterClockwise;

function BuildCurvedStair(int direction)
{
	local Rotator RotStep;
	local Vector vtx, NewVtx;
	local int X, InnerStart, OuterStart, BottomInnerStart, BottomOuterStart, Adjustment;

	RotStep.Yaw = Divide_IntInt(int(Multiply_FloatFloat(float(65536), Divide_FloatFloat(float(AngleOfCurve), 360.0000000))), NumSteps);
	if(CounterClockwise)
	{
		MultiplyEqual_IntFloat(RotStep.Yaw, float(-1));
		MultiplyEqual_IntFloat(direction, float(-1));
	}
	InnerStart = GetVertexCount();
	vtx.X = float(InnerRadius);
	X = 0;
	J0x7A:

	if(Less_IntInt(X, Add_IntInt(NumSteps, 1)))
	{
		if(EqualEqual_IntInt(X, 0))
		{
			Adjustment = AddToFirstStep;
		}
		else
		{
			Adjustment = 0;
		}
		NewVtx = GreaterGreater_VectorRotator(vtx, Multiply_RotatorFloat(RotStep, float(X)));
		Vertex3f(NewVtx.X, NewVtx.Y, Subtract_FloatFloat(vtx.Z, float(Adjustment)));
		AddEqual_FloatFloat(vtx.Z, float(StepHeight));
		Vertex3f(NewVtx.X, NewVtx.Y, vtx.Z);
		AddAdd_Int(X);
		// [Loop Continue]
		goto J0x7A;
	}
	OuterStart = GetVertexCount();
	vtx.X = float(Add_IntInt(InnerRadius, StepWidth));
	vtx.Z = 0.0000000;
	X = 0;
	J0x173:

	if(Less_IntInt(X, Add_IntInt(NumSteps, 1)))
	{
		if(EqualEqual_IntInt(X, 0))
		{
			Adjustment = AddToFirstStep;
		}
		else
		{
			Adjustment = 0;
		}
		NewVtx = GreaterGreater_VectorRotator(vtx, Multiply_RotatorFloat(RotStep, float(X)));
		Vertex3f(NewVtx.X, NewVtx.Y, Subtract_FloatFloat(vtx.Z, float(Adjustment)));
		AddEqual_FloatFloat(vtx.Z, float(StepHeight));
		Vertex3f(NewVtx.X, NewVtx.Y, vtx.Z);
		AddAdd_Int(X);
		// [Loop Continue]
		goto J0x173;
	}
	BottomInnerStart = GetVertexCount();
	vtx.X = float(InnerRadius);
	vtx.Z = 0.0000000;
	X = 0;
	J0x265:

	if(Less_IntInt(X, Add_IntInt(NumSteps, 1)))
	{
		NewVtx = GreaterGreater_VectorRotator(vtx, Multiply_RotatorFloat(RotStep, float(X)));
		Vertex3f(NewVtx.X, NewVtx.Y, Subtract_FloatFloat(vtx.Z, float(AddToFirstStep)));
		AddAdd_Int(X);
		// [Loop Continue]
		goto J0x265;
	}
	BottomOuterStart = GetVertexCount();
	vtx.X = float(Add_IntInt(InnerRadius, StepWidth));
	X = 0;
	J0x2F7:

	if(Less_IntInt(X, Add_IntInt(NumSteps, 1)))
	{
		NewVtx = GreaterGreater_VectorRotator(vtx, Multiply_RotatorFloat(RotStep, float(X)));
		Vertex3f(NewVtx.X, NewVtx.Y, Subtract_FloatFloat(vtx.Z, float(AddToFirstStep)));
		AddAdd_Int(X);
		// [Loop Continue]
		goto J0x2F7;
	}
	X = 0;
	J0x364:

	if(Less_IntInt(X, NumSteps))
	{
		Poly4i(direction, Add_IntInt(Add_IntInt(InnerStart, Multiply_IntInt(X, 2)), 2), Add_IntInt(Add_IntInt(InnerStart, Multiply_IntInt(X, 2)), 1), Add_IntInt(Add_IntInt(OuterStart, Multiply_IntInt(X, 2)), 1), Add_IntInt(Add_IntInt(OuterStart, Multiply_IntInt(X, 2)), 2), 'steptop');
		Poly4i(direction, Add_IntInt(Add_IntInt(InnerStart, Multiply_IntInt(X, 2)), 1), Add_IntInt(InnerStart, Multiply_IntInt(X, 2)), Add_IntInt(OuterStart, Multiply_IntInt(X, 2)), Add_IntInt(Add_IntInt(OuterStart, Multiply_IntInt(X, 2)), 1), 'stepfront');
		Poly4i(direction, Add_IntInt(BottomInnerStart, X), Add_IntInt(Add_IntInt(InnerStart, Multiply_IntInt(X, 2)), 1), Add_IntInt(Add_IntInt(InnerStart, Multiply_IntInt(X, 2)), 2), Add_IntInt(Add_IntInt(BottomInnerStart, X), 1), 'innercurve');
		Poly4i(direction, Add_IntInt(Add_IntInt(OuterStart, Multiply_IntInt(X, 2)), 1), Add_IntInt(BottomOuterStart, X), Add_IntInt(Add_IntInt(BottomOuterStart, X), 1), Add_IntInt(Add_IntInt(OuterStart, Multiply_IntInt(X, 2)), 2), 'outercurve');
		Poly4i(direction, Add_IntInt(BottomInnerStart, X), Add_IntInt(Add_IntInt(BottomInnerStart, X), 1), Add_IntInt(Add_IntInt(BottomOuterStart, X), 1), Add_IntInt(BottomOuterStart, X), 'Bottom');
		AddAdd_Int(X);
		// [Loop Continue]
		goto J0x364;
	}
	Poly4i(direction, Add_IntInt(BottomInnerStart, NumSteps), Add_IntInt(InnerStart, Multiply_IntInt(NumSteps, 2)), Add_IntInt(OuterStart, Multiply_IntInt(NumSteps, 2)), Add_IntInt(BottomOuterStart, NumSteps), 'back');
	return;
}

function bool Build()
{
	if(OrOr_BoolBool(Less_IntInt(AngleOfCurve, 1), Greater_IntInt(AngleOfCurve, 360)))
	{
		return BadParameters("Angle is out of range.");
	}
	if(OrOr_BoolBool(OrOr_BoolBool(Less_IntInt(InnerRadius, 1), Less_IntInt(StepWidth, 1)), Less_IntInt(NumSteps, 1)))
	{
		return BadParameters();
	}
	BeginBrush(false, GroupName);
	BuildCurvedStair(1);
	return EndBrush();
	return;
}

defaultproperties
{
	InnerRadius=240
	StepHeight=16
	StepWidth=256
	AngleOfCurve=90
	NumSteps=4
	GroupName="CStair"
	BitmapFilename="BBCurvedStair"
	ToolTip="Curved Staircase"
}