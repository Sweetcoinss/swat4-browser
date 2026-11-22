class PlayerInput extends Object within PlayerController
	transient
	native
	config(User);

var globalconfig bool bInvertMouse;
var bool bWasForward;
var bool bWasBack;
var bool bWasLeft;
var bool bWasRight;
var bool bEdgeForward;
var bool bEdgeBack;
var bool bEdgeLeft;
var bool bEdgeRight;
var bool bAdjustSampling;
var globalconfig byte MouseSmoothingMode;
var globalconfig float MouseSmoothingStrength;
var globalconfig float MouseSensitivity;
var globalconfig float MouseSamplingTime;
var globalconfig float MouseAccelThreshold;
var float SmoothedMouse[2];
var float ZeroTime[2];
var float SamplingTime[2];
var float MaybeTime[2];
var float OldSamples[4];
var int MouseSamples[2];
var float DoubleClickTimer;
var globalconfig float DoubleClickTime;

function bool InvertLook()
{
	return;
}

event PlayerInput(float DeltaTime)
{
	local float FOVScale, MouseScale;

	if(AndAnd_BoolBool(Outer.bDemoOwner, Not_PreBool(Outer.default.bDemoOwner)))
	{
		return;
	}
	bEdgeForward = XorXor_BoolBool(bWasForward, Greater_FloatFloat(Outer.aBaseY, float(0)));
	bEdgeBack = XorXor_BoolBool(bWasBack, Less_FloatFloat(Outer.aBaseY, float(0)));
	bEdgeLeft = XorXor_BoolBool(bWasLeft, Less_FloatFloat(Outer.aStrafe, float(0)));
	bEdgeRight = XorXor_BoolBool(bWasRight, Greater_FloatFloat(Outer.aStrafe, float(0)));
	bWasForward = Greater_FloatFloat(Outer.aBaseY, float(0));
	bWasBack = Less_FloatFloat(Outer.aBaseY, float(0));
	bWasLeft = Less_FloatFloat(Outer.aStrafe, float(0));
	bWasRight = Greater_FloatFloat(Outer.aStrafe, float(0));
	if(Outer.WantsZoom)
	{
		FOVScale = Multiply_FloatFloat(Outer.ZoomedFOV, 0.0111100);
	}
	else
	{
		FOVScale = Multiply_FloatFloat(Outer.BaseFOV, 0.0111100);
	}
	MouseScale = Multiply_FloatFloat(MouseSensitivity, FOVScale);
	Outer.aMouseX = SmoothMouse(Multiply_FloatFloat(Outer.aMouseX, MouseScale), DeltaTime, Outer.bXAxis, 0);
	Outer.aMouseY = SmoothMouse(Multiply_FloatFloat(Outer.aMouseY, MouseScale), DeltaTime, Outer.bYAxis, 1);
	Outer.aMouseX = AccelerateMouse(Outer.aMouseX);
	Outer.aMouseY = AccelerateMouse(Outer.aMouseY);
	MultiplyEqual_FloatFloat(Outer.aLookUp, FOVScale);
	MultiplyEqual_FloatFloat(Outer.aTurn, FOVScale);
	if(NotEqual_IntInt(int(Outer.bStrafe), 0))
	{
		AddEqual_FloatFloat(Outer.aStrafe, Add_FloatFloat(Multiply_FloatFloat(Outer.aBaseX, 7.5000000), Outer.aMouseX));
	}
	else
	{
		AddEqual_FloatFloat(Outer.aTurn, Add_FloatFloat(Multiply_FloatFloat(Outer.aBaseX, FOVScale), Outer.aMouseX));
	}
	Outer.aBaseX = 0.0000000;
	if(AndAnd_BoolBool(EqualEqual_IntInt(int(Outer.bStrafe), 0), OrOr_BoolBool(Outer.bAlwaysMouseLook, NotEqual_IntInt(int(Outer.bLook), 0))))
	{
		if(bInvertMouse)
		{
			SubtractEqual_FloatFloat(Outer.aLookUp, Outer.aMouseY);
		}
		else
		{
			AddEqual_FloatFloat(Outer.aLookUp, Outer.aMouseY);
		}
	}
	else
	{
		AddEqual_FloatFloat(Outer.aForward, Outer.aMouseY);
	}
	if(NotEqual_IntInt(int(Outer.bSnapLevel), 0))
	{
		Outer.bCenterView = true;
		Outer.bKeyboardLook = false;
	}
	else
	{
		if(NotEqual_FloatFloat(Outer.aLookUp, float(0)))
		{
			Outer.bCenterView = false;
			Outer.bKeyboardLook = true;
		}
		else
		{
			if(AndAnd_BoolBool(Outer.bSnapToLevel, Not_PreBool(Outer.bAlwaysMouseLook)))
			{
				Outer.bCenterView = true;
				Outer.bKeyboardLook = false;
			}
		}
	}
	if(NotEqual_IntInt(int(Outer.bFreeLook), 0))
	{
		Outer.bKeyboardLook = true;
		AddEqual_FloatFloat(Outer.aLookUp, Multiply_FloatFloat(Multiply_FloatFloat(0.5000000, Outer.aBaseY), FOVScale));
	}
	else
	{
		AddEqual_FloatFloat(Outer.aForward, Outer.aBaseY);
	}
	Outer.aBaseY = 0.0000000;
	Outer.HandleWalking();
	return;
}

exec function SetSmoothingMode(byte B)
{
	MouseSmoothingMode = B;
	Log(Concat_StrStr("Smoothing mode ", string(MouseSmoothingMode)));
	return;
}

exec function SetSmoothingStrength(float F)
{
	MouseSmoothingStrength = FClamp(F, 0.0000000, 1.0000000);
	return;
}

function float AccelerateMouse(float aMouse)
{
	local float Accel;

	if(EqualEqual_FloatFloat(Abs(aMouse), float(0)))
	{
		return 0.0000000;
	}
	Accel = Multiply_FloatFloat(MouseAccelThreshold, MouseSensitivity);
	if(Less_FloatFloat(Abs(aMouse), Accel))
	{
		if(Less_FloatFloat(Abs(aMouse), Multiply_FloatFloat(0.1000000, Accel)))
		{
			MultiplyEqual_FloatFloat(aMouse, 0.1000000);
		}
		else
		{
			aMouse = Divide_FloatFloat(Multiply_FloatFloat(aMouse, Abs(aMouse)), Accel);
		}
	}
	return aMouse;
	return;
}

function float SmoothMouse(float aMouse, float DeltaTime, out byte SampleCount, int Index)
{
	local int i, sum;

	if(EqualEqual_IntInt(int(MouseSmoothingMode), 0))
	{
		return aMouse;
	}
	if(EqualEqual_FloatFloat(aMouse, float(0)))
	{
		AddEqual_FloatFloat(ZeroTime[Index], DeltaTime);
		if(Less_FloatFloat(ZeroTime[Index], MouseSamplingTime))
		{
			AddEqual_FloatFloat(SamplingTime[Index], DeltaTime);
			AddEqual_FloatFloat(MaybeTime[Index], DeltaTime);
			aMouse = SmoothedMouse[Index];
		}
		else
		{
			if(AndAnd_BoolBool(bAdjustSampling, Greater_IntInt(MouseSamples[Index], 9)))
			{
				SubtractEqual_FloatFloat(SamplingTime[Index], MaybeTime[Index]);
				MouseSamplingTime = Add_FloatFloat(Multiply_FloatFloat(0.9000000, MouseSamplingTime), Divide_FloatFloat(Multiply_FloatFloat(0.1000000, SamplingTime[Index]), float(MouseSamples[Index])));
			}
			SamplingTime[Index] = 0.0000000;
			SmoothedMouse[Index] = 0.0000000;
			MouseSamples[Index] = 0;
		}
	}
	else
	{
		MaybeTime[Index] = 0.0000000;
		if(NotEqual_FloatFloat(SmoothedMouse[Index], float(0)))
		{
			AddEqual_IntInt(MouseSamples[Index], int(SampleCount));
			if(Greater_FloatFloat(DeltaTime, Multiply_FloatFloat(MouseSamplingTime, float(Add_IntInt(int(SampleCount), 1)))))
			{
				AddEqual_FloatFloat(SamplingTime[Index], Multiply_FloatFloat(MouseSamplingTime, float(SampleCount)));
			}
			else
			{
				AddEqual_FloatFloat(SamplingTime[Index], DeltaTime);
				aMouse = Divide_FloatFloat(Multiply_FloatFloat(aMouse, DeltaTime), Multiply_FloatFloat(MouseSamplingTime, float(SampleCount)));
			}
		}
		else
		{
			SamplingTime[Index] = Multiply_FloatFloat(0.5000000, MouseSamplingTime);
		}
		SmoothedMouse[Index] = Divide_FloatFloat(aMouse, float(SampleCount));
		ZeroTime[Index] = 0.0000000;
	}
	SampleCount = 0;
	if(Greater_IntInt(int(MouseSmoothingMode), 1))
	{
		if(EqualEqual_FloatFloat(aMouse, float(0)))
		{
			i = 0;
			J0x231:

			if(Less_IntInt(i, 3))
			{
				AddEqual_IntInt(sum, int(Multiply_FloatFloat(float(Add_IntInt(i, 1)), 0.1000000)));
				AddEqual_FloatFloat(aMouse, Multiply_FloatFloat(float(sum), OldSamples[i]));
				OldSamples[i] = 0.0000000;
				AddAdd_Int(i);
				// [Loop Continue]
				goto J0x231;
			}
			OldSamples[3] = 0.0000000;
		}
		else
		{
			aMouse = Multiply_FloatFloat(0.4000000, aMouse);
			OldSamples[3] = aMouse;
			i = 0;
			J0x2C5:

			if(Less_IntInt(i, 3))
			{
				AddEqual_FloatFloat(aMouse, Multiply_FloatFloat(Multiply_FloatFloat(float(Add_IntInt(i, 1)), 0.1000000), OldSamples[i]));
				OldSamples[i] = OldSamples[Add_IntInt(i, 1)];
				AddAdd_Int(i);
				// [Loop Continue]
				goto J0x2C5;
			}
		}
	}
	return aMouse;
	return;
}

function UpdateSensitivity(float F)
{
	MouseSensitivity = FMax(0.0000000, F);
	default.MouseSensitivity = MouseSensitivity;
	Class'Engine.PlayerInput'.static.StaticSaveConfig();
	return;
}

function UpdateAccel(float F)
{
	MouseAccelThreshold = FMax(0.0000000, F);
	default.MouseAccelThreshold = MouseAccelThreshold;
	Class'Engine.PlayerInput'.static.StaticSaveConfig();
	return;
}

function UpdateSmoothing(int Mode)
{
	MouseSmoothingMode = byte(Mode);
	default.MouseSmoothingMode = MouseSmoothingMode;
	Class'Engine.PlayerInput'.static.StaticSaveConfig();
	return;
}

function ChangeSnapView(bool B)
{
	Outer.bSnapToLevel = B;
	return;
}

function Actor.EDoubleClickDir CheckForDoubleClickMove(float DeltaTime)
{
	local Actor.EDoubleClickDir DoubleClickMove, OldDoubleClick;

	if(EqualEqual_IntInt(int(Outer.DoubleClickDir), int(5)))
	{
		DoubleClickMove = 5;
	}
	else
	{
		DoubleClickMove = 0;
	}
	if(Greater_FloatFloat(DoubleClickTime, 0.0000000))
	{
		if(EqualEqual_IntInt(int(Outer.DoubleClickDir), int(5)))
		{
			if(AndAnd_BoolBool(NotEqual_ObjectObject(Outer.Pawn, none), EqualEqual_IntInt(int(Outer.Pawn.Physics), int(1))))
			{
				DoubleClickTimer = 0.0000000;
				Outer.DoubleClickDir = 6;
			}
		}
		else
		{
			if(NotEqual_IntInt(int(Outer.DoubleClickDir), int(6)))
			{
				OldDoubleClick = Outer.DoubleClickDir;
				Outer.DoubleClickDir = 0;
				if(AndAnd_BoolBool(bEdgeForward, bWasForward))
				{
					Outer.DoubleClickDir = 3;
				}
				else
				{
					if(AndAnd_BoolBool(bEdgeBack, bWasBack))
					{
						Outer.DoubleClickDir = 4;
					}
					else
					{
						if(AndAnd_BoolBool(bEdgeLeft, bWasLeft))
						{
							Outer.DoubleClickDir = 1;
						}
						else
						{
							if(AndAnd_BoolBool(bEdgeRight, bWasRight))
							{
								Outer.DoubleClickDir = 2;
							}
						}
					}
				}
				if(EqualEqual_IntInt(int(Outer.DoubleClickDir), int(0)))
				{
					Outer.DoubleClickDir = OldDoubleClick;
				}
				else
				{
					if(NotEqual_IntInt(int(Outer.DoubleClickDir), int(OldDoubleClick)))
					{
						DoubleClickTimer = Add_FloatFloat(DoubleClickTime, Multiply_FloatFloat(0.5000000, DeltaTime));
					}
					else
					{
						DoubleClickMove = Outer.DoubleClickDir;
					}
				}
			}
		}
		if(EqualEqual_IntInt(int(Outer.DoubleClickDir), int(6)))
		{
			DoubleClickTimer = FMin(Subtract_FloatFloat(DoubleClickTimer, DeltaTime), 0.0000000);
			if(Less_FloatFloat(DoubleClickTimer, -0.3500000))
			{
				Outer.DoubleClickDir = 0;
				DoubleClickTimer = DoubleClickTime;
			}
		}
		else
		{
			if(AndAnd_BoolBool(NotEqual_IntInt(int(Outer.DoubleClickDir), int(0)), NotEqual_IntInt(int(Outer.DoubleClickDir), int(5))))
			{
				SubtractEqual_FloatFloat(DoubleClickTimer, DeltaTime);
				if(Less_FloatFloat(DoubleClickTimer, float(0)))
				{
					Outer.DoubleClickDir = 0;
					DoubleClickTimer = DoubleClickTime;
				}
			}
		}
	}
	return DoubleClickMove;
	return;
}

defaultproperties
{
	bAdjustSampling=true
	MouseSmoothingMode=1
	MouseSmoothingStrength=0.3000000
	MouseSensitivity=3.0000000
	MouseSamplingTime=0.0083330
	MouseAccelThreshold=100.0000000
	DoubleClickTime=0.2500000
}