class SwatConnectionFailureMenu extends SwatGUIPage
	config(SwatGui)
	perobjectconfig
	instanced
	hidecategories(Menu,Object,Menu,Object,Menu,Object);

var(SwatGui) private export editinline config GUILabel MyErrorLabel;
var(SwatGui) private export editinline config GUIButton MyOKButton;
var private config localized string ConnectionFailed;
var private config localized string NetworkingFailed;
var private config localized string UrlFailed;
var private config localized string ConnectionTimeOut;
var private config localized string RejectedByServer;
var private config localized string CDKeyFailed;
var private config localized string DemoLoadFailed;
var private config localized string ConfigMD5ChecksumFailure;
var private config localized string ConfigMD5ChecksumCountFailure;
var private config localized string PackageMD5ChecksumFailure;
var private config localized string GenericFailure;

function InitComponent(GUIComponent MyOwner)
{
	super.InitComponent(MyOwner);
	MyOKButton.__OnClick__Delegate = InternalOnClick;
	return;
}

event HandleParameters(string Param1, string Param2, optional int param3)
{
	if(EqualEqual_StrStr(Param1, "ConnectionFailed"))
	{
		if(EqualEqual_StrStr(Param2, "CDKeyFailed"))
		{
			MyErrorLabel.SetCaption(CDKeyFailed);
		}
		else
		{
			MyErrorLabel.SetCaption(ConnectionFailed);
		}
	}
	else
	{
		if(EqualEqual_StrStr(Param1, "DemoLoadFailed"))
		{
			MyErrorLabel.SetCaption(FormatTextString(DemoLoadFailed, Param2));
		}
		else
		{
			if(EqualEqual_StrStr(Param1, "Networking Failed"))
			{
				MyErrorLabel.SetCaption(NetworkingFailed);
			}
			else
			{
				if(EqualEqual_StrStr(Param1, "UrlFailed"))
				{
					if(NotEqual_IntInt(InStr(Param2, "Index.s4m"), -1))
					{
						MyErrorLabel.SetCaption(ConnectionFailed);
					}
					else
					{
						MyErrorLabel.SetCaption(FormatTextString(UrlFailed, Param2));
					}
				}
				else
				{
					if(EqualEqual_StrStr(Param1, "ConnectingText"))
					{
						MyErrorLabel.SetCaption(ConnectionTimeOut);
					}
					else
					{
						if(EqualEqual_StrStr(Param1, "Rejected By Server"))
						{
							MyErrorLabel.SetCaption(Param2);
						}
						else
						{
							if(EqualEqual_StrStr(Param1, "ConfigMD5ChecksumFailed"))
							{
								MyErrorLabel.SetCaption(FormatTextString(ConfigMD5ChecksumFailure, Param2));
							}
							else
							{
								if(EqualEqual_StrStr(Param1, "ConfigMD5ChecksumCountFailed"))
								{
									MyErrorLabel.SetCaption(ConfigMD5ChecksumCountFailure);
								}
								else
								{
									if(EqualEqual_StrStr(Param1, "PackageMD5ChecksumFailed"))
									{
										MyErrorLabel.SetCaption(PackageMD5ChecksumFailure);
									}
									else
									{
										if(EqualEqual_StrStr(Param1, "GenericFailure"))
										{
											MyErrorLabel.SetCaption(GenericFailure);
										}
										else
										{
											MyErrorLabel.SetCaption(GenericFailure);
										}
									}
								}
							}
						}
					}
				}
			}
		}
	}
	return;
}

function InternalOnClick(GUIComponent Sender)
{
	switch(Sender)
	{
		case MyOKButton:
			PerformClose();
			break;
		default:
			break;
	}
	return;
}

function PerformClose()
{
	SwatGUIController(Controller).FailedConnectionAccepted();
	return;
}

defaultproperties
{
	ConnectionFailed="The connection to the server has failed."
	NetworkingFailed="The network connection has failed."
	UrlFailed="Error: %1"
	ConnectionTimeOut="The connection to the server has timed out."
	RejectedByServer="The connection to the server was rejected."
	CDKeyFailed="CD Key authentication has failed."
	DemoLoadFailed="Invalid demo map: '%1'"
	ConfigMD5ChecksumFailure="File is incompatible with the version on the server: '%1'"
	ConfigMD5ChecksumCountFailure="Connection to server rejected (unexpected number of configuration files)."
	PackageMD5ChecksumFailure="Connection to server rejected (invalid content)."
	GenericFailure="The connection to the server has failed."
}