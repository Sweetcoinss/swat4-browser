class PerlinNoise extends DeleteableObject
	native;

cpptext
{
    //Constructor
    UPerlinNoise::UPerlinNoise();

    //Overridden from UObject, called via the destructor implemented in this
    //  class's DECLARE_CLASS macro.
	virtual void Destroy();

    class FPerlinNoise* Generator;

}

var private const noexport transient int Generator;

// Export UPerlinNoise::execNoise1(FFrame&, void* const)
native function float Noise1(float X);

// Export UPerlinNoise::execNoise2(FFrame&, void* const)
native function float Noise2(float X, float Y);

// Export UPerlinNoise::execNoise3(FFrame&, void* const)
native function float Noise3(float X, float Y, float Z);

// Export UPerlinNoise::execReinitialize(FFrame&, void* const)
native function Reinitialize();
