#include "DeviceInterface/DeviceInterface.pkg"
#include "YM2612.h"

IDevice* GetYM2612(const wchar_t* implementationName, const wchar_t* instanceName, unsigned int moduleID)
{
	return static_cast<IDevice*>(new YM2612(implementationName, instanceName, moduleID));
}

void DeleteYM2612(IDevice* device)
{
	delete static_cast<YM2612*>(device);
}

#ifdef EX_DLLINTERFACE
extern "C" __declspec(dllexport) unsigned int GetInterfaceVersion()
{
	return EXODUS_INTERFACEVERSION;
}

extern "C" __declspec(dllexport) bool GetDeviceEntry(unsigned int entryNo, IDeviceInfo& entry)
{
	//Retrieve any required information from the version info table for our plugin
	std::wstring copyrightText;
	std::wstring commentsText;
	HMODULE moduleHandle = NULL;
	BOOL getModuleHandleExReturn = GetModuleHandleEx(GET_MODULE_HANDLE_EX_FLAG_FROM_ADDRESS | GET_MODULE_HANDLE_EX_FLAG_UNCHANGED_REFCOUNT, (LPCWSTR)GetDeviceEntry, &moduleHandle);
	if(getModuleHandleExReturn != 0)
	{
		std::wstring modulePath = GetModuleFilePath(moduleHandle);
		GetModuleVersionInfoString(modulePath, VERSIONINFOPROPERTY_LEGALCOPYRIGHT, copyrightText);
		GetModuleVersionInfoString(modulePath, VERSIONINFOPROPERTY_COMMENTS, commentsText);
	}

	switch(entryNo)
	{
	case 0:
		entry.SetDeviceSettings(GetYM2612, DeleteYM2612, L"Audio.YM2612", L"YM2612", 1, copyrightText, commentsText);
		return true;
	}
	return false;
}
#endif
