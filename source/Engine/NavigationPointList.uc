class NavigationPointList extends Object
	native;

var array<NavigationPoint> NavPointList;

// Export UNavigationPointList::execAdd(FFrame&, void* const)
native final function Add(NavigationPoint NavPoint);

// Export UNavigationPointList::execRemove(FFrame&, void* const)
native final function Remove(NavigationPoint NavPoint);

// Export UNavigationPointList::execEmpty(FFrame&, void* const)
native final function Empty();

// Export UNavigationPointList::execGetIndexOf(FFrame&, void* const)
native final function int GetIndexOf(NavigationPoint NavPoint);

// Export UNavigationPointList::execGetSize(FFrame&, void* const)
native final function int GetSize();

// Export UNavigationPointList::execGetEntryAt(FFrame&, void* const)
native final function NavigationPoint GetEntryAt(int Index);

// Export UNavigationPointList::execContains(FFrame&, void* const)
native final function bool Contains(NavigationPoint Point);

event NavigationPoint GetRandomEntry()
{
	return NavPointList[Rand(NavPointList.Length)];
	return;
}
