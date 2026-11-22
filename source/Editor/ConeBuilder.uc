class ConeBuilder extends BrushBuilder
	hidecategories(Object,BrushBuilder);

var float Height;
var float CapHeight;
var float OuterRadius;
var float InnerRadius;
var int Sides;
var name GroupName;
var bool AlignToSide;
var bool Hollow;

function BuildCone(int direction, bool AlignToSide, int Sides, float Height, float Radius, name Item)
{
	local int n, i, Ofs;

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
		Vertex3f(Multiply_FloatFloat(Radius, Sin(Divide_FloatFloat(Multiply_FloatFloat(Add_FloatFloat(Multiply_FloatFloat(2.0000000, float(i)), float(Ofs)), 3.1415930), float(Sides)))), Multiply_FloatFloat(Radius, Cos(Divide_FloatFloat(Multiply_FloatFloat(Add_FloatFloat(Multiply_FloatFloat(2.0000000, float(i)), float(Ofs)), 3.1415930), float(Sides)))), 0.0000000);
		AddAdd_Int(i);
		// [Loop Continue]
		goto J0x3A;
	}
	Vertex3f(0.0000000, 0.0000000, Height);
	i = 0;
	J0xDA:

	if(Less_IntInt(i, Sides))
	{
		Poly3i(direction, Add_IntInt(n, i), Add_IntInt(n, Sides), int(Add_FloatFloat(float(n), Percent_FloatFloat(float(Add_IntInt(i, 1)), float(Sides)))), Item);
		AddAdd_Int(i);
		// [Loop Continue]
		goto J0xDA;
	}
	return;
}

function bool Build()
{
	local int i;

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
	if(AndAnd_BoolBool(Hollow, Greater_FloatFloat(CapHeight, Height)))
	{
		return BadParameters();
	}
	if(AndAnd_BoolBool(Hollow, AndAnd_BoolBool(EqualEqual_FloatFloat(CapHeight, Height), EqualEqual_FloatFloat(InnerRadius, OuterRadius))))
	{
		return BadParameters();
	}
	BeginBrush(false, GroupName);
	BuildCone(1, AlignToSide, Sides, Height, OuterRadius, 'Top');
	if(Hollow)
	{
		BuildCone(-1, AlignToSide, Sides, CapHeight, InnerRadius, 'Cap');
		if(NotEqual_FloatFloat(OuterRadius, InnerRadius))
		{
			i = 0;
			J0x12A:

			if(Less_IntInt(i, Sides))
			{
				Poly4i(1, i, int(Percent_FloatFloat(float(Add_IntInt(i, 1)), float(Sides))), int(Add_FloatFloat(float(Add_IntInt(Sides, 1)), Percent_FloatFloat(float(Add_IntInt(i, 1)), float(Sides)))), Add_IntInt(Add_IntInt(Sides, 1), i), 'Bottom');
				AddAdd_Int(i);
				// [Loop Continue]
				goto J0x12A;
			}
		}
	}
	else
	{
		PolyBegin(1, 'Bottom');
		i = 0;
		J0x1AF:

		if(Less_IntInt(i, Sides))
		{
			Polyi(i);
			AddAdd_Int(i);
			// [Loop Continue]
			goto J0x1AF;
		}
		PolyEnd();
	}
	return EndBrush();
	return;
}

defaultproperties
{
	Height=256.0000000
	CapHeight=256.0000000
	OuterRadius=512.0000000
	InnerRadius=384.0000000
	Sides=8
	GroupName="Cone"
	AlignToSide=true
	BitmapFilename="BBCone"
	ToolTip="Cone"
}