class CylinderBuilder extends BrushBuilder
	hidecategories(Object,BrushBuilder);

var float Height;
var float OuterRadius;
var float InnerRadius;
var int Sides;
var name GroupName;
var bool AlignToSide;
var bool Hollow;

function BuildCylinder(int direction, bool AlignToSide, int Sides, float Height, float Radius)
{
	local int n, i, j, Ofs;

	n = GetVertexCount();
	if(AlignToSide)
	{
		DivideEqual_FloatFloat(Radius, Cos(Divide_FloatFloat(3.1415930, float(Sides))));
		Ofs = 1;
	}
	i = 0;
	J0x3A:

	if(Less_IntInt(i, Sides))
	{
		j = -1;
		J0x54:

		if(Less_IntInt(j, 2))
		{
			Vertex3f(Multiply_FloatFloat(Radius, Sin(Divide_FloatFloat(Multiply_FloatFloat(Add_FloatFloat(Multiply_FloatFloat(2.0000000, float(i)), float(Ofs)), 3.1415930), float(Sides)))), Multiply_FloatFloat(Radius, Cos(Divide_FloatFloat(Multiply_FloatFloat(Add_FloatFloat(Multiply_FloatFloat(2.0000000, float(i)), float(Ofs)), 3.1415930), float(Sides)))), Divide_FloatFloat(Multiply_FloatFloat(float(j), Height), float(2)));
			AddEqual_IntInt(j, 2);
			// [Loop Continue]
			goto J0x54;
		}
		AddAdd_Int(i);
		// [Loop Continue]
		goto J0x3A;
	}
	i = 0;
	J0xF7:

	if(Less_IntInt(i, Sides))
	{
		Poly4i(direction, Add_IntInt(n, Multiply_IntInt(i, 2)), Add_IntInt(Add_IntInt(n, Multiply_IntInt(i, 2)), 1), int(Add_FloatFloat(float(n), Percent_FloatFloat(float(Add_IntInt(Multiply_IntInt(i, 2), 3)), float(Multiply_IntInt(2, Sides))))), int(Add_FloatFloat(float(n), Percent_FloatFloat(float(Add_IntInt(Multiply_IntInt(i, 2), 2)), float(Multiply_IntInt(2, Sides))))), 'Wall');
		AddAdd_Int(i);
		// [Loop Continue]
		goto J0xF7;
	}
	return;
}

function bool Build()
{
	local int i, j;

	if(Less_IntInt(Sides, 3))
	{
		return BadParameters();
	}
	if(OrOr_BoolBool(LessEqual_FloatFloat(Height, float(0)), LessEqual_FloatFloat(OuterRadius, float(0))))
	{
		return BadParameters();
	}
	if(AndAnd_BoolBool(Hollow, OrOr_BoolBool(LessEqual_FloatFloat(InnerRadius, float(0)), GreaterEqual_FloatFloat(InnerRadius, OuterRadius))))
	{
		return BadParameters();
	}
	BeginBrush(false, GroupName);
	BuildCylinder(1, AlignToSide, Sides, Height, OuterRadius);
	if(Hollow)
	{
		BuildCylinder(-1, AlignToSide, Sides, Height, InnerRadius);
		j = -1;
		J0xC2:

		if(Less_IntInt(j, 2))
		{
			i = 0;
			J0xD5:

			if(Less_IntInt(i, Sides))
			{
				Poly4i(j, Add_IntInt(Multiply_IntInt(i, 2), Divide_IntInt(Subtract_IntInt(1, j), 2)), Add_IntInt(Multiply_IntInt(int(Percent_FloatFloat(float(Add_IntInt(i, 1)), float(Sides))), 2), Divide_IntInt(Subtract_IntInt(1, j), 2)), Add_IntInt(Add_IntInt(Multiply_IntInt(int(Percent_FloatFloat(float(Add_IntInt(i, 1)), float(Sides))), 2), Divide_IntInt(Subtract_IntInt(1, j), 2)), Multiply_IntInt(Sides, 2)), Add_IntInt(Add_IntInt(Multiply_IntInt(i, 2), Divide_IntInt(Subtract_IntInt(1, j), 2)), Multiply_IntInt(Sides, 2)), 'Cap');
				AddAdd_Int(i);
				// [Loop Continue]
				goto J0xD5;
			}
			AddEqual_IntInt(j, 2);
			// [Loop Continue]
			goto J0xC2;
		}
	}
	else
	{
		j = -1;
		J0x1AA:

		if(Less_IntInt(j, 2))
		{
			PolyBegin(j, 'Cap');
			i = 0;
			J0x1CD:

			if(Less_IntInt(i, Sides))
			{
				Polyi(Add_IntInt(Multiply_IntInt(i, 2), Divide_IntInt(Subtract_IntInt(1, j), 2)));
				AddAdd_Int(i);
				// [Loop Continue]
				goto J0x1CD;
			}
			PolyEnd();
			AddEqual_IntInt(j, 2);
			// [Loop Continue]
			goto J0x1AA;
		}
	}
	return EndBrush();
	return;
}

defaultproperties
{
	Height=256.0000000
	OuterRadius=512.0000000
	InnerRadius=384.0000000
	Sides=8
	GroupName="Cylinder"
	AlignToSide=true
	BitmapFilename="BBCylinder"
	ToolTip="Cylinder"
}