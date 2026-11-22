class SpiralStairBuilder extends BrushBuilder
	hidecategories(Object,BrushBuilder);

var int InnerRadius;
var int StepWidth;
var int StepHeight;
var int StepThickness;
var int NumStepsPer360;
var int NumSteps;
var name GroupName;
var bool SlopedCeiling;
var bool SlopedFloor;
var bool CounterClockwise;

function BuildCurvedStair(int direction)
{
	local Rotator RotStep;
	local Vector vtx, NewVtx, Template[8];
	local int X, Y, idx, VertexStart;

	RotStep.Yaw = int(Multiply_FloatFloat(float(65536), Divide_FloatFloat(Divide_FloatFloat(360.0000000, float(NumStepsPer360)), 360.0000000)));
	if(CounterClockwise)
	{
		MultiplyEqual_IntFloat(RotStep.Yaw, float(-1));
		MultiplyEqual_IntFloat(direction, float(-1));
	}
	idx = 0;
	VertexStart = GetVertexCount();
	vtx.X = float(InnerRadius);
	X = 0;
	J0x81:

	if(Less_IntInt(X, 2))
	{
		NewVtx = GreaterGreater_VectorRotator(vtx, Multiply_RotatorFloat(RotStep, float(X)));
		vtx.Z = 0.0000000;
		if(AndAnd_BoolBool(SlopedCeiling, EqualEqual_IntInt(X, 1)))
		{
			vtx.Z = float(StepHeight);
		}
		Vertex3f(NewVtx.X, NewVtx.Y, vtx.Z);
		Template[idx].X = NewVtx.X;
		Template[idx].Y = NewVtx.Y;
		Template[idx].Z = vtx.Z;
		AddAdd_Int(idx);
		vtx.Z = float(StepThickness);
		if(AndAnd_BoolBool(SlopedFloor, EqualEqual_IntInt(X, 0)))
		{
			SubtractEqual_FloatFloat(vtx.Z, float(StepHeight));
		}
		Vertex3f(NewVtx.X, NewVtx.Y, vtx.Z);
		Template[idx].X = NewVtx.X;
		Template[idx].Y = NewVtx.Y;
		Template[idx].Z = vtx.Z;
		AddAdd_Int(idx);
		AddAdd_Int(X);
		// [Loop Continue]
		goto J0x81;
	}
	vtx.X = float(Add_IntInt(InnerRadius, StepWidth));
	X = 0;
	J0x23F:

	if(Less_IntInt(X, 2))
	{
		NewVtx = GreaterGreater_VectorRotator(vtx, Multiply_RotatorFloat(RotStep, float(X)));
		vtx.Z = 0.0000000;
		if(AndAnd_BoolBool(SlopedCeiling, EqualEqual_IntInt(X, 1)))
		{
			vtx.Z = float(StepHeight);
		}
		Vertex3f(NewVtx.X, NewVtx.Y, vtx.Z);
		Template[idx].X = NewVtx.X;
		Template[idx].Y = NewVtx.Y;
		Template[idx].Z = vtx.Z;
		AddAdd_Int(idx);
		vtx.Z = float(StepThickness);
		if(AndAnd_BoolBool(SlopedFloor, EqualEqual_IntInt(X, 0)))
		{
			SubtractEqual_FloatFloat(vtx.Z, float(StepHeight));
		}
		Vertex3f(NewVtx.X, NewVtx.Y, vtx.Z);
		Template[idx].X = NewVtx.X;
		Template[idx].Y = NewVtx.Y;
		Template[idx].Z = vtx.Z;
		AddAdd_Int(idx);
		AddAdd_Int(X);
		// [Loop Continue]
		goto J0x23F;
	}
	X = 0;
	J0x3E4:

	if(Less_IntInt(X, Subtract_IntInt(NumSteps, 1)))
	{
		if(SlopedFloor)
		{
			Poly3i(direction, Add_IntInt(VertexStart, 3), Add_IntInt(VertexStart, 1), Add_IntInt(VertexStart, 5), 'steptop');
			Poly3i(direction, Add_IntInt(VertexStart, 3), Add_IntInt(VertexStart, 5), Add_IntInt(VertexStart, 7), 'steptop');
		}
		else
		{
			Poly4i(direction, Add_IntInt(VertexStart, 3), Add_IntInt(VertexStart, 1), Add_IntInt(VertexStart, 5), Add_IntInt(VertexStart, 7), 'steptop');
		}
		Poly4i(direction, Add_IntInt(VertexStart, 0), Add_IntInt(VertexStart, 1), Add_IntInt(VertexStart, 3), Add_IntInt(VertexStart, 2), 'inner');
		Poly4i(direction, Add_IntInt(VertexStart, 5), Add_IntInt(VertexStart, 4), Add_IntInt(VertexStart, 6), Add_IntInt(VertexStart, 7), 'Outer');
		Poly4i(direction, Add_IntInt(VertexStart, 1), Add_IntInt(VertexStart, 0), Add_IntInt(VertexStart, 4), Add_IntInt(VertexStart, 5), 'stepfront');
		Poly4i(direction, Add_IntInt(VertexStart, 2), Add_IntInt(VertexStart, 3), Add_IntInt(VertexStart, 7), Add_IntInt(VertexStart, 6), 'stepback');
		if(SlopedCeiling)
		{
			Poly3i(direction, Add_IntInt(VertexStart, 0), Add_IntInt(VertexStart, 2), Add_IntInt(VertexStart, 6), 'stepbottom');
			Poly3i(direction, Add_IntInt(VertexStart, 0), Add_IntInt(VertexStart, 6), Add_IntInt(VertexStart, 4), 'stepbottom');
		}
		else
		{
			Poly4i(direction, Add_IntInt(VertexStart, 0), Add_IntInt(VertexStart, 2), Add_IntInt(VertexStart, 6), Add_IntInt(VertexStart, 4), 'stepbottom');
		}
		VertexStart = GetVertexCount();
		Y = 0;
		J0x5FC:

		if(Less_IntInt(Y, 8))
		{
			NewVtx = GreaterGreater_VectorRotator(Template[Y], Multiply_RotatorFloat(RotStep, float(Add_IntInt(X, 1))));
			Vertex3f(NewVtx.X, NewVtx.Y, Add_FloatFloat(NewVtx.Z, float(Multiply_IntInt(StepHeight, Add_IntInt(X, 1)))));
			AddAdd_Int(Y);
			// [Loop Continue]
			goto J0x5FC;
		}
		AddAdd_Int(X);
		// [Loop Continue]
		goto J0x3E4;
	}
	return;
}

function bool Build()
{
	if(OrOr_BoolBool(OrOr_BoolBool(OrOr_BoolBool(Less_IntInt(InnerRadius, 1), Less_IntInt(StepWidth, 1)), Less_IntInt(NumSteps, 1)), Less_IntInt(NumStepsPer360, 3)))
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
	InnerRadius=64
	StepWidth=256
	StepHeight=16
	StepThickness=32
	NumStepsPer360=8
	NumSteps=8
	GroupName="Spiral"
	SlopedCeiling=true
	BitmapFilename="BBSpiralStair"
	ToolTip="Spiral Staircase"
}