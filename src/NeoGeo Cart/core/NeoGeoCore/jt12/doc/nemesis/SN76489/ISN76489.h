#ifndef __ISN76489_H__
#define __ISN76489_H__
#include "GenericAccess/GenericAccess.pkg"
#include <string>

class ISN76489 :public virtual IGenericAccess
{
public:
	//Constants
	static const unsigned int channelCount = 4;
	static const unsigned int noiseChannelNo = 3;
	static const unsigned int toneRegisterBitCount = 10;
	static const unsigned int volumeRegisterBitCount = 4;
	static const unsigned int noiseRegisterBitCount = 3;

	//Enumerations
	enum class ISN76489DataSource;

public:
	//Interface version functions
	static inline unsigned int ThisISN76489Version() { return 1; }
	virtual unsigned int GetISN76489Version() const = 0;

	//Raw register functions
	inline unsigned int GetVolumeRegisterExternal(unsigned int channelNo) const;
	inline void SetVolumeRegisterExternal(unsigned int channelNo, unsigned int adata);
	inline unsigned int GetToneRegisterExternal(unsigned int channelNo) const;
	inline void SetToneRegisterExternal(unsigned int channelNo, unsigned int adata);
	inline unsigned int GetNoiseShiftRegisterExternal() const;
	inline void SetNoiseShiftRegisterExternal(unsigned int adata);

	//Latched register functions
	inline unsigned int GetLatchedChannelNoExternal() const;
	inline void SetLatchedChannelNoExternal(unsigned int adata);
	inline bool GetVolumeRegisterLatchedExternal() const;
	inline void SetVolumeRegisterLatchedExternal(bool adata);

	//Device property functions
	inline double GetExternalClockRate() const;
	inline void SetExternalClockRate(double adata);
	inline double GetExternalClockDivider() const;
	inline void SetExternalClockDivider(double adata);
	inline unsigned int GetShiftRegisterBitCount() const;
	inline void SetShiftRegisterBitCount(unsigned int adata);
	inline unsigned int GetShiftRegisterDefaultValue() const;
	inline void SetShiftRegisterDefaultValue(unsigned int adata);
	inline unsigned int GetNoiseChannelWhiteNoiseTappedBitMask() const;
	inline void SetNoiseChannelWhiteNoiseTappedBitMask(unsigned int adata);
	inline unsigned int GetNoiseChannelPeriodicNoiseTappedBitMask() const;
	inline void SetNoiseChannelPeriodicNoiseTappedBitMask(unsigned int adata);

	//Audio logging functions
	inline bool IsAudioLoggingEnabled() const;
	inline void SetAudioLoggingEnabled(bool adata);
	inline bool IsChannelAudioLoggingEnabled(unsigned int channelNo) const;
	inline void SetChannelAudioLoggingEnabled(unsigned int channelNo, bool adata);
	inline std::wstring GetAudioLoggingOutputPath() const;
	inline void SetAudioLoggingOutputPath(const std::wstring& adata);
	inline std::wstring GetChannelAudioLoggingOutputPath(unsigned int channelNo) const;
	inline void SetChannelAudioLoggingOutputPath(unsigned int channelNo, const std::wstring& adata);
};

#include "ISN76489.inl"
#endif
