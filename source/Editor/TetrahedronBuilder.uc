class TetrahedronBuilder extends BrushBuilder
	hidecategories(Object,BrushBuilder);

var float Radius;
var int SphereExtrapolation;
var name GroupName;

function Extrapolate(int A, int B, int C, int Count, float Radius)
{
	local int ab, bc, ca;

	if(Greater_IntInt(Count, 1))
	{
		ab = Vertexv(Multiply_FloatVector(Radius, Normal(Add_VectorVector(GetVertex(A), GetVertex(B)))));
		bc = Vertexv(Multiply_FloatVector(Radius, Normal(Add_VectorVector(GetVertex(B), GetVertex(C)))));
		ca = Vertexv(Multiply_FloatVector(Radius, Normal(Add_VectorVector(GetVertex(C), GetVertex(A)))));
		Extrapolate(A, ab, ca, Subtract_IntInt(Count, 1), Radius);
		Extrapolate(B, bc, ab, Subtract_IntInt(Count, 1), Radius);
		Extrapolate(C, ca, bc, Subtract_IntInt(Count, 1), Radius);
		Extrapolate(ab, bc, ca, Subtract_IntInt(Count, 1), Radius);
	}
	else
	{
		Poly3i(1, A, B, C);
	}
	return;
}

function BuildTetrahedron(float R, int SphereExtrapolation)
{
	Vertex3f(R, 0.0000000, 0.0000000);
	Vertex3f(Subtract_PreFloat(R), 0.0000000, 0.0000000);
	Vertex3f(0.0000000, R, 0.0000000);
	Vertex3f(0.0000000, Subtract_PreFloat(R), 0.0000000);
	Vertex3f(0.0000000, 0.0000000, R);
	Vertex3f(0.0000000, 0.0000000, Subtract_PreFloat(R));
	Extrapolate(2, 1, 4, SphereExtrapolation, Radius);
	Extrapolate(1, 3, 4, SphereExtrapolation, Radius);
	Extrapolate(3, 0, 4, SphereExtrapolation, Radius);
	Extrapolate(0, 2, 4, SphereExtrapolation, Radius);
	Extrapolate(1, 2, 5, SphereExtrapolation, Radius);
	Extrapolate(3, 1, 5, SphereExtrapolation, Radius);
	Extrapolate(0, 3, 5, SphereExtrapolation, Radius);
	Extrapolate(2, 0, 5, SphereExtrapolation, Radius);
	return;
}

event bool Build()
{
	if(OrOr_BoolBool(LessEqual_FloatFloat(Radius, float(0)), LessEqual_IntInt(SphereExtrapolation, 0)))
	{
		return BadParameters();
	}
	BeginBrush(false, GroupName);
	BuildTetrahedron(Radius, SphereExtrapolation);
	return EndBrush();
	return;
}

defaultproperties
{
	Radius=256.0000000
	SphereExtrapolation=1
	GroupName="Tetrahedron"
	BitmapFilename="BBSphere"
	ToolTip="Tetrahedron (Sphere)"
}