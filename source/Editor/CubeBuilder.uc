class CubeBuilder extends BrushBuilder
	hidecategories(Object,BrushBuilder);

var float Height;
var float Width;
var float Breadth;
var float WallThickness;
var name GroupName;
var bool Hollow;
var bool Tessellated;

function BuildCube(int direction, float dx, float dy, float dz, bool _tessellated)
{
	local int n, i, j, k;

	n = GetVertexCount();
	i = -1;
	J0x17:

	if(Less_IntInt(i, 2))
	{
		j = -1;
		J0x2E:

		if(Less_IntInt(j, 2))
		{
			k = -1;
			J0x45:

			if(Less_IntInt(k, 2))
			{
				Vertex3f(Divide_FloatFloat(Multiply_FloatFloat(float(i), dx), float(2)), Divide_FloatFloat(Multiply_FloatFloat(float(j), dy), float(2)), Divide_FloatFloat(Multiply_FloatFloat(float(k), dz), float(2)));
				AddEqual_IntInt(k, 2);
				// [Loop Continue]
				goto J0x45;
			}
			AddEqual_IntInt(j, 2);
			// [Loop Continue]
			goto J0x2E;
		}
		AddEqual_IntInt(i, 2);
		// [Loop Continue]
		goto J0x17;
	}
	if(_tessellated)
	{
		Poly3i(direction, Add_IntInt(n, 0), Add_IntInt(n, 1), Add_IntInt(n, 3));
		Poly3i(direction, Add_IntInt(n, 0), Add_IntInt(n, 3), Add_IntInt(n, 2));
		Poly3i(direction, Add_IntInt(n, 2), Add_IntInt(n, 3), Add_IntInt(n, 7));
		Poly3i(direction, Add_IntInt(n, 2), Add_IntInt(n, 7), Add_IntInt(n, 6));
		Poly3i(direction, Add_IntInt(n, 6), Add_IntInt(n, 7), Add_IntInt(n, 5));
		Poly3i(direction, Add_IntInt(n, 6), Add_IntInt(n, 5), Add_IntInt(n, 4));
		Poly3i(direction, Add_IntInt(n, 4), Add_IntInt(n, 5), Add_IntInt(n, 1));
		Poly3i(direction, Add_IntInt(n, 4), Add_IntInt(n, 1), Add_IntInt(n, 0));
		Poly3i(direction, Add_IntInt(n, 3), Add_IntInt(n, 1), Add_IntInt(n, 5));
		Poly3i(direction, Add_IntInt(n, 3), Add_IntInt(n, 5), Add_IntInt(n, 7));
		Poly3i(direction, Add_IntInt(n, 0), Add_IntInt(n, 2), Add_IntInt(n, 6));
		Poly3i(direction, Add_IntInt(n, 0), Add_IntInt(n, 6), Add_IntInt(n, 4));
	}
	else
	{
		Poly4i(direction, Add_IntInt(n, 0), Add_IntInt(n, 1), Add_IntInt(n, 3), Add_IntInt(n, 2));
		Poly4i(direction, Add_IntInt(n, 2), Add_IntInt(n, 3), Add_IntInt(n, 7), Add_IntInt(n, 6));
		Poly4i(direction, Add_IntInt(n, 6), Add_IntInt(n, 7), Add_IntInt(n, 5), Add_IntInt(n, 4));
		Poly4i(direction, Add_IntInt(n, 4), Add_IntInt(n, 5), Add_IntInt(n, 1), Add_IntInt(n, 0));
		Poly4i(direction, Add_IntInt(n, 3), Add_IntInt(n, 1), Add_IntInt(n, 5), Add_IntInt(n, 7));
		Poly4i(direction, Add_IntInt(n, 0), Add_IntInt(n, 2), Add_IntInt(n, 6), Add_IntInt(n, 4));
	}
	return;
}

event bool Build()
{
	if(OrOr_BoolBool(OrOr_BoolBool(LessEqual_FloatFloat(Height, float(0)), LessEqual_FloatFloat(Width, float(0))), LessEqual_FloatFloat(Breadth, float(0))))
	{
		return BadParameters();
	}
	if(AndAnd_BoolBool(Hollow, OrOr_BoolBool(OrOr_BoolBool(LessEqual_FloatFloat(Height, WallThickness), LessEqual_FloatFloat(Width, WallThickness)), LessEqual_FloatFloat(Breadth, WallThickness))))
	{
		return BadParameters();
	}
	if(AndAnd_BoolBool(Hollow, Tessellated))
	{
		return BadParameters("The 'Tessellated' option can't be specified with the 'Hollow' option.");
	}
	BeginBrush(false, GroupName);
	BuildCube(1, Breadth, Width, Height, Tessellated);
	if(Hollow)
	{
		BuildCube(-1, Subtract_FloatFloat(Breadth, WallThickness), Subtract_FloatFloat(Width, WallThickness), Subtract_FloatFloat(Height, WallThickness), Tessellated);
	}
	return EndBrush();
	return;
}

defaultproperties
{
	Height=256.0000000
	Width=256.0000000
	Breadth=256.0000000
	WallThickness=16.0000000
	GroupName="Cube"
	BitmapFilename="BBCube"
	ToolTip="Cube"
}