//----------------------------------------------------------------------------------------
//Enumerations
//----------------------------------------------------------------------------------------
enum class ISN76489::ISN76489DataSource
{
	Channel1VolumeRegister = 1,
	Channel2VolumeRegister,
	Channel3VolumeRegister,
	Channel4VolumeRegister,
	Channel1ToneRegister,
	Channel2ToneRegister,
	Channel3ToneRegister,
	Channel4ToneRegister,
	Channel4NoiseType,
	Channel4NoisePeriod,
	NoiseShiftRegister,
	LatchedChannelNo,
	VolumeRegisterLatched,
	ExternalClockRate,
	ExternalClockDivider,
	ShiftRegisterBitCount,
	ShiftRegisterDefaultValue,
	WhiteNoiseTappedBitMask,
	PeriodicNoiseTappedBitMask,
	AudioLoggingEnabled,
	AudioLoggingPath,
	Channel1AudioLoggingEnabled,
	Channel2AudioLoggingEnabled,
	Channel3AudioLoggingEnabled,
	Channel4AudioLoggingEnabled,
	Channel1AudioLoggingPath,
	Channel2AudioLoggingPath,
	Channel3AudioLoggingPath,
	Channel4AudioLoggingPath
};

//----------------------------------------------------------------------------------------
//Raw register functions
//----------------------------------------------------------------------------------------
unsigned int ISN76489::GetVolumeRegisterExternal(unsigned int channelNo) const
{
	GenericAccessDataValueUInt data;
	ReadGenericData((unsigned int)ISN76489DataSource::Channel1VolumeRegister + channelNo, 0, data);
	return data.GetValue();
}

//----------------------------------------------------------------------------------------
void ISN76489::SetVolumeRegisterExternal(unsigned int channelNo, unsigned int adata)
{
	GenericAccessDataValueUInt data(adata);
	WriteGenericData((unsigned int)ISN76489DataSource::Channel1VolumeRegister + channelNo, 0, data);
}

//----------------------------------------------------------------------------------------
unsigned int ISN76489::GetToneRegisterExternal(unsigned int channelNo) const
{
	GenericAccessDataValueUInt data;
	ReadGenericData((unsigned int)ISN76489DataSource::Channel1ToneRegister + channelNo, 0, data);
	return data.GetValue();
}

//----------------------------------------------------------------------------------------
void ISN76489::SetToneRegisterExternal(unsigned int channelNo, unsigned int adata)
{
	GenericAccessDataValueUInt data(adata);
	WriteGenericData((unsigned int)ISN76489DataSource::Channel1ToneRegister + channelNo, 0, data);
}

//----------------------------------------------------------------------------------------
unsigned int ISN76489::GetNoiseShiftRegisterExternal() const
{
	GenericAccessDataValueUInt data;
	ReadGenericData((unsigned int)ISN76489DataSource::NoiseShiftRegister, 0, data);
	return data.GetValue();
}

//----------------------------------------------------------------------------------------
void ISN76489::SetNoiseShiftRegisterExternal(unsigned int adata)
{
	GenericAccessDataValueUInt data(adata);
	WriteGenericData((unsigned int)ISN76489DataSource::NoiseShiftRegister, 0, data);
}

//----------------------------------------------------------------------------------------
//Latched register functions
//----------------------------------------------------------------------------------------
unsigned int ISN76489::GetLatchedChannelNoExternal() const
{
	GenericAccessDataValueUInt data;
	ReadGenericData((unsigned int)ISN76489DataSource::LatchedChannelNo, 0, data);
	return data.GetValue();
}

//----------------------------------------------------------------------------------------
void ISN76489::SetLatchedChannelNoExternal(unsigned int adata)
{
	GenericAccessDataValueUInt data(adata);
	WriteGenericData((unsigned int)ISN76489DataSource::LatchedChannelNo, 0, data);
}

//----------------------------------------------------------------------------------------
bool ISN76489::GetVolumeRegisterLatchedExternal() const
{
	GenericAccessDataValueBool data;
	ReadGenericData((unsigned int)ISN76489DataSource::VolumeRegisterLatched, 0, data);
	return data.GetValue();
}

//----------------------------------------------------------------------------------------
void ISN76489::SetVolumeRegisterLatchedExternal(bool adata)
{
	GenericAccessDataValueBool data(adata);
	WriteGenericData((unsigned int)ISN76489DataSource::VolumeRegisterLatched, 0, data);
}

//----------------------------------------------------------------------------------------
//Device property functions
//----------------------------------------------------------------------------------------
double ISN76489::GetExternalClockRate() const
{
	GenericAccessDataValueDouble data;
	ReadGenericData((unsigned int)ISN76489DataSource::ExternalClockRate, 0, data);
	return data.GetValue();
}

//----------------------------------------------------------------------------------------
void ISN76489::SetExternalClockRate(double adata)
{
	GenericAccessDataValueDouble data(adata);
	WriteGenericData((unsigned int)ISN76489DataSource::ExternalClockRate, 0, data);
}

//----------------------------------------------------------------------------------------
double ISN76489::GetExternalClockDivider() const
{
	GenericAccessDataValueDouble data;
	ReadGenericData((unsigned int)ISN76489DataSource::ExternalClockDivider, 0, data);
	return data.GetValue();
}

//----------------------------------------------------------------------------------------
void ISN76489::SetExternalClockDivider(double adata)
{
	GenericAccessDataValueDouble data(adata);
	WriteGenericData((unsigned int)ISN76489DataSource::ExternalClockDivider, 0, data);
}

//----------------------------------------------------------------------------------------
unsigned int ISN76489::GetShiftRegisterBitCount() const
{
	GenericAccessDataValueUInt data;
	ReadGenericData((unsigned int)ISN76489DataSource::ShiftRegisterBitCount, 0, data);
	return data.GetValue();
}

//----------------------------------------------------------------------------------------
void ISN76489::SetShiftRegisterBitCount(unsigned int adata)
{
	GenericAccessDataValueUInt data(adata);
	WriteGenericData((unsigned int)ISN76489DataSource::ShiftRegisterBitCount, 0, data);
}

//----------------------------------------------------------------------------------------
unsigned int ISN76489::GetShiftRegisterDefaultValue() const
{
	GenericAccessDataValueUInt data;
	ReadGenericData((unsigned int)ISN76489DataSource::ShiftRegisterDefaultValue, 0, data);
	return data.GetValue();
}

//----------------------------------------------------------------------------------------
void ISN76489::SetShiftRegisterDefaultValue(unsigned int adata)
{
	GenericAccessDataValueUInt data(adata);
	WriteGenericData((unsigned int)ISN76489DataSource::ShiftRegisterDefaultValue, 0, data);
}

//----------------------------------------------------------------------------------------
unsigned int ISN76489::GetNoiseChannelWhiteNoiseTappedBitMask() const
{
	GenericAccessDataValueUInt data;
	ReadGenericData((unsigned int)ISN76489DataSource::WhiteNoiseTappedBitMask, 0, data);
	return data.GetValue();
}

//----------------------------------------------------------------------------------------
void ISN76489::SetNoiseChannelWhiteNoiseTappedBitMask(unsigned int adata)
{
	GenericAccessDataValueUInt data(adata);
	WriteGenericData((unsigned int)ISN76489DataSource::WhiteNoiseTappedBitMask, 0, data);
}

//----------------------------------------------------------------------------------------
unsigned int ISN76489::GetNoiseChannelPeriodicNoiseTappedBitMask() const
{
	GenericAccessDataValueUInt data;
	ReadGenericData((unsigned int)ISN76489DataSource::PeriodicNoiseTappedBitMask, 0, data);
	return data.GetValue();
}

//----------------------------------------------------------------------------------------
void ISN76489::SetNoiseChannelPeriodicNoiseTappedBitMask(unsigned int adata)
{
	GenericAccessDataValueUInt data(adata);
	WriteGenericData((unsigned int)ISN76489DataSource::PeriodicNoiseTappedBitMask, 0, data);
}

//----------------------------------------------------------------------------------------
//Audio logging functions
//----------------------------------------------------------------------------------------
bool ISN76489::IsAudioLoggingEnabled() const
{
	GenericAccessDataValueBool data;
	ReadGenericData((unsigned int)ISN76489DataSource::AudioLoggingEnabled, 0, data);
	return data.GetValue();
}

//----------------------------------------------------------------------------------------
void ISN76489::SetAudioLoggingEnabled(bool adata)
{
	GenericAccessDataValueBool data(adata);
	WriteGenericData((unsigned int)ISN76489DataSource::AudioLoggingEnabled, 0, data);
}

//----------------------------------------------------------------------------------------
bool ISN76489::IsChannelAudioLoggingEnabled(unsigned int channelNo) const
{
	GenericAccessDataValueBool data;
	ReadGenericData((unsigned int)ISN76489DataSource::Channel1AudioLoggingEnabled + channelNo, 0, data);
	return data.GetValue();
}

//----------------------------------------------------------------------------------------
void ISN76489::SetChannelAudioLoggingEnabled(unsigned int channelNo, bool adata)
{
	GenericAccessDataValueBool data(adata);
	WriteGenericData((unsigned int)ISN76489DataSource::Channel1AudioLoggingEnabled + channelNo, 0, data);
}

//----------------------------------------------------------------------------------------
std::wstring ISN76489::GetAudioLoggingOutputPath() const
{
	GenericAccessDataValueFilePath data;
	ReadGenericData((unsigned int)ISN76489DataSource::AudioLoggingPath, 0, data);
	return data.GetValue();
}

//----------------------------------------------------------------------------------------
void ISN76489::SetAudioLoggingOutputPath(const std::wstring& adata)
{
	GenericAccessDataValueFilePath data(adata);
	WriteGenericData((unsigned int)ISN76489DataSource::AudioLoggingPath, 0, data);
}

//----------------------------------------------------------------------------------------
std::wstring ISN76489::GetChannelAudioLoggingOutputPath(unsigned int channelNo) const
{
	GenericAccessDataValueFilePath data;
	ReadGenericData((unsigned int)ISN76489DataSource::Channel1AudioLoggingPath + channelNo, 0, data);
	return data.GetValue();
}

//----------------------------------------------------------------------------------------
void ISN76489::SetChannelAudioLoggingOutputPath(unsigned int channelNo, const std::wstring& adata)
{
	GenericAccessDataValueFilePath data(adata);
	WriteGenericData((unsigned int)ISN76489DataSource::Channel1AudioLoggingPath + channelNo, 0, data);
}
