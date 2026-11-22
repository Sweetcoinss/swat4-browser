class RefCount extends Object
	native
	noexport;

var private const int m_RefCount;

// Export URefCount::execAddRef(FFrame&, void* const)
native(199) final function int AddRef();

// Export URefCount::execRelease(FFrame&, void* const)
native(198) final function int Release();
