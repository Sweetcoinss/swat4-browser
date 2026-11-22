class SheetBuilder extends BrushBuilder
	hidecategories(Object,BrushBuilder);

enum ESheetAxis
{
	AX_Horizontal,                  // 0
	AX_XAxis,                       // 1
	AX_YAxis                        // 2
};

var int Height;
var int Width;
var int HorizBreaks;
var int VertBreaks;
var SheetBuilder.ESheetAxis Axis;
var name GroupName;

event bool Build()
{
	local int X, Y, XStep, YStep, Count;

	if(OrOr_BoolBool(OrOr_BoolBool(OrOr_BoolBool(LessEqual_IntInt(Height, 0), LessEqual_IntInt(Width, 0)), LessEqual_IntInt(HorizBreaks, 0)), LessEqual_IntInt(VertBreaks, 0)))
	{
		return BadParameters();
	}
	BeginBrush(false, GroupName);
	XStep = Divide_IntInt(Width, HorizBreaks);
	YStep = Divide_IntInt(Height, VertBreaks);
	Count = 0;
	X = 0;
	J0x77:

	if(Less_IntInt(X, HorizBreaks))
	{
		Y = 0;
		J0x8D:

		if(Less_IntInt(Y, VertBreaks))
		{
			if(EqualEqual_IntInt(int(Axis), int(0)))
			{
				Vertex3f(Subtract_FloatFloat(float(Multiply_IntInt(X, XStep)), float(Divide_IntInt(Width, 2))), Subtract_FloatFloat(float(Multiply_IntInt(Y, YStep)), float(Divide_IntInt(Height, 2))), 0.0000000);
				Vertex3f(Subtract_FloatFloat(float(Multiply_IntInt(X, XStep)), float(Divide_IntInt(Width, 2))), Subtract_FloatFloat(Multiply_FloatFloat(float(Add_IntInt(Y, 1)), float(YStep)), float(Divide_IntInt(Height, 2))), 0.0000000);
				Vertex3f(Subtract_FloatFloat(Multiply_FloatFloat(float(Add_IntInt(X, 1)), float(XStep)), float(Divide_IntInt(Width, 2))), Subtract_FloatFloat(Multiply_FloatFloat(float(Add_IntInt(Y, 1)), float(YStep)), float(Divide_IntInt(Height, 2))), 0.0000000);
				Vertex3f(Subtract_FloatFloat(Multiply_FloatFloat(float(Add_IntInt(X, 1)), float(XStep)), float(Divide_IntInt(Width, 2))), Subtract_FloatFloat(float(Multiply_IntInt(Y, YStep)), float(Divide_IntInt(Height, 2))), 0.0000000);
			}
			else
			{
				if(EqualEqual_IntInt(int(Axis), int(1)))
				{
					Vertex3f(0.0000000, Subtract_FloatFloat(float(Multiply_IntInt(X, XStep)), float(Divide_IntInt(Width, 2))), Subtract_FloatFloat(float(Multiply_IntInt(Y, YStep)), float(Divide_IntInt(Height, 2))));
					Vertex3f(0.0000000, Subtract_FloatFloat(float(Multiply_IntInt(X, XStep)), float(Divide_IntInt(Width, 2))), Subtract_FloatFloat(Multiply_FloatFloat(float(Add_IntInt(Y, 1)), float(YStep)), float(Divide_IntInt(Height, 2))));
					Vertex3f(0.0000000, Subtract_FloatFloat(Multiply_FloatFloat(float(Add_IntInt(X, 1)), float(XStep)), float(Divide_IntInt(Width, 2))), Subtract_FloatFloat(Multiply_FloatFloat(float(Add_IntInt(Y, 1)), float(YStep)), float(Divide_IntInt(Height, 2))));
					Vertex3f(0.0000000, Subtract_FloatFloat(Multiply_FloatFloat(float(Add_IntInt(X, 1)), float(XStep)), float(Divide_IntInt(Width, 2))), Subtract_FloatFloat(float(Multiply_IntInt(Y, YStep)), float(Divide_IntInt(Height, 2))));
				}
				else
				{
					Vertex3f(Subtract_FloatFloat(float(Multiply_IntInt(X, XStep)), float(Divide_IntInt(Width, 2))), 0.0000000, Subtract_FloatFloat(float(Multiply_IntInt(Y, YStep)), float(Divide_IntInt(Height, 2))));
					Vertex3f(Subtract_FloatFloat(float(Multiply_IntInt(X, XStep)), float(Divide_IntInt(Width, 2))), 0.0000000, Subtract_FloatFloat(Multiply_FloatFloat(float(Add_IntInt(Y, 1)), float(YStep)), float(Divide_IntInt(Height, 2))));
					Vertex3f(Subtract_FloatFloat(Multiply_FloatFloat(float(Add_IntInt(X, 1)), float(XStep)), float(Divide_IntInt(Width, 2))), 0.0000000, Subtract_FloatFloat(Multiply_FloatFloat(float(Add_IntInt(Y, 1)), float(YStep)), float(Divide_IntInt(Height, 2))));
					Vertex3f(Subtract_FloatFloat(Multiply_FloatFloat(float(Add_IntInt(X, 1)), float(XStep)), float(Divide_IntInt(Width, 2))), 0.0000000, Subtract_FloatFloat(float(Multiply_IntInt(Y, YStep)), float(Divide_IntInt(Height, 2))));
				}
			}
			Poly4i(1, Count, Add_IntInt(Count, 1), Add_IntInt(Count, 2), Add_IntInt(Count, 3), 'Sheet', 264);
			Count = GetVertexCount();
			AddAdd_Int(Y);
			// [Loop Continue]
			goto J0x8D;
		}
		AddAdd_Int(X);
		// [Loop Continue]
		goto J0x77;
	}
	return EndBrush();
	return;
}

defaultproperties
{
	Height=256
	Width=256
	HorizBreaks=1
	VertBreaks=1
	GroupName="Sheet"
	BitmapFilename="BBSheet"
	ToolTip="Sheet"
}