class BufferedTCPLink extends TcpLink
	transient
	config
	hidecategories(Karma,Movement,Collision,Lighting,LightColor,Karma,Force);

var string InputBuffer;
var string OutputBuffer;
var string CRLF;
var string CR;
var string LF;
var bool bWaiting;
var float WaitTimeoutTime;
var string WaitingFor;
var int WaitForCountChars;
var string WaitResult;
var int WaitMatchData;

function ResetBuffer()
{
	InputBuffer = "";
	OutputBuffer = "";
	bWaiting = false;
	CRLF = Concat_StrStr(Chr(10), Chr(13));
	CR = Chr(13);
	LF = Chr(10);
	return;
}

function WaitFor(string What, float TimeOut, int MatchData)
{
	bWaiting = true;
	WaitingFor = What;
	WaitForCountChars = 0;
	WaitTimeoutTime = Add_FloatFloat(Level.TimeSeconds, TimeOut);
	WaitMatchData = MatchData;
	WaitResult = "";
	return;
}

function WaitForCount(int Count, float TimeOut, int MatchData)
{
	bWaiting = true;
	WaitingFor = "";
	WaitForCountChars = Count;
	WaitTimeoutTime = Add_FloatFloat(Level.TimeSeconds, TimeOut);
	WaitMatchData = MatchData;
	WaitResult = "";
	return;
}

function GotMatch(int MatchData)
{
	return;
}

function GotMatchTimeout(int MatchData)
{
	return;
}

function string ParseDelimited(string Text, string Delimiter, int Count, optional bool bToEndOfLine)
{
	local string Result;
	local int Found, i;
	local string S;

	Result = "";
	Found = 1;
	i = 0;
	J0x16:

	if(Less_IntInt(i, Len(Text)))
	{
		S = Mid(Text, i, 1);
		if(NotEqual_IntInt(InStr(Delimiter, S), -1))
		{
			if(EqualEqual_IntInt(Found, Count))
			{
				if(bToEndOfLine)
				{
					return Concat_StrStr(Result, Mid(Text, i));
				}
				else
				{
					return Result;
				}
			}
			AddAdd_Int(Found);
			// [Explicit Continue]
			goto J0xB0;
		}
		if(GreaterEqual_IntInt(Found, Count))
		{
			Result = Concat_StrStr(Result, S);
		}
		J0xB0:

		AddAdd_Int(i);
		// [Loop Continue]
		goto J0x16;
	}
	return Result;
	return;
}

function int ReadChar()
{
	local int C;

	if(EqualEqual_StrStr(InputBuffer, ""))
	{
		return 0;
	}
	C = Asc(Left(InputBuffer, 1));
	InputBuffer = Mid(InputBuffer, 1);
	return C;
	return;
}

function int PeekChar()
{
	if(EqualEqual_StrStr(InputBuffer, ""))
	{
		return 0;
	}
	return Asc(Left(InputBuffer, 1));
	return;
}

function bool ReadBufferedLine(out string Text)
{
	local int i;

	i = InStr(InputBuffer, Chr(13));
	if(EqualEqual_IntInt(i, -1))
	{
		return false;
	}
	Text = Left(InputBuffer, i);
	if(EqualEqual_StrStr(Mid(InputBuffer, Add_IntInt(i, 1), 1), Chr(10)))
	{
		AddAdd_Int(i);
	}
	InputBuffer = Mid(InputBuffer, Add_IntInt(i, 1));
	return true;
	return;
}

function SendBufferedData(string Text)
{
	OutputBuffer = Concat_StrStr(OutputBuffer, Text);
	return;
}

event ReceivedText(string Text)
{
	InputBuffer = Concat_StrStr(InputBuffer, Text);
	return;
}

function DoBufferQueueIO()
{
	local int i;

	J0x00:
	if(bWaiting)
	{
		if(Greater_FloatFloat(Level.TimeSeconds, WaitTimeoutTime))
		{
			bWaiting = false;
			GotMatchTimeout(WaitMatchData);
		}
		if(Greater_IntInt(WaitForCountChars, 0))
		{
			if(Less_IntInt(Len(InputBuffer), WaitForCountChars))
			{
				// [Explicit Break]
				goto J0x132;
			}
			WaitResult = Left(InputBuffer, WaitForCountChars);
			InputBuffer = Mid(InputBuffer, WaitForCountChars);
			bWaiting = false;
			GotMatch(WaitMatchData);
		}
		else
		{
			i = InStr(InputBuffer, WaitingFor);
			if(AndAnd_BoolBool(EqualEqual_IntInt(i, -1), EqualEqual_StrStr(WaitingFor, CR)))
			{
				i = InStr(InputBuffer, LF);
			}
			if(NotEqual_IntInt(i, -1))
			{
				WaitResult = Left(InputBuffer, Add_IntInt(i, Len(WaitingFor)));
				InputBuffer = Mid(InputBuffer, Add_IntInt(i, Len(WaitingFor)));
				bWaiting = false;
				GotMatch(WaitMatchData);
			}
			else
			{
				// [Explicit Break]
				goto J0x132;
			}
		}
		// [Loop Continue]
		goto J0x00;
	}
	J0x132:

	if(IsConnected())
	{
		if(NotEqual_StrStr(OutputBuffer, ""))
		{
			i = SendText(OutputBuffer);
			OutputBuffer = Mid(OutputBuffer, i);
		}
	}
	return;
}

defaultproperties
{
	ReceiveMode=1
}