class VolumetricBuilder extends BrushBuilder
	hidecategories(Object,BrushBuilder);

var float Height;
var float Radius;
var int NumSheets;
var name GroupName;

function BuildVolumetric(int direction, int NumSheets, float Height, float Radius)
{
	local int n, X, Y;
	local Rotator RotStep;
	local Vector vtx, NewVtx;

	n = GetVertexCount();
	RotStep.Yaw = Divide_IntInt(65536, Multiply_IntInt(NumSheets, 2));
	vtx.X = Radius;
	vtx.Z = Divide_FloatFloat(Height, float(2));
	X = 0;
	J0x54:

	if(Less_IntInt(X, Multiply_IntInt(NumSheets, 2)))
	{
		NewVtx = GreaterGreater_VectorRotator(vtx, Multiply_RotatorFloat(RotStep, float(X)));
		Vertex3f(NewVtx.X, NewVtx.Y, NewVtx.Z);
		Vertex3f(NewVtx.X, NewVtx.Y, Subtract_FloatFloat(NewVtx.Z, Height));
		AddAdd_Int(X);
		// [Loop Continue]
		goto J0x54;
	}
	X = 0;
	J0xE4:

	if(Less_IntInt(X, NumSheets))
	{
		Y = Add_IntInt(Multiply_IntInt(X, 2), 1);
		if(GreaterEqual_IntInt(Y, Multiply_IntInt(NumSheets, 2)))
		{
			SubtractEqual_IntInt(Y, Multiply_IntInt(NumSheets, 2));
		}
		Poly4i(direction, Add_IntInt(n, Multiply_IntInt(X, 2)), Add_IntInt(n, Y), Add_IntInt(Add_IntInt(n, Y), Multiply_IntInt(NumSheets, 2)), Add_IntInt(Add_IntInt(n, Multiply_IntInt(X, 2)), Multiply_IntInt(NumSheets, 2)), 'Sheets', 264);
		AddAdd_Int(X);
		// [Loop Continue]
		goto J0xE4;
	}
	return;
}

function bool Build()
{
	if(Less_IntInt(NumSheets, 2))
	{
		return BadParameters();
	}
	if(OrOr_BoolBool(LessEqual_FloatFloat(Height, float(0)), LessEqual_FloatFloat(Radius, float(0))))
	{
		return BadParameters();
	}
	BeginBrush(true, GroupName);
	BuildVolumetric(1, NumSheets, Height, Radius);
	return EndBrush();
	return;
}

defaultproperties
{
	Height=128.0000000
	Radius=64.0000000
	NumSheets=2
	GroupName="Volumetric"
	BitmapFilename="BBVolumetric"
	ToolTip="Volumetric (Torches, Chains, etc)"
}