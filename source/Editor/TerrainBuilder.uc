class TerrainBuilder extends BrushBuilder
	hidecategories(Object,BrushBuilder);

var float Height;
var float Width;
var float Breadth;
var int WidthSegments;
var int DepthSegments;
var name GroupName;

function BuildTerrain(int direction, float dx, float dy, float dz, int WidthSeg, int DepthSeg)
{
	local int n, nbottom, ntop, i, j, k,
		X, Y;

	local float WidthStep, DepthStep;

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
	Poly4i(direction, Add_IntInt(n, 3), Add_IntInt(n, 1), Add_IntInt(n, 5), Add_IntInt(n, 7), 'sky');
	nbottom = GetVertexCount();
	WidthStep = Divide_FloatFloat(dx, float(WidthSeg));
	DepthStep = Divide_FloatFloat(dy, float(DepthSeg));
	X = 0;
	J0x125:

	if(Less_IntInt(X, Add_IntInt(WidthSeg, 1)))
	{
		Y = 0;
		J0x13E:

		if(Less_IntInt(Y, Add_IntInt(DepthSeg, 1)))
		{
			Vertex3f(Subtract_FloatFloat(Multiply_FloatFloat(WidthStep, float(X)), Divide_FloatFloat(dx, float(2))), Subtract_FloatFloat(Multiply_FloatFloat(DepthStep, float(Y)), Divide_FloatFloat(dy, float(2))), Subtract_PreFloat(Divide_FloatFloat(dz, float(2))));
			AddAdd_Int(Y);
			// [Loop Continue]
			goto J0x13E;
		}
		AddAdd_Int(X);
		// [Loop Continue]
		goto J0x125;
	}
	ntop = GetVertexCount();
	X = 0;
	J0x1C0:

	if(Less_IntInt(X, Add_IntInt(WidthSeg, 1)))
	{
		Y = 0;
		J0x1D9:

		if(Less_IntInt(Y, Add_IntInt(DepthSeg, 1)))
		{
			Vertex3f(Subtract_FloatFloat(Multiply_FloatFloat(WidthStep, float(X)), Divide_FloatFloat(dx, float(2))), Subtract_FloatFloat(Multiply_FloatFloat(DepthStep, float(Y)), Divide_FloatFloat(dy, float(2))), Divide_FloatFloat(dz, float(2)));
			AddAdd_Int(Y);
			// [Loop Continue]
			goto J0x1D9;
		}
		AddAdd_Int(X);
		// [Loop Continue]
		goto J0x1C0;
	}
	X = 0;
	J0x24D:

	if(Less_IntInt(X, WidthSeg))
	{
		Y = 0;
		J0x263:

		if(Less_IntInt(Y, DepthSeg))
		{
			Poly3i(Subtract_PreInt(direction), Add_IntInt(Add_IntInt(nbottom, Y), Multiply_IntInt(Add_IntInt(DepthSeg, 1), X)), Add_IntInt(Add_IntInt(nbottom, Y), Multiply_IntInt(Add_IntInt(DepthSeg, 1), Add_IntInt(X, 1))), Add_IntInt(Add_IntInt(Add_IntInt(nbottom, 1), Y), Multiply_IntInt(Add_IntInt(DepthSeg, 1), Add_IntInt(X, 1))), 'ground');
			Poly3i(Subtract_PreInt(direction), Add_IntInt(Add_IntInt(nbottom, Y), Multiply_IntInt(Add_IntInt(DepthSeg, 1), X)), Add_IntInt(Add_IntInt(Add_IntInt(nbottom, 1), Y), Multiply_IntInt(Add_IntInt(DepthSeg, 1), Add_IntInt(X, 1))), Add_IntInt(Add_IntInt(Add_IntInt(nbottom, 1), Y), Multiply_IntInt(Add_IntInt(DepthSeg, 1), X)), 'ground');
			AddAdd_Int(Y);
			// [Loop Continue]
			goto J0x263;
		}
		AddAdd_Int(X);
		// [Loop Continue]
		goto J0x24D;
	}
	X = 0;
	J0x371:

	if(Less_IntInt(X, WidthSeg))
	{
		Poly4i(Subtract_PreInt(direction), Add_IntInt(Add_IntInt(nbottom, DepthSeg), Multiply_IntInt(Add_IntInt(DepthSeg, 1), X)), Add_IntInt(Add_IntInt(nbottom, DepthSeg), Multiply_IntInt(Add_IntInt(DepthSeg, 1), Add_IntInt(X, 1))), Add_IntInt(Add_IntInt(ntop, DepthSeg), Multiply_IntInt(Add_IntInt(DepthSeg, 1), Add_IntInt(X, 1))), Add_IntInt(Add_IntInt(ntop, DepthSeg), Multiply_IntInt(Add_IntInt(DepthSeg, 1), X)), 'sky');
		Poly4i(Subtract_PreInt(direction), Add_IntInt(nbottom, Multiply_IntInt(Add_IntInt(DepthSeg, 1), Add_IntInt(X, 1))), Add_IntInt(nbottom, Multiply_IntInt(Add_IntInt(DepthSeg, 1), X)), Add_IntInt(ntop, Multiply_IntInt(Add_IntInt(DepthSeg, 1), X)), Add_IntInt(ntop, Multiply_IntInt(Add_IntInt(DepthSeg, 1), Add_IntInt(X, 1))), 'sky');
		AddAdd_Int(X);
		// [Loop Continue]
		goto J0x371;
	}
	Y = 0;
	J0x48D:

	if(Less_IntInt(Y, DepthSeg))
	{
		Poly4i(Subtract_PreInt(direction), Add_IntInt(nbottom, Y), Add_IntInt(nbottom, Add_IntInt(Y, 1)), Add_IntInt(ntop, Add_IntInt(Y, 1)), Add_IntInt(ntop, Y), 'sky');
		Poly4i(Subtract_PreInt(direction), Add_IntInt(Add_IntInt(nbottom, Multiply_IntInt(Add_IntInt(DepthSeg, 1), WidthSeg)), Add_IntInt(Y, 1)), Add_IntInt(Add_IntInt(nbottom, Multiply_IntInt(Add_IntInt(DepthSeg, 1), WidthSeg)), Y), Add_IntInt(Add_IntInt(ntop, Multiply_IntInt(Add_IntInt(DepthSeg, 1), WidthSeg)), Y), Add_IntInt(Add_IntInt(ntop, Multiply_IntInt(Add_IntInt(DepthSeg, 1), WidthSeg)), Add_IntInt(Y, 1)), 'sky');
		AddAdd_Int(Y);
		// [Loop Continue]
		goto J0x48D;
	}
	return;
}

event bool Build()
{
	if(OrOr_BoolBool(OrOr_BoolBool(OrOr_BoolBool(OrOr_BoolBool(LessEqual_FloatFloat(Height, float(0)), LessEqual_FloatFloat(Width, float(0))), LessEqual_FloatFloat(Breadth, float(0))), LessEqual_IntInt(WidthSegments, 0)), LessEqual_IntInt(DepthSegments, 0)))
	{
		return BadParameters();
	}
	BeginBrush(false, GroupName);
	BuildTerrain(1, Breadth, Width, Height, WidthSegments, DepthSegments);
	return EndBrush();
	return;
}

defaultproperties
{
	Height=256.0000000
	Width=256.0000000
	Breadth=512.0000000
	WidthSegments=4
	DepthSegments=2
	GroupName="Terrain"
	BitmapFilename="BBTerrain"
	ToolTip="BSP Based Terrain"
}