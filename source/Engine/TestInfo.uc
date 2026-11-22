class TestInfo extends Info
	config
	notplaceable
	hidecategories(Karma,Movement,Collision,Lighting,LightColor,Karma,Force);

const Pie = 3.14;
const Str = "Tim";
const Lotus = vect(1,2,3);

struct STest
{
	var bool b1;
	var int i;
	var bool b2;
	var bool b3;
};

var bool bTrue1;
var bool bFalse1;
var bool bTrue2;
var bool bFalse2;
var bool bBool1;
var bool bBool2;
var int xnum;
var float ppp;
var string sxx;
var int MyArray[2];
var Vector v1;
var Vector v2;
var string TestRepStr;
var STest ST;

function TestQ()
{
	local Vector V;

	V.X = 2.0000000;
	V.Y = 3.0000000;
	V.Z = 4.0000000;
	assert(EqualEqual_VectorVector(V, vect(2.0000000, 3.0000000, 4.0000000)));
	assert(EqualEqual_FloatFloat(V.Z, float(4)));
	assert(EqualEqual_FloatFloat(V.Y, float(3)));
	assert(EqualEqual_FloatFloat(V.X, float(2)));
	return;
}

static function test()
{
	Class'Engine.TestInfo'.default.v1 = vect(1.0000000, 2.0000000, 3.0000000);
	return;
}

function PostBeginPlay()
{
	Log("!!BEGIN");
	default.v1 = vect(5.0000000, 4.0000000, 3.0000000);
	assert(EqualEqual_VectorVector(default.v1, vect(5.0000000, 4.0000000, 3.0000000)));
	test();
	assert(EqualEqual_VectorVector(default.v1, vect(1.0000000, 2.0000000, 3.0000000)));
	assert(IsA('Actor'));
	assert(IsA('TestInfo'));
	assert(IsA('Info'));
	assert(Not_PreBool(IsA('LevelInfo')));
	assert(Not_PreBool(IsA('Texture')));
	Log("!!END");
	return;
}

function TestStructBools()
{
	assert(EqualEqual_BoolBool(ST.b1, false));
	assert(EqualEqual_BoolBool(ST.b2, false));
	assert(EqualEqual_BoolBool(ST.b3, false));
	ST.b1 = true;
	assert(EqualEqual_BoolBool(ST.b1, true));
	assert(EqualEqual_BoolBool(ST.b2, false));
	assert(EqualEqual_BoolBool(ST.b3, false));
	ST.b2 = true;
	assert(EqualEqual_BoolBool(ST.b1, true));
	assert(EqualEqual_BoolBool(ST.b2, true));
	assert(EqualEqual_BoolBool(ST.b3, false));
	ST.b3 = true;
	assert(EqualEqual_BoolBool(ST.b1, true));
	assert(EqualEqual_BoolBool(ST.b2, true));
	assert(EqualEqual_BoolBool(ST.b3, true));
	ST.b1 = false;
	ST.b2 = false;
	ST.b3 = false;
	return;
}

function BeginPlay()
{
	local TestObj to;

	to = Class'Engine.TestObj'.static.Allocate(self).;
	Construct_Void();
	to = Class'Engine.TestObj'.static.Allocate(self).;
	Construct_Void();
	to = Class'Engine.TestObj'.static.Allocate(self, self).;
	Construct_Void();
	to = Class'Engine.TestObj'.static.Allocate(self, self, "").;
	Construct_Void();
	to = Class'Engine.TestObj'.static.Allocate(self, self, "", 0).;
	Construct_Void();
	to.test();
	TestStructBools();
	return;
}

function TestX(bool bResource)
{
	local int n;

	n = int(bResource);
	MyArray[int(bResource)] = 0;
	AddAdd_Int(MyArray[int(bResource)]);
	return;
}

function bool RecurseTest()
{
	bBool1 = true;
	return false;
	return;
}

function TestLimitor(Class C)
{
	local Class<Actor> NewClass;

	NewClass = Class<Actor>(C);
	return;
}

static function int OtherStatic(int i)
{
	assert(EqualEqual_IntInt(i, 246));
	assert(EqualEqual_IntInt(default.xnum, 777));
	return 555;
	return;
}

static function int TestStatic(int i)
{
	assert(EqualEqual_IntInt(i, 123));
	assert(EqualEqual_IntInt(default.xnum, 777));
	assert(EqualEqual_IntInt(OtherStatic(Multiply_IntInt(i, 2)), 555));
	return i;
	return;
}

function TestContinueFor()
{
	local int i;

	Log("TestContinue");
	i = 0;
	J0x17:

	if(Less_IntInt(i, 20))
	{
		Log(Concat_StrStr("iteration ", string(i)));
		if(OrOr_BoolBool(OrOr_BoolBool(EqualEqual_IntInt(i, 7), EqualEqual_IntInt(i, 9)), EqualEqual_IntInt(i, 19)))
		{
			// [Explicit Continue]
			goto J0x6C;
		}
		Log("...");
		J0x6C:

		AddAdd_Int(i);
		// [Loop Continue]
		goto J0x17;
	}
	Log("DoneContinue");
	return;
}

function TestContinueWhile()
{
	local int i;

	Log("TestContinue");
	J0x10:

	if(LessEqual_IntInt(AddAdd_PreInt(i), 20))
	{
		Log(Concat_StrStr("iteration ", string(i)));
		if(OrOr_BoolBool(EqualEqual_IntInt(i, 7), EqualEqual_IntInt(i, 9)))
		{
		}
		else
		{
			Log("...");
		}
		// [Loop Continue]
		goto J0x10;
	}
	Log("DoneContinue");
	return;
}

function TestContinueDoUntil()
{
	local int i;

	Log("TestContinue");
	J0x10:

	AddAdd_Int(i);
	Log(Concat_StrStr("iteration ", string(i)));
	if(OrOr_BoolBool(OrOr_BoolBool(EqualEqual_IntInt(i, 7), EqualEqual_IntInt(i, 9)), Greater_IntInt(i, 18)))
	{
	}
	else
	{
		Log("...");
	}
	if(!(Greater_IntInt(i, 20)))
		goto J0x10;
	Log("DoneContinue");
	return;
}

function TestContinueForEach()
{
	local Actor A;

	Log("TestContinue");
	foreach AllActors(Class'Engine.Actor', A)
	{
		Log(Concat_StrStr("actor ", string(A)));
		if(EqualEqual_ObjectObject(Light(A), none))
		{
			continue;
		}
		Log("...");
	}
	Log("DoneContinue");
	return;
}

function SubTestOptionalOut(optional out int A, optional out int B, optional out int C)
{
	MultiplyEqual_IntFloat(A, float(2));
	B = Multiply_IntInt(B, 2);
	AddEqual_IntInt(C, C);
	return;
}

function TestOptionalOut()
{
	local int A, B, C;

	A = 1;
	B = 2;
	C = 3;
	SubTestOptionalOut(A, B, C);
	assert(EqualEqual_IntInt(A, 2));
	assert(EqualEqual_IntInt(B, 4));
	assert(EqualEqual_IntInt(C, 6));
	SubTestOptionalOut(A, B);
	assert(EqualEqual_IntInt(A, 4));
	assert(EqualEqual_IntInt(B, 8));
	assert(EqualEqual_IntInt(C, 6));
	SubTestOptionalOut(, B, C);
	assert(EqualEqual_IntInt(A, 4));
	assert(EqualEqual_IntInt(B, 16));
	assert(EqualEqual_IntInt(C, 12));
	SubTestOptionalOut();
	assert(EqualEqual_IntInt(A, 4));
	assert(EqualEqual_IntInt(B, 16));
	assert(EqualEqual_IntInt(C, 12));
	SubTestOptionalOut(A, B, C);
	assert(EqualEqual_IntInt(A, 8));
	assert(EqualEqual_IntInt(B, 32));
	assert(EqualEqual_IntInt(C, 24));
	Log("TestOptionalOut ok!");
	return;
}

function TestNullContext(Actor A)
{
	bHidden = A.bHidden;
	A.bHidden = bHidden;
	return;
}

function TestSwitch()
{
	local string S;
	local int i;
	local bool B;

	S = "Tim";
	i = 2;
	switch(i)
	{
		case 0:
			assert(false);
			break;
		case 2:
			B = true;
			break;
		default:
			assert(false);
			break;
			break;
	}
	assert(B);
	switch(S)
	{
		case "":
			assert(false);
			break;
		case "xyzzy":
			assert(false);
			break;
		default:
			B = false;
			break;
			break;
	}
	assert(Not_PreBool(B));
	Log("testswitch succeeded");
	return;
}

function Tick(float DeltaTime)
{
	local Class C;
	local Class<TestInfo> TC;

	Log(Concat_StrStr("time=", string(Level.TimeSeconds)));
	TestOptionalOut();
	TestNullContext(self);
	TestNullContext(none);
	TestSwitch();
	v1 = vect(1.0000000, 2.0000000, 3.0000000);
	v2 = vect(2.0000000, 4.0000000, 6.0000000);
	assert(NotEqual_VectorVector(v1, v2));
	assert(Not_PreBool(EqualEqual_VectorVector(v1, v2)));
	assert(EqualEqual_VectorVector(v1, vect(1.0000000, 2.0000000, 3.0000000)));
	assert(EqualEqual_VectorVector(v2, vect(2.0000000, 4.0000000, 6.0000000)));
	assert(NotEqual_VectorVector(vect(1.0000000, 2.0000000, 5.0000000), v1));
	assert(EqualEqual_VectorVector(Multiply_VectorFloat(v1, float(2)), v2));
	assert(EqualEqual_VectorVector(v1, Divide_VectorFloat(v2, float(2))));
	assert(EqualEqual_FloatFloat(3.1400000, 3.1400000));
	assert(NotEqual_FloatFloat(3.1400000, float(2)));
	assert(EqualEqual_StrStr("Tim", "Tim"));
	assert(NotEqual_StrStr("Tim", "Bob"));
	assert(EqualEqual_VectorVector(vect(1.0000000, 2.0000000, 3.0000000), vect(1.0000000, 2.0000000, 3.0000000)));
	assert(EqualEqual_StrStr(GetPropertyText("sxx"), "Tim"));
	assert(NotEqual_StrStr(GetPropertyText("ppp"), "123"));
	assert(EqualEqual_StrStr(GetPropertyText("bogus"), ""));
	xnum = 345;
	assert(EqualEqual_StrStr(GetPropertyText("xnum"), "345"));
	SetPropertyText("xnum", "999");
	assert(EqualEqual_IntInt(xnum, 999));
	assert(NotEqual_IntInt(xnum, 666));
	assert(EqualEqual_BoolBool(bTrue1, true));
	assert(EqualEqual_BoolBool(bFalse1, false));
	assert(EqualEqual_BoolBool(bTrue2, true));
	assert(EqualEqual_BoolBool(bFalse2, false));
	assert(EqualEqual_BoolBool(default.bTrue1, true));
	assert(EqualEqual_BoolBool(default.bFalse1, false));
	assert(EqualEqual_BoolBool(default.bTrue2, true));
	assert(EqualEqual_BoolBool(default.bFalse2, false));
	assert(EqualEqual_BoolBool(Class'Engine.TestInfo'.default.bTrue1, true));
	assert(EqualEqual_BoolBool(Class'Engine.TestInfo'.default.bFalse1, false));
	assert(EqualEqual_BoolBool(Class'Engine.TestInfo'.default.bTrue2, true));
	assert(EqualEqual_BoolBool(Class'Engine.TestInfo'.default.bFalse2, false));
	TC = Class;
	assert(EqualEqual_BoolBool(TC.default.bTrue1, true));
	assert(EqualEqual_BoolBool(TC.default.bFalse1, false));
	assert(EqualEqual_BoolBool(TC.default.bTrue2, true));
	assert(EqualEqual_BoolBool(TC.default.bFalse2, false));
	C = Class;
	assert(EqualEqual_BoolBool(Class<TestInfo>(C).default.bTrue1, true));
	assert(EqualEqual_BoolBool(Class<TestInfo>(C).default.bFalse1, false));
	assert(EqualEqual_BoolBool(Class<TestInfo>(C).default.bTrue2, true));
	assert(EqualEqual_BoolBool(Class<TestInfo>(C).default.bFalse2, false));
	assert(EqualEqual_IntInt(default.xnum, 777));
	TestStatic(123);
	TC.static.TestStatic(123);
	Class<TestInfo>(C).static.TestStatic(123);
	bBool2 = RecurseTest();
	assert(EqualEqual_BoolBool(bBool2, false));
	TestStructBools();
	TestQ();
	Log("All tests passed");
	return;
}

function F()
{
	return;
}

function temp()
{
	temp();
	return;
}

state AA
{	stop;
}

state BB
{	stop;
}

state CCAA extends AA
{	stop;
}

state DDAA extends AA
{	stop;
}

state EEDDAA extends DDAA
{	stop;
}

defaultproperties
{
	bTrue1=true
	bTrue2=true
	xnum=777
	ppp=3.1400000
	sxx="Tim"
	bHidden=false
	bAlwaysRelevant=true
	RemoteRole=2
}