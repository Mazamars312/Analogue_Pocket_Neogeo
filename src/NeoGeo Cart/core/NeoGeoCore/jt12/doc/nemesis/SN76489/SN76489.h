/*--------------------------------------------------------------------------------------*\
Description:
This core emulates the SN76489 Programmable Sound Generator (PSG), and is designed to
produce a sample-accurate output. Each channel is generated and mixed at the correct
internal sample rate, and all known aspects and behaviour of this device are faithfully
emulated.

Things to do:
-Get a final answer on the conversion from attenuation to linear power, and document it
within your core.
-Make it possible to define the clock and noise register settings externally

Output filtering:
-Note that there is real "decay-like" behaviour, which comes from the audio output
circuitry in the Mega Drive. The same circuit affects the output of the YM2612 in the
same way. If we want to emulate this behaviour, we need to emulate it using a form of
audio filter which can be applied to any sound core, just like we need to emulate analog
video distortion using output filters. These filters need to be separate from the device
cores, and be modular and chainable. Note that we should also use output "filters" to
balance output levels between sound devices.
-Measure the final audio output levels from the embedded SN76489 in the Mega Drive, both
directly from the chip and after the mixing circuit. According to SN76489.txt, several of
the minimum attenuation levels may in fact be clipped, which will greatly affect the
overall volume of the PSG, and the relative volume levels of the different register
settings on the system.

Debug output modifications:
-Add the calculated frequency, and attenuation in db, for each channel, on the register
debug window.
-Display the noise register using its actual separate register values, named correctly,
on the register debug window.

References:
-SN76489 Notes (SN76489.txt), Maxim, 2005
-Genesis Sound Software Manual, Sega Enterprises, 1992, scans by antime
-SN76489 Datasheet, Texas Instruments
-SN76494 Datasheet, Texas Instruments
-SN76489 sound chip details, John Kortink, http://web.inter.nl.net/users/J.Kortink/home/articles/sn76489/index.htm
\*--------------------------------------------------------------------------------------*/
#include "ISN76489.h"
#ifndef __SN76489_H__
#define __SN76489_H__
#include "DeviceInterface/DeviceInterface.pkg"
#include "TimedBuffers/TimedBuffers.pkg"
#include <vector>
#include <map>
#include <set>
#include <list>
#include "Device/Device.pkg"
#include "AudioStream/AudioStream.pkg"
#include "Stream/Stream.pkg"
#include <mutex>
#include <condition_variable>

class SN76489 :public Device, public GenericAccessBase<ISN76489>
{
public:
	//Constructors
	SN76489(const std::wstring& aimplementationName, const std::wstring& ainstanceName, unsigned int amoduleID);

	//Interface version functions
	virtual unsigned int GetISN76489Version() const;

	//Initialization functions
	virtual bool BuildDevice();
	virtual bool ValidateDevice();
	virtual void Initialize();

	//Clock source functions
	virtual unsigned int GetClockSourceID(const MarshalSupport::Marshal::In<std::wstring>& clockSourceName) const;
	virtual MarshalSupport::Marshal::Ret<std::wstring> GetClockSourceName(unsigned int clockSourceID) const;
	virtual void SetClockSourceRate(unsigned int clockInput, double clockRate, IDeviceContext* caller, double accessTime, unsigned int accessContext);
	virtual void TransparentSetClockSourceRate(unsigned int clockInput, double clockRate);

	//Execute functions
	virtual void BeginExecution();
	virtual void SuspendExecution();
	virtual bool SendNotifyUpcomingTimeslice() const;
	virtual void NotifyUpcomingTimeslice(double nanoseconds);
	virtual UpdateMethod GetUpdateMethod() const;
	virtual void ExecuteTimeslice(double nanoseconds);
	virtual void ExecuteRollback();
	virtual void ExecuteCommit();

	//Memory interface functions
	virtual IBusInterface::AccessResult WriteInterface(unsigned int interfaceNumber, unsigned int location, const Data& data, IDeviceContext* caller, double accessTime, unsigned int accessContext);

	//Savestate functions
	virtual void LoadState(IHierarchicalStorageNode& node);
	virtual void SaveState(IHierarchicalStorageNode& node) const;
	virtual void LoadDebuggerState(IHierarchicalStorageNode& node);
	virtual void SaveDebuggerState(IHierarchicalStorageNode& node) const;

	//Data read/write functions
	virtual bool ReadGenericData(unsigned int dataID, const DataContext* dataContext, IGenericAccessDataValue& dataValue) const;
	virtual bool WriteGenericData(unsigned int dataID, const DataContext* dataContext, IGenericAccessDataValue& dataValue);

	//Data locking functions
	virtual bool GetGenericDataLocked(unsigned int dataID, const DataContext* dataContext) const;
	virtual bool SetGenericDataLocked(unsigned int dataID, const DataContext* dataContext, bool state);

private:
	//Enumerations
	enum class ClockID;

	//Structures
	struct ChannelRenderData
	{
		unsigned int initialToneCycles;
		unsigned int remainingToneCycles;
		bool polarityNegative;
	};

	//Typedefs
	typedef RandomTimeAccessBuffer<Data, double>::AccessTarget AccessTarget;

private:
	//Render functions
	void RenderThread();
	void UpdateChannel(unsigned int channelNo, unsigned int outputSampleCount, std::vector<float>& outputBuffer);

	//Raw register functions
	inline Data GetVolumeRegister(unsigned int channelNo, const AccessTarget& accessTarget) const;
	inline void SetVolumeRegister(unsigned int channelNo, const Data& adata, const AccessTarget& accessTarget);
	inline Data GetToneRegister(unsigned int channelNo, const AccessTarget& accessTarget) const;
	inline void SetToneRegister(unsigned int channelNo, const Data& adata, const AccessTarget& accessTarget);

	//Audio logging functions
	void SetAudioLoggingEnabled(bool state);
	void SetChannelAudioLoggingEnabled(unsigned int channelNo, bool state);

private:
	//Registers
	mutable std::mutex accessMutex;
	double lastAccessTime;
	RandomTimeAccessBuffer<Data, double> reg;
	unsigned int latchedChannel;
	unsigned int blatchedChannel;
	bool latchedVolume;
	bool blatchedVolume;

	//Render thread properties
	mutable std::mutex renderThreadMutex;
	mutable std::mutex timesliceMutex;
	std::condition_variable renderThreadUpdate;
	std::condition_variable renderThreadStopped;
	bool renderThreadActive;
	static const unsigned int maxPendingRenderOperationCount = 4;
	bool renderThreadLagging;
	std::condition_variable renderThreadLaggingStateChange;
	unsigned int pendingRenderOperationCount;
	std::list<RandomTimeAccessBuffer<Data, double>::Timeslice> regTimesliceList;
	std::list<RandomTimeAccessBuffer<Data, double>::Timeslice> regTimesliceListUncommitted;
	double remainingRenderTime;
	unsigned int outputSampleRate;
	AudioStream outputStream;
	std::vector<short> outputBuffer;

	//Render data
	ChannelRenderData channelRenderData[channelCount];
	unsigned int noiseShiftRegister;
	bool noiseOutputMasked;

	//Device Properties
	double externalClockRate;
	double externalClockDivider;
	unsigned int shiftRegisterBitCount;
	unsigned int shiftRegisterDefaultValue;
	unsigned int noiseWhiteTappedBitMask;
	unsigned int noisePeriodicTappedBitMask;
	std::list<GenericAccessDataInfo*> genericDataToUpdateOnShiftRegisterBitCountChange;

	//Register locking
	bool channelVolumeRegisterLocked[channelCount];
	bool channelDataRegisterLocked[channelCount];
	bool noiseChannelTypeLocked;
	bool noiseChannelPeriodLocked;

	//Wave logging
	mutable std::mutex waveLoggingMutex;
	bool wavLoggingEnabled;
	bool wavLoggingChannelEnabled[channelCount];
	std::wstring wavLoggingPath;
	std::wstring wavLoggingChannelPath[channelCount];
	Stream::WAVFile wavLog;
	Stream::WAVFile wavLogChannel[channelCount];
};

#include "SN76489.inl"
#endif
