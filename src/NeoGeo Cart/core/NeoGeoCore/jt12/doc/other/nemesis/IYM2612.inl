//----------------------------------------------------------------------------------------
//Enumerations
//----------------------------------------------------------------------------------------
enum class IYM2612::IYM2612DataSource
{
	RawRegister = 1,

	TestData,
	LFOEnabled,
	LFOData,
	TimerAData,
	TimerBData,
	CH3Mode,
	TimerBReset,
	TimerAReset,
	TimerBEnable,
	TimerAEnable,
	TimerBLoad,
	TimerALoad,
	DACData,
	DACEnabled,
	DetuneData,
	MultipleData,
	TotalLevelData,
	KeyScaleData,
	AttackRateData,
	AmplitudeModulationEnabled,
	DecayRateData,
	SustainRateData,
	SustainLevelData,
	ReleaseRateData,
	SSGData,
	SSGEnabled,
	SSGAttack,
	SSGAlternate,
	SSGHold,

	FrequencyData,
	BlockData,
	FrequencyDataChannel3,
	BlockDataChannel3,
	FeedbackData,
	AlgorithmData,
	OutputLeft,
	OutputRight,
	AMSData,
	PMSData,

	KeyState,

	StatusRegister,
	BusyFlag,
	TimerBOverflow,
	TimerAOverflow,

	TimerACurrentCounter,
	TimerBCurrentCounter,

	ExternalClockRate,
	FMClockDivider,
	EGClockDivider,
	OutputClockDivider,
	TimerAClockDivider,
	TimerBClockDivider,

	AudioLoggingEnabled,
	AudioLoggingPath,
	ChannelAudioLoggingEnabled,
	ChannelAudioLoggingPath,
	OperatorAudioLoggingEnabled,
	OperatorAudioLoggingPath
};

//----------------------------------------------------------------------------------------
enum IYM2612::Channels :unsigned int
{
	CHANNEL1 = 0,
	CHANNEL2 = 1,
	CHANNEL3 = 2,
	CHANNEL4 = 3,
	CHANNEL5 = 4,
	CHANNEL6 = 5
};

//----------------------------------------------------------------------------------------
enum IYM2612::Operators:unsigned int
{
	OPERATOR1 = 0,
	OPERATOR2 = 1,
	OPERATOR3 = 2,
	OPERATOR4 = 3
};

//----------------------------------------------------------------------------------------
//Structures
//----------------------------------------------------------------------------------------
struct IYM2612::RegisterDataContext :public IGenericAccess::DataContext
{
	RegisterDataContext(unsigned int aregisterNo = 0)
	:registerNo(aregisterNo)
	{}

	unsigned int registerNo;
};

//----------------------------------------------------------------------------------------
struct IYM2612::ChannelDataContext :public IGenericAccess::DataContext
{
	ChannelDataContext(unsigned int achannelNo = 0)
	:channelNo(achannelNo)
	{}

	unsigned int channelNo;
};

//----------------------------------------------------------------------------------------
struct IYM2612::OperatorDataContext :public IGenericAccess::DataContext
{
	OperatorDataContext(unsigned int achannelNo = 0, unsigned int aoperatorNo = 0)
	:channelNo(achannelNo), operatorNo(aoperatorNo)
	{}

	unsigned int channelNo;
	unsigned int operatorNo;
};

//----------------------------------------------------------------------------------------
//Clock setting functions
//----------------------------------------------------------------------------------------
double IYM2612::GetExternalClockRate() const
{
	GenericAccessDataValueDouble data;
	ReadGenericData((unsigned int)IYM2612DataSource::ExternalClockRate, 0, data);
	return data.GetValue();
}

//----------------------------------------------------------------------------------------
void IYM2612::SetExternalClockRate(double adata)
{
	GenericAccessDataValueDouble data(adata);
	WriteGenericData((unsigned int)IYM2612DataSource::ExternalClockRate, 0, data);
}

//----------------------------------------------------------------------------------------
unsigned int IYM2612::GetFMClockDivider() const
{
	GenericAccessDataValueUInt data;
	ReadGenericData((unsigned int)IYM2612DataSource::FMClockDivider, 0, data);
	return data.GetValue();
}

//----------------------------------------------------------------------------------------
void IYM2612::SetFMClockDivider(unsigned int adata)
{
	GenericAccessDataValueUInt data(adata);
	WriteGenericData((unsigned int)IYM2612DataSource::FMClockDivider, 0, data);
}

//----------------------------------------------------------------------------------------
unsigned int IYM2612::GetEGClockDivider() const
{
	GenericAccessDataValueUInt data;
	ReadGenericData((unsigned int)IYM2612DataSource::EGClockDivider, 0, data);
	return data.GetValue();
}

//----------------------------------------------------------------------------------------
void IYM2612::SetEGClockDivider(unsigned int adata)
{
	GenericAccessDataValueUInt data(adata);
	WriteGenericData((unsigned int)IYM2612DataSource::EGClockDivider, 0, data);
}

//----------------------------------------------------------------------------------------
unsigned int IYM2612::GetOutputClockDivider() const
{
	GenericAccessDataValueUInt data;
	ReadGenericData((unsigned int)IYM2612DataSource::OutputClockDivider, 0, data);
	return data.GetValue();
}

//----------------------------------------------------------------------------------------
void IYM2612::SetOutputClockDivider(unsigned int adata)
{
	GenericAccessDataValueUInt data(adata);
	WriteGenericData((unsigned int)IYM2612DataSource::OutputClockDivider, 0, data);
}

//----------------------------------------------------------------------------------------
unsigned int IYM2612::GetTimerAClockDivider() const
{
	GenericAccessDataValueUInt data;
	ReadGenericData((unsigned int)IYM2612DataSource::TimerAClockDivider, 0, data);
	return data.GetValue();
}

//----------------------------------------------------------------------------------------
void IYM2612::SetTimerAClockDivider(unsigned int adata)
{
	GenericAccessDataValueUInt data(adata);
	WriteGenericData((unsigned int)IYM2612DataSource::TimerAClockDivider, 0, data);
}

//----------------------------------------------------------------------------------------
unsigned int IYM2612::GetTimerBClockDivider() const
{
	GenericAccessDataValueUInt data;
	ReadGenericData((unsigned int)IYM2612DataSource::TimerBClockDivider, 0, data);
	return data.GetValue();
}

//----------------------------------------------------------------------------------------
void IYM2612::SetTimerBClockDivider(unsigned int adata)
{
	GenericAccessDataValueUInt data(adata);
	WriteGenericData((unsigned int)IYM2612DataSource::TimerBClockDivider, 0, data);
}

//----------------------------------------------------------------------------------------
//Raw register functions
//----------------------------------------------------------------------------------------
unsigned int IYM2612::GetRegisterData(unsigned int registerNo) const
{
	GenericAccessDataValueUInt data;
	RegisterDataContext dataContext(registerNo);
	ReadGenericData((unsigned int)IYM2612DataSource::RawRegister, &dataContext, data);
	return data.GetValue();
}

//----------------------------------------------------------------------------------------
void IYM2612::SetRegisterData(unsigned int registerNo, unsigned int adata)
{
	GenericAccessDataValueUInt data(adata);
	RegisterDataContext dataContext(registerNo);
	WriteGenericData((unsigned int)IYM2612DataSource::RawRegister, &dataContext, data);
}

//----------------------------------------------------------------------------------------
//Register functions
//----------------------------------------------------------------------------------------
unsigned int IYM2612::GetTestData() const
{
	GenericAccessDataValueUInt data;
	ReadGenericData((unsigned int)IYM2612DataSource::TestData, 0, data);
	return data.GetValue();
}

//----------------------------------------------------------------------------------------
void IYM2612::SetTestData(unsigned int adata)
{
	GenericAccessDataValueUInt data(adata);
	WriteGenericData((unsigned int)IYM2612DataSource::TestData, 0, data);
}

//----------------------------------------------------------------------------------------
bool IYM2612::GetLFOEnabled() const
{
	GenericAccessDataValueBool data;
	ReadGenericData((unsigned int)IYM2612DataSource::LFOEnabled, 0, data);
	return data.GetValue();
}

//----------------------------------------------------------------------------------------
void IYM2612::SetLFOEnabled(bool adata)
{
	GenericAccessDataValueBool data(adata);
	WriteGenericData((unsigned int)IYM2612DataSource::LFOEnabled, 0, data);
}

//----------------------------------------------------------------------------------------
unsigned int IYM2612::GetLFOData() const
{
	GenericAccessDataValueUInt data;
	ReadGenericData((unsigned int)IYM2612DataSource::LFOData, 0, data);
	return data.GetValue();
}

//----------------------------------------------------------------------------------------
void IYM2612::SetLFOData(unsigned int adata)
{
	GenericAccessDataValueUInt data(adata);
	WriteGenericData((unsigned int)IYM2612DataSource::LFOData, 0, data);
}

//----------------------------------------------------------------------------------------
unsigned int IYM2612::GetTimerAData() const
{
	GenericAccessDataValueUInt data;
	ReadGenericData((unsigned int)IYM2612DataSource::TimerAData, 0, data);
	return data.GetValue();
}

//----------------------------------------------------------------------------------------
void IYM2612::SetTimerAData(unsigned int adata)
{
	GenericAccessDataValueUInt data(adata);
	WriteGenericData((unsigned int)IYM2612DataSource::TimerAData, 0, data);
}

//----------------------------------------------------------------------------------------
unsigned int IYM2612::GetTimerBData() const
{
	GenericAccessDataValueUInt data;
	ReadGenericData((unsigned int)IYM2612DataSource::TimerBData, 0, data);
	return data.GetValue();
}

//----------------------------------------------------------------------------------------
void IYM2612::SetTimerBData(unsigned int adata)
{
	GenericAccessDataValueUInt data(adata);
	WriteGenericData((unsigned int)IYM2612DataSource::TimerBData, 0, data);
}

//----------------------------------------------------------------------------------------
unsigned int IYM2612::GetCH3Mode() const
{
	GenericAccessDataValueUInt data;
	ReadGenericData((unsigned int)IYM2612DataSource::CH3Mode, 0, data);
	return data.GetValue();
}

//----------------------------------------------------------------------------------------
void IYM2612::SetCH3Mode(unsigned int adata)
{
	GenericAccessDataValueUInt data(adata);
	WriteGenericData((unsigned int)IYM2612DataSource::CH3Mode, 0, data);
}

//----------------------------------------------------------------------------------------
bool IYM2612::GetTimerBReset() const
{
	GenericAccessDataValueBool data;
	ReadGenericData((unsigned int)IYM2612DataSource::TimerBReset, 0, data);
	return data.GetValue();
}

//----------------------------------------------------------------------------------------
void IYM2612::SetTimerBReset(bool adata)
{
	GenericAccessDataValueBool data(adata);
	WriteGenericData((unsigned int)IYM2612DataSource::TimerBReset, 0, data);
}

//----------------------------------------------------------------------------------------
bool IYM2612::GetTimerAReset() const
{
	GenericAccessDataValueBool data;
	ReadGenericData((unsigned int)IYM2612DataSource::TimerAReset, 0, data);
	return data.GetValue();
}

//----------------------------------------------------------------------------------------
void IYM2612::SetTimerAReset(bool adata)
{
	GenericAccessDataValueBool data(adata);
	WriteGenericData((unsigned int)IYM2612DataSource::TimerAReset, 0, data);
}

//----------------------------------------------------------------------------------------
bool IYM2612::GetTimerBEnable() const
{
	GenericAccessDataValueBool data;
	ReadGenericData((unsigned int)IYM2612DataSource::TimerBEnable, 0, data);
	return data.GetValue();
}

//----------------------------------------------------------------------------------------
void IYM2612::SetTimerBEnable(bool adata)
{
	GenericAccessDataValueBool data(adata);
	WriteGenericData((unsigned int)IYM2612DataSource::TimerBEnable, 0, data);
}

//----------------------------------------------------------------------------------------
bool IYM2612::GetTimerAEnable() const
{
	GenericAccessDataValueBool data;
	ReadGenericData((unsigned int)IYM2612DataSource::TimerAEnable, 0, data);
	return data.GetValue();
}

//----------------------------------------------------------------------------------------
void IYM2612::SetTimerAEnable(bool adata)
{
	GenericAccessDataValueBool data(adata);
	WriteGenericData((unsigned int)IYM2612DataSource::TimerAEnable, 0, data);
}

//----------------------------------------------------------------------------------------
bool IYM2612::GetTimerBLoad() const
{
	GenericAccessDataValueBool data;
	ReadGenericData((unsigned int)IYM2612DataSource::TimerBLoad, 0, data);
	return data.GetValue();
}

//----------------------------------------------------------------------------------------
void IYM2612::SetTimerBLoad(bool adata)
{
	GenericAccessDataValueBool data(adata);
	WriteGenericData((unsigned int)IYM2612DataSource::TimerBLoad, 0, data);
}

//----------------------------------------------------------------------------------------
bool IYM2612::GetTimerALoad() const
{
	GenericAccessDataValueBool data;
	ReadGenericData((unsigned int)IYM2612DataSource::TimerALoad, 0, data);
	return data.GetValue();
}

//----------------------------------------------------------------------------------------
void IYM2612::SetTimerALoad(bool adata)
{
	GenericAccessDataValueBool data(adata);
	WriteGenericData((unsigned int)IYM2612DataSource::TimerALoad, 0, data);
}

//----------------------------------------------------------------------------------------
unsigned int IYM2612::GetDACData() const
{
	GenericAccessDataValueUInt data;
	ReadGenericData((unsigned int)IYM2612DataSource::DACData, 0, data);
	return data.GetValue();
}

//----------------------------------------------------------------------------------------
void IYM2612::SetDACData(unsigned int adata)
{
	GenericAccessDataValueUInt data(adata);
	WriteGenericData((unsigned int)IYM2612DataSource::DACData, 0, data);
}

//----------------------------------------------------------------------------------------
bool IYM2612::GetDACEnabled() const
{
	GenericAccessDataValueBool data;
	ReadGenericData((unsigned int)IYM2612DataSource::DACEnabled, 0, data);
	return data.GetValue();
}

//----------------------------------------------------------------------------------------
void IYM2612::SetDACEnabled(bool adata)
{
	GenericAccessDataValueBool data(adata);
	WriteGenericData((unsigned int)IYM2612DataSource::DACEnabled, 0, data);
}

//----------------------------------------------------------------------------------------
unsigned int IYM2612::GetDetuneData(unsigned int channelNo, unsigned int operatorNo) const
{
	GenericAccessDataValueUInt data;
	OperatorDataContext dataContext(channelNo, operatorNo);
	ReadGenericData((unsigned int)IYM2612DataSource::DetuneData, &dataContext, data);
	return data.GetValue();
}

//----------------------------------------------------------------------------------------
void IYM2612::SetDetuneData(unsigned int channelNo, unsigned int operatorNo, unsigned int adata)
{
	GenericAccessDataValueUInt data(adata);
	OperatorDataContext dataContext(channelNo, operatorNo);
	WriteGenericData((unsigned int)IYM2612DataSource::DetuneData, &dataContext, data);
}

//----------------------------------------------------------------------------------------
unsigned int IYM2612::GetMultipleData(unsigned int channelNo, unsigned int operatorNo) const
{
	GenericAccessDataValueUInt data;
	OperatorDataContext dataContext(channelNo, operatorNo);
	ReadGenericData((unsigned int)IYM2612DataSource::MultipleData, &dataContext, data);
	return data.GetValue();
}

//----------------------------------------------------------------------------------------
void IYM2612::SetMultipleData(unsigned int channelNo, unsigned int operatorNo, unsigned int adata)
{
	GenericAccessDataValueUInt data(adata);
	OperatorDataContext dataContext(channelNo, operatorNo);
	WriteGenericData((unsigned int)IYM2612DataSource::MultipleData, &dataContext, data);
}

//----------------------------------------------------------------------------------------
unsigned int IYM2612::GetTotalLevelData(unsigned int channelNo, unsigned int operatorNo) const
{
	GenericAccessDataValueUInt data;
	OperatorDataContext dataContext(channelNo, operatorNo);
	ReadGenericData((unsigned int)IYM2612DataSource::TotalLevelData, &dataContext, data);
	return data.GetValue();
}

//----------------------------------------------------------------------------------------
void IYM2612::SetTotalLevelData(unsigned int channelNo, unsigned int operatorNo, unsigned int adata)
{
	GenericAccessDataValueUInt data(adata);
	OperatorDataContext dataContext(channelNo, operatorNo);
	WriteGenericData((unsigned int)IYM2612DataSource::TotalLevelData, &dataContext, data);
}

//----------------------------------------------------------------------------------------
unsigned int IYM2612::GetKeyScaleData(unsigned int channelNo, unsigned int operatorNo) const
{
	GenericAccessDataValueUInt data;
	OperatorDataContext dataContext(channelNo, operatorNo);
	ReadGenericData((unsigned int)IYM2612DataSource::KeyScaleData, &dataContext, data);
	return data.GetValue();
}

//----------------------------------------------------------------------------------------
void IYM2612::SetKeyScaleData(unsigned int channelNo, unsigned int operatorNo, unsigned int adata)
{
	GenericAccessDataValueUInt data(adata);
	OperatorDataContext dataContext(channelNo, operatorNo);
	WriteGenericData((unsigned int)IYM2612DataSource::KeyScaleData, &dataContext, data);
}

//----------------------------------------------------------------------------------------
unsigned int IYM2612::GetAttackRateData(unsigned int channelNo, unsigned int operatorNo) const
{
	GenericAccessDataValueUInt data;
	OperatorDataContext dataContext(channelNo, operatorNo);
	ReadGenericData((unsigned int)IYM2612DataSource::AttackRateData, &dataContext, data);
	return data.GetValue();
}

//----------------------------------------------------------------------------------------
void IYM2612::SetAttackRateData(unsigned int channelNo, unsigned int operatorNo, unsigned int adata)
{
	GenericAccessDataValueUInt data(adata);
	OperatorDataContext dataContext(channelNo, operatorNo);
	WriteGenericData((unsigned int)IYM2612DataSource::AttackRateData, &dataContext, data);
}

//----------------------------------------------------------------------------------------
bool IYM2612::GetAmplitudeModulationEnabled(unsigned int channelNo, unsigned int operatorNo) const
{
	GenericAccessDataValueBool data;
	OperatorDataContext dataContext(channelNo, operatorNo);
	ReadGenericData((unsigned int)IYM2612DataSource::AmplitudeModulationEnabled, &dataContext, data);
	return data.GetValue();
}

//----------------------------------------------------------------------------------------
void IYM2612::SetAmplitudeModulationEnabled(unsigned int channelNo, unsigned int operatorNo, bool adata)
{
	GenericAccessDataValueBool data(adata);
	OperatorDataContext dataContext(channelNo, operatorNo);
	WriteGenericData((unsigned int)IYM2612DataSource::AmplitudeModulationEnabled, &dataContext, data);
}

//----------------------------------------------------------------------------------------
unsigned int IYM2612::GetDecayRateData(unsigned int channelNo, unsigned int operatorNo) const
{
	GenericAccessDataValueUInt data;
	OperatorDataContext dataContext(channelNo, operatorNo);
	ReadGenericData((unsigned int)IYM2612DataSource::DecayRateData, &dataContext, data);
	return data.GetValue();
}

//----------------------------------------------------------------------------------------
void IYM2612::SetDecayRateData(unsigned int channelNo, unsigned int operatorNo, unsigned int adata)
{
	GenericAccessDataValueUInt data(adata);
	OperatorDataContext dataContext(channelNo, operatorNo);
	WriteGenericData((unsigned int)IYM2612DataSource::DecayRateData, &dataContext, data);
}

//----------------------------------------------------------------------------------------
unsigned int IYM2612::GetSustainRateData(unsigned int channelNo, unsigned int operatorNo) const
{
	GenericAccessDataValueUInt data;
	OperatorDataContext dataContext(channelNo, operatorNo);
	ReadGenericData((unsigned int)IYM2612DataSource::SustainRateData, &dataContext, data);
	return data.GetValue();
}

//----------------------------------------------------------------------------------------
void IYM2612::SetSustainRateData(unsigned int channelNo, unsigned int operatorNo, unsigned int adata)
{
	GenericAccessDataValueUInt data(adata);
	OperatorDataContext dataContext(channelNo, operatorNo);
	WriteGenericData((unsigned int)IYM2612DataSource::SustainRateData, &dataContext, data);
}

//----------------------------------------------------------------------------------------
unsigned int IYM2612::GetSustainLevelData(unsigned int channelNo, unsigned int operatorNo) const
{
	GenericAccessDataValueUInt data;
	OperatorDataContext dataContext(channelNo, operatorNo);
	ReadGenericData((unsigned int)IYM2612DataSource::SustainLevelData, &dataContext, data);
	return data.GetValue();
}

//----------------------------------------------------------------------------------------
void IYM2612::SetSustainLevelData(unsigned int channelNo, unsigned int operatorNo, unsigned int adata)
{
	GenericAccessDataValueUInt data(adata);
	OperatorDataContext dataContext(channelNo, operatorNo);
	WriteGenericData((unsigned int)IYM2612DataSource::SustainLevelData, &dataContext, data);
}

//----------------------------------------------------------------------------------------
unsigned int IYM2612::GetReleaseRateData(unsigned int channelNo, unsigned int operatorNo) const
{
	GenericAccessDataValueUInt data;
	OperatorDataContext dataContext(channelNo, operatorNo);
	ReadGenericData((unsigned int)IYM2612DataSource::ReleaseRateData, &dataContext, data);
	return data.GetValue();
}

//----------------------------------------------------------------------------------------
void IYM2612::SetReleaseRateData(unsigned int channelNo, unsigned int operatorNo, unsigned int adata)
{
	GenericAccessDataValueUInt data(adata);
	OperatorDataContext dataContext(channelNo, operatorNo);
	WriteGenericData((unsigned int)IYM2612DataSource::ReleaseRateData, &dataContext, data);
}

//----------------------------------------------------------------------------------------
unsigned int IYM2612::GetSSGData(unsigned int channelNo, unsigned int operatorNo) const
{
	GenericAccessDataValueUInt data;
	OperatorDataContext dataContext(channelNo, operatorNo);
	ReadGenericData((unsigned int)IYM2612DataSource::SSGData, &dataContext, data);
	return data.GetValue();
}

//----------------------------------------------------------------------------------------
void IYM2612::SetSSGData(unsigned int channelNo, unsigned int operatorNo, unsigned int adata)
{
	GenericAccessDataValueUInt data(adata);
	OperatorDataContext dataContext(channelNo, operatorNo);
	WriteGenericData((unsigned int)IYM2612DataSource::SSGData, &dataContext, data);
}

//----------------------------------------------------------------------------------------
bool IYM2612::GetSSGEnabled(unsigned int channelNo, unsigned int operatorNo) const
{
	GenericAccessDataValueBool data;
	OperatorDataContext dataContext(channelNo, operatorNo);
	ReadGenericData((unsigned int)IYM2612DataSource::SSGEnabled, &dataContext, data);
	return data.GetValue();
}

//----------------------------------------------------------------------------------------
void IYM2612::SetSSGEnabled(unsigned int channelNo, unsigned int operatorNo, bool adata)
{
	GenericAccessDataValueBool data(adata);
	OperatorDataContext dataContext(channelNo, operatorNo);
	WriteGenericData((unsigned int)IYM2612DataSource::SSGEnabled, &dataContext, data);
}

//----------------------------------------------------------------------------------------
bool IYM2612::GetSSGAttack(unsigned int channelNo, unsigned int operatorNo) const
{
	GenericAccessDataValueBool data;
	OperatorDataContext dataContext(channelNo, operatorNo);
	ReadGenericData((unsigned int)IYM2612DataSource::SSGAttack, &dataContext, data);
	return data.GetValue();
}

//----------------------------------------------------------------------------------------
void IYM2612::SetSSGAttack(unsigned int channelNo, unsigned int operatorNo, bool adata)
{
	GenericAccessDataValueBool data(adata);
	OperatorDataContext dataContext(channelNo, operatorNo);
	WriteGenericData((unsigned int)IYM2612DataSource::SSGAttack, &dataContext, data);
}

//----------------------------------------------------------------------------------------
bool IYM2612::GetSSGAlternate(unsigned int channelNo, unsigned int operatorNo) const
{
	GenericAccessDataValueBool data;
	OperatorDataContext dataContext(channelNo, operatorNo);
	ReadGenericData((unsigned int)IYM2612DataSource::SSGAlternate, &dataContext, data);
	return data.GetValue();
}

//----------------------------------------------------------------------------------------
void IYM2612::SetSSGAlternate(unsigned int channelNo, unsigned int operatorNo, bool adata)
{
	GenericAccessDataValueBool data(adata);
	OperatorDataContext dataContext(channelNo, operatorNo);
	WriteGenericData((unsigned int)IYM2612DataSource::SSGAlternate, &dataContext, data);
}

//----------------------------------------------------------------------------------------
bool IYM2612::GetSSGHold(unsigned int channelNo, unsigned int operatorNo) const
{
	GenericAccessDataValueBool data;
	OperatorDataContext dataContext(channelNo, operatorNo);
	ReadGenericData((unsigned int)IYM2612DataSource::SSGHold, &dataContext, data);
	return data.GetValue();
}

//----------------------------------------------------------------------------------------
void IYM2612::SetSSGHold(unsigned int channelNo, unsigned int operatorNo, bool adata)
{
	GenericAccessDataValueBool data(adata);
	OperatorDataContext dataContext(channelNo, operatorNo);
	WriteGenericData((unsigned int)IYM2612DataSource::SSGHold, &dataContext, data);
}

//----------------------------------------------------------------------------------------
unsigned int IYM2612::GetFrequencyData(unsigned int channelNo) const
{
	GenericAccessDataValueUInt data;
	ChannelDataContext dataContext(channelNo);
	ReadGenericData((unsigned int)IYM2612DataSource::FrequencyData, &dataContext, data);
	return data.GetValue();
}

//----------------------------------------------------------------------------------------
void IYM2612::SetFrequencyData(unsigned int channelNo, unsigned int adata)
{
	GenericAccessDataValueUInt data(adata);
	ChannelDataContext dataContext(channelNo);
	WriteGenericData((unsigned int)IYM2612DataSource::FrequencyData, &dataContext, data);
}

//----------------------------------------------------------------------------------------
unsigned int IYM2612::GetBlockData(unsigned int channelNo) const
{
	GenericAccessDataValueUInt data;
	ChannelDataContext dataContext(channelNo);
	ReadGenericData((unsigned int)IYM2612DataSource::BlockData, &dataContext, data);
	return data.GetValue();
}

//----------------------------------------------------------------------------------------
void IYM2612::SetBlockData(unsigned int channelNo, unsigned int adata)
{
	GenericAccessDataValueUInt data(adata);
	ChannelDataContext dataContext(channelNo);
	WriteGenericData((unsigned int)IYM2612DataSource::BlockData, &dataContext, data);
}

//----------------------------------------------------------------------------------------
unsigned int IYM2612::GetFrequencyDataChannel3(unsigned int operatorNo) const
{
	GenericAccessDataValueUInt data;
	OperatorDataContext dataContext(CHANNEL3, operatorNo);
	ReadGenericData((unsigned int)IYM2612DataSource::FrequencyDataChannel3, &dataContext, data);
	return data.GetValue();
}

//----------------------------------------------------------------------------------------
void IYM2612::SetFrequencyDataChannel3(unsigned int operatorNo, unsigned int adata)
{
	GenericAccessDataValueUInt data(adata);
	OperatorDataContext dataContext(CHANNEL3, operatorNo);
	WriteGenericData((unsigned int)IYM2612DataSource::FrequencyDataChannel3, &dataContext, data);
}

//----------------------------------------------------------------------------------------
unsigned int IYM2612::GetBlockDataChannel3(unsigned int operatorNo) const
{
	GenericAccessDataValueUInt data;
	OperatorDataContext dataContext(CHANNEL3, operatorNo);
	ReadGenericData((unsigned int)IYM2612DataSource::BlockDataChannel3, &dataContext, data);
	return data.GetValue();
}

//----------------------------------------------------------------------------------------
void IYM2612::SetBlockDataChannel3(unsigned int operatorNo, unsigned int adata)
{
	GenericAccessDataValueUInt data(adata);
	OperatorDataContext dataContext(CHANNEL3, operatorNo);
	WriteGenericData((unsigned int)IYM2612DataSource::BlockDataChannel3, &dataContext, data);
}

//----------------------------------------------------------------------------------------
unsigned int IYM2612::GetFeedbackData(unsigned int channelNo) const
{
	GenericAccessDataValueUInt data;
	ChannelDataContext dataContext(channelNo);
	ReadGenericData((unsigned int)IYM2612DataSource::FeedbackData, &dataContext, data);
	return data.GetValue();
}

//----------------------------------------------------------------------------------------
void IYM2612::SetFeedbackData(unsigned int channelNo, unsigned int adata)
{
	GenericAccessDataValueUInt data(adata);
	ChannelDataContext dataContext(channelNo);
	WriteGenericData((unsigned int)IYM2612DataSource::FeedbackData, &dataContext, data);
}

//----------------------------------------------------------------------------------------
unsigned int IYM2612::GetAlgorithmData(unsigned int channelNo) const
{
	GenericAccessDataValueUInt data;
	ChannelDataContext dataContext(channelNo);
	ReadGenericData((unsigned int)IYM2612DataSource::AlgorithmData, &dataContext, data);
	return data.GetValue();
}

//----------------------------------------------------------------------------------------
void IYM2612::SetAlgorithmData(unsigned int channelNo, unsigned int adata)
{
	GenericAccessDataValueUInt data(adata);
	ChannelDataContext dataContext(channelNo);
	WriteGenericData((unsigned int)IYM2612DataSource::AlgorithmData, &dataContext, data);
}

//----------------------------------------------------------------------------------------
bool IYM2612::GetOutputLeft(unsigned int channelNo) const
{
	GenericAccessDataValueBool data;
	ChannelDataContext dataContext(channelNo);
	ReadGenericData((unsigned int)IYM2612DataSource::OutputLeft, &dataContext, data);
	return data.GetValue();
}

//----------------------------------------------------------------------------------------
void IYM2612::SetOutputLeft(unsigned int channelNo, bool adata)
{
	GenericAccessDataValueBool data(adata);
	ChannelDataContext dataContext(channelNo);
	WriteGenericData((unsigned int)IYM2612DataSource::OutputLeft, &dataContext, data);
}

//----------------------------------------------------------------------------------------
bool IYM2612::GetOutputRight(unsigned int channelNo) const
{
	GenericAccessDataValueBool data;
	ChannelDataContext dataContext(channelNo);
	ReadGenericData((unsigned int)IYM2612DataSource::OutputRight, &dataContext, data);
	return data.GetValue();
}

//----------------------------------------------------------------------------------------
void IYM2612::SetOutputRight(unsigned int channelNo, bool adata)
{
	GenericAccessDataValueBool data(adata);
	ChannelDataContext dataContext(channelNo);
	WriteGenericData((unsigned int)IYM2612DataSource::OutputRight, &dataContext, data);
}

//----------------------------------------------------------------------------------------
unsigned int IYM2612::GetAMSData(unsigned int channelNo) const
{
	GenericAccessDataValueUInt data;
	ChannelDataContext dataContext(channelNo);
	ReadGenericData((unsigned int)IYM2612DataSource::AMSData, &dataContext, data);
	return data.GetValue();
}

//----------------------------------------------------------------------------------------
void IYM2612::SetAMSData(unsigned int channelNo, unsigned int adata)
{
	GenericAccessDataValueUInt data(adata);
	ChannelDataContext dataContext(channelNo);
	WriteGenericData((unsigned int)IYM2612DataSource::AMSData, &dataContext, data);
}

//----------------------------------------------------------------------------------------
unsigned int IYM2612::GetPMSData(unsigned int channelNo) const
{
	GenericAccessDataValueUInt data;
	ChannelDataContext dataContext(channelNo);
	ReadGenericData((unsigned int)IYM2612DataSource::PMSData, &dataContext, data);
	return data.GetValue();
}

//----------------------------------------------------------------------------------------
void IYM2612::SetPMSData(unsigned int channelNo, unsigned int adata)
{
	GenericAccessDataValueUInt data(adata);
	ChannelDataContext dataContext(channelNo);
	WriteGenericData((unsigned int)IYM2612DataSource::PMSData, &dataContext, data);
}

//----------------------------------------------------------------------------------------
//Key on/off functions
//----------------------------------------------------------------------------------------
bool IYM2612::GetKeyState(unsigned int channelNo, unsigned int operatorNo) const
{
	GenericAccessDataValueBool data;
	OperatorDataContext dataContext(channelNo, operatorNo);
	ReadGenericData((unsigned int)IYM2612DataSource::KeyState, &dataContext, data);
	return data.GetValue();
}

//----------------------------------------------------------------------------------------
void IYM2612::SetKeyState(unsigned int channelNo, unsigned int operatorNo, bool adata)
{
	GenericAccessDataValueBool data(adata);
	OperatorDataContext dataContext(channelNo, operatorNo);
	WriteGenericData((unsigned int)IYM2612DataSource::KeyState, &dataContext, data);
}

//----------------------------------------------------------------------------------------
//Status register functions
//----------------------------------------------------------------------------------------
unsigned int IYM2612::GetStatusRegister() const
{
	GenericAccessDataValueUInt data;
	ReadGenericData((unsigned int)IYM2612DataSource::StatusRegister, 0, data);
	return data.GetValue();
}

//----------------------------------------------------------------------------------------
void IYM2612::SetStatusRegister(unsigned int adata)
{
	GenericAccessDataValueUInt data(adata);
	WriteGenericData((unsigned int)IYM2612DataSource::StatusRegister, 0, data);
}

//----------------------------------------------------------------------------------------
bool IYM2612::GetBusyFlag() const
{
	GenericAccessDataValueBool data;
	ReadGenericData((unsigned int)IYM2612DataSource::BusyFlag, 0, data);
	return data.GetValue();
}

//----------------------------------------------------------------------------------------
void IYM2612::SetBusyFlag(bool adata)
{
	GenericAccessDataValueBool data(adata);
	WriteGenericData((unsigned int)IYM2612DataSource::BusyFlag, 0, data);
}

//----------------------------------------------------------------------------------------
bool IYM2612::GetTimerBOverflow() const
{
	GenericAccessDataValueBool data;
	ReadGenericData((unsigned int)IYM2612DataSource::TimerBOverflow, 0, data);
	return data.GetValue();
}

//----------------------------------------------------------------------------------------
void IYM2612::SetTimerBOverflow(bool adata)
{
	GenericAccessDataValueBool data(adata);
	WriteGenericData((unsigned int)IYM2612DataSource::TimerBOverflow, 0, data);
}

//----------------------------------------------------------------------------------------
bool IYM2612::GetTimerAOverflow() const
{
	GenericAccessDataValueBool data;
	ReadGenericData((unsigned int)IYM2612DataSource::TimerAOverflow, 0, data);
	return data.GetValue();
}

//----------------------------------------------------------------------------------------
void IYM2612::SetTimerAOverflow(bool adata)
{
	GenericAccessDataValueBool data(adata);
	WriteGenericData((unsigned int)IYM2612DataSource::TimerAOverflow, 0, data);
}

//----------------------------------------------------------------------------------------
//Timer functions
//----------------------------------------------------------------------------------------
unsigned int IYM2612::GetTimerACurrentCounter() const
{
	GenericAccessDataValueUInt data;
	ReadGenericData((unsigned int)IYM2612DataSource::TimerACurrentCounter, 0, data);
	return data.GetValue();
}

//----------------------------------------------------------------------------------------
void IYM2612::SetTimerACurrentCounter(unsigned int adata)
{
	GenericAccessDataValueUInt data(adata);
	WriteGenericData((unsigned int)IYM2612DataSource::TimerACurrentCounter, 0, data);
}

//----------------------------------------------------------------------------------------
unsigned int IYM2612::GetTimerBCurrentCounter() const
{
	GenericAccessDataValueUInt data;
	ReadGenericData((unsigned int)IYM2612DataSource::TimerBCurrentCounter, 0, data);
	return data.GetValue();
}

//----------------------------------------------------------------------------------------
void IYM2612::SetTimerBCurrentCounter(unsigned int adata)
{
	GenericAccessDataValueUInt data(adata);
	WriteGenericData((unsigned int)IYM2612DataSource::TimerBCurrentCounter, 0, data);
}

//----------------------------------------------------------------------------------------
//Audio logging functions
//----------------------------------------------------------------------------------------
bool IYM2612::IsAudioLoggingEnabled() const
{
	GenericAccessDataValueBool data;
	ReadGenericData((unsigned int)IYM2612DataSource::AudioLoggingEnabled, 0, data);
	return data.GetValue();
}

//----------------------------------------------------------------------------------------
void IYM2612::SetAudioLoggingEnabled(bool adata)
{
	GenericAccessDataValueBool data(adata);
	WriteGenericData((unsigned int)IYM2612DataSource::AudioLoggingEnabled, 0, data);
}

//----------------------------------------------------------------------------------------
bool IYM2612::IsChannelAudioLoggingEnabled(unsigned int channelNo) const
{
	GenericAccessDataValueBool data;
	ChannelDataContext dataContext(channelNo);
	ReadGenericData((unsigned int)IYM2612DataSource::ChannelAudioLoggingEnabled, &dataContext, data);
	return data.GetValue();
}

//----------------------------------------------------------------------------------------
void IYM2612::SetChannelAudioLoggingEnabled(unsigned int channelNo, bool adata)
{
	GenericAccessDataValueBool data(adata);
	ChannelDataContext dataContext(channelNo);
	WriteGenericData((unsigned int)IYM2612DataSource::ChannelAudioLoggingEnabled, &dataContext, data);
}

//----------------------------------------------------------------------------------------
bool IYM2612::IsOperatorAudioLoggingEnabled(unsigned int channelNo, unsigned int operatorNo) const
{
	GenericAccessDataValueBool data;
	OperatorDataContext dataContext(channelNo, operatorNo);
	ReadGenericData((unsigned int)IYM2612DataSource::OperatorAudioLoggingEnabled, &dataContext, data);
	return data.GetValue();
}

//----------------------------------------------------------------------------------------
void IYM2612::SetOperatorAudioLoggingEnabled(unsigned int channelNo, unsigned int operatorNo, bool adata)
{
	GenericAccessDataValueBool data(adata);
	OperatorDataContext dataContext(channelNo, operatorNo);
	WriteGenericData((unsigned int)IYM2612DataSource::OperatorAudioLoggingEnabled, &dataContext, data);
}

//----------------------------------------------------------------------------------------
std::wstring IYM2612::GetAudioLoggingOutputPath() const
{
	GenericAccessDataValueFilePath data;
	ReadGenericData((unsigned int)IYM2612DataSource::AudioLoggingPath, 0, data);
	return data.GetValue();
}

//----------------------------------------------------------------------------------------
void IYM2612::SetAudioLoggingOutputPath(const std::wstring& adata)
{
	GenericAccessDataValueFilePath data(adata);
	WriteGenericData((unsigned int)IYM2612DataSource::AudioLoggingPath, 0, data);
}

//----------------------------------------------------------------------------------------
std::wstring IYM2612::GetChannelAudioLoggingOutputPath(unsigned int channelNo) const
{
	GenericAccessDataValueFilePath data;
	ChannelDataContext dataContext(channelNo);
	ReadGenericData((unsigned int)IYM2612DataSource::ChannelAudioLoggingPath, &dataContext, data);
	return data.GetValue();
}

//----------------------------------------------------------------------------------------
void IYM2612::SetChannelAudioLoggingOutputPath(unsigned int channelNo, const std::wstring& adata)
{
	GenericAccessDataValueFilePath data(adata);
	ChannelDataContext dataContext(channelNo);
	WriteGenericData((unsigned int)IYM2612DataSource::ChannelAudioLoggingPath, &dataContext, data);
}

//----------------------------------------------------------------------------------------
std::wstring IYM2612::GetOperatorAudioLoggingOutputPath(unsigned int channelNo, unsigned int operatorNo) const
{
	GenericAccessDataValueFilePath data;
	OperatorDataContext dataContext(channelNo, operatorNo);
	ReadGenericData((unsigned int)IYM2612DataSource::OperatorAudioLoggingPath, &dataContext, data);
	return data.GetValue();
}

//----------------------------------------------------------------------------------------
void IYM2612::SetOperatorAudioLoggingOutputPath(unsigned int channelNo, unsigned int operatorNo, const std::wstring& adata)
{
	GenericAccessDataValueFilePath data(adata);
	OperatorDataContext dataContext(channelNo, operatorNo);
	WriteGenericData((unsigned int)IYM2612DataSource::OperatorAudioLoggingPath, &dataContext, data);
}
