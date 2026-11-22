class LinearStairBuilder extends BrushBuilder
	hidecategories(Object,BrushBuilder);

var int StepLength;
var int StepHeight;
var int StepWidth;
var int NumSteps;
var int AddToFirstStep;
var name GroupName;

event bool Build()
{
	local int i, LastIdx, CurrentX, CurrentY, CurrentZ, Adjustment;

	if(OrOr_BoolBool(OrOr_BoolBool(LessEqual_IntInt(StepLength, 0), LessEqual_IntInt(StepHeight, 0)), LessEqual_IntInt(StepWidth, 0)))
	{
		return BadParameters();
	}
	if(OrOr_BoolBool(LessEqual_IntInt(NumSteps, 1), Greater_IntInt(NumSteps, 45)))
	{
		return BadParameters("NumSteps must be greater than 1 and less than 45.");
	}
	BeginBrush(false, GroupName);
	CurrentX = 0;
	CurrentY = 0;
	CurrentZ = 0;
	LastIdx = GetVertexCount();
	Vertex3f(0.0000000, 0.0000000, float(Subtract_PreInt(StepHeight)));
	Vertex3f(0.0000000, float(StepWidth), float(Subtract_PreInt(StepHeight)));
	Vertex3f(float(Multiply_IntInt(StepLength, NumSteps)), float(StepWidth), float(Subtract_PreInt(StepHeight)));
	Vertex3f(float(Multiply_IntInt(StepLength, NumSteps)), 0.0000000, float(Subtract_PreInt(StepHeight)));
	Poly4i(1, 0, 1, 2, 3, 'Base');
	AddEqual_IntInt(LastIdx, 4);
	Vertex3f(float(Multiply_IntInt(StepLength, NumSteps)), float(StepWidth), float(Subtract_PreInt(StepHeight)));
	Vertex3f(float(Multiply_IntInt(StepLength, NumSteps)), float(StepWidth), Add_FloatFloat(float(Multiply_IntInt(StepHeight, Subtract_IntInt(NumSteps, 1))), float(AddToFirstStep)));
	Vertex3f(float(Multiply_IntInt(StepLength, NumSteps)), 0.0000000, Add_FloatFloat(float(Multiply_IntInt(StepHeight, Subtract_IntInt(NumSteps, 1))), float(AddToFirstStep)));
	Vertex3f(float(Multiply_IntInt(StepLength, NumSteps)), 0.0000000, float(Subtract_PreInt(StepHeight)));
	Poly4i(1, 4, 5, 6, 7, 'back');
	AddEqual_IntInt(LastIdx, 4);
	i = 0;
	J0x213:

	if(Less_IntInt(i, NumSteps))
	{
		CurrentX = Multiply_IntInt(i, StepLength);
		CurrentZ = Add_IntInt(Multiply_IntInt(i, StepHeight), AddToFirstStep);
		Vertex3f(float(CurrentX), float(CurrentY), float(CurrentZ));
		Vertex3f(float(CurrentX), float(Add_IntInt(CurrentY, StepWidth)), float(CurrentZ));
		Vertex3f(float(Add_IntInt(CurrentX, StepLength)), float(Add_IntInt(CurrentY, StepWidth)), float(CurrentZ));
		Vertex3f(float(Add_IntInt(CurrentX, StepLength)), float(CurrentY), float(CurrentZ));
		Poly4i(1, Add_IntInt(Add_IntInt(LastIdx, Multiply_IntInt(i, 4)), 3), Add_IntInt(Add_IntInt(LastIdx, Multiply_IntInt(i, 4)), 2), Add_IntInt(Add_IntInt(LastIdx, Multiply_IntInt(i, 4)), 1), Add_IntInt(LastIdx, Multiply_IntInt(i, 4)), 'Step');
		AddAdd_Int(i);
		// [Loop Continue]
		goto J0x213;
	}
	AddEqual_IntInt(LastIdx, Multiply_IntInt(NumSteps, 4));
	i = 0;
	J0x34D:

	if(Less_IntInt(i, NumSteps))
	{
		CurrentX = Multiply_IntInt(i, StepLength);
		CurrentZ = Add_IntInt(Multiply_IntInt(i, StepHeight), AddToFirstStep);
		if(EqualEqual_IntInt(i, 0))
		{
			Adjustment = AddToFirstStep;
		}
		else
		{
			Adjustment = 0;
		}
		Vertex3f(float(CurrentX), float(CurrentY), float(CurrentZ));
		Vertex3f(float(CurrentX), float(CurrentY), float(Subtract_IntInt(Subtract_IntInt(CurrentZ, StepHeight), Adjustment)));
		Vertex3f(float(CurrentX), float(Add_IntInt(CurrentY, StepWidth)), float(Subtract_IntInt(Subtract_IntInt(CurrentZ, StepHeight), Adjustment)));
		Vertex3f(float(CurrentX), float(Add_IntInt(CurrentY, StepWidth)), float(CurrentZ));
		Poly4i(1, Add_IntInt(Add_IntInt(LastIdx, Multiply_IntInt(i, 12)), 3), Add_IntInt(Add_IntInt(LastIdx, Multiply_IntInt(i, 12)), 2), Add_IntInt(Add_IntInt(LastIdx, Multiply_IntInt(i, 12)), 1), Add_IntInt(LastIdx, Multiply_IntInt(i, 12)), 'Rise');
		Vertex3f(float(CurrentX), float(CurrentY), float(CurrentZ));
		Vertex3f(float(CurrentX), float(CurrentY), float(Subtract_IntInt(Subtract_IntInt(CurrentZ, StepHeight), Adjustment)));
		Vertex3f(float(Add_IntInt(CurrentX, Multiply_IntInt(StepLength, Subtract_IntInt(NumSteps, i)))), float(CurrentY), float(Subtract_IntInt(Subtract_IntInt(CurrentZ, StepHeight), Adjustment)));
		Vertex3f(float(Add_IntInt(CurrentX, Multiply_IntInt(StepLength, Subtract_IntInt(NumSteps, i)))), float(CurrentY), float(CurrentZ));
		Poly4i(1, Add_IntInt(Add_IntInt(LastIdx, Multiply_IntInt(i, 12)), 4), Add_IntInt(Add_IntInt(LastIdx, Multiply_IntInt(i, 12)), 5), Add_IntInt(Add_IntInt(LastIdx, Multiply_IntInt(i, 12)), 6), Add_IntInt(Add_IntInt(LastIdx, Multiply_IntInt(i, 12)), 7), 'Side');
		Vertex3f(float(CurrentX), float(Add_IntInt(CurrentY, StepWidth)), float(CurrentZ));
		Vertex3f(float(CurrentX), float(Add_IntInt(CurrentY, StepWidth)), float(Subtract_IntInt(Subtract_IntInt(CurrentZ, StepHeight), Adjustment)));
		Vertex3f(float(Add_IntInt(CurrentX, Multiply_IntInt(StepLength, Subtract_IntInt(NumSteps, i)))), float(Add_IntInt(CurrentY, StepWidth)), float(Subtract_IntInt(Subtract_IntInt(CurrentZ, StepHeight), Adjustment)));
		Vertex3f(float(Add_IntInt(CurrentX, Multiply_IntInt(StepLength, Subtract_IntInt(NumSteps, i)))), float(Add_IntInt(CurrentY, StepWidth)), float(CurrentZ));
		Poly4i(1, Add_IntInt(Add_IntInt(LastIdx, Multiply_IntInt(i, 12)), 11), Add_IntInt(Add_IntInt(LastIdx, Multiply_IntInt(i, 12)), 10), Add_IntInt(Add_IntInt(LastIdx, Multiply_IntInt(i, 12)), 9), Add_IntInt(Add_IntInt(LastIdx, Multiply_IntInt(i, 12)), 8), 'Side');
		AddAdd_Int(i);
		// [Loop Continue]
		goto J0x34D;
	}
	return EndBrush();
	return;
}

defaultproperties
{
	StepLength=32
	StepHeight=16
	StepWidth=256
	NumSteps=8
	GroupName="LinearStair"
	BitmapFilename="BBLinearStair"
	ToolTip="Linear Staircase"
}