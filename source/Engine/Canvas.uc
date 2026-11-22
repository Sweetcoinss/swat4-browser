class Canvas extends Object
	native
	noexport;

var const Font DefaultFont;
var Font Font;
var float SpaceX;
var float SpaceY;
var float OrgX;
var float OrgY;
var float ClipX;
var float ClipY;
var float CurX;
var float CurY;
var float Z;
var byte Style;
var float CurYL;
var Color DrawColor;
var bool bCenter;
var bool bNoSmooth;
var const int SizeX;
var const int SizeY;
var const Font TinyFont;
var const Font SmallFont;
var const Font MedFont;
var string DefaultFontName;
var string TinyFontName;
var string SmallFontName;
var string MedFontName;
var Texture WhiteTex;
var const Viewport Viewport;
var const int pCanvasUtil;

// Export UCanvas::execStrLen(FFrame&, void* const)
native(464) final function StrLen(coerce string String, out float XL, out float YL);

// Export UCanvas::execDrawText(FFrame&, void* const)
native(465) final function DrawText(coerce string Text, optional bool CR);

// Export UCanvas::execDrawTile(FFrame&, void* const)
native(466) final function DrawTile(Material Mat, float XL, float YL, float U, float V, float UL, float VL);

// Export UCanvas::execDrawActor(FFrame&, void* const)
native(467) final function DrawActor(Actor A, bool Wireframe, optional bool ClearZ, optional float DisplayFOV);

// Export UCanvas::execDrawTileClipped(FFrame&, void* const)
native(468) final function DrawTileClipped(Material Mat, float XL, float YL, float U, float V, float UL, float VL);

// Export UCanvas::execDrawTextClipped(FFrame&, void* const)
native(469) final function DrawTextClipped(coerce string Text, optional bool bCheckHotKey);

// Export UCanvas::execTextSize(FFrame&, void* const)
native(470) final function TextSize(coerce string String, out float XL, out float YL);

// Export UCanvas::execDrawPortal(FFrame&, void* const)
native(480) final function DrawPortal(int X, int Y, int Width, int Height, Actor CamActor, Vector CamLocation, Rotator CamRotation, optional int FOV, optional bool ClearZ);

// Export UCanvas::execWrapStringToArray(FFrame&, void* const)
native final function WrapStringToArray(string Text, out array<string> OutArray, float dx, string EOL, optional bool bIsCodedString);

// Export UCanvas::execDrawTileStretched(FFrame&, void* const)
native final function DrawTileStretched(Material Mat, float XL, float YL);

// Export UCanvas::execDrawTileJustified(FFrame&, void* const)
native final function DrawTileJustified(Material Mat, byte Justification, float XL, float YL);

// Export UCanvas::execDrawTileScaled(FFrame&, void* const)
native final function DrawTileScaled(Material Mat, float XScale, float YScale);

// Export UCanvas::execDrawTextJustified(FFrame&, void* const)
native final function DrawTextJustified(coerce string String, byte Justification, float x1, float y1, float x2, float y2);

// Export UCanvas::execDrawTextMultiline(FFrame&, void* const)
native final function DrawTextMultiline(coerce string Text, Vector Origin2D, Color ForegroundColor, optional Color BackgroundColor, optional bool Wrapped, optional bool Centered);

event Reset()
{
	Font = DefaultFont;
	SpaceX = default.SpaceX;
	SpaceY = default.SpaceY;
	OrgX = default.OrgX;
	OrgY = default.OrgY;
	CurX = default.CurX;
	CurY = default.CurY;
	Style = default.Style;
	DrawColor = default.DrawColor;
	CurYL = default.CurYL;
	bCenter = false;
	bNoSmooth = false;
	Z = 1.0000000;
	return;
}

final function SetPos(float X, float Y)
{
	CurX = X;
	CurY = Y;
	return;
}

final function SetOrigin(float X, float Y)
{
	OrgX = X;
	OrgY = Y;
	return;
}

final function SetClip(float X, float Y)
{
	ClipX = X;
	ClipY = Y;
	return;
}

final function DrawPattern(Material Tex, float XL, float YL, float Scale)
{
	DrawTile(Tex, XL, YL, Multiply_FloatFloat(Subtract_FloatFloat(CurX, OrgX), Scale), Multiply_FloatFloat(Subtract_FloatFloat(CurY, OrgY), Scale), Multiply_FloatFloat(XL, Scale), Multiply_FloatFloat(YL, Scale));
	return;
}

final function DrawIcon(Texture Tex, float Scale)
{
	if(NotEqual_ObjectObject(Tex, none))
	{
		DrawTile(Tex, Multiply_FloatFloat(float(Tex.USize), Scale), Multiply_FloatFloat(float(Tex.VSize), Scale), 0.0000000, 0.0000000, float(Tex.USize), float(Tex.VSize));
	}
	return;
}

final function DrawRect(Texture Tex, float RectX, float RectY)
{
	DrawTile(Tex, RectX, RectY, 0.0000000, 0.0000000, float(Tex.USize), float(Tex.VSize));
	return;
}

final function SetDrawColor(byte R, byte G, byte B, optional byte A)
{
	local Color C;

	C.R = R;
	C.G = G;
	C.B = B;
	if(EqualEqual_IntInt(int(A), 0))
	{
		A = byte(255);
	}
	C.A = A;
	DrawColor = C;
	return;
}

static final function Color MakeColor(byte R, byte G, byte B, optional byte A)
{
	local Color C;

	C.R = R;
	C.G = G;
	C.B = B;
	if(EqualEqual_IntInt(int(A), 0))
	{
		A = byte(255);
	}
	C.A = A;
	return C;
	return;
}

final function DrawVertical(float X, float Height)
{
	SetPos(X, CurY);
	DrawRect(WhiteTex, 2.0000000, Height);
	return;
}

final function DrawHorizontal(float Y, float Width)
{
	SetPos(CurX, Y);
	DrawRect(WhiteTex, Width, 2.0000000);
	return;
}

final function DrawLine(int direction, float Size)
{
	local float X, Y;

	X = CurX;
	Y = CurY;
	switch(direction)
	{
		case 0:
			SetPos(X, Subtract_FloatFloat(Y, Size));
			DrawRect(WhiteTex, 2.0000000, Size);
			break;
		case 1:
			DrawRect(WhiteTex, 2.0000000, Size);
			break;
		case 2:
			SetPos(Subtract_FloatFloat(X, Size), Y);
			DrawRect(WhiteTex, Size, 2.0000000);
			break;
		case 3:
			DrawRect(WhiteTex, Size, 2.0000000);
			break;
		default:
			break;
	}
	SetPos(X, Y);
	return;
}

final simulated function DrawBracket(float Width, float Height, float bracket_size)
{
	local float X, Y;

	X = CurX;
	Y = CurY;
	Width = float(Max(int(Width), 5));
	Height = float(Max(int(Height), 5));
	DrawLine(3, bracket_size);
	DrawLine(1, bracket_size);
	SetPos(Add_FloatFloat(X, Width), Y);
	DrawLine(2, bracket_size);
	DrawLine(1, bracket_size);
	SetPos(Add_FloatFloat(X, Width), Add_FloatFloat(Y, Height));
	DrawLine(0, bracket_size);
	DrawLine(2, bracket_size);
	SetPos(X, Add_FloatFloat(Y, Height));
	DrawLine(3, bracket_size);
	DrawLine(0, bracket_size);
	SetPos(X, Y);
	return;
}

final simulated function DrawBox(Canvas Canvas, float Width, float Height)
{
	local float X, Y;

	X = Canvas.CurX;
	Y = Canvas.CurY;
	Canvas.DrawRect(WhiteTex, 2.0000000, Height);
	Canvas.DrawRect(WhiteTex, Width, 2.0000000);
	Canvas.SetPos(Add_FloatFloat(X, Width), Y);
	Canvas.DrawRect(WhiteTex, 2.0000000, Height);
	Canvas.SetPos(X, Add_FloatFloat(Y, Height));
	Canvas.DrawRect(WhiteTex, Add_FloatFloat(Width, float(1)), 2.0000000);
	Canvas.SetPos(X, Y);
	return;
}

defaultproperties
{
	Z=1.0000000
	Style=1
	DrawColor=(R=127,G=127,B=127,A=255)
	DefaultFontName="Engine_res.Res_DefaultFont"
	TinyFontName="Engine_res.Res_DefaultFont"
	SmallFontName="Engine_res.Res_DefaultFont"
	MedFontName="Engine_res.Res_DefaultFont"
	WhiteTex=Texture'Engine_res.WhiteSquareTexture'
}