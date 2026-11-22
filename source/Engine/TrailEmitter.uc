class TrailEmitter extends ParticleEmitter
	abstract
	native
	editinlinenew;

struct ParticleTrailData
{
	var Vector Location;
	var Color Color;
	var float Size;
	var int DoubleDummy1;
	var int DoubleDummy2;
};

struct ParticleTrailInfo
{
	var int TrailIndex;
	var int NumPoints;
	var Vector LastLocation;
};

var(Trail) int MaxPointsPerTrail;
var(Trail) float DistanceThreshold;
var(Trail) bool UseCrossedSheets;
var(Trail) int MaxTrailTwistAngle;
var transient array<ParticleTrailData> TrailData;
var transient array<ParticleTrailInfo> TrailInfo;
var transient VertexBuffer VertexBuffer;
var transient IndexBuffer IndexBuffer;
var transient int VerticesPerParticle;
var transient int IndicesPerParticle;
var transient int PrimitivesPerParticle;

defaultproperties
{
	MaxPointsPerTrail=50
	DistanceThreshold=1.0000000
	MaxTrailTwistAngle=16384
}