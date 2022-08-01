#include "YM2612.h"
#include "DataConversion/DataConversion.pkg"
#include <functional>
#include <thread>
//##DEBUG##
//#include <iostream>

//----------------------------------------------------------------------------------------
//These tables are primarily based on the work of Jarek Burczynski in his OPN envelope
//generator implementation for the MAME core. Some corrections have been made to the
//attenuation increment table following hardware tests.
//----------------------------------------------------------------------------------------
const unsigned int YM2612::counterShiftTable[1 << rateBitCount] = {
	11, 11, 11, 11, //0-3    (0x00-0x03)
	10, 10, 10, 10, //4-7    (0x04-0x07)
	9,  9,  9,  9,  //8-11   (0x08-0x0B)
	8,  8,  8,  8,  //12-15  (0x0C-0x0F)
	7,  7,  7,  7,  //16-19  (0x10-0x13)
	6,  6,  6,  6,  //20-23  (0x14-0x17)
	5,  5,  5,  5,  //24-27  (0x18-0x1B)
	4,  4,  4,  4,  //28-31  (0x1C-0x1F)
	3,  3,  3,  3,  //32-35  (0x20-0x23)
	2,  2,  2,  2,  //36-39  (0x24-0x27)
	1,  1,  1,  1,  //40-43  (0x28-0x2B)
	0,  0,  0,  0,  //44-47  (0x2C-0x2F)
	0,  0,  0,  0,  //48-51  (0x30-0x33)
	0,  0,  0,  0,  //52-55  (0x34-0x37)
	0,  0,  0,  0,  //56-59  (0x38-0x3B)
	0,  0,  0,  0}; //60-63  (0x3C-0x3F)

//----------------------------------------------------------------------------------------
const unsigned int YM2612::attenuationIncrementTable[1 << rateBitCount][8] = {
	{0,0,0,0,0,0,0,0}, {0,0,0,0,0,0,0,0}, {0,1,0,1,0,1,0,1}, {0,1,0,1,0,1,0,1},  //0-3    (0x00-0x03)
	{0,1,0,1,0,1,0,1}, {0,1,0,1,0,1,0,1}, {0,1,1,1,0,1,1,1}, {0,1,1,1,0,1,1,1},  //4-7    (0x04-0x07)
	{0,1,0,1,0,1,0,1}, {0,1,0,1,1,1,0,1}, {0,1,1,1,0,1,1,1}, {0,1,1,1,1,1,1,1},  //8-11   (0x08-0x0B)
	{0,1,0,1,0,1,0,1}, {0,1,0,1,1,1,0,1}, {0,1,1,1,0,1,1,1}, {0,1,1,1,1,1,1,1},  //12-15  (0x0C-0x0F)
	{0,1,0,1,0,1,0,1}, {0,1,0,1,1,1,0,1}, {0,1,1,1,0,1,1,1}, {0,1,1,1,1,1,1,1},  //16-19  (0x10-0x13)
	{0,1,0,1,0,1,0,1}, {0,1,0,1,1,1,0,1}, {0,1,1,1,0,1,1,1}, {0,1,1,1,1,1,1,1},  //20-23  (0x14-0x17)
	{0,1,0,1,0,1,0,1}, {0,1,0,1,1,1,0,1}, {0,1,1,1,0,1,1,1}, {0,1,1,1,1,1,1,1},  //24-27  (0x18-0x1B)
	{0,1,0,1,0,1,0,1}, {0,1,0,1,1,1,0,1}, {0,1,1,1,0,1,1,1}, {0,1,1,1,1,1,1,1},  //28-31  (0x1C-0x1F)
	{0,1,0,1,0,1,0,1}, {0,1,0,1,1,1,0,1}, {0,1,1,1,0,1,1,1}, {0,1,1,1,1,1,1,1},  //32-35  (0x20-0x23)
	{0,1,0,1,0,1,0,1}, {0,1,0,1,1,1,0,1}, {0,1,1,1,0,1,1,1}, {0,1,1,1,1,1,1,1},  //36-39  (0x24-0x27)
	{0,1,0,1,0,1,0,1}, {0,1,0,1,1,1,0,1}, {0,1,1,1,0,1,1,1}, {0,1,1,1,1,1,1,1},  //40-43  (0x28-0x2B)
	{0,1,0,1,0,1,0,1}, {0,1,0,1,1,1,0,1}, {0,1,1,1,0,1,1,1}, {0,1,1,1,1,1,1,1},  //44-47  (0x2C-0x2F)
	{1,1,1,1,1,1,1,1}, {1,1,1,2,1,1,1,2}, {1,2,1,2,1,2,1,2}, {1,2,2,2,1,2,2,2},  //48-51  (0x30-0x33)
	{2,2,2,2,2,2,2,2}, {2,2,2,4,2,2,2,4}, {2,4,2,4,2,4,2,4}, {2,4,4,4,2,4,4,4},  //52-55  (0x34-0x37)
	{4,4,4,4,4,4,4,4}, {4,4,4,8,4,4,4,8}, {4,8,4,8,4,8,4,8}, {4,8,8,8,4,8,8,8},  //56-59  (0x38-0x3B)
	{8,8,8,8,8,8,8,8}, {8,8,8,8,8,8,8,8}, {8,8,8,8,8,8,8,8}, {8,8,8,8,8,8,8,8}}; //60-63  (0x3C-0x3F)

//----------------------------------------------------------------------------------------
//This table is derived from the detune table given in the YM2608 Application Manual,
//page 26. The negative inverse of the table (detune 4-7) is generated in code.
//----------------------------------------------------------------------------------------
const unsigned int YM2612::detunePhaseIncrementTable[1 << keyCodeBitCount][1 << (detuneBitCount - 1)] = {
//	   Detune        Key-Code
//	 0  1  2  3
	{0, 0, 1, 2},  //0  (0x00)
	{0, 0, 1, 2},  //1  (0x01)
	{0, 0, 1, 2},  //2  (0x02)
	{0, 0, 1, 2},  //3  (0x03)
	{0, 1, 2, 2},  //4  (0x04)
	{0, 1, 2, 3},  //5  (0x05)
	{0, 1, 2, 3},  //6  (0x06)
	{0, 1, 2, 3},  //7  (0x07)
	{0, 1, 2, 4},  //8  (0x08)
	{0, 1, 3, 4},  //9  (0x09)
	{0, 1, 3, 4},  //10 (0x0A)
	{0, 1, 3, 5},  //11 (0x0B)
	{0, 2, 4, 5},  //12 (0x0C)
	{0, 2, 4, 6},  //13 (0x0D)
	{0, 2, 4, 6},  //14 (0x0E)
	{0, 2, 5, 7},  //15 (0x0F)
	{0, 2, 5, 8},  //16 (0x10)
	{0, 3, 6, 8},  //17 (0x11)
	{0, 3, 6, 9},  //18 (0x12)
	{0, 3, 7,10},  //19 (0x13)
	{0, 4, 8,11},  //20 (0x14)
	{0, 4, 8,12},  //21 (0x15)
	{0, 4, 9,13},  //22 (0x16)
	{0, 5,10,14},  //23 (0x17)
	{0, 5,11,16},  //24 (0x18)
	{0, 6,12,17},  //25 (0x19)
	{0, 6,13,19},  //26 (0x1A)
	{0, 7,14,20},  //27 (0x1B)
	{0, 8,16,22},  //28 (0x1C)
	{0, 8,16,22},  //29 (0x1D)
	{0, 8,16,22},  //30 (0x1E)
	{0, 8,16,22}}; //31 (0x1F)

//----------------------------------------------------------------------------------------
const unsigned int YM2612::phaseModIncrementTable[1 << pmsBitCount][1 << (phaseModIndexBitCount - 2)] = {
	{0, 0, 0, 0, 0, 0, 0, 0},  //0
	{0, 0, 0, 0, 1, 1, 1, 1},  //1
	{0, 0, 0, 1, 1, 1, 2, 2},  //2
	{0, 0, 1, 1, 2, 2, 3, 3},  //3
	{0, 0, 1, 2, 2, 2, 3, 4},  //4
	{0, 0, 2, 3, 4, 4, 5, 6},  //5
	{0, 0, 4, 6, 8, 8,10,12},  //6
	{0, 0, 8,12,16,16,20,24}}; //7

//----------------------------------------------------------------------------------------
const unsigned int YM2612::channelAddressOffsets[channelCount] = {
	0,                         //Channel 1
	1,                         //Channel 2
	2,                         //Channel 3
	registerCountPerPart + 0,  //Channel 4
	registerCountPerPart + 1,  //Channel 5
	registerCountPerPart + 2}; //Channel 6

//----------------------------------------------------------------------------------------
const unsigned int YM2612::operatorAddressOffsets[channelCount][operatorCount] = {
	{channelAddressOffsets[0] + 0x0, channelAddressOffsets[0] + 0x8, channelAddressOffsets[0] + 0x4, channelAddressOffsets[0] + 0xC},  //Channel 1
	{channelAddressOffsets[1] + 0x0, channelAddressOffsets[1] + 0x8, channelAddressOffsets[1] + 0x4, channelAddressOffsets[1] + 0xC},  //Channel 2
	{channelAddressOffsets[2] + 0x0, channelAddressOffsets[2] + 0x8, channelAddressOffsets[2] + 0x4, channelAddressOffsets[2] + 0xC},  //Channel 3
	{channelAddressOffsets[3] + 0x0, channelAddressOffsets[3] + 0x8, channelAddressOffsets[3] + 0x4, channelAddressOffsets[3] + 0xC},  //Channel 4
	{channelAddressOffsets[4] + 0x0, channelAddressOffsets[4] + 0x8, channelAddressOffsets[4] + 0x4, channelAddressOffsets[4] + 0xC},  //Channel 5
	{channelAddressOffsets[5] + 0x0, channelAddressOffsets[5] + 0x8, channelAddressOffsets[5] + 0x4, channelAddressOffsets[5] + 0xC}}; //Channel 6

//----------------------------------------------------------------------------------------
const unsigned int YM2612::channel3OperatorFrequencyAddressOffsets[2][operatorCount] = {
	{0xA9, 0xAA, 0xA8, 0xA2},
	{0xAD, 0xAE, 0xAC, 0xA6}};

//----------------------------------------------------------------------------------------
//Constructors
//----------------------------------------------------------------------------------------
YM2612::YM2612(const std::wstring& aimplementationName, const std::wstring& ainstanceName, unsigned int amoduleID)
:Device(aimplementationName, ainstanceName, amoduleID),
status(8), bstatus(8), reg(registerCountTotal, false, Data(8)),
latchedFrequencyData(channelCount, Data(8)), blatchedFrequencyData(channelCount, Data(8)),
latchedFrequencyDataCH3(3, Data(8)), blatchedFrequencyDataCH3(3, Data(8)),
timerAOverflowTimes(false)
{
	//Bus interface
	memoryBus = 0;
	icLineState = false;

	//Set the default clock rate parameters
	externalClockRate = 0;
	fmClockDivider = 6;
	egClockDivider = 3;
	outputClockDivider = channelCount * operatorCount;	//24
	timerAClockDivider = 1;
	timerBClockDivider = 16;

	//Initialize the audio output stream
	outputSampleRate = 48000;	//44100;
	outputStream.Open(2, 16, outputSampleRate, outputSampleRate/4, outputSampleRate/20);

	//Initialize the raw register locking state
	for(unsigned int registerNo = 0; registerNo < registerCountTotal; ++registerNo)
	{
		rawRegisterLocking[registerNo] = false;
	}

	//Initialize the key locking state
	for(unsigned int channelNo = 0; channelNo < channelCount; ++channelNo)
	{
		for(unsigned int operatorNo = 0; operatorNo < operatorCount; ++operatorNo)
		{
			keyStateLocking[channelNo][operatorNo] = false;
		}
	}

	//Initialize the timer locking state
	timerAStateLocking.load = false;
	timerAStateLocking.enable = false;
	timerAStateLocking.overflow = false;
	timerAStateLocking.rate = false;
	timerAStateLocking.counter = false;
	timerBStateLocking.load = false;
	timerBStateLocking.enable = false;
	timerBStateLocking.overflow = false;
	timerBStateLocking.rate = false;
	timerBStateLocking.counter = false;
}

//----------------------------------------------------------------------------------------
//Interface version functions
//----------------------------------------------------------------------------------------
unsigned int YM2612::GetIYM2612Version() const
{
	return ThisIYM2612Version();
}

//----------------------------------------------------------------------------------------
//Initialization functions
//----------------------------------------------------------------------------------------
bool YM2612::BuildDevice()
{
	//Build the sin table. This table has been tested and confirmed to be 100% identical
	//to the one in the real chip, by reading the internal operator output using the test
	//register.
	for(unsigned int i = 0; i < (1 << sinTableBitCount); ++i)
	{
		//Calculate the normalized phase value for the input into the sine table. Note
		//that this is calculated as a normalized result from 0.0-1.0 where 0 is not
		//reached, because the phase is calculated as if it was a 9-bit index with the
		//LSB fixed to 1. This was done so that the sine table would be more accurate
		//when it was "mirrored" to create the negative oscillation of the wave. It's
		//also convenient we don't have to worry about a phase of 0, because 0 is an
		//invalid input for a log function, which we need to use below.
		double phaseNormalized = ((double)((i << 1) + 1) / (1 << (sinTableBitCount + 1)));

		//Calculate the pure sine value for the input. Note that we only build a sine
		//table for a quarter of the full oscillation (0-PI/2), since the upper two bits
		//of the full phase are extracted by the external circuit.
		const double pi = 3.14159265358979323846;
		double sinResultNormalized = sin(phaseNormalized * (pi / 2));

		//Convert the sine result from a linear representation of volume, to a
		//logarithmic representation of attenuation. The YM2612 stores values in the sine
		//table in this form because logarithms simplify multiplication down to addition,
		//and this allowed them to attenuate the sine result by the envelope generator
		//output simply by adding the two numbers together.
		double sinResultAsAttenuation = -log(sinResultNormalized) / log(2.0);
		//The division by log(2) is required because the log function is base 10, but the
		//YM2612 uses a base 2 logarithmic value. Dividing the base 10 log result by
		//log10(2) will convert the result to a base 2 logarithmic value, which can then
		//be converted back to a linear value by a pow2 function. In other words:
		//2^(log10(x)/log10(2)) = 2^log2(x) = x
		//If there was a native log2() function provided we could use that instead.

		//Convert the attenuation value to a rounded 12-bit result in 4.8 fixed point
		//format.
		const unsigned int fixedBitCount = 8;
		unsigned int sinResult = (unsigned int)((sinResultAsAttenuation * (1 << fixedBitCount)) + 0.5);

		//Write the result to the table
		sinTable[i] = sinResult;
	}

	//Build the pow table. This table has been tested and confirmed to be 100% identical
	//to the one in the real chip, by reading the internal operator output using the test
	//register.
	for(unsigned int i = 0; i < (1 << powTableBitCount); ++i)
	{
		//Normalize the current index to the range 0.0-1.0. Note that in this case, 0.0
		//is a value which is never actually reached, since we start from i+1. They only
		//did this to keep the result to an 11-bit output. It probably would have been
		//better to simply subtract 1 from every final number and have 1.0 as the input
		//limit instead when building the table, so an input of 0 would output 0x7FF,
		//but they didn't.
		double entryNormalized = (double)(i + 1) / (double)(1 << powTableBitCount);

		//Calculate 2^-entryNormalized
		double resultNormalized = pow(2, -entryNormalized);

		//Convert the normalized result to an 11-bit rounded result
		unsigned int result = (unsigned int)((resultNormalized * (1 << powTableOutputBitCount)) + 0.5);

		//Write the result to the table
		powTable[i] = result;
	}

	//Initialize the wave logging state
	std::wstring captureFolder = GetSystemInterface().GetCapturePath();
	wavLoggingEnabled = false;
	std::wstring wavLoggingFileName = GetDeviceInstanceName() + L".wav";
	wavLoggingPath = PathCombinePaths(captureFolder, wavLoggingFileName);
	for(unsigned int channelNo = 0; channelNo < channelCount; ++channelNo)
	{
		wavLoggingChannelEnabled[channelNo] = false;
		std::wstringstream wavLoggingChannelFileName;
		wavLoggingChannelFileName << GetDeviceInstanceName() << L" - C" << channelNo + 1 << L".wav";
		wavLoggingChannelPath[channelNo] = PathCombinePaths(captureFolder, wavLoggingChannelFileName.str());
		for(unsigned int operatorNo = 0; operatorNo < operatorCount; ++operatorNo)
		{
			wavLoggingOperatorEnabled[channelNo][operatorNo] = false;
			std::wstringstream wavLoggingOperatorFileName;
			wavLoggingOperatorFileName << GetDeviceInstanceName() << L" - C" << channelNo + 1 << L"O" << operatorNo + 1 << L".wav";
			wavLoggingOperatorPath[channelNo][operatorNo] = PathCombinePaths(captureFolder, wavLoggingOperatorFileName.str());
		}
	}

	//Register each data source with the generic data access base class
	std::wstring audioLogExtensionFilter = L"Wave file|wav";
	std::wstring audioLogDefaultExtension = L"wav";
	bool result = true;
	result &= AddGenericDataInfo((new GenericAccessDataInfo(IYM2612DataSource::RawRegister, IGenericAccessDataValue::DataType::UInt))->SetLockingSupported(true)->SetUIntMaxValue(0xFF)->SetIntDisplayMode(IGenericAccessDataValue::IntDisplayMode::Hexadecimal));
	result &= AddGenericDataInfo((new GenericAccessDataInfo(IYM2612DataSource::TestData, IGenericAccessDataValue::DataType::UInt))->SetLockingSupported(true)->SetUIntMaxValue(0xFF)->SetIntDisplayMode(IGenericAccessDataValue::IntDisplayMode::Hexadecimal));
	result &= AddGenericDataInfo((new GenericAccessDataInfo(IYM2612DataSource::LFOEnabled, IGenericAccessDataValue::DataType::Bool))->SetLockingSupported(true));
	result &= AddGenericDataInfo((new GenericAccessDataInfo(IYM2612DataSource::LFOData, IGenericAccessDataValue::DataType::UInt))->SetLockingSupported(true)->SetUIntMaxValue(0x07)->SetIntDisplayMode(IGenericAccessDataValue::IntDisplayMode::Hexadecimal));
	result &= AddGenericDataInfo((new GenericAccessDataInfo(IYM2612DataSource::TimerAData, IGenericAccessDataValue::DataType::UInt))->SetLockingSupported(true)->SetUIntMaxValue(0x3FF)->SetIntDisplayMode(IGenericAccessDataValue::IntDisplayMode::Hexadecimal));
	result &= AddGenericDataInfo((new GenericAccessDataInfo(IYM2612DataSource::TimerBData, IGenericAccessDataValue::DataType::UInt))->SetLockingSupported(true)->SetUIntMaxValue(0xFF)->SetIntDisplayMode(IGenericAccessDataValue::IntDisplayMode::Hexadecimal));
	result &= AddGenericDataInfo((new GenericAccessDataInfo(IYM2612DataSource::CH3Mode, IGenericAccessDataValue::DataType::UInt))->SetLockingSupported(true)->SetUIntMaxValue(0x03)->SetIntDisplayMode(IGenericAccessDataValue::IntDisplayMode::Hexadecimal));
	result &= AddGenericDataInfo((new GenericAccessDataInfo(IYM2612DataSource::TimerBReset, IGenericAccessDataValue::DataType::Bool))->SetLockingSupported(true));
	result &= AddGenericDataInfo((new GenericAccessDataInfo(IYM2612DataSource::TimerAReset, IGenericAccessDataValue::DataType::Bool))->SetLockingSupported(true));
	result &= AddGenericDataInfo((new GenericAccessDataInfo(IYM2612DataSource::TimerBEnable, IGenericAccessDataValue::DataType::Bool))->SetLockingSupported(true));
	result &= AddGenericDataInfo((new GenericAccessDataInfo(IYM2612DataSource::TimerAEnable, IGenericAccessDataValue::DataType::Bool))->SetLockingSupported(true));
	result &= AddGenericDataInfo((new GenericAccessDataInfo(IYM2612DataSource::TimerBLoad, IGenericAccessDataValue::DataType::Bool))->SetLockingSupported(true));
	result &= AddGenericDataInfo((new GenericAccessDataInfo(IYM2612DataSource::TimerALoad, IGenericAccessDataValue::DataType::Bool))->SetLockingSupported(true));
	result &= AddGenericDataInfo((new GenericAccessDataInfo(IYM2612DataSource::DACData, IGenericAccessDataValue::DataType::UInt))->SetLockingSupported(true)->SetUIntMaxValue(0xFF)->SetIntDisplayMode(IGenericAccessDataValue::IntDisplayMode::Hexadecimal));
	result &= AddGenericDataInfo((new GenericAccessDataInfo(IYM2612DataSource::DACEnabled, IGenericAccessDataValue::DataType::Bool))->SetLockingSupported(true));
	result &= AddGenericDataInfo((new GenericAccessDataInfo(IYM2612DataSource::DetuneData, IGenericAccessDataValue::DataType::UInt))->SetLockingSupported(true)->SetUIntMaxValue(0x07)->SetIntDisplayMode(IGenericAccessDataValue::IntDisplayMode::Hexadecimal));
	result &= AddGenericDataInfo((new GenericAccessDataInfo(IYM2612DataSource::MultipleData, IGenericAccessDataValue::DataType::UInt))->SetLockingSupported(true)->SetUIntMaxValue(0x0F)->SetIntDisplayMode(IGenericAccessDataValue::IntDisplayMode::Hexadecimal));
	result &= AddGenericDataInfo((new GenericAccessDataInfo(IYM2612DataSource::TotalLevelData, IGenericAccessDataValue::DataType::UInt))->SetLockingSupported(true)->SetUIntMaxValue(0x7F)->SetIntDisplayMode(IGenericAccessDataValue::IntDisplayMode::Hexadecimal));
	result &= AddGenericDataInfo((new GenericAccessDataInfo(IYM2612DataSource::KeyScaleData, IGenericAccessDataValue::DataType::UInt))->SetLockingSupported(true)->SetUIntMaxValue(0x03)->SetIntDisplayMode(IGenericAccessDataValue::IntDisplayMode::Hexadecimal));
	result &= AddGenericDataInfo((new GenericAccessDataInfo(IYM2612DataSource::AttackRateData, IGenericAccessDataValue::DataType::UInt))->SetLockingSupported(true)->SetUIntMaxValue(0x1F)->SetIntDisplayMode(IGenericAccessDataValue::IntDisplayMode::Hexadecimal));
	result &= AddGenericDataInfo((new GenericAccessDataInfo(IYM2612DataSource::AmplitudeModulationEnabled, IGenericAccessDataValue::DataType::Bool)));
	result &= AddGenericDataInfo((new GenericAccessDataInfo(IYM2612DataSource::DecayRateData, IGenericAccessDataValue::DataType::UInt))->SetLockingSupported(true)->SetUIntMaxValue(0x1F)->SetIntDisplayMode(IGenericAccessDataValue::IntDisplayMode::Hexadecimal));
	result &= AddGenericDataInfo((new GenericAccessDataInfo(IYM2612DataSource::SustainRateData, IGenericAccessDataValue::DataType::UInt))->SetLockingSupported(true)->SetUIntMaxValue(0x1F)->SetIntDisplayMode(IGenericAccessDataValue::IntDisplayMode::Hexadecimal));
	result &= AddGenericDataInfo((new GenericAccessDataInfo(IYM2612DataSource::SustainLevelData, IGenericAccessDataValue::DataType::UInt))->SetLockingSupported(true)->SetUIntMaxValue(0x0F)->SetIntDisplayMode(IGenericAccessDataValue::IntDisplayMode::Hexadecimal));
	result &= AddGenericDataInfo((new GenericAccessDataInfo(IYM2612DataSource::ReleaseRateData, IGenericAccessDataValue::DataType::UInt))->SetLockingSupported(true)->SetUIntMaxValue(0x0F)->SetIntDisplayMode(IGenericAccessDataValue::IntDisplayMode::Hexadecimal));
	result &= AddGenericDataInfo((new GenericAccessDataInfo(IYM2612DataSource::SSGData, IGenericAccessDataValue::DataType::UInt))->SetLockingSupported(true)->SetUIntMaxValue(0x0F)->SetIntDisplayMode(IGenericAccessDataValue::IntDisplayMode::Hexadecimal));
	result &= AddGenericDataInfo((new GenericAccessDataInfo(IYM2612DataSource::SSGEnabled, IGenericAccessDataValue::DataType::Bool))->SetLockingSupported(true));
	result &= AddGenericDataInfo((new GenericAccessDataInfo(IYM2612DataSource::SSGAttack, IGenericAccessDataValue::DataType::Bool))->SetLockingSupported(true));
	result &= AddGenericDataInfo((new GenericAccessDataInfo(IYM2612DataSource::SSGAlternate, IGenericAccessDataValue::DataType::Bool))->SetLockingSupported(true));
	result &= AddGenericDataInfo((new GenericAccessDataInfo(IYM2612DataSource::SSGHold, IGenericAccessDataValue::DataType::Bool))->SetLockingSupported(true));
	result &= AddGenericDataInfo((new GenericAccessDataInfo(IYM2612DataSource::FrequencyData, IGenericAccessDataValue::DataType::UInt))->SetLockingSupported(true)->SetUIntMaxValue(0x7FF)->SetIntDisplayMode(IGenericAccessDataValue::IntDisplayMode::Hexadecimal));
	result &= AddGenericDataInfo((new GenericAccessDataInfo(IYM2612DataSource::BlockData, IGenericAccessDataValue::DataType::UInt))->SetLockingSupported(true)->SetUIntMaxValue(0x03)->SetIntDisplayMode(IGenericAccessDataValue::IntDisplayMode::Hexadecimal));
	result &= AddGenericDataInfo((new GenericAccessDataInfo(IYM2612DataSource::FrequencyDataChannel3, IGenericAccessDataValue::DataType::UInt))->SetLockingSupported(true)->SetUIntMaxValue(0x7FF)->SetIntDisplayMode(IGenericAccessDataValue::IntDisplayMode::Hexadecimal));
	result &= AddGenericDataInfo((new GenericAccessDataInfo(IYM2612DataSource::BlockDataChannel3, IGenericAccessDataValue::DataType::UInt))->SetLockingSupported(true)->SetUIntMaxValue(0x03)->SetIntDisplayMode(IGenericAccessDataValue::IntDisplayMode::Hexadecimal));
	result &= AddGenericDataInfo((new GenericAccessDataInfo(IYM2612DataSource::FeedbackData, IGenericAccessDataValue::DataType::UInt))->SetLockingSupported(true)->SetUIntMaxValue(0x07)->SetIntDisplayMode(IGenericAccessDataValue::IntDisplayMode::Hexadecimal));
	result &= AddGenericDataInfo((new GenericAccessDataInfo(IYM2612DataSource::AlgorithmData, IGenericAccessDataValue::DataType::UInt))->SetLockingSupported(true)->SetUIntMaxValue(0x07)->SetIntDisplayMode(IGenericAccessDataValue::IntDisplayMode::Hexadecimal));
	result &= AddGenericDataInfo((new GenericAccessDataInfo(IYM2612DataSource::OutputLeft, IGenericAccessDataValue::DataType::Bool))->SetLockingSupported(true));
	result &= AddGenericDataInfo((new GenericAccessDataInfo(IYM2612DataSource::OutputRight, IGenericAccessDataValue::DataType::Bool))->SetLockingSupported(true));
	result &= AddGenericDataInfo((new GenericAccessDataInfo(IYM2612DataSource::AMSData, IGenericAccessDataValue::DataType::UInt))->SetLockingSupported(true)->SetUIntMaxValue(0x03)->SetIntDisplayMode(IGenericAccessDataValue::IntDisplayMode::Hexadecimal));
	result &= AddGenericDataInfo((new GenericAccessDataInfo(IYM2612DataSource::PMSData, IGenericAccessDataValue::DataType::UInt))->SetLockingSupported(true)->SetUIntMaxValue(0x07)->SetIntDisplayMode(IGenericAccessDataValue::IntDisplayMode::Hexadecimal));
	result &= AddGenericDataInfo((new GenericAccessDataInfo(IYM2612DataSource::KeyState, IGenericAccessDataValue::DataType::Bool))->SetLockingSupported(true));
	result &= AddGenericDataInfo((new GenericAccessDataInfo(IYM2612DataSource::StatusRegister, IGenericAccessDataValue::DataType::UInt))->SetLockingSupported(true)->SetUIntMaxValue(0xFF)->SetIntDisplayMode(IGenericAccessDataValue::IntDisplayMode::Hexadecimal));
	result &= AddGenericDataInfo((new GenericAccessDataInfo(IYM2612DataSource::BusyFlag, IGenericAccessDataValue::DataType::Bool))->SetLockingSupported(true));
	result &= AddGenericDataInfo((new GenericAccessDataInfo(IYM2612DataSource::TimerBOverflow, IGenericAccessDataValue::DataType::Bool))->SetLockingSupported(true));
	result &= AddGenericDataInfo((new GenericAccessDataInfo(IYM2612DataSource::TimerAOverflow, IGenericAccessDataValue::DataType::Bool))->SetLockingSupported(true));
	result &= AddGenericDataInfo((new GenericAccessDataInfo(IYM2612DataSource::TimerACurrentCounter, IGenericAccessDataValue::DataType::UInt))->SetLockingSupported(true)->SetUIntMaxValue(0x3FF)->SetIntDisplayMode(IGenericAccessDataValue::IntDisplayMode::Hexadecimal));
	result &= AddGenericDataInfo((new GenericAccessDataInfo(IYM2612DataSource::TimerBCurrentCounter, IGenericAccessDataValue::DataType::UInt))->SetLockingSupported(true)->SetUIntMaxValue(0xFF)->SetIntDisplayMode(IGenericAccessDataValue::IntDisplayMode::Hexadecimal));
	result &= AddGenericDataInfo((new GenericAccessDataInfo(IYM2612DataSource::ExternalClockRate, IGenericAccessDataValue::DataType::Double)));
	result &= AddGenericDataInfo((new GenericAccessDataInfo(IYM2612DataSource::FMClockDivider, IGenericAccessDataValue::DataType::UInt)));
	result &= AddGenericDataInfo((new GenericAccessDataInfo(IYM2612DataSource::EGClockDivider, IGenericAccessDataValue::DataType::UInt)));
	result &= AddGenericDataInfo((new GenericAccessDataInfo(IYM2612DataSource::OutputClockDivider, IGenericAccessDataValue::DataType::UInt)));
	result &= AddGenericDataInfo((new GenericAccessDataInfo(IYM2612DataSource::TimerAClockDivider, IGenericAccessDataValue::DataType::UInt)));
	result &= AddGenericDataInfo((new GenericAccessDataInfo(IYM2612DataSource::TimerBClockDivider, IGenericAccessDataValue::DataType::UInt)));
	result &= AddGenericDataInfo((new GenericAccessDataInfo(IYM2612DataSource::AudioLoggingEnabled, IGenericAccessDataValue::DataType::Bool)));
	result &= AddGenericDataInfo((new GenericAccessDataInfo(IYM2612DataSource::AudioLoggingPath, IGenericAccessDataValue::DataType::FilePath))->SetFilePathExtensionFilter(audioLogExtensionFilter)->SetFilePathDefaultExtension(audioLogDefaultExtension)->SetFilePathCreatingTarget(true));
	result &= AddGenericDataInfo((new GenericAccessDataInfo(IYM2612DataSource::ChannelAudioLoggingEnabled, IGenericAccessDataValue::DataType::Bool)));
	result &= AddGenericDataInfo((new GenericAccessDataInfo(IYM2612DataSource::ChannelAudioLoggingPath, IGenericAccessDataValue::DataType::FilePath))->SetFilePathExtensionFilter(audioLogExtensionFilter)->SetFilePathDefaultExtension(audioLogDefaultExtension)->SetFilePathCreatingTarget(true));
	result &= AddGenericDataInfo((new GenericAccessDataInfo(IYM2612DataSource::OperatorAudioLoggingEnabled, IGenericAccessDataValue::DataType::Bool)));
	result &= AddGenericDataInfo((new GenericAccessDataInfo(IYM2612DataSource::OperatorAudioLoggingPath, IGenericAccessDataValue::DataType::FilePath))->SetFilePathExtensionFilter(audioLogExtensionFilter)->SetFilePathDefaultExtension(audioLogDefaultExtension)->SetFilePathCreatingTarget(true));

	//Register page layouts for generic access to this device
	GenericAccessPage* audioLoggingPage = new GenericAccessPage(L"Audio Logging", L"Audio Logging");
	audioLoggingPage->AddEntry((new GenericAccessGroup(L"Combined Output"))
	                    ->AddEntry(new GenericAccessGroupDataEntry(IYM2612DataSource::AudioLoggingEnabled, L"Log Enabled"))
	                    ->AddEntry(new GenericAccessGroupDataEntry(IYM2612DataSource::AudioLoggingPath, L"Log Path")));
	GenericAccessGroup* channelGroup = new GenericAccessGroup(L"Channel Output");
	for(unsigned int channelNo = 0; channelNo < channelCount; ++channelNo)
	{
		std::wstring channelNoAsString;
		IntToString(channelNo + 1, channelNoAsString);
		channelGroup->AddEntry((new GenericAccessGroupDataEntry(IYM2612DataSource::ChannelAudioLoggingEnabled, L"Channel " + channelNoAsString + L" Log Enabled"))->SetDataContext(new ChannelDataContext(channelNo)));
	}
	for(unsigned int channelNo = 0; channelNo < channelCount; ++channelNo)
	{
		std::wstring channelNoAsString;
		IntToString(channelNo + 1, channelNoAsString);
		channelGroup->AddEntry((new GenericAccessGroupDataEntry(IYM2612DataSource::ChannelAudioLoggingPath, L"Channel " + channelNoAsString + L" Log Path"))->SetDataContext(new ChannelDataContext(channelNo)));
	}
	audioLoggingPage->AddEntry(channelGroup);
	GenericAccessGroup* operatorGroup = new GenericAccessGroup(L"Operator Output");
	for(unsigned int channelNo = 0; channelNo < channelCount; ++channelNo)
	{
		std::wstring channelNoAsString;
		IntToString(channelNo + 1, channelNoAsString);
		GenericAccessGroup* channelGroupForOperators = (new GenericAccessGroup(L"Channel " + channelNoAsString))->SetOpenByDefault(false);
		for(unsigned int operatorNo = 0; operatorNo < operatorCount; ++operatorNo)
		{
			std::wstring operatorNoAsString;
			IntToString(operatorNo + 1, operatorNoAsString);
			channelGroupForOperators->AddEntry((new GenericAccessGroupDataEntry(IYM2612DataSource::OperatorAudioLoggingEnabled, L"Operator " + operatorNoAsString + L" Log Enabled"))->SetDataContext(new OperatorDataContext(channelNo, operatorNo)));
		}
		for(unsigned int operatorNo = 0; operatorNo < operatorCount; ++operatorNo)
		{
			std::wstring operatorNoAsString;
			IntToString(operatorNo + 1, operatorNoAsString);
			channelGroupForOperators->AddEntry((new GenericAccessGroupDataEntry(IYM2612DataSource::OperatorAudioLoggingPath, L"Operator " + operatorNoAsString + L" Log Path"))->SetDataContext(new OperatorDataContext(channelNo, operatorNo)));
		}
		operatorGroup->AddEntry(channelGroupForOperators);
	}
	audioLoggingPage->AddEntry(operatorGroup);
	result &= AddGenericAccessPage(audioLoggingPage);

	return result;
}

//----------------------------------------------------------------------------------------
bool YM2612::ValidateDevice()
{
	return (externalClockRate != 0.0);
}

//----------------------------------------------------------------------------------------
void YM2612::Initialize()
{
	//All registers are initialized to 0, with one exception. The Left/Right output flags
	//for the accumulator both power up selected for all channels. Without support for
	//this, the SEGA sound for Sonic 1 on the Mega Drive fails to play. This exception
	//probably only exists for compatibility reasons. The YM2612 aims for a degree of
	//compatibility with the YM2203(OPN), and this chip didn't have the L/R registers. If
	//the YM2612 powered up with these registers unset, all legacy code would require
	//modification in order to set these flags, otherwise no sound would be produced. The
	//YM2608 would also select these flags by default, as it has an even greater focus on
	//YM2203 compatibility.
	reg.Initialize();
	timerAOverflowTimes.Initialize();
	currentReg = 0;
	status = 0;

	//Bus interface
	icLineState = false;

	//We have confirmed that the YM2612 powers up with output enabled to both the left and
	//right speakers for all channels.
	for(unsigned int channelNo = 0; channelNo < channelCount; ++channelNo)
	{
		unsigned int channelAddressOffset = GetChannelBlockAddressOffset(channelNo);
		SetOutputLeft(channelAddressOffset, true, AccessTarget().AccessLatest());
		SetOutputRight(channelAddressOffset, true, AccessTarget().AccessLatest());
	}

	//Initialize the timer state
	lastTimesliceLength = 0;
	timersLastUpdateTime = 0;
	timersRemainingTime = 0;
	timerARemainingCycles = 0;
	timerBRemainingCycles = 0;
	timerACounter = 0;
	timerBCounter = 0;
	timerAInitialCounter = 0;
	timerBInitialCounter = 0;
	timerAEnable = false;
	timerBEnable = false;
	timerALoad = false;
	timerBLoad = false;
	irqLineState = false;

	//Initialize the render thread properties
	remainingRenderTime = 0;
	egRemainingRenderCycles = 0;
	outputBuffer.clear();

	//Clear all register latch data
	for(unsigned int channelNo = 0; channelNo < channelCount; ++channelNo)
	{
		latchedFrequencyDataPending[channelNo] = false;
		latchedFrequencyData[channelNo] = 0;
	}
	for(unsigned int regNo = 0; regNo < 3; ++regNo)
	{
		latchedFrequencyDataPendingCH3[regNo] = false;
		latchedFrequencyDataCH3[regNo] = 0;
	}

	//Initialize the envelope generator state
	envelopeCycleCounter = 0;
	cyclesUntilLFOIncrement = 0;
	currentLFOCounter = 0;
	for(unsigned int channelNo = 0; channelNo < channelCount; ++channelNo)
	{
		for(unsigned int operatorNo = 0; operatorNo < operatorCount; ++operatorNo)
		{
			operatorData[channelNo][operatorNo].phase = OperatorData::ADSR_RELEASE;
			operatorData[channelNo][operatorNo].keyonPrevious = false;
			operatorData[channelNo][operatorNo].keyon = false;
			operatorData[channelNo][operatorNo].csmKeyOn = false;
			operatorData[channelNo][operatorNo].attenuation = (1 << attenuationBitCount) - 1;
			operatorData[channelNo][operatorNo].ssgOutputInverted = false;
		}
	}

	//Fix any locked registers at their set value
	std::unique_lock<std::mutex> lock2(registerLockMutex);
	for(std::map<unsigned int, std::list<RegisterLocking>>::const_iterator lockedRegisterStateIterator = lockedRegisterState.begin(); lockedRegisterStateIterator != lockedRegisterState.end(); ++lockedRegisterStateIterator)
	{
		for(std::list<RegisterLocking>::const_iterator i = lockedRegisterStateIterator->second.begin(); i != lockedRegisterStateIterator->second.end(); ++i)
		{
			WriteGenericData(i->dataID, i->GetDataContext(), i->lockedValue);
		}
	}
}

//----------------------------------------------------------------------------------------
void YM2612::Reset(double accessTime)
{
	//Initialize all our internal registers to 0
	std::unique_lock<std::mutex> lock(accessMutex);
	AccessTarget accessTarget;
	if(reg.DoesLatestTimesliceExist())
	{
		accessTarget.AccessTime(accessTime);
	}
	else
	{
		accessTarget.AccessLatest();
	}
	for(unsigned int i = 0; i < registerCountTotal; ++i)
	{
		Data data(8, 0);
		RegisterSpecialUpdateFunction(i, data, accessTime, GetDeviceContext(), 0);
		SetRegisterData(i, data, accessTarget);
	}

	//We have confirmed that the YM2612 powers up with output enabled to both the left and
	//right speakers for all channels.
	for(unsigned int channelNo = 0; channelNo < channelCount; ++channelNo)
	{
		unsigned int channelAddressOffset = GetChannelBlockAddressOffset(channelNo);
		SetOutputLeft(channelAddressOffset, true, AccessTarget().AccessLatest());
		SetOutputRight(channelAddressOffset, true, AccessTarget().AccessLatest());
	}

	//Fix any locked registers at their set value
	std::unique_lock<std::mutex> lock2(registerLockMutex);
	for(std::map<unsigned int, std::list<RegisterLocking>>::const_iterator lockedRegisterStateIterator = lockedRegisterState.begin(); lockedRegisterStateIterator != lockedRegisterState.end(); ++lockedRegisterStateIterator)
	{
		for(std::list<RegisterLocking>::const_iterator i = lockedRegisterStateIterator->second.begin(); i != lockedRegisterStateIterator->second.end(); ++i)
		{
			WriteGenericData(i->dataID, i->GetDataContext(), i->lockedValue);
		}
	}
}

//----------------------------------------------------------------------------------------
//Reference functions
//----------------------------------------------------------------------------------------
bool YM2612::AddReference(const MarshalSupport::Marshal::In<std::wstring>& referenceName, IBusInterface* target)
{
	if(referenceName == L"BusInterface")
	{
		memoryBus = target;
	}
	else
	{
		return false;
	}
	return true;
}

//----------------------------------------------------------------------------------------
void YM2612::RemoveReference(IBusInterface* target)
{
	if(memoryBus == target)
	{
		memoryBus = 0;
	}
}

//----------------------------------------------------------------------------------------
//Line functions
//----------------------------------------------------------------------------------------
unsigned int YM2612::GetLineID(const MarshalSupport::Marshal::In<std::wstring>& lineName) const
{
	if(lineName == L"IRQ")     //O
	{
		return (unsigned int)LineID::IRQ;
	}
	else if(lineName == L"IC") //I
	{
		return (unsigned int)LineID::IC;
	}
	return 0;
}

//----------------------------------------------------------------------------------------
MarshalSupport::Marshal::Ret<std::wstring> YM2612::GetLineName(unsigned int lineID) const
{
	switch((LineID)lineID)
	{
	case LineID::IRQ:
		return L"IRQ";
	case LineID::IC:
		return L"IC";
	}
	return L"";
}

//----------------------------------------------------------------------------------------
unsigned int YM2612::GetLineWidth(unsigned int lineID) const
{
	switch((LineID)lineID)
	{
	case LineID::IRQ:
		return 1;
	case LineID::IC:
		return 1;
	}
	return 0;
}

//----------------------------------------------------------------------------------------
void YM2612::SetLineState(unsigned int targetLine, const Data& lineData, IDeviceContext* caller, double accessTime, unsigned int accessContext)
{
	std::unique_lock<std::mutex> lock(lineMutex);

	//Process the line state change
	switch((LineID)targetLine)
	{
	case LineID::IC:{
		bool icLineStateNew = lineData.LSB();
		if(icLineStateNew != icLineState)
		{
			icLineState = icLineStateNew;
			Reset(accessTime);
		}
		break;}
	}
}

//----------------------------------------------------------------------------------------
void YM2612::AssertCurrentOutputLineState() const
{
	if(memoryBus != 0)
	{
		if(irqLineState) memoryBus->SetLineState((unsigned int)LineID::IRQ, Data(GetLineWidth((unsigned int)LineID::IRQ), 1), GetDeviceContext(), GetDeviceContext(), GetCurrentTimesliceProgress(), 0);
	}
}

//----------------------------------------------------------------------------------------
void YM2612::NegateCurrentOutputLineState() const
{
	if(memoryBus != 0)
	{
		if(irqLineState) memoryBus->SetLineState((unsigned int)LineID::IRQ, Data(GetLineWidth((unsigned int)LineID::IRQ), 0), GetDeviceContext(), GetDeviceContext(), GetCurrentTimesliceProgress(), 0);
	}
}

//----------------------------------------------------------------------------------------
//Clock source functions
//----------------------------------------------------------------------------------------
unsigned int YM2612::GetClockSourceID(const MarshalSupport::Marshal::In<std::wstring>& clockSourceName) const
{
	if(clockSourceName == L"0M")
	{
		return (unsigned int)ClockID::C0M;
	}
	return 0;
}

//----------------------------------------------------------------------------------------
MarshalSupport::Marshal::Ret<std::wstring> YM2612::GetClockSourceName(unsigned int clockSourceID) const
{
	switch((ClockID)clockSourceID)
	{
	case ClockID::C0M:
		return L"0M";
	}
	return L"";
}

//----------------------------------------------------------------------------------------
void YM2612::SetClockSourceRate(unsigned int clockInput, double clockRate, IDeviceContext* caller, double accessTime, unsigned int accessContext)
{
	//Apply the input clock rate change
	if((ClockID)clockInput == ClockID::C0M)
	{
		externalClockRate = clockRate;
	}

	//Since a clock rate change will affect our timing point calculations, trigger a
	//rollback.
	GetSystemInterface().SetSystemRollback(GetDeviceContext(), caller, accessTime, accessContext);
}

//----------------------------------------------------------------------------------------
void YM2612::TransparentSetClockSourceRate(unsigned int clockInput, double clockRate)
{
	//Apply the input clock rate change
	if((ClockID)clockInput == ClockID::C0M)
	{
		externalClockRate = clockRate;
	}
}

//----------------------------------------------------------------------------------------
//Execute functions
//----------------------------------------------------------------------------------------
void YM2612::BeginExecution()
{
	//Initialize the worker thread state
	pendingRenderOperationCount = 0;
	renderThreadLagging = false;
	regTimesliceList.clear();
	timerATimesliceList.clear();

	//Start the render worker thread
	renderThreadActive = true;
	std::thread workerThread(std::bind(std::mem_fn(&YM2612::RenderThread), this));
	workerThread.detach();
}

//----------------------------------------------------------------------------------------
void YM2612::SuspendExecution()
{
	std::unique_lock<std::mutex> lock(renderThreadMutex);

	//Suspend the render worker thread
	if(renderThreadActive)
	{
		renderThreadActive = false;
		renderThreadUpdate.notify_all();
		renderThreadStopped.wait(lock);
	}
}

//----------------------------------------------------------------------------------------
YM2612::UpdateMethod YM2612::GetUpdateMethod() const
{
	return UpdateMethod::Timeslice;
}

//----------------------------------------------------------------------------------------
bool YM2612::SendNotifyUpcomingTimeslice() const
{
	return true;
}

//----------------------------------------------------------------------------------------
void YM2612::NotifyUpcomingTimeslice(double nanoseconds)
{
	//Update the timer status, and reset the last access time for each timer. We need to
	//perform this operation here, as we calculate the amount of time that has passed
	//between timer updates based on the progress through the current timeslice. Since
	//we're now switching to a new timeslice, we need to advance to the end of the last
	//timeslice and reset the access time.
	if(lastTimesliceLength > 0)
	{
		std::unique_lock<std::mutex> lock(accessMutex);
		UpdateTimers(lastTimesliceLength);
	}
	timersLastUpdateTime = 0;

	lastTimesliceLength = nanoseconds;
	lastAccessTime = 0;

	//Add the new timeslice to all our timed buffers
	reg.AddTimeslice(nanoseconds);
	timerAOverflowTimes.AddTimeslice(nanoseconds);

	//Add references to the new timeslice entry from our timed buffers to the uncommitted
	//timeslice lists for the buffers
	regTimesliceListUncommitted.push_back(reg.GetLatestTimeslice());
	timerATimesliceListUncommitted.push_back(timerAOverflowTimes.GetLatestTimeslice());
}

//----------------------------------------------------------------------------------------
void YM2612::ExecuteTimeslice(double nanoseconds)
{
	//If the render thread is lagging, pause here until it has caught up, so we don't
	//leave the render thread behind with an ever-increasing workload it will never be
	//able to complete.
	if(renderThreadLagging)
	{
		std::unique_lock<std::mutex> lock(timesliceMutex);
		while(renderThreadLagging)
		{
			renderThreadLaggingStateChange.wait(lock);
		}
	}
}

//----------------------------------------------------------------------------------------
void YM2612::ExecuteRollback()
{
	//Clock settings
	externalClockRate = bexternalClockRate;

	//Bus interface
	icLineState = bicLineState;

	//Rollback our timed buffers
	reg.Rollback();
	timerAOverflowTimes.Rollback();

	//Rollback our port registers
	currentReg = bcurrentReg;
	status = bstatus;

	//Rollback the register latch data
	for(unsigned int i = 0; i < channelCount; ++i)
	{
		latchedFrequencyDataPending[i] = blatchedFrequencyDataPending[i];
		latchedFrequencyData[i] = blatchedFrequencyData[i];
	}
	for(unsigned int i = 0; i < 3; ++i)
	{
		latchedFrequencyDataPendingCH3[i] = blatchedFrequencyDataPendingCH3[i];
		latchedFrequencyDataCH3[i] = blatchedFrequencyDataCH3[i];
	}

	//Rollback the timer data
	timersRemainingTime = btimersRemainingTime;
	timerARemainingCycles = btimerARemainingCycles;
	timerBRemainingCycles = btimerBRemainingCycles;
	timerACounter = btimerACounter;
	timerBCounter = btimerBCounter;
	timerAInitialCounter = btimerAInitialCounter;
	timerBInitialCounter = btimerBInitialCounter;
	timerAEnable = btimerAEnable;
	timerBEnable = btimerBEnable;
	timerALoad = btimerALoad;
	timerBLoad = btimerBLoad;
	irqLineState = birqLineState;

	//Clear any uncommitted timeslices from our render timeslice buffers
	regTimesliceListUncommitted.clear();
	timerATimesliceListUncommitted.clear();
}

//----------------------------------------------------------------------------------------
void YM2612::ExecuteCommit()
{
	//Clock settings
	bexternalClockRate = externalClockRate;

	//Bus interface
	bicLineState = icLineState;

	//Commit our timed buffers
	reg.Commit();
	timerAOverflowTimes.Commit();

	//Take a backup of our port registers
	bcurrentReg = currentReg;
	bstatus = status;

	//Take a backup of the register latch data
	for(unsigned int i = 0; i < channelCount; ++i)
	{
		blatchedFrequencyDataPending[i] = latchedFrequencyDataPending[i];
		blatchedFrequencyData[i] = latchedFrequencyData[i];
	}
	for(unsigned int i = 0; i < 3; ++i)
	{
		blatchedFrequencyDataPendingCH3[i] = latchedFrequencyDataPendingCH3[i];
		blatchedFrequencyDataCH3[i] = latchedFrequencyDataCH3[i];
	}

	//Take a backup of the timer data
	btimersRemainingTime = timersRemainingTime;
	btimerARemainingCycles = timerARemainingCycles;
	btimerBRemainingCycles = timerBRemainingCycles;
	btimerACounter = timerACounter;
	btimerBCounter = timerBCounter;
	btimerAInitialCounter = timerAInitialCounter;
	btimerBInitialCounter = timerBInitialCounter;
	btimerAEnable = timerAEnable;
	btimerBEnable = timerBEnable;
	btimerALoad = timerALoad;
	btimerBLoad = timerBLoad;
	birqLineState = irqLineState;

	//Ensure that a valid latest timeslice exists in all our buffers. We need this
	//check here, because commits can be triggered by the system at potentially any
	//point in time, whether a timeslice has been issued or not.
	if(!regTimesliceListUncommitted.empty() && !timerATimesliceListUncommitted.empty())
	{
		//Obtain a timeslice lock so we can update the data we feed to the render
		//thread
		std::unique_lock<std::mutex> lock(timesliceMutex);

		//Add the number of timeslices we are about to commit to the count of pending
		//render operations. This is used to track if the render thread is lagging.
		pendingRenderOperationCount += (unsigned int)regTimesliceListUncommitted.size();

		//Move all timeslices in our uncommitted timeslice lists over to the committed
		//timeslice lists, for processing by the render thread.
		regTimesliceList.splice(regTimesliceList.end(), regTimesliceListUncommitted);
		timerATimesliceList.splice(timerATimesliceList.end(), timerATimesliceListUncommitted);

		//Notify the render thread that it's got more work to do
		renderThreadUpdate.notify_all();
	}
}

//----------------------------------------------------------------------------------------
//##TODO## Refactor this function to break it down into a set of smaller functions
void YM2612::RenderThread()
{
	std::unique_lock<std::mutex> lock(renderThreadMutex);

	//Start the render loop
	bool done = false;
	while(!done)
	{
		//Obtain a copy of the latest completed timeslice period
		RandomTimeAccessBuffer<Data, double>::Timeslice regTimesliceCopy;
		RandomTimeAccessValue<bool, double>::Timeslice timerATimesliceCopy;
		bool renderTimesliceObtained = false;
		{
			std::unique_lock<std::mutex> timesliceLock(timesliceMutex);

			//If there is at least one render timeslice pending, grab it from the queue.
			if(!regTimesliceList.empty() && !timerATimesliceList.empty())
			{
				//Update the lagging state for the render thread
				--pendingRenderOperationCount;
				renderThreadLagging = (pendingRenderOperationCount > maxPendingRenderOperationCount);
				renderThreadLaggingStateChange.notify_all();

				//Grab the next completed timeslice from the timeslice list
				regTimesliceCopy = *regTimesliceList.begin();
				timerATimesliceCopy = *timerATimesliceList.begin();
				regTimesliceList.pop_front();
				timerATimesliceList.pop_front();

				//Flag that we managed to obtain a render timeslice
				renderTimesliceObtained = true;
			}
		}

		//If no render timeslice was available, we need to wait for a thread suspension
		//request or a new timeslice to be received, then begin the loop again.
		if(!renderTimesliceObtained)
		{
			//If the render thread has not already been instructed to stop, suspend this
			//thread until a timeslice becomes available or this thread is instructed to
			//stop.
			if(renderThreadActive)
			{
				renderThreadUpdate.wait(lock);
			}

			//If the render thread has been suspended, flag that we need to exit this
			//render loop.
			done = !renderThreadActive;

			//Begin the loop again
			continue;
		}

		AccessTarget accessTarget;
		accessTarget.AccessCommitted();

		//Calculate the FM clock period
		double fmClock = (externalClockRate / fmClockDivider) / outputClockDivider;
		double fmClockPeriod = 1000000000 / fmClock;

		//Render the YM2612 output
		size_t outputBufferPos = outputBuffer.size();
//		unsigned int outputBufferMultiplexedPos = 0;
//		std::vector<short> outputBufferMultiplexed(0);
		bool moreSamplesRemaining = true;
		while(moreSamplesRemaining)
		{
			//Determine the time of the next write. Note that currently, this may be
			//negative under certain circumstances, in particular when a write occurs past
			//the end of a timeslice. Negative times won't cause writes to be processed at
			//the incorrect time under the current model, but we do need to ensure that
			//remainingRenderTime isn't negative before attempting to generate an output.
			remainingRenderTime += reg.GetNextWriteTime(regTimesliceCopy);

			//##DEBUG##
//			std::wcout << "YM2612 Buffer:\t" << remainingRenderTime << '\t' << outputBuffer.size() << '\t' << ((unsigned int)(remainingRenderTime / fmClockPeriod) * 2) << '\n';

			//Calculate the output sample count. Note that remainingRenderTime may be
			//negative, but we catch that below before using outputSampleCount.
			unsigned int outputSampleCount = ((unsigned int)(remainingRenderTime / fmClockPeriod) * 2);

			//If we have one or more output samples to generate before the next settings
			//change or the end of the target timeslice, generate and output the samples.
			if((remainingRenderTime > 0) && (outputSampleCount > 0))
			{
				//Resize the output buffer to fit the samples we're about to add
				outputBuffer.resize(outputBuffer.size() + outputSampleCount);
	//			outputBufferMultiplexed.resize(outputBufferMultiplexed.size() + (outputSampleCount * channelCount));

				//##TODO## Change the way we advance the render thread so that the update
				//steps are driven by integer cycle numbers, rather than timeslice values.
				//Refer to the timer update function.
				while(remainingRenderTime >= fmClockPeriod)
				{
					//If CSM mode is active, advance the timer A overflow buffer by one step.
					//We make this conditional as an optimization, to prevent the need to
					//advance the timer A overflow buffer at such a fine resolution every
					//update cycle, for such a rarely used feature. We use a larger update
					//step later on for cases where CSM mode is inactive.
					if(GetCH3Mode(accessTarget) == 2)
					{
						//Reset the committed state. We do this before each update, as we use
						//the overflow value as a signal line which is only asserted when an
						//overflow has occurred after the last update. Each write always sets
						//it to true, and we reset it once that write has been processed.
						timerAOverflowTimes.WriteCommitted(false);
						//Advance the buffer
						timerAOverflowTimes.AdvanceByTime(fmClockPeriod, timerATimesliceCopy);
					}

					//Advance the global envelope generator state, and determine whether an
					//envelope generator update cycle needs to run for each operator on this
					//update step.
					bool updateEnvelopeGenerator = false;
					--egRemainingRenderCycles;
					if(egRemainingRenderCycles <= 0)
					{
						egRemainingRenderCycles = (int)egClockDivider;
						++envelopeCycleCounter;
						updateEnvelopeGenerator = true;
					}

					//Update the state of the envelope and phase generators for each operator
					for(unsigned int channelNo = 0; channelNo < channelCount; ++channelNo)
					{
						for(unsigned int operatorNo = 0; operatorNo < operatorCount; ++operatorNo)
						{
							UpdateOperator(channelNo, operatorNo, updateEnvelopeGenerator);
						}
					}

					//Update the LFO
					if(GetLFOEnabled(accessTarget))
					{
						--cyclesUntilLFOIncrement;
						if(cyclesUntilLFOIncrement <= 0)
						{
							const unsigned int lfoIncrementValues[8] = {108, 77, 71, 67, 62, 44, 8, 5};
							unsigned int lfoData = GetLFOData(accessTarget);
							cyclesUntilLFOIncrement = lfoIncrementValues[lfoData];
							++currentLFOCounter;
						}
					}
					else
					{
						//If the LFO is disabled, the LFO counter is forced to 0
						currentLFOCounter = 0;
					}

					//Calculate the FM output for each channel in the YM2612 for this sample
					int channelOutput[channelCount][2];
					for(unsigned int channelNo = 0; channelNo < channelCount; ++channelNo)
					{
						//Calculate the address offset for all channel registers for the
						//target channel
						unsigned int channelAddressOffset = GetChannelBlockAddressOffset(channelNo);

						//Read the current algorithm selection for the channel
						unsigned int algorithmNo = GetAlgorithmData(channelAddressOffset, accessTarget);

						//Calculate the output for each operator in the channel
						for(unsigned int operatorNo = 0; operatorNo < operatorCount; ++operatorNo)
						{
							//Calculate the address offset for all operator registers for
							//the target channel and operator
							unsigned int operatorAddressOffset = GetOperatorBlockAddressOffset(channelNo, operatorNo);

							//Calculate the phase modulation input for the operator unit
							int phaseModulation = 0;
							if((operatorNo == OPERATOR2) && ((algorithmNo == 0) || (algorithmNo == 3) || (algorithmNo == 4) || (algorithmNo == 5) || (algorithmNo == 6)))
							{
								phaseModulation = operatorOutput[channelNo][OPERATOR1];
							}
							else if((operatorNo == OPERATOR3) && ((algorithmNo == 0) || (algorithmNo == 2)))
							{
								phaseModulation = operatorOutput[channelNo][OPERATOR2];
							}
							else if((operatorNo == OPERATOR3) && (algorithmNo == 1))
							{
								phaseModulation = operatorOutput[channelNo][OPERATOR1] + operatorOutput[channelNo][OPERATOR2];
							}
							else if((operatorNo == OPERATOR3) && (algorithmNo == 5))
							{
								phaseModulation = operatorOutput[channelNo][OPERATOR1];
							}
							else if((operatorNo == OPERATOR4) && ((algorithmNo == 0) || (algorithmNo == 1) || (algorithmNo == 4)))
							{
								phaseModulation = operatorOutput[channelNo][OPERATOR3];
							}
							else if((operatorNo == OPERATOR4) && (algorithmNo == 2))
							{
								phaseModulation = operatorOutput[channelNo][OPERATOR1] + operatorOutput[channelNo][OPERATOR3];
							}
							else if((operatorNo == OPERATOR4) && (algorithmNo == 3))
							{
								phaseModulation = operatorOutput[channelNo][OPERATOR2] + operatorOutput[channelNo][OPERATOR3];
							}
							else if((operatorNo == OPERATOR4) && (algorithmNo == 5))
							{
								phaseModulation = operatorOutput[channelNo][OPERATOR1];
							}
							//Convert the 14-bit operator unit output from the modulator into
							//a 10-bit phase modulation input. Note that the bits are not
							//mapped quite the way you might expect. The operator output is
							//shifted down by 1 when it is mapped to the phase modulation
							//input. The remaining upper 3 bits of the operator output are
							//discarded.
							//  ---------------------------------------------------------
							//  |               Operator Output (14-bit)                |
							//  |-------------------------------------------------------|
							//  |13 |12 |11 |10 | 9 | 8 | 7 | 6 | 5 | 4 | 3 | 2 | 1 | 0 |
							//  ------------=========================================----
							//              |       Modulation Input (10-bit)       |
							//              |---------------------------------------|
							//              | 9 | 8 | 7 | 6 | 5 | 4 | 3 | 2 | 1 | 0 |
							//              -----------------------------------------
							phaseModulation >>= 1;
							phaseModulation &= ((1 << phaseBitCount) - 1);

							//If we're updating operator 1, calculate the self-feedback value
							//for phase modulation.
							if(operatorNo == OPERATOR1)
							{
								unsigned int feedback = GetFeedbackData(channelAddressOffset, accessTarget);
								if(feedback > 0)
								{
									phaseModulation = feedbackBuffer[channelNo][0] + feedbackBuffer[channelNo][1];
									phaseModulation >>= (10 - feedback);

									phaseModulation &= ((1 << phaseBitCount) - 1);
								}
							}

							//Read the current phase value from the phase generator
							unsigned int phase = GetCurrentPhase(channelNo, operatorNo);

							//Read the current attenuation value from the envelope generator
							unsigned int attenuation = GetOutputAttenuation(channelNo, operatorNo, channelAddressOffset, operatorAddressOffset);

							//Calculate the output from the operator unit
							int result = CalculateOperator(phase, phaseModulation, attenuation);
							operatorOutput[channelNo][operatorNo] = result;

							//If we're updating operator 1, add the output sample to the
							//self-feedback output buffer.
							if(operatorNo == OPERATOR1)
							{
								feedbackBuffer[channelNo][0] = feedbackBuffer[channelNo][1];
								feedbackBuffer[channelNo][1] = result;
							}

							//Write to the wav log
							if(wavLoggingOperatorEnabled[channelNo][operatorNo])
							{
								std::unique_lock<std::mutex> lock(waveLoggingMutex);
								short outputSample;
								float operatorOutputNormalized = (float)operatorOutput[channelNo][operatorNo] / ((1 << (operatorOutputBitCount - 1)) - 1);
								//We halve the amplitude of the operator output just to
								//make it a little easier to work with.
								outputSample = (short)(operatorOutputNormalized * (32767.0f/2));
								wavLogOperator[channelNo][operatorNo].WriteData(outputSample);
							}
						}

						//The Accumulator
						//Calculate the combined operator output for this channel
						int combinedChannelOutput = 0;
						switch(algorithmNo)
						{
						case 0:
							//  -----  -----  -----  -----
							//  | 1 |--| 2 |--| 3 |--| 4 |-
							//  -----  -----  -----  -----
						case 1:
							//  -----
							//  | 1 |--\
							//  -----  |  -----  -----
							//         +--| 3 |--| 4 |-
							//  -----  |  -----  -----
							//  | 2 |--/
							//  -----
						case 2:
							//         -----
							//         | 1 |--\
							//         -----  |  -----
							//                +--| 4 |-
							//  -----  -----  |  -----
							//  | 2 |--| 3 |--/
							//  -----  -----
						case 3:
							//  -----  -----
							//  | 1 |--| 2 |--\
							//  -----  -----  |  -----
							//                +--| 4 |-
							//         -----  |  -----
							//         | 3 |--/
							//         -----
							combinedChannelOutput = operatorOutput[channelNo][OPERATOR4];
							break;
						case 4:
							//  -----  -----
							//  | 1 |--| 2 |--\
							//  -----  -----  |
							//                +-
							//  -----  -----  |
							//  | 3 |--| 4 |--/
							//  -----  -----
							combinedChannelOutput = operatorOutput[channelNo][OPERATOR4] + operatorOutput[channelNo][OPERATOR2];
							break;
						case 5:
							//            -----
							//         /--| 2 |--\
							//         |  -----  |
							//         |         |
							//  -----  |  -----  |
							//  | 1 |--+--| 3 |--+-
							//  -----  |  -----  |
							//         |         |
							//         |  -----  |
							//         \--| 4 |--/
							//            -----
						case 6:
							//  -----
							//  | 1 |
							//  -----
							//    |
							//  -----   -----   -----
							//  | 2 |   | 3 |   | 4 |
							//  -----   -----   -----
							//    |       |       |
							//    \-------+-------/
							//            |
							combinedChannelOutput = operatorOutput[channelNo][OPERATOR4] + operatorOutput[channelNo][OPERATOR2] + operatorOutput[channelNo][OPERATOR3];
							break;
						case 7:
							//  -----   -----   -----   -----
							//  | 1 |   | 2 |   | 3 |   | 4 |
							//  -----   -----   -----   -----
							//    |       |       |       |
							//    \-----------+-----------/
							//                |
							combinedChannelOutput = operatorOutput[channelNo][OPERATOR4] + operatorOutput[channelNo][OPERATOR2] + operatorOutput[channelNo][OPERATOR3] + operatorOutput[channelNo][OPERATOR1];
							break;
						}

						//DAC support
						if((channelNo == CHANNEL6) && GetDACEnabled(accessTarget))
						{
							const unsigned int dacDataBitCount = 8;
							//The DAC data is written as an unsigned value. We convert it to
							//a signed value here.
							//##TODO## It's possible the DAC data uses a primitive sign bit.
							//Perform a test to determine whether this is the case.
							unsigned int dacData = GetDACData(accessTarget);
							int dacResult = (int)dacData - 0x80;
							//Convert from the 8-bit signed DAC data value to a 14-bit signed
							//operator output. The DAC data is mapped to the upper 8 bits of
							//the 14-bit output.
							dacResult <<= operatorOutputBitCount - dacDataBitCount;
							//Since DAC is enabled, the specified DAC sample replaces the
							//calculated FM output for this channel.
							combinedChannelOutput = dacResult;
						}

						//The result needs to be shifted up by 2 to correctly convert from
						//the 14-bit output from the operator unit, to the 16-bit output from
						//the accumulator.
						//##TODO## Confirm whether operators are summed before the shift
						//occurs, or whether the operators are shifted to 16-bit values
						//first, and then summed.
						combinedChannelOutput <<= 2;

						//A single operator at max attenuation won't clip, but multiple
						//operators combined might. We add a limit here to reproduce the
						//clipping operation.
						int maxAccumulatorOutput = (int)((1 << (accumulatorOutputBitCount - 1)) - 1);
						int minAccumulatorOutput = -(int)((1 << (accumulatorOutputBitCount - 1)) - 1);
						if(combinedChannelOutput > maxAccumulatorOutput)
						{
							combinedChannelOutput = maxAccumulatorOutput;
						}
						else if(combinedChannelOutput < minAccumulatorOutput)
						{
							combinedChannelOutput = minAccumulatorOutput;
						}

						//Pan Left/Right
						channelOutput[channelNo][0] = GetOutputLeft(channelAddressOffset, accessTarget)? combinedChannelOutput: 0;
						channelOutput[channelNo][1] = GetOutputRight(channelAddressOffset, accessTarget)? combinedChannelOutput: 0;

						//Write to the wave log
						if(wavLoggingChannelEnabled[channelNo])
						{
							std::unique_lock<std::mutex> lock(waveLoggingMutex);
							short outputSampleLeft;
							short outputSampleRight;
							float channelOutputLeftNormalized = (float)channelOutput[channelNo][0] / ((1 << (accumulatorOutputBitCount - 1)) - 1);
							float channelOutputRightNormalized = (float)channelOutput[channelNo][1] / ((1 << (accumulatorOutputBitCount - 1)) - 1);
							//We halve the amplitude of the channel output just to
							//make it a little easier to work with.
							outputSampleLeft = (short)(channelOutputLeftNormalized * (32767.0f/2));
							outputSampleRight = (short)(channelOutputRightNormalized * (32767.0f/2));
							wavLogChannel[channelNo].WriteData(outputSampleLeft);
							wavLogChannel[channelNo].WriteData(outputSampleRight);
						}
					}

					//##FIX##
					//Run the combined channel output from the accumulator through the
					//embedded YM3016 DAC. Note that we perform this calculation in the 2's
					//compliment mode for the DAC.
	//				Data channelOutputLeft(16, channelOutput[channelNo][0]);

					//Calculate the shift value
	//				unsigned int shiftLeft = 6;
	//				for(unsigned int i = 14; i >= 9; --i)
	//				{
	//					if(channelOutputLeft.GetBit(i))
	//					{
	//						shiftLeft = 14 - i;
	//						break;
	//					}
	//				}

					//Calculate the mantissa
	//				Data mantissaLeft(10);
	//				mantissaLeft = channelOutputLeft.GetDataSegment(14 - shiftLeft, 9);
	//				mantissaLeft.SetBit(10, channelOutputLeft.GetBit(15));

					//Calculate a single combined output for the YM2612. The DAC in the real
					//YM2612 multiplexes the output from each of the 6 channels, and outputs
					//at 6 times the output frequency we use here. We combine the output of
					//each channel here, and calculate the average sample output instead. The
					//apparent output should basically be the same. The best possible output
					//would be obtained by generating the true multiplexed output, and
					//resampling from the true output to the final audio output frequency
					//we're sending to the sound card.
					double finalOutputLeft = 0;
					double finalOutputRight = 0;
					for(unsigned int i = 0; i < channelCount; ++i)
					{
						float channelOutputLeftNormalized = (float)channelOutput[i][0] / ((1 << (accumulatorOutputBitCount - 1)) - 1);
						float channelOutputRightNormalized = (float)channelOutput[i][1] / ((1 << (accumulatorOutputBitCount - 1)) - 1);
						finalOutputLeft += (channelOutputLeftNormalized / channelCount);
						finalOutputRight += (channelOutputRightNormalized / channelCount);
					}
					short outputSampleLeft = (short)(32767.0f * finalOutputLeft);
					short outputSampleRight = (short)(32767.0f * finalOutputRight);
					outputBuffer[outputBufferPos++] = outputSampleLeft;
					outputBuffer[outputBufferPos++] = outputSampleRight;

					//Write to the wave log
					if(wavLoggingEnabled)
					{
						std::unique_lock<std::mutex> lock(waveLoggingMutex);
						Stream::ViewBinary wavlogStream(wavLog);
						wavlogStream << outputSampleLeft;
						wavlogStream << outputSampleRight;
					}

					////Calculate the true multiplexed output for the YM2612
					//for(unsigned int i = 0; i < channelCount; ++i)
					//{
					//	float channelOutputLeftNormalized = (float)channelOutput[i][0] / ((1 << (accumulatorOutputBitCount - 1)) - 1);
					//	float channelOutputRightNormalized = (float)channelOutput[i][1] / ((1 << (accumulatorOutputBitCount - 1)) - 1);
					//	short outputSampleLeft = (short)(32767.0f * channelOutputLeftNormalized);
					//	short outputSampleRight = (short)(32767.0f * channelOutputRightNormalized);
					//	outputBufferMultiplexed[outputBufferMultiplexedPos++] = outputSampleLeft;
					//	outputBufferMultiplexed[outputBufferMultiplexedPos++] = outputSampleRight;

					//	Write to the wave log
					//	if(wavLoggingEnabled)
					//	{
					//		std::unique_lock<std::mutex> lock(waveLoggingMutex);
					//		wavLog.WriteData(outputSampleLeft);
					//		wavLog.WriteData(outputSampleRight);
					//	}
					//}

					remainingRenderTime -= fmClockPeriod;
				}
			}

			RandomTimeAccessBuffer<Data, double>::WriteInfo writeInfo = reg.GetWriteInfo(0, regTimesliceCopy);
			if(writeInfo.exists)
			{
				//Handle any special case register changes
				switch(writeInfo.writeAddress)
				{
				case 0x28:
					{
						//Key-on/off
						//    ---------------------------------
						//    | 7 | 6 | 5 | 4 | 3 | 2 | 1 | 0 |
						//    |-------------------------------|
						//28H |   Key State   |   |           |
						//    |---------------| / |  Channel  |
						//    |OP4|OP3|OP2|OP1|   |           |
						//    ---------------------------------
						//##TODO## Confirm that bit 3 really is ignored when processing
						//key on/off writes.
						bool op4KeyState = writeInfo.newValue.GetBit(7);
						bool op3KeyState = writeInfo.newValue.GetBit(6);
						bool op2KeyState = writeInfo.newValue.GetBit(5);
						bool op1KeyState = writeInfo.newValue.GetBit(4);
						bool validChannelSelected = true;
						Channels channelNo;
						switch(writeInfo.newValue.GetDataSegment(0, 3))
						{
						case 0:  //000 - Channel 1
							channelNo = CHANNEL1;
							break;
						case 1:  //001 - Channel 2
							channelNo = CHANNEL2;
							break;
						case 2:  //010 - Channel 3
							channelNo = CHANNEL3;
							break;
						case 4:  //100 - Channel 4
							channelNo = CHANNEL4;
							break;
						case 5:  //101 - Channel 5
							channelNo = CHANNEL5;
							break;
						case 6:  //110 - Channel 6
							channelNo = CHANNEL6;
							break;
						default: //011, 111
							validChannelSelected = false;
							break;
						}

						if(validChannelSelected)
						{
							if(!keyStateLocking[channelNo][OPERATOR4])
							{
								operatorData[channelNo][OPERATOR4].keyon = op4KeyState;
							}
							if(!keyStateLocking[channelNo][OPERATOR3])
							{
								operatorData[channelNo][OPERATOR3].keyon = op3KeyState;
							}
							if(!keyStateLocking[channelNo][OPERATOR2])
							{
								operatorData[channelNo][OPERATOR2].keyon = op2KeyState;
							}
							if(!keyStateLocking[channelNo][OPERATOR1])
							{
								operatorData[channelNo][OPERATOR1].keyon = op1KeyState;
							}
						}
					}
				}
			}

			//See the notes above where we update the envelope generator for more info
			//about this conditional step of the timer A overflow buffer.
			if(GetCH3Mode(accessTarget) != 2)
			{
				timerAOverflowTimes.AdvanceByTime(writeInfo.writeTime, timerATimesliceCopy);
				//Reset the committed state. We do this after each update here, as CSM
				//mode has been disabled until this point, so all the overflow events
				//we've just advanced through would have been ignored.
				timerAOverflowTimes.WriteCommitted(false);
			}
			moreSamplesRemaining = reg.AdvanceByStep(regTimesliceCopy);
		}

		//Play the mixed audio stream. Note that we fold samples from successive render
		//operations together, ensuring that we only send data to the output audio stream
		//when we have a significant number of samples to send.
		unsigned int outputFrequency = (unsigned int)fmClock;
		size_t minimumSamplesToOutput = (size_t)(outputFrequency / 60);
		if(outputBuffer.size() >= minimumSamplesToOutput)
		{
			unsigned int internalSampleCount = (unsigned int)outputBuffer.size() / 2;
			unsigned int outputSampleCount = (unsigned int)((double)internalSampleCount * ((double)outputSampleRate / (double)outputFrequency));
			AudioStream::AudioBuffer* outputBufferFinal = outputStream.CreateAudioBuffer(outputSampleCount, 2);
			if(outputBufferFinal != 0)
			{
				outputStream.ConvertSampleRate(outputBuffer, internalSampleCount, 2, outputBufferFinal->buffer, outputSampleCount);
				outputStream.PlayBuffer(outputBufferFinal);
			}
			outputBuffer.clear();
			outputBuffer.reserve(minimumSamplesToOutput * 2);

			//##DEBUG##
			//std::wcout << "YM2612 Output: " << internalSampleCount << '\t' << outputSampleCount << '\n';
		}

		//Play the multiplexed output audio stream
		//if(!outputBufferMultiplexed.empty())
		//{
		//	unsigned int outputFrequency = (unsigned int)fmClock * channelCount;
		//	unsigned int internalSampleCount = (unsigned int)outputBufferMultiplexed.size() / 2;
		//	unsigned int outputSampleCount = (unsigned int)((double)internalSampleCount * ((double)outputSampleRate / (double)outputFrequency));
		//	AudioStream::AudioBuffer* outputBufferFinal = outputStream.CreateAudioBuffer(outputSampleCount, 2);
		//	if(outputBufferFinal != 0)
		//	{
		//		outputStream.ConvertSampleRate(outputBufferMultiplexed, internalSampleCount, 2, outputBufferFinal->buffer, outputSampleCount);
		//		outputStream.PlayBuffer(outputBufferFinal);
		//	}
		//}

		//Advance past the timeslice we've just rendered from
		{
			std::unique_lock<std::mutex> lock(timesliceMutex);
			reg.AdvancePastTimeslice(regTimesliceCopy);
			timerAOverflowTimes.AdvancePastTimeslice(timerATimesliceCopy);
		}
	}
	renderThreadStopped.notify_all();
}

//----------------------------------------------------------------------------------------
//General operator functions
//----------------------------------------------------------------------------------------
void YM2612::UpdateOperator(unsigned int channelNo, unsigned int operatorNo, bool updateEnvelopeGenerator)
{
	AccessTarget accessTarget;
	accessTarget.AccessCommitted();
	OperatorData* state = &operatorData[channelNo][operatorNo];

	//Calculate the address offsets for all channel and operator registers for the target
	//channel and operator.
	unsigned int channelAddressOffset = GetChannelBlockAddressOffset(channelNo);
	unsigned int operatorAddressOffset = GetOperatorBlockAddressOffset(channelNo, operatorNo);

	//Update the key-on state. Note that hardware tests have shown that this does in fact
	//happen each FM clock cycle, not just each envelope generator update cycle. Also
	//note the update process for CSM key-on events, and the interaction between CSM and
	//manual key-on events. This implementation is based on comprehensive hardware tests.

	//Update the CSM key-on state
	if(channelNo == CHANNEL3)
	{
		state->csmKeyOn = (GetCH3Mode(accessTarget) == 2) && timerAOverflowTimes.ReadCommitted();
	}

	//Respond to any key on/off changes
	bool keyonState = state->keyon || state->csmKeyOn;
	if(keyonState != state->keyonPrevious)
	{
		if(keyonState)
		{
			//Key-on
			SetADSRPhase(channelNo, operatorNo, channelAddressOffset, operatorAddressOffset, OperatorData::ADSR_ATTACK);

			//Restart the phase counter. Hardware tests have shown that the phase counter
			//is always reset to 0 when key-on occurs. Note that this does include cases
			//where key-on is triggered automatically by CSM mode.
			state->phaseCounter = 0;

			//Reset the SSG-EG output inversion flag
			state->ssgOutputInverted = false;
		}
		else
		{
			//Key-off
			SetADSRPhase(channelNo, operatorNo, channelAddressOffset, operatorAddressOffset, OperatorData::ADSR_RELEASE);

			//If SSG-EG is enabled and the output is currently inverted, convert the
			//current attenuation value into an equivalent non-inverted value. This
			//emulates the release mode behaviour when SSG-EG is active. Note that we do
			//not alter the output inversion flag here. Output inversion is ignored
			//during the release phase. The output inversion flag is cleared when key-on
			//occurs.
			if(GetSSGEnabled(operatorAddressOffset, accessTarget) && (state->ssgOutputInverted ^ GetSSGAttack(operatorAddressOffset, accessTarget)))
			{
				state->attenuation = Data(attenuationBitCount, 0x200) - state->attenuation;
			}
		}
		state->keyonPrevious = keyonState;
	}

	//If SSG-EG is enabled, and the current internal attenuation level of the envelope
	//generator is greater than or equal to 0x200, we need to run some special SSG-EG
	//update steps. Note that hardware tests have proven that these operations occur each
	//time the output of the envelope generator is calculated (IE, each sample), not just
	//each time the envelope generator is updated. The output inversion and phase counter
	//reset steps in particular are easily measurable, and have been shown to occur each
	//sample. Note that hardware tests have also shown that this update process occurs
	//before the normal envelope generator update steps in the case where both run on the
	//same cycle. This can allow a single sample to be output at an attenuation level of
	//0x200 before these update steps are applied.
	if(GetSSGEnabled(operatorAddressOffset, accessTarget)	//SSG-EG mode is enabled
		&& (state->attenuation >= 0x200))	//The internal attenuation value has reached the magic 0x200 threshold
	{
		if(GetSSGAlternate(operatorAddressOffset, accessTarget)	//SSG-EG is set to an alternating pattern
			&& (!GetSSGHold(operatorAddressOffset, accessTarget) || !state->ssgOutputInverted))	//Hold mode is disabled, or the current inversion state matches the initial inversion state at key-on
		{
			//Toggle the current inversion state of the envelope generator output. Note
			//that extensive hardware tests have been performed on SSG-EG output
			//inversion. This implementation has been shown to always produce the correct
			//output, even under unusual circumstances such as when an attack phase is
			//present, and/or changes are made to the SSG-EG mode at critical points.
			state->ssgOutputInverted = !state->ssgOutputInverted;

			//Note that if the hold bit is set, the inversion state is only toggled if
			//the current inversion state matches the initial inversion state. Under
			//normal circumstances, this prevents the inversion state from being toggled
			//more than once when the hold bit is set. This matches the confirmed
			//behaviour of the real chip. This behaviour is vital, as the internal
			//attenuation value finishes on 0x200 after each decay phase. Without this
			//test, once hold mode begins, the inversion state would be toggled each
			//sample. Note that the envelope generator does not maintain a separate flag
			//which tracks whether the output has been inverted since key-on, as changes
			//to the SSG-EG mode after key-on can cause the output to be inverted more
			//than once under hold mode.
		}

		if(!GetSSGAlternate(operatorAddressOffset, accessTarget)
			&& !GetSSGHold(operatorAddressOffset, accessTarget))
		{
			//Hardware tests have shown that the phase counter is held at 0 in cases
			//where SSG-EG is enabled, both the hold bit and alternate bit are unset, and
			//the internal envelope generator attenuation value is greater than or equal
			//to 0x200. Once any of these conditions change, the phase counter will
			//resume counting up from 0. This causes the phase of the output wave to
			//restart on each repetition of patterns 08 and 0C, which occurs on the real
			//hardware. Note that the phase counter really is held at 0, not simply set
			//to 0 at a particular point in time. This can create silence gaps between
			//repetitions of the SSG-EG envelope where an attack phase exists.
			state->phaseCounter = 0;
		}

		if(state->phase != OperatorData::ADSR_ATTACK)
		{
			if((state->phase != OperatorData::ADSR_RELEASE)
				&& !GetSSGHold(operatorAddressOffset, accessTarget))
			{
				//If SSG-EG is enabled, we're in either the decay or sustain phase, and
				//the hold bit is not set, now that we've reached an attenuation level of
				//0x200, we need to loop back to the attack phase and begin the ADSR
				//envelope again.

				//Switch back to the attack phase
				SetADSRPhase(channelNo, operatorNo, channelAddressOffset, operatorAddressOffset, OperatorData::ADSR_ATTACK);

				//Note that we've confirmed that the attenuation is not clamped to 0x200
				//in SSG-EG mode when the ADSR envelope loops. By toggling DR during the
				//decay phase, we've proven that the final attenuation value is allowed
				//to move past 0x200 before looping. If an attack curve follows, it
				//begins its decay from this final attenuation value. Don't uncomment the
				//line below, it is incorrect. It is only provided as an example of what
				//NOT to do.
				//state->attenuation = 0x200;
			}
			else if((state->phase == OperatorData::ADSR_RELEASE)
				|| !(state->ssgOutputInverted ^ GetSSGAttack(operatorAddressOffset, accessTarget)))	//If the output is not currently inverted
			{
				//If the output is not currently inverted, and we've reached an internal
				//attenuation level of 0x200 in one of the decay phases (either the
				//decay, sustain, or release phase), but the envelope is not looping back
				//to the attack phase, we need to force the internal attenuation value to
				//0x3FF. This emulates the behaviour of the YM2612 when entering a
				//low-hold state in SSG-EG mode, and when the release phase reaches
				//0x200. In both cases, the internal attenuation value is forced directly
				//to 0x3FF. This has been confirmed through hardware tests. Note that
				//this step occurs after the inversion state has been toggled. Performing
				//these steps the wrong way around would break SSG-EG pattern 0xB, where
				//both the hold and alternate bits are set, and the attack bit is clear.

				//Force the internal attenuation value to 0x3FF
				state->attenuation = 0x3FF;

				//Note that this behaviour can be observed when switching from an
				//inverted hold pattern to a low-hold pattern, then back again after the
				//hold sequence has begun. When the inverted hold pattern resumes, the
				//digital output will be 0x001F instead of 0x1FE8, as the internal
				//attenuation value has been forced from 0x200 to 0x3FF, which becomes
				//0x201 when it is inverted, outputting a value of 0x001F. This effect
				//can also be observed when reading the decay sequence under the release
				//phase when SSG-EG mode is active. With an increment value of 1, the
				//digital output from the operator unit can be observed to jump directly
				//from 0x0021 to 0, indicating the output attenuation value from the
				//envelope generator skipped from a known value of 0x1FC from the decay
				//sequence, to a value greater than 0x33F.
			}
		}
	}

	//Update the Envelope Generator
	if(updateEnvelopeGenerator)
	{
		UpdateEnvelopeGenerator(channelNo, operatorNo, channelAddressOffset, operatorAddressOffset);
	}

	//Update the Phase Generator
	UpdatePhaseGenerator(channelNo, operatorNo, channelAddressOffset, operatorAddressOffset);
}

//----------------------------------------------------------------------------------------
//This function implements the KeyCode formula as described on page 25 of the YM2608
//documentation. Result is a 5-bit number with the following structure:
// ---------------------
// | 4 | 3 | 2 | 1 | 0 |
// |-------------------|
// |   Block   |N4 |N3 |
// ---------------------
//Where Block is the 3-bit block data, and N4/N3 are built from fnumber as follows:
// N4=F11
// N3=(F11&(F10|F9|F8)) | !F11&F10&F9&F8
//Where FXX indicates bit XX from fnumber, starting with the LSB as 1.
//----------------------------------------------------------------------------------------
unsigned int YM2612::CalculateKeyCode(unsigned int block, unsigned int fnumber) const
{
	Data keyCode(keyCodeBitCount);
	Data fnumberData(fnumDataBitCount, fnumber);
	keyCode.SetDataSegment(2, 3, block);
	keyCode.SetBit(1, fnumberData.GetBit(10));
	keyCode.SetBit(0, (fnumberData.GetBit(10) && (fnumberData.GetBit(9) || fnumberData.GetBit(8) || fnumberData.GetBit(7))) || (!fnumberData.GetBit(10) && (fnumberData.GetBit(9) && fnumberData.GetBit(8) && fnumberData.GetBit(7))));
	return keyCode.GetData();
}

//----------------------------------------------------------------------------------------
//Phase generator functions
//----------------------------------------------------------------------------------------
void YM2612::UpdatePhaseGenerator(unsigned int channelNo, unsigned int operatorNo, unsigned int channelAddressOffset, unsigned int operatorAddressOffset)
{
	AccessTarget accessTarget;
	accessTarget.AccessCommitted();
	OperatorData* state = &operatorData[channelNo][operatorNo];

	//This algorithm is primarily based on the F-Number calculation given in the YM2608
	//manual, page 24. That formula is as follows:
	//F-Number = (144 * fnote * 2^20 / M) / 2^(B-1)
	//Additional tests were performed on hardware to answer all remaining questions about
	//the update process.

	//Read the frequency and block data
	unsigned int frequencyData = GetFrequencyData(channelNo, operatorNo, channelAddressOffset, accessTarget);
	unsigned int blockData = GetBlockData(channelNo, operatorNo, channelAddressOffset, accessTarget);

	//Apply frequency modulation to fnum
	//  ---------------------------------
	//  |          LFO Counter          |
	//  |-------------------------------|
	//  |...| 6 | 5 | 4 | 3 | 2 | 1 | 0 |
	//  ----=====================--------
	//      | Phase Modulation  |
	//      |   Index (5-bit)   |
	//      |-------------------|
	//      | 4 | 3 | 2 | 1 | 0 |
	//      ---------------------
	Data pmCounter(phaseModIndexBitCount, currentLFOCounter >> 2);
	unsigned int pmSensitivity = GetPMSData(channelAddressOffset, accessTarget);
	if((pmCounter != 0) && (pmSensitivity != 0))
	{
		bool pmInverted = pmCounter.GetBit(phaseModIndexBitCount - 1);
		bool pmSlopeNegative = pmCounter.GetBit(phaseModIndexBitCount - 2);
		Data quarterPhase(phaseModIndexBitCount - 2, pmCounter.GetData());
		if(pmSlopeNegative)
		{
			quarterPhase = ~quarterPhase;
		}

		//##TODO## Run a test where the upper 6 bits of fnum are 0, and see if the
		//inverted frequency modulation wave will create a measurable, effective 1-bit
		//frequency modulation due to sign-extension.
		//##TODO## Determine whether all 11 bits of fnum are used to calculate the
		//frequency modulation value. It's possible that all 11 bits of fnum are used to
		//build a frequency modulation value, and that value is calculated at full
		//precision, without any loss. That value is then sign-extended, and added to
		//fnum, but lower bits of the frequency modulation value are discarded. If this
		//is the case, the sign-extension behaviour will mean that a 1-bit modulation
		//value is present, even when only the LSB of fnum is set. It would also mean
		//that we would be able to detect the results of carry operations in the addition
		//for the increment values for each bit, below the level of the LSB of fnum.

		int pmIncrement = 0;
		for(unsigned int i = 0; i < fnumDataBitCount; ++i)
		{
			if((frequencyData & (1 << i)) != 0)
			{
				unsigned int pmIncrementValue = phaseModIncrementTable[pmSensitivity][quarterPhase.GetData()];
				pmIncrement += (int)(pmIncrementValue << i);
			}
		}
		if(pmInverted)
		{
			pmIncrement = -pmIncrement;
		}
		pmIncrement >>= 9;
		frequencyData += (unsigned int)pmIncrement;

		////Calculate the frequency modulation value based on the upper 6 bits of fnum
		//const unsigned int fnumModulationBits = 6;
		//unsigned int pmSensitivity = GetPMSData(channelNo, accessTarget);
		//unsigned int pmIncrement = 0;
		//unsigned int frequencyDataUpperBits = frequencyData >> (fnumDataBitCount - fnumModulationBits);
		//for(unsigned int i = 0; i < fnumModulationBits; ++i)
		//{
		//	if((frequencyDataUpperBits & (1 << i)) != 0)
		//	{
		//		unsigned int pmIncrementValue = phaseModIncrementTable[pmSensitivity][quarterPhase.GetData()];
		//		unsigned int pmIncrementForBit = (pmIncrementValue << 1) >> ((fnumModulationBits - 1) - i);
		//		pmIncrement += pmIncrementForBit;
		//	}
		//}

		//if(pmInverted)
		//{
		//	frequencyData -= pmIncrement;
		//}
		//else
		//{
		//	frequencyData += pmIncrement;
		//}

		//Clamp the adjusted fnum value to an 11-bit result.
		frequencyData &= ((1 << fnumDataBitCount) - 1);
	}

	//Adjust the fnum data by the block shift data, to calculate the initial phase
	//increment value. The block data applies a shift to fnum in the following way:
	//-------------------------------------------------
	//|  0  |  1  |  2  |  3  |  4  |  5  |  6  |  7  |
	//|-----------------------------------------------|
	//| >>1 |  -  | <<1 | <<2 | <<3 | <<4 | <<5 | <<6 |
	//-------------------------------------------------
	//Note the loss of precision when block=0. The LSB of fnum is discarded when block=0.
	//This has been confirmed through hardware tests.
	unsigned int phaseIncrement;
	if(blockData == 0)
	{
		phaseIncrement = (frequencyData >> 1);
	}
	else
	{
		phaseIncrement = frequencyData << (blockData - 1);
	}

	//Apply detune to the phase increment value. Note that the detune adjustment is
	//applied before the frequency multiplier.
	unsigned int keyCode = CalculateKeyCode(blockData, frequencyData);
	Data detuneData(detuneBitCount, GetDetuneData(operatorAddressOffset, accessTarget));
	bool detuneNegative = detuneData.GetBit(detuneBitCount - 1);
	unsigned int detuneIndex = detuneData.GetDataSegment(0, 2);
	unsigned int detuneIncrement = detunePhaseIncrementTable[keyCode][detuneIndex];
	if(detuneNegative)
	{
		phaseIncrement -= detuneIncrement;
	}
	else
	{
		phaseIncrement += detuneIncrement;
	}

	//Clamp the intermediate phase increment to a 17-bit result. This is necessary in
	//order to accurately emulate overflows caused by the detune adjustment.
	const unsigned int intermediatePhaseIncrementBitCount = 17;
	phaseIncrement &= ((1 << intermediatePhaseIncrementBitCount) - 1);

	//Apply the frequency multiplier to the phase increment value
	unsigned int mul = GetMultipleData(operatorAddressOffset, accessTarget);
	if(mul == 0)
	{
		phaseIncrement /= 2;
	}
	else
	{
		phaseIncrement *= mul;
	}

	//Apply the phase increment to the phase counter
	state->phaseCounter += phaseIncrement;
}

//----------------------------------------------------------------------------------------
unsigned int YM2612::GetCurrentPhase(unsigned int channelNo, unsigned int operatorNo) const
{
	const OperatorData* state = &operatorData[channelNo][operatorNo];
	//This function returns the 10-bit output from the phase generator, which is used by
	//the operator unit. This 10-bit output represents the upper 10 bits of the internal
	//phase counter. We extract the upper 10 bits of the internal phase counter here, to
	//build that 10-bit output.
	return state->phaseCounter.GetDataSegment(state->phaseCounter.GetBitCount() - 10, 10);
}

//----------------------------------------------------------------------------------------
unsigned int YM2612::GetFrequencyData(unsigned int channelNo, unsigned int operatorNo, unsigned int channelAddressOffset, const AccessTarget& accessTarget) const
{
	if((channelNo == CHANNEL3) && (GetCH3Mode(accessTarget) != 0))
	{
		//If we're in channel 3 special mode, read the separate frequency data for the
		//operator.
		return GetFrequencyDataChannel3(operatorNo, accessTarget);
	}
	else
	{
		//Read the global frequency data for the channel
		return GetFrequencyData(channelAddressOffset, accessTarget);
	}
}

//----------------------------------------------------------------------------------------
unsigned int YM2612::GetBlockData(unsigned int channelNo, unsigned int operatorNo, unsigned int channelAddressOffset, const AccessTarget& accessTarget) const
{
	if((channelNo == CHANNEL3) && (GetCH3Mode(accessTarget) != 0))
	{
		//If we're in channel 3 special mode, read the separate block data for the
		//operator.
		return GetBlockDataChannel3(operatorNo, accessTarget);
	}
	else
	{
		//Read the global block data for the channel
		return GetBlockData(channelAddressOffset, accessTarget);
	}
}

//----------------------------------------------------------------------------------------
//Envelope generator functions
//----------------------------------------------------------------------------------------
void YM2612::UpdateEnvelopeGenerator(unsigned int channelNo, unsigned int operatorNo, unsigned int channelAddressOffset, unsigned int operatorAddressOffset)
{
	AccessTarget accessTarget;
	accessTarget.AccessCommitted();
	OperatorData* state = &operatorData[channelNo][operatorNo];

	//Check if we need to progress to a different phase of the ADSR envelope
	if(state->phase == OperatorData::ADSR_ATTACK)
	{
		//If we're in the attack phase and attenuation has hit minimum, switch to the
		//decay phase.
		if(state->attenuation == 0)
		{
			SetADSRPhase(channelNo, operatorNo, channelAddressOffset, operatorAddressOffset, OperatorData::ADSR_DECAY);
		}
	}
	else if(state->phase == OperatorData::ADSR_DECAY)
	{
		unsigned int sustainLevelAsAttenuation = ConvertSustainLevelToAttenuation(GetSustainLevelData(operatorAddressOffset, accessTarget));

		//If we're in the decay phase and attenuation has passed SL, switch to the
		//sustain phase.
		if(state->attenuation >= sustainLevelAsAttenuation)
		{
			//We have confirmed that the current internal attenuation number is NOT
			//clamped to SL when the decay phase passes SL. This can't happen under normal
			//circumstances. The minimum step for SL is 0x20, which is also 8*4=0x20 the
			//maximum output step for the decay phase under SSG-EG. Decay should always
			//end exactly on SL. Where this may not be true is when DR is modified during
			//the decay phase. We know from hardware tests where we modified DR during the
			//decay phase to get the attenuation value to "skip over" 0x200 that the final
			//level is allowed to move past SL during the decay phase. The sustain phase
			//then begins from the point at which the decay rate finished. This has been
			//confirmed both under normal mode and when SSG-EG is active. Don't uncomment
			//the line below, it is incorrect. It is only provided as an example of what
			//NOT to do.
			//state->attenuation = sustainLevelAsAttenuation;

			//Switch from the decay phase to the sustain phase. Note that we have
			//confirmed that changing SL after the sustain phase has been entered can't
			//cause the operator to re-enter the decay phase. The switch from decay to
			//sustain is a one-way process. The selection between the decay or sustain
			//phases is not based on the current attenuation value relative to SL.
			SetADSRPhase(channelNo, operatorNo, channelAddressOffset, operatorAddressOffset, OperatorData::ADSR_SUSTAIN);
		}
	}

	//Calculate the current rate value for the envelope. Note that we have confirmed this
	//value is evaluated on every update cycle. Changes to the effective rate for the
	//current phase of the envelope generator take effect immediately.
	unsigned int rateKeyScale = CalculateRateKeyScale(GetKeyScaleData(operatorAddressOffset, accessTarget), CalculateKeyCode(GetBlockData(channelNo, operatorNo, channelAddressOffset, accessTarget), GetFrequencyData(channelNo, operatorNo, channelAddressOffset, accessTarget)));
	unsigned int rate = 0;
	switch(state->phase)
	{
	case OperatorData::ADSR_ATTACK:
		rate = CalculateRate(GetAttackRateData(operatorAddressOffset, accessTarget), rateKeyScale);
		break;
	case OperatorData::ADSR_DECAY:
		rate = CalculateRate(GetDecayRateData(operatorAddressOffset, accessTarget), rateKeyScale);
		break;
	case OperatorData::ADSR_SUSTAIN:
		rate = CalculateRate(GetSustainRateData(operatorAddressOffset, accessTarget), rateKeyScale);
		break;
	case OperatorData::ADSR_RELEASE:{
		//Note that we pass the 4-bit release rate data as a 5-bit number, with the LSB
		//fixed to 1. This is based on the information given in the YM2608 Application
		//Manual, page 30, which states that the release rate data is passed as
		//(value * 2 + 1).
		unsigned int adjustedRateData = (GetReleaseRateData(operatorAddressOffset, accessTarget) << 1) | 0x01;
		rate = CalculateRate(adjustedRateData, rateKeyScale);
		break;}
	}

	//Check the envelope cycle counter and see if we should be adjusting the attenuation
	//for the operator on this cycle.
	unsigned int counterShiftValue = counterShiftTable[rate];
	if((envelopeCycleCounter % (1 << counterShiftValue)) == 0)
	{
		//Get the index of the next attenuation increment value in the update cycle (0-7)
		unsigned int updateCycle = (envelopeCycleCounter >> counterShiftValue) & 0x07;

		//Read the next attenuation increment value in the cycle
		unsigned int attenuationIncrement = attenuationIncrementTable[rate][updateCycle];

		//Update the attenuation
		unsigned int newAttenuation = state->attenuation.GetData();
		if(state->phase == OperatorData::ADSR_ATTACK)
		{
			//If the attack rate is less than 62, advance the attack curve. Attack rate
			//values of 62 and 63 have special case handling when the attack phase is
			//first entered, which forces the attenuation directly to 0. Note that if an
			//attack phase begins with an attack rate less than 62, then the attack rate
			//changes during the attack phase to a rate value of 62 or 63, this exclusion
			//will prevent the attack curve from advancing, and the attack phase will
			//stall. This matches the confirmed behaviour of the real hardware.
			if(rate < 62)
			{
				//Note that we've confirmed this formula for the attack curve produces a
				//binary accurate result.
				unsigned int attenuationAdjustment = (~newAttenuation * attenuationIncrement) >> 4;

				//Combine the attenuation adjustment value with the current attenuation
				//value. The attenuation adjustment is a two's compliment representation
				//of a negative number, so this addition operation will actually subtract
				//a value from the current attenuation level. Note that we don't apply any
				//limiting operation here, so an overflow is possible. This is vital, as
				//the addition of the two's compliment negative value will always cause an
				//overflow to occur.
				newAttenuation += attenuationAdjustment;
			}
		}
		else
		{
			//Advance the linear decay for the decay, sustain, or release phase. Note that
			//if SSG-EG is enabled for this operator, the decay phase runs at 4x the
			//normal speed.
			if(GetSSGEnabled(operatorAddressOffset, accessTarget))
			{
				//If the current internal attenuation value is below 0x200, advance the
				//decay phase. In most cases when the attenuation level reaches 0x200,
				//the envelope will move back to the attack phase, or the attenuation
				//level will be forced to 0x3FF anyway. One case where neither of these
				//changes occur, and we need this check here to ensure the attenuation
				//level isn't permitted to advance any further, is when we enter an
				//inverted hold phase. Hardware tests have conclusively shown that in
				//these cases, if the internal attenuation level is greater than or equal
				//to 0x200, the attenuation level remains unchanged. This is true even in
				//cases where the internal attenuation level has been offset from a
				//multiple of 4, and the precise value of 0x200 is skipped over by an
				//SSG-EG increment.
				if(newAttenuation < 0x200)
				{
					newAttenuation += (int)(4 * attenuationIncrement);
				}
			}
			else
			{
				newAttenuation += (int)attenuationIncrement;
			}

			//Limit the result to the maximum attenuation value. This is necessary to stop
			//the final step in a decay phase overflowing back to 0. The last update step
			//in a decay phase is always capped at 0x3FF, even when the step would have
			//advanced past 0x3FF. Under normal circumstances, all decay phases would
			//always end on a value of 0x400 which would be clamped back to 0x3FF, but
			//this this clamping behaviour has also been confirmed to work correctly when
			//the decay rate is modified during the decay phase, to cause the final step
			//to "skip over" the usual ending value of 0x400.
			unsigned int maxAttenuation = (1 << attenuationBitCount) - 1;
			if(newAttenuation > maxAttenuation)
			{
				newAttenuation = maxAttenuation;
			}
		}

		//Write the new attenuation value to the envelope generator state
		state->attenuation = newAttenuation;
	}
}

//----------------------------------------------------------------------------------------
void YM2612::SetADSRPhase(unsigned int channelNo, unsigned int operatorNo, unsigned int channelAddressOffset, unsigned int operatorAddressOffset, OperatorData::ADSRPhase phase)
{
	AccessTarget accessTarget;
	accessTarget.AccessCommitted();
	OperatorData* state = &operatorData[channelNo][operatorNo];

	if(phase != state->phase)
	{
		if(phase == OperatorData::ADSR_ATTACK)
		{
			//If the rate is greater than or equal to 62, the current attenuation level is
			//forced directly to 0. This causes the next envelope generator update cycle
			//to advance through the first step of the decay phase. It seems a little odd
			//to have to evaluate the effective attack rate here, but this implementation
			//does appear to match the behaviour of the chip.
			unsigned int rateKeyScale = CalculateRateKeyScale(GetKeyScaleData(operatorAddressOffset, accessTarget), CalculateKeyCode(GetBlockData(channelNo, operatorNo, channelAddressOffset, accessTarget), GetFrequencyData(channelNo, operatorNo, channelAddressOffset, accessTarget)));
			unsigned int rate = CalculateRate(GetAttackRateData(operatorAddressOffset, accessTarget), rateKeyScale);
			if(rate >= 62)
			{
				state->attenuation = 0;
			}
		}
		state->phase = phase;
	}
}

//----------------------------------------------------------------------------------------
unsigned int YM2612::GetOutputAttenuation(unsigned int channelNo, unsigned int operatorNo, unsigned int channelAddressOffset, unsigned int operatorAddressOffset) const
{
	AccessTarget accessTarget;
	accessTarget.AccessCommitted();
	const OperatorData* state = &operatorData[channelNo][operatorNo];

	unsigned int attenuation = state->attenuation.GetData();

	//If SSG-EG is enabled and the output is inverted, invert the output data. Note that
	//extensive testing has been performed on the hardware to build this implementation.
	//This test is performed exactly as shown each time the attenuation value is used.
	//Note the way the attack bit is combined with the inversion state. This is known to
	//be correct, and is essential in order to deal with cases where the SSG-EG state is
	//changed after key-on. A change in the state of the attack bit will result in an
	//immediate inversion of the output. Also note the calculation performed to derive
	//the "inverted" data. This calculation has been proven to be binary-accurate.
	if(GetSSGEnabled(operatorAddressOffset, accessTarget)
		&& (state->phase != OperatorData::ADSR_RELEASE)
		&& (state->ssgOutputInverted ^ GetSSGAttack(operatorAddressOffset, accessTarget)))
	{
		attenuation = 0x200 - attenuation;
		attenuation &= 0x3FF;
	}

	//Combine TL with the output attenuation value. Note that TL is applied after SSG-EG
	//output inversion has been applied.
	attenuation += ConvertTotalLevelToAttenuation(GetTotalLevelData(operatorAddressOffset, accessTarget));

	//Apply amplitude modulation to the output attenuation value
	if(GetAmplitudeModulationEnabled(operatorAddressOffset, accessTarget))
	{
		//  ---------------------------------
		//  |          LFO Counter          |
		//  |-------------------------------|
		//  |...| 6 | 5 | 4 | 3 | 2 | 1 | 0 |
		//  ----=============================
		//      |   Amplitude Modulation    |
		//      |       Index (7-bit)       |
		//      |---------------------------|
		//      | 6 | 5 | 4 | 3 | 2 | 1 | 0 |
		//      -----------------------------
		//Calculate the current attenuation value from the LFO. Note that the amplitude
		//modulation wave starts off inverted. An index of 0 corresponds with the maximum
		//attenuation value that amplitude modulation can apply, according to the current
		//amplitude modulation sensitivity. This is of particular importance when the LFO
		//is set to the disabled state. In this state, the LFO counter is held at 0, but
		//since an amplitude modulation index of 0 represents the "peak" of the wave, the
		//operator will be attenuated by a fixed amount through amplitude modulation while
		//the LFO counter is being held at 0.
		bool inverted = (currentLFOCounter & 0x40) == 0;
		unsigned int amValue = currentLFOCounter & 0x3F;
		if(inverted)
		{
			amValue = ~amValue & 0x3F;
		}

		//Adjust the attenuation value by the amplitude modulation sensitivity
		const unsigned int amShiftValues[4] = {8, 3, 1, 0};
		unsigned int amSensitivity = GetAMSData(channelAddressOffset, accessTarget);
		amValue = (amValue << 1) >> amShiftValues[amSensitivity];

		//Attenuate the operator output by the current amplitude modulation value
		attenuation += amValue;
	}

	//Limit the result to the maximum attenuation value
	if(attenuation >= (1 << attenuationBitCount))
	{
		attenuation = (1 << attenuationBitCount) - 1;
	}

	return attenuation;
}

//----------------------------------------------------------------------------------------
//This function implements the ADSR envelope rate calculation. Refer to page 30 of
//the YM2608 documentation for further info.
//----------------------------------------------------------------------------------------
unsigned int YM2612::CalculateRate(unsigned int rateData, unsigned int rateKeyScale) const
{
	//Parameters rateData and rateKeyScale are 5-bit numbers in the range 0x00-0x1F
	unsigned int rate = (2 * rateData) + rateKeyScale;
	//Special case. If rateData is 0, rate is forced to 0, regardless of the value of
	//rateKeyScale.
	if(rateData == 0)
	{
		rate = 0;
	}
	//The rate number is a 6-bit number, and the result is capped at the max to prevent
	//overflows. We limit the result to the maximum value here in the case where the
	//calculation exceeds the maximum.
	if(rate >= (1 << rateBitCount))
	{
		rate = (1 << rateBitCount) - 1;
	}
	return rate;
}

//----------------------------------------------------------------------------------------
//This function implements the rate key-scaling calculation. Refer to page 29 of the
//YM2608 documentation for further info.
//----------------------------------------------------------------------------------------
unsigned int YM2612::CalculateRateKeyScale(unsigned int keyScaleData, unsigned int keyCode) const
{
	//Parameter keyScaleData is a 2-bit value. Parameter keyCode is a 5-bit value. Result
	//is a 5-bit value.
	unsigned int keyScaleDivisor = 1 << (3 - keyScaleData);
	unsigned int rateKeyScale = keyCode / keyScaleDivisor;
	return rateKeyScale;
}

//----------------------------------------------------------------------------------------
unsigned int YM2612::ConvertTotalLevelToAttenuation(unsigned int totalLevel) const
{
	//Note that in the YM2608 Application Manual, section 2-5-3, page 32, there's a
	//comment that when all the bits of TL are set, the attenuation level is set to the
	//maximum amount (96db). This is a little misleading for our purposes here. This does
	//NOT mean that all 10 bits of the attenuation output have to be forced to set when
	//all 7 bits of TL are set. In reality, due to the precision limitations of the
	//operator unit, an envelope generator output of 0x340 or greater will always force
	//the final output to maximum attenuation (96db). This is well below the output of
	//0x3F8 we would get if all the bits in TL are set. Due to this, it's impossible to
	//know if the YM2612 forces all 10 bits of the envelope generator output to set when
	//all 7 bits of TL are set, but it doesn't matter for the same reason, as there's no
	//way for that to have any measurable effect.
	return totalLevel << 3;
}

//----------------------------------------------------------------------------------------
unsigned int YM2612::ConvertSustainLevelToAttenuation(unsigned int sustainLevel) const
{
	//Note that in the YM2608 Application Manual, section 2-5-1, page 28, there's a
	//comment that when all the bits of SL are set, SL is set to 93db. You might wonder
	//whether they really meant 96db. In reality, it makes no difference. At 93db, the
	//10-bit output from the envelope generator would be 0x370, which is over the maximum
	//attenuation value of 0x340 that the operator unit can accept, before precision
	//limitations force the output to minimum.
	if(sustainLevel == 0xF)
	{
		//If all bits are set, sustain level is forced to 93db
		sustainLevel |= 0x10;
	}
	sustainLevel <<= 5;
	return sustainLevel;
}

//----------------------------------------------------------------------------------------
//Operator unit functions
//----------------------------------------------------------------------------------------
//This function duplicates the exact power conversion performed by the YM2612 in the
//final stage of the operator unit. It is an implementation of the following:
//   result = pow(2, -num);
// num:     A 13-bit fixed point value of the form 5.8 (5 bit whole, 8 bit fractional)
// result:  A 13-bit normalized output in the range 1-0.
//Internally, a 256 entry lookup table is used. This lookup stores a rounded 11-bit result
//for a range 0-1. Since we're dealing with powers of 2, this result can be adjusted for
//source numbers outside the range 0-1 by shifting the result.
//----------------------------------------------------------------------------------------
unsigned int YM2612::InversePow2(unsigned int num) const
{
	unsigned int shiftCount = num >> powTableBitCount;
	unsigned int tableIndex = num & ((1 << powTableBitCount) - 1);
	unsigned int tableEntry = powTable[tableIndex];
	unsigned int outputShifted = (tableEntry << 2) >> shiftCount;
	return outputShifted;
}

//----------------------------------------------------------------------------------------
int YM2612::CalculateOperator(unsigned int phase, int phaseModulation, unsigned int attenuation) const
{
	//Add the current phase and phase modulation values
	Data combinedPhase(phaseBitCount);
	combinedPhase = (unsigned int)((int)phase + phaseModulation);

	//The YM2612 sine table only stores values for a quarter of the full sine wave. We
	//separate the sign bit of the phase value here, which leaves us with a half-phase
	//representing positive wave oscillations only. For the remaining half-phase, if
	//the phase is on the second half of the oscillation (decreasing slope), we invert
	//the phase. The second half of the oscillation is a mirror of the first, so by
	//inverting the half-phase, the quarter-phase sine table can be used to resolve the
	//correct sine value for the full positive oscillation. The separated sign bit is
	//used later to correct the result for negative oscillations.
	bool signBit = combinedPhase.GetBit(phaseBitCount - 1);
	bool slopeBit = combinedPhase.GetBit(phaseBitCount - 2);
	Data quarterPhase(phaseBitCount - 2);
	quarterPhase = combinedPhase;
	if(slopeBit)
	{
		//If the MSB of the half-phase is set, the sine wave is decreasing in slope. In
		//this case, we need to invert the quarter phase value, to mirror the lookup
		//index into the sine table.
		quarterPhase = ~quarterPhase;
	}

	//Output from sinTable is a 4.8 fixed point attenuation value
	unsigned int sinValue = sinTable[quarterPhase.GetData()];
	//Convert attenuation from a 4.6 fixed point value, to a 4.8 fixed point value.
	unsigned int convertedAttenuation = attenuation << 2;
	//Combined attenuation is a 5.8 fixed point value
	unsigned int combinedAttenuation = sinValue + convertedAttenuation;

	//Convert the 5.8 fixed point attenuation value from a logarithmic representation of
	//attenuation, to a linear representation of power.
	int powResult = (int)InversePow2(combinedAttenuation);

	//Our calculated value currently represents the absolute value of the true result. If
	//the original phase value specified a negative oscillation of the wave, negate the
	//result. This will give us the true signed result.
	if(signBit)
	{
		powResult = 0 - powResult;
	}
	return powResult;
}

//----------------------------------------------------------------------------------------
//Memory interface functions
//----------------------------------------------------------------------------------------
IBusInterface::AccessResult YM2612::ReadInterface(unsigned int interfaceNumber, unsigned int location, Data& data, IDeviceContext* caller, double accessTime, unsigned int accessContext)
{
	std::unique_lock<std::mutex> lock(accessMutex);

	//Trigger a system rollback if the device has been accessed out of order. This is
	//required in order to ensure that the address register is correct when each write
	//occurs.
	if(accessTime < lastAccessTime)
	{
		GetSystemInterface().SetSystemRollback(GetDeviceContext(), caller, accessTime, accessContext);
	}
	lastAccessTime = accessTime;

	UpdateTimers(accessTime);
	data.SetLowerBits(status);

	return true;
}

//----------------------------------------------------------------------------------------
IBusInterface::AccessResult YM2612::WriteInterface(unsigned int interfaceNumber, unsigned int location, const Data& data, IDeviceContext* caller, double accessTime, unsigned int accessContext)
{
	std::unique_lock<std::mutex> lock(accessMutex);
	AccessTarget accessTarget;
	accessTarget.AccessTime(accessTime);

	//Trigger a system rollback if the device has been accessed out of order. This is
	//required in order to ensure that the register latch settings are correct when each
	//write occurs.
	if(accessTime < lastAccessTime)
	{
		GetSystemInterface().SetSystemRollback(GetDeviceContext(), caller, accessTime, accessContext);
	}
	lastAccessTime = accessTime;

	//Decode and carry out the write operation. Note that hardware tests have shown that
	//both data ports are equivalent, and that a write to either of the address ports
	//stores both the part number and the register number. Regardless of whether the
	//currently selected register is in part 1 or part 2, both data ports can be used to
	//update the currently selected register value.
	if(location == 0)
	{
		//Set the currently latched register to the specified part 1 register
		currentReg = data.GetData();
	}
	else if(location == 2)
	{
		//Set the currently latched register to the specified part 2 register
		currentReg = registerCountPerPart + data.GetData();
	}
	else if((location == 1) || (location == 3))
	{
		//Only commit this register write if it wasn't latched
		if(!rawRegisterLocking[currentReg] && !CheckForLatchedWrite(currentReg, data, accessTime))
		{
			//Write to the selected register
			RegisterSpecialUpdateFunction(currentReg, data, accessTime, caller, accessContext);
			SetRegisterData(currentReg, data, accessTarget);

			//Fix any locked registers at their set value
			std::unique_lock<std::mutex> lock2(registerLockMutex);
			for(std::map<unsigned int, std::list<RegisterLocking>>::const_iterator lockedRegisterStateIterator = lockedRegisterState.begin(); lockedRegisterStateIterator != lockedRegisterState.end(); ++lockedRegisterStateIterator)
			{
				for(std::list<RegisterLocking>::const_iterator i = lockedRegisterStateIterator->second.begin(); i != lockedRegisterStateIterator->second.end(); ++i)
				{
					WriteGenericData(i->dataID, i->GetDataContext(), i->lockedValue);
				}
			}
		}
	}

	return true;
}

//----------------------------------------------------------------------------------------
void YM2612::RegisterSpecialUpdateFunction(unsigned int location, const Data& data, double accessTime, IDeviceContext* caller, unsigned int accessContext)
{
	//Note that the only register changes which currently require special handling at the
	//time they are written are registers which relate to the timers. Writes to all other
	//registers including key-on/off notifications are handled in the render thread.
	switch(location)
	{
		//      ---------------------------------
		//      | 7 | 6 | 5 | 4 | 3 | 2 | 1 | 0 |
		//24H   |-------------------------------|
		//      |    Timer A MSBs (bits 2-9)    |
		//      ---------------------------------
		//      ---------------------------------
		//      | 7 | 6 | 5 | 4 | 3 | 2 | 1 | 0 |
		//25H   |-------------------------------|
		//      | /   /   /   /   /   / | Timer |
		//      |                       |A LSBs |
		//      ---------------------------------
	case 0x24:{
		UpdateTimers(accessTime);
		if(!timerAStateLocking.rate)
		{
			unsigned int trueTimerAInitialCounter = ~timerAInitialCounter & 0x3FF;
			trueTimerAInitialCounter = (trueTimerAInitialCounter & 0x003) | (data.GetDataSegment(0, 8) << 2);
			timerAInitialCounter = ~trueTimerAInitialCounter & 0x3FF;
		}
		break;}
	case 0x25:{
		UpdateTimers(accessTime);
		if(!timerAStateLocking.rate)
		{
			unsigned int trueTimerAInitialCounter = ~timerAInitialCounter & 0x3FF;
			trueTimerAInitialCounter = (trueTimerAInitialCounter & 0x3FC) | data.GetDataSegment(0, 2);
			timerAInitialCounter = ~trueTimerAInitialCounter & 0x3FF;
		}
		break;}
	case 0x26:
		//      ---------------------------------
		//      | 7 | 6 | 5 | 4 | 3 | 2 | 1 | 0 |
		//26H   |-------------------------------|
		//      |            Timer B            |
		//      ---------------------------------
		UpdateTimers(accessTime);
		if(!timerBStateLocking.rate)
		{
			timerBInitialCounter = ~data.GetDataSegment(0, 8) & 0xFF;
		}
		break;
	case 0x27:
		//      ---------------------------------
		//      | 7 | 6 | 5 | 4 | 3 | 2 | 1 | 0 |
		//      |-------------------------------|
		//      |       | Timer | Timer | Timer |
		//27H   |  CH3  | Reset | Enable| Load  |
		//      |  Mode |-------|-------|-------|
		//      |       | B | A | B | A | B | A |
		//      ---------------------------------
		//##TODO## According to the Y8950AM Application Manual, page 17, when the IRQ
		//RESET bit is flagged in that processor, all other bits in the write to the
		//register are ignored. Confirm this is not the case on the YM2612.
		UpdateTimers(accessTime);

		//Update the load bits for timers A and B. Note that hardware tests have shown
		//that the current counter value for a timer is reloaded when the load bit is
		//changed from 0 to 1. A timer does not resume counting from its previous
		//position when the load bit is toggled from 0 to 1. Setting the load bit to 1
		//for a timer which is already loaded does not force a re-load of the counter.
		if(!timerAStateLocking.load)
		{
			bool timerALoadNew = data.GetBit(0);
			if(!timerALoad && timerALoadNew)
			{
				timerACounter = timerAInitialCounter;
			}
			timerALoad = timerALoadNew;
		}
		if(!timerBStateLocking.load)
		{
			bool timerBLoadNew = data.GetBit(1);
			if(!timerBLoad && timerBLoadNew)
			{
				timerBCounter = timerBInitialCounter;
			}
			timerBLoad = timerBLoadNew;
		}

		//Update the enable bits for timers A and B
		if(!timerAStateLocking.enable)
		{
			timerAEnable = data.GetBit(2);
		}
		if(!timerBStateLocking.enable)
		{
			timerBEnable = data.GetBit(3);
		}

		//Update the overflow bits for timers A and B. We also negate the IRQ line here
		//if it was asserted, and is now clear after processing the reset bits.
		bool initialIntLineState = GetTimerAOverflow() || GetTimerBOverflow();
		if(!timerAStateLocking.overflow && data.GetBit(4))
		{
			SetTimerAOverflow(false);
		}
		if(!timerBStateLocking.overflow && data.GetBit(5))
		{
			SetTimerBOverflow(false);
		}
		if(initialIntLineState && !GetTimerAOverflow() && !GetTimerBOverflow())
		{
			if(memoryBus != 0)
			{
				irqLineState = false;
				memoryBus->SetLineState((unsigned int)LineID::IRQ, Data(GetLineWidth((unsigned int)LineID::IRQ), (unsigned int)irqLineState), GetDeviceContext(), caller, accessTime, accessContext);
			}
		}
		break;
	}
}

//----------------------------------------------------------------------------------------
bool YM2612::CheckForLatchedWrite(unsigned int location, const Data& data, double accessTime)
{
	AccessTarget accessTarget;
	accessTarget.AccessTime(accessTime);

	switch(location)
	{
	//If we're writing to a block/fnum register, the write needs to be put in limbo until
	//the corresponding fnum register is next written to.
	case 0xA4:
		latchedFrequencyDataPending[CHANNEL1] = true;
		latchedFrequencyData[CHANNEL1] = data;
		return true;
	case 0xA5:
		latchedFrequencyDataPending[CHANNEL2] = true;
		latchedFrequencyData[CHANNEL2] = data;
		return true;
	case 0xA6:
		latchedFrequencyDataPending[CHANNEL3] = true;
		latchedFrequencyData[CHANNEL3] = data;
		return true;
	case 0x1A4:
		latchedFrequencyDataPending[CHANNEL4] = true;
		latchedFrequencyData[CHANNEL4] = data;
		return true;
	case 0x1A5:
		latchedFrequencyDataPending[CHANNEL5] = true;
		latchedFrequencyData[CHANNEL5] = data;
		return true;
	case 0x1A6:
		latchedFrequencyDataPending[CHANNEL6] = true;
		latchedFrequencyData[CHANNEL6] = data;
		return true;
	case 0xAD:
		latchedFrequencyDataPendingCH3[0] = true;
		latchedFrequencyDataCH3[0] = data;
		return true;
	case 0xAC:
		latchedFrequencyDataPendingCH3[1] = true;
		latchedFrequencyDataCH3[1] = data;
		return true;
	case 0xAE:
		latchedFrequencyDataPendingCH3[2] = true;
		latchedFrequencyDataCH3[2] = data;
		return true;

	//If we're writing to an fnum register, commit any latched write to the corresponding
	//block/fnum register.
	case 0xA0:
		if(latchedFrequencyDataPending[CHANNEL1])
		{
			SetRegisterData(0xA4, latchedFrequencyData[CHANNEL1], accessTarget);
			latchedFrequencyDataPending[CHANNEL1] = false;
			latchedFrequencyData[CHANNEL1] = 0;
		}
		return false;
	case 0xA1:
		if(latchedFrequencyDataPending[CHANNEL2])
		{
			SetRegisterData(0xA5, latchedFrequencyData[CHANNEL2], accessTarget);
			latchedFrequencyDataPending[CHANNEL2] = false;
			latchedFrequencyData[CHANNEL2] = 0;
		}
		return false;
	case 0xA2:
		if(latchedFrequencyDataPending[CHANNEL3])
		{
			SetRegisterData(0xA6, latchedFrequencyData[CHANNEL3], accessTarget);
			latchedFrequencyDataPending[CHANNEL3] = false;
			latchedFrequencyData[CHANNEL3] = 0;
		}
		return false;
	case 0x1A0:
		if(latchedFrequencyDataPending[CHANNEL4])
		{
			SetRegisterData(0x1A4, latchedFrequencyData[CHANNEL4], accessTarget);
			latchedFrequencyDataPending[CHANNEL4] = false;
			latchedFrequencyData[CHANNEL4] = 0;
		}
		return false;
	case 0x1A1:
		if(latchedFrequencyDataPending[CHANNEL5])
		{
			SetRegisterData(0x1A5, latchedFrequencyData[CHANNEL5], accessTarget);
			latchedFrequencyDataPending[CHANNEL5] = false;
			latchedFrequencyData[CHANNEL5] = 0;
		}
		return false;
	case 0x1A2:
		if(latchedFrequencyDataPending[CHANNEL6])
		{
			SetRegisterData(0x1A6, latchedFrequencyData[CHANNEL6], accessTarget);
			latchedFrequencyDataPending[CHANNEL6] = false;
			latchedFrequencyData[CHANNEL6] = 0;
		}
		return false;
	case 0xA9:
		if(latchedFrequencyDataPendingCH3[0])
		{
			SetRegisterData(0xAD, latchedFrequencyDataCH3[0], accessTarget);
			latchedFrequencyDataPendingCH3[0] = false;
			latchedFrequencyDataCH3[0] = 0;
		}
		return false;
	case 0xA8:
		if(latchedFrequencyDataPendingCH3[1])
		{
			SetRegisterData(0xAC, latchedFrequencyDataCH3[1], accessTarget);
			latchedFrequencyDataPendingCH3[1] = false;
			latchedFrequencyDataCH3[1] = 0;
		}
		return false;
	case 0xAA:
		if(latchedFrequencyDataPendingCH3[2])
		{
			SetRegisterData(0xAE, latchedFrequencyDataCH3[2], accessTarget);
			latchedFrequencyDataPendingCH3[2] = false;
			latchedFrequencyDataCH3[2] = 0;
		}
		return false;
	}
	return false;
}

//----------------------------------------------------------------------------------------
//Timer management functions
//----------------------------------------------------------------------------------------
void YM2612::UpdateTimers(double timesliceProgress)
{
	//Calculate the total number of cycles that have executed since the last timer update
	double initialTimersRemainingTime = timersRemainingTime;
	double timerClockPeriod = 1000000000.0 / ((externalClockRate / (double)fmClockDivider) / (double)outputClockDivider);
	double timePeriod = timersRemainingTime + (timesliceProgress - timersLastUpdateTime);
	unsigned int timerClockCyclesExecuted = (unsigned int)(timePeriod / timerClockPeriod);
	timersRemainingTime = timePeriod - ((double)timerClockCyclesExecuted * timerClockPeriod);
	timersLastUpdateTime = timesliceProgress;

	//Calculate the total number of steps the timers have advanced
	unsigned int initialTimerARemainingCycles = timerARemainingCycles;
	unsigned int totalTimerACyclesExecuted = (timerClockCyclesExecuted + timerARemainingCycles) / timerAClockDivider;
	timerARemainingCycles = (timerClockCyclesExecuted + timerARemainingCycles) % timerAClockDivider;
	unsigned int initialTimerBRemainingCycles = timerBRemainingCycles;
	unsigned int totalTimerBCyclesExecuted = (timerClockCyclesExecuted + timerBRemainingCycles) / timerBClockDivider;
	timerBRemainingCycles = (timerClockCyclesExecuted + timerBRemainingCycles) % timerBClockDivider;

	//If timer A is loaded and the counter isn't locked, update the timer value
	if(timerALoad && !timerAStateLocking.counter)
	{
		unsigned int timerAPeriod = timerAInitialCounter + 1;

		//Calculate each overflow time. In the case of timer A, we do this regardless of
		//whether the timer is enabled, or whether the overflow flag is locked, since CSM
		//key-on events are still generated each time timer A expires, regardless of
		//whether the timer is enabled or the state of the overflow bit.
		int timerAOverflowCount = ((int)totalTimerACyclesExecuted + ((int)timerAInitialCounter - (int)timerACounter)) / (int)timerAPeriod;
		for(int i = 0; i < timerAOverflowCount; ++i)
		{
			unsigned int overflowCycle = ((unsigned int)i * timerAPeriod) + timerACounter;
			double interruptTime = ((double)((overflowCycle * timerAClockDivider) + initialTimerARemainingCycles) * timerClockPeriod) - initialTimersRemainingTime;

			//Only use this overflow time to adjust the overflow flag and IRQ line state
			//if the timer is enabled, and the overflow flag isn't locked.
			if(timerAEnable && !timerAStateLocking.overflow)
			{
				//If the IRQ line is currently negated, and we're about to generate an
				//overflow, assert the IRQ line.
				if(!GetTimerAOverflow() && !GetTimerBOverflow())
				{
					if(memoryBus != 0)
					{
						irqLineState = true;
						memoryBus->SetLineState((unsigned int)LineID::IRQ, Data(GetLineWidth((unsigned int)LineID::IRQ), (unsigned int)irqLineState), GetDeviceContext(), GetDeviceContext(), interruptTime, (unsigned int)AccessContext::IRQ);
					}
				}
				//Update the overflow flag
				SetTimerAOverflow(true);
			}
			//Record the exact times when each timer A overflow occurred since the
			//last update cycle. This is required in order to implement accurate CSM
			//support.
			timerAOverflowTimes.Write(interruptTime, true);
		}

		//Calculate the new counter value for the timer
		unsigned int timerACounterDisplace = totalTimerACyclesExecuted % timerAPeriod;
		timerACounter = (timerACounter + (timerAPeriod - timerACounterDisplace)) % timerAPeriod;
	}

	//If timer B is loaded and the counter isn't locked, update the timer value
	if(timerBLoad && !timerBStateLocking.counter)
	{
		unsigned int timerBPeriod = timerBInitialCounter + 1;

		//If the timer is enabled, generate interrupts for each time an overflow has
		//occurred, and update the overflow flag.
		if(timerBEnable && !timerBStateLocking.overflow)
		{
			//Calculate each overflow time
			int timerBOverflowCount = ((int)totalTimerBCyclesExecuted + ((int)timerBInitialCounter - (int)timerBCounter)) / (int)timerBPeriod;
			for(int i = 0; i < timerBOverflowCount; ++i)
			{
				unsigned int overflowCycle = ((unsigned int)i * timerBPeriod) + timerBCounter;
				double interruptTime = ((double)((overflowCycle * timerBClockDivider) + initialTimerBRemainingCycles) * timerClockPeriod) - initialTimersRemainingTime;
				//If the IRQ line is currently negated, and we're about to generate an
				//overflow, assert the IRQ line.
				if(!GetTimerAOverflow() && !GetTimerBOverflow())
				{
					if(memoryBus != 0)
					{
						irqLineState = true;
						memoryBus->SetLineState((unsigned int)LineID::IRQ, Data(GetLineWidth((unsigned int)LineID::IRQ), (unsigned int)irqLineState), GetDeviceContext(), GetDeviceContext(), interruptTime, (unsigned int)AccessContext::IRQ);
					}
				}
				//Update the overflow flag
				SetTimerBOverflow(true);
			}
		}

		//Calculate the new counter value for the timer
		unsigned int timerBCounterDisplace = totalTimerBCyclesExecuted % timerBPeriod;
		timerBCounter = (timerBCounter + (timerBPeriod - timerBCounterDisplace)) % timerBPeriod;
	}
}

//----------------------------------------------------------------------------------------
//Savestate functions
//----------------------------------------------------------------------------------------
void YM2612::LoadState(IHierarchicalStorageNode& node)
{
	std::list<IHierarchicalStorageNode*> childList = node.GetChildList();
	for(std::list<IHierarchicalStorageNode*>::iterator i = childList.begin(); i != childList.end(); ++i)
	{
		//Clock settings
		if((*i)->GetName() == L"ExternalClockRate")
		{
			(*i)->ExtractData(externalClockRate);
		}

		//Bus interface
		else if((*i)->GetName() == L"ICLineState")
		{
			icLineState = (*i)->ExtractData<bool>();
		}

		//Register data
		else if((*i)->GetName() == L"Registers")
		{
			reg.LoadState(*(*i));
		}
		else if((*i)->GetName() == L"StatusRegister")
		{
			(*i)->ExtractData(status);
		}

		//Register latch settings
		else if((*i)->GetName() == L"LatchedRegister")
		{
			(*i)->ExtractData(currentReg);
		}
		else if((*i)->GetName() == L"LatchedFrequencyData")
		{
			unsigned int channelNo;
			if((*i)->ExtractAttribute(L"ChannelNo", channelNo) && (channelNo < channelCount))
			{
				latchedFrequencyDataPending[channelNo] = true;
				(*i)->ExtractData(latchedFrequencyData[channelNo]);
			}
		}
		else if((*i)->GetName() == L"LatchedFrequencyDataCH3")
		{
			unsigned int operatorNo;
			if((*i)->ExtractAttribute(L"OperatorNo", operatorNo) && (operatorNo < operatorCount))
			{
				latchedFrequencyDataPendingCH3[operatorNo] = true;
				(*i)->ExtractData(latchedFrequencyDataCH3[operatorNo]);
			}
		}

		//Render thread properties
		else if((*i)->GetName() == L"RemainingRenderTime")
		{
			(*i)->ExtractData(remainingRenderTime);
		}
		else if((*i)->GetName() == L"EGRemainingRenderCycles")
		{
			(*i)->ExtractData(egRemainingRenderCycles);
		}

		//Render data
		else if((*i)->GetName() == L"EnvelopeCycleCounter")
		{
			(*i)->ExtractHexData(envelopeCycleCounter);
		}
		else if((*i)->GetName() == L"RenderData")
		{
			unsigned int channelNo;
			unsigned int operatorNo;
			if((*i)->ExtractAttribute(L"ChannelNo", channelNo) && (channelNo < channelCount) &&
			   (*i)->ExtractAttribute(L"OperatorNo", operatorNo) && (operatorNo < operatorCount))
			{
				OperatorData* state = &operatorData[channelNo][operatorNo];
				(*i)->ExtractAttributeHex(L"Attenuation", state->attenuation);
				(*i)->ExtractAttributeHex(L"PhaseCounter", state->phaseCounter);
				if(!keyStateLocking[channelNo][operatorNo])
				{
					(*i)->ExtractAttribute(L"KeyOn", state->keyon);
				}
				(*i)->ExtractAttribute(L"CSMKeyOn", state->csmKeyOn);
				(*i)->ExtractAttribute(L"KeyOnPrevious", state->keyonPrevious);
				(*i)->ExtractAttribute(L"SSGOutputInverted", state->ssgOutputInverted);

				std::wstring phaseString;
				(*i)->ExtractAttribute(L"Phase", phaseString);
				if(phaseString == L"ADSR_ATTACK")
				{
					state->phase = OperatorData::ADSR_ATTACK;
				}
				else if(phaseString == L"ADSR_DECAY")
				{
					state->phase = OperatorData::ADSR_DECAY;
				}
				else if(phaseString == L"ADSR_SUSTAIN")
				{
					state->phase = OperatorData::ADSR_SUSTAIN;
				}
				else if(phaseString == L"ADSR_RELEASE")
				{
					state->phase = OperatorData::ADSR_RELEASE;
				}
			}
		}
		else if((*i)->GetName() == L"OP1FeedbackData")
		{
			unsigned int channelNo;
			if((*i)->ExtractAttribute(L"ChannelNo", channelNo) && (channelNo < channelCount))
			{
				(*i)->ExtractAttributeHex(L"Sample1", feedbackBuffer[channelNo][0]);
				(*i)->ExtractAttributeHex(L"Sample2", feedbackBuffer[channelNo][1]);
			}
		}
		else if((*i)->GetName() == L"CyclesUntilLFOIncrement")
		{
			(*i)->ExtractData(cyclesUntilLFOIncrement);
		}
		else if((*i)->GetName() == L"CurrentLFOCounter")
		{
			(*i)->ExtractData(currentLFOCounter);
		}

		//Timer status
		else if((*i)->GetName() == L"LastTimesliceLength")
		{
			(*i)->ExtractData(lastTimesliceLength);
		}
		else if((*i)->GetName() == L"TimersRemainingTime")
		{
			(*i)->ExtractData(timersRemainingTime);
		}
		else if((*i)->GetName() == L"TimerARemainingCycles")
		{
			(*i)->ExtractData(timerARemainingCycles);
		}
		else if((*i)->GetName() == L"TimerBRemainingCycles")
		{
			(*i)->ExtractData(timerBRemainingCycles);
		}
		else if(((*i)->GetName() == L"TimerACounter") && !timerAStateLocking.counter)
		{
			(*i)->ExtractData(timerACounter);
		}
		else if(((*i)->GetName() == L"TimerBCounter") && !timerBStateLocking.counter)
		{
			(*i)->ExtractData(timerBCounter);
		}
		else if(((*i)->GetName() == L"TimerAInitialCounter") && !timerAStateLocking.rate)
		{
			(*i)->ExtractData(timerAInitialCounter);
		}
		else if(((*i)->GetName() == L"TimerBInitialCounter") && !timerBStateLocking.rate)
		{
			(*i)->ExtractData(timerBInitialCounter);
		}
		else if(((*i)->GetName() == L"TimerAEnable") && !timerAStateLocking.enable)
		{
			(*i)->ExtractData(timerAEnable);
		}
		else if(((*i)->GetName() == L"TimerBEnable") && !timerBStateLocking.enable)
		{
			(*i)->ExtractData(timerBEnable);
		}
		else if(((*i)->GetName() == L"TimerALoad") && !timerAStateLocking.load)
		{
			(*i)->ExtractData(timerALoad);
		}
		else if(((*i)->GetName() == L"TimerBLoad") && !timerBStateLocking.load)
		{
			(*i)->ExtractData(timerBLoad);
		}
	}

	//Fix any locked registers at their set value
	std::unique_lock<std::mutex> lock2(registerLockMutex);
	for(std::map<unsigned int, std::list<RegisterLocking>>::const_iterator lockedRegisterStateIterator = lockedRegisterState.begin(); lockedRegisterStateIterator != lockedRegisterState.end(); ++lockedRegisterStateIterator)
	{
		for(std::list<RegisterLocking>::const_iterator i = lockedRegisterStateIterator->second.begin(); i != lockedRegisterStateIterator->second.end(); ++i)
		{
			WriteGenericData(i->dataID, i->GetDataContext(), i->lockedValue);
		}
	}
}

//----------------------------------------------------------------------------------------
void YM2612::SaveState(IHierarchicalStorageNode& node) const
{
	//Clock settings
	node.CreateChild(L"ExternalClockRate").SetData(externalClockRate);

	//Bus interface
	node.CreateChild(L"ICLineState").SetData(icLineState);

	//Register data
	IHierarchicalStorageNode& regNode = node.CreateChild(L"Registers");
	std::wstring regBufferName = GetFullyQualifiedDeviceInstanceName();
	regBufferName += L".Registers";
	reg.SaveState(regNode, regBufferName, false);
	node.CreateChild(L"StatusRegister").SetData(status);

	//Register latch settings
	node.CreateChild(L"LatchedRegister").SetData(currentReg);
	for(unsigned int i = 0; i < channelCount; ++i)
	{
		if(latchedFrequencyDataPending[i])
		{
			node.CreateChild(L"LatchedFrequencyData").SetData(latchedFrequencyData[i]).CreateAttribute(L"ChannelNo", i);
		}
	}
	for(unsigned int i = 0; i < 3; ++i)
	{
		if(latchedFrequencyDataPendingCH3[i])
		{
			node.CreateChild(L"LatchedFrequencyDataCH3").SetData(latchedFrequencyDataCH3[i]).CreateAttribute(L"OperatorNo", i);
		}
	}

	//Render thread properties
	node.CreateChild(L"RemainingRenderTime", remainingRenderTime);
	node.CreateChild(L"EGRemainingRenderCycles", egRemainingRenderCycles);

	//Render data
	node.CreateChildHex(L"EnvelopeCycleCounter", envelopeCycleCounter, sizeof(envelopeCycleCounter)*2);
	for(unsigned int channelNo = 0; channelNo < channelCount; ++channelNo)
	{
		for(unsigned int operatorNo = 0; operatorNo < operatorCount; ++operatorNo)
		{
			const OperatorData* state = &operatorData[channelNo][operatorNo];
			IHierarchicalStorageNode& renderDataState = node.CreateChild(L"RenderData");
			renderDataState.CreateAttribute(L"ChannelNo", channelNo);
			renderDataState.CreateAttribute(L"OperatorNo", operatorNo);
			renderDataState.CreateAttributeHex(L"Attenuation", state->attenuation, (attenuationBitCount+3)/4);
			renderDataState.CreateAttributeHex(L"PhaseCounter", state->phaseCounter, (phaseBitCount+3)/4);
			renderDataState.CreateAttribute(L"KeyOn", state->keyon);
			renderDataState.CreateAttribute(L"CSMKeyOn", state->csmKeyOn);
			renderDataState.CreateAttribute(L"KeyOnPrevious", state->keyonPrevious);
			renderDataState.CreateAttribute(L"SSGOutputInverted", state->ssgOutputInverted);

			std::wstring phaseString;
			switch(state->phase)
			{
			case OperatorData::ADSR_ATTACK:
				phaseString = L"ADSR_ATTACK";
				break;
			case OperatorData::ADSR_DECAY:
				phaseString = L"ADSR_DECAY";
				break;
			case OperatorData::ADSR_SUSTAIN:
				phaseString = L"ADSR_SUSTAIN";
				break;
			case OperatorData::ADSR_RELEASE:
				phaseString = L"ADSR_RELEASE";
				break;
			}
			renderDataState.CreateAttribute(L"Phase", phaseString);
		}
	}
	for(unsigned int i = 0; i < channelCount; ++i)
	{
		IHierarchicalStorageNode& feedbackData = node.CreateChild(L"OP1FeedbackData");
		feedbackData.CreateAttribute(L"ChannelNo", i);
		feedbackData.CreateAttributeHex(L"Sample1", feedbackBuffer[i][0], (operatorOutputBitCount+3)/4);
		feedbackData.CreateAttributeHex(L"Sample2", feedbackBuffer[i][1], (operatorOutputBitCount+3)/4);
	}
	node.CreateChild(L"CyclesUntilLFOIncrement", cyclesUntilLFOIncrement);
	node.CreateChild(L"CurrentLFOCounter", currentLFOCounter);

	//Timer status
	node.CreateChild(L"LastTimesliceLength", lastTimesliceLength);
	node.CreateChild(L"TimersRemainingTime", timersRemainingTime);
	node.CreateChild(L"TimerARemainingCycles", timerARemainingCycles);
	node.CreateChild(L"TimerBRemainingCycles", timerBRemainingCycles);
	node.CreateChild(L"TimerACounter", timerACounter);
	node.CreateChild(L"TimerBCounter", timerBCounter);
	node.CreateChild(L"TimerAInitialCounter", timerAInitialCounter);
	node.CreateChild(L"TimerBInitialCounter", timerBInitialCounter);
	node.CreateChild(L"TimerAEnable", timerAEnable);
	node.CreateChild(L"TimerBEnable", timerBEnable);
	node.CreateChild(L"TimerALoad", timerALoad);
	node.CreateChild(L"TimerBLoad", timerBLoad);
}

//----------------------------------------------------------------------------------------
void YM2612::LoadDebuggerState(IHierarchicalStorageNode& node)
{
	//Initialize the register locking state
	std::unique_lock<std::mutex> lock2(registerLockMutex);
	lockedRegisterState.clear();
	for(unsigned int i = 0; i < registerCountTotal; ++i)
	{
		rawRegisterLocking[i] = false;
	}
	for(unsigned int channelNo = 0; channelNo < channelCount; ++channelNo)
	{
		for(unsigned int operatorNo = 0; operatorNo < operatorCount; ++operatorNo)
		{
			keyStateLocking[channelNo][operatorNo] = false;
		}
	}
	timerAStateLocking.rate = false;
	timerAStateLocking.counter = false;
	timerAStateLocking.load = false;
	timerAStateLocking.enable = false;
	timerAStateLocking.overflow = false;
	timerBStateLocking.rate = false;
	timerBStateLocking.counter = false;
	timerBStateLocking.load = false;
	timerBStateLocking.enable = false;
	timerBStateLocking.overflow = false;

	//Load the register locking state
	std::list<IHierarchicalStorageNode*> childList = node.GetChildList();
	for(std::list<IHierarchicalStorageNode*>::iterator i = childList.begin(); i != childList.end(); ++i)
	{
		if((*i)->GetName() == L"LockedRegisterState")
		{
			unsigned int dataID;
			std::wstring lockedValue;
			if((*i)->ExtractAttribute(L"DataID", dataID) && (*i)->ExtractAttribute(L"LockedValue", lockedValue))
			{
				IHierarchicalStorageAttribute* usingChannelDataContextAttribute = (*i)->GetAttribute(L"UsingChannelDataContext");
				IHierarchicalStorageAttribute* usingOperatorDataContextAttribute = (*i)->GetAttribute(L"UsingOperatorDataContext");
				if(usingChannelDataContextAttribute != 0)
				{
					unsigned int channelNo;
					if((*i)->ExtractAttribute(L"ChannelNo", channelNo))
					{
						lockedRegisterState[dataID].push_back(RegisterLocking(dataID, ChannelDataContext(channelNo), lockedValue));
					}
				}
				else if(usingOperatorDataContextAttribute != 0)
				{
					unsigned int channelNo;
					unsigned int operatorNo;
					if((*i)->ExtractAttribute(L"ChannelNo", channelNo) && (*i)->ExtractAttribute(L"OperatorNo", operatorNo))
					{
						lockedRegisterState[dataID].push_back(RegisterLocking(dataID, OperatorDataContext(channelNo, operatorNo), lockedValue));
					}
				}
				else
				{
					lockedRegisterState[dataID].push_back(RegisterLocking(dataID, lockedValue));
				}
			}
		}
		else if((*i)->GetName() == L"LockedRawRegister")
		{
			unsigned int registerNo;
			if((*i)->ExtractAttribute(L"RegisterNo", registerNo))
			{
				if(registerNo < registerCountTotal)
				{
					rawRegisterLocking[registerNo] = true;
				}
			}
		}
		else if((*i)->GetName() == L"LockedKeyState")
		{
			unsigned int channelNo;
			unsigned int operatorNo;
			if((*i)->ExtractAttribute(L"ChannelNo", channelNo) && (*i)->ExtractAttribute(L"OperatorNo", operatorNo))
			{
				if((channelNo < channelCount) && (operatorNo < operatorCount))
				{
					keyStateLocking[channelNo][operatorNo] = true;
				}
			}
		}
		else if((*i)->GetName() == L"LockedTimerARate")
		{
			timerAStateLocking.rate = true;
		}
		else if((*i)->GetName() == L"LockedTimerACounter")
		{
			timerAStateLocking.counter = true;
		}
		else if((*i)->GetName() == L"LockedTimerALoad")
		{
			timerAStateLocking.load = true;
		}
		else if((*i)->GetName() == L"LockedTimerAEnable")
		{
			timerAStateLocking.enable = true;
		}
		else if((*i)->GetName() == L"LockedTimerAOverflow")
		{
			timerAStateLocking.overflow = true;
		}
		else if((*i)->GetName() == L"LockedTimerBRate")
		{
			timerBStateLocking.rate = true;
		}
		else if((*i)->GetName() == L"LockedTimerBCounter")
		{
			timerBStateLocking.counter = true;
		}
		else if((*i)->GetName() == L"LockedTimerBLoad")
		{
			timerBStateLocking.load = true;
		}
		else if((*i)->GetName() == L"LockedTimerBEnable")
		{
			timerBStateLocking.enable = true;
		}
		else if((*i)->GetName() == L"LockedTimerBOverflow")
		{
			timerBStateLocking.overflow = true;
		}
	}
}

//----------------------------------------------------------------------------------------
void YM2612::SaveDebuggerState(IHierarchicalStorageNode& node) const
{
	//Save the register locking state
	for(std::map<unsigned int, std::list<RegisterLocking>>::const_iterator lockedRegisterStateIterator = lockedRegisterState.begin(); lockedRegisterStateIterator != lockedRegisterState.end(); ++lockedRegisterStateIterator)
	{
		for(std::list<RegisterLocking>::const_iterator lockedRegisterStateListIterator = lockedRegisterStateIterator->second.begin(); lockedRegisterStateListIterator != lockedRegisterStateIterator->second.end(); ++lockedRegisterStateListIterator)
		{
			const RegisterLocking& registerLockingInfo = *lockedRegisterStateListIterator;
			IHierarchicalStorageNode& childNode = node.CreateChild(L"LockedRegisterState");
			childNode.CreateAttribute(L"DataID", registerLockingInfo.dataID);
			childNode.CreateAttribute(L"LockedValue", registerLockingInfo.lockedValue);
			if(registerLockingInfo.usingChannelDataContext)
			{
				childNode.CreateAttribute(L"UsingChannelDataContext", true);
				childNode.CreateAttribute(L"ChannelNo", registerLockingInfo.channelDataContext.channelNo);
			}
			else if(registerLockingInfo.usingOperatorDataContext)
			{
				childNode.CreateAttribute(L"UsingOperatorDataContext", true);
				childNode.CreateAttribute(L"ChannelNo", registerLockingInfo.operatorDataContext.channelNo);
				childNode.CreateAttribute(L"OperatorNo", registerLockingInfo.operatorDataContext.operatorNo);
			}
		}
	}
	for(unsigned int i = 0; i < registerCountTotal; ++i)
	{
		if(rawRegisterLocking[i])
		{
			node.CreateChild(L"LockedRawRegister").CreateAttributeHex(L"RegisterNo", i, 3);
		}
	}
	for(unsigned int channelNo = 0; channelNo < channelCount; ++channelNo)
	{
		for(unsigned int operatorNo = 0; operatorNo < operatorCount; ++operatorNo)
		{
			if(keyStateLocking[channelNo][operatorNo])
			{
				node.CreateChild(L"LockedKeyState").CreateAttribute(L"ChannelNo", channelNo).CreateAttribute(L"OperatorNo", operatorNo);
			}
		}
	}
	if(timerAStateLocking.rate)
	{
		node.CreateChild(L"LockedTimerARate");
	}
	if(timerAStateLocking.counter)
	{
		node.CreateChild(L"LockedTimerACounter");
	}
	if(timerAStateLocking.load)
	{
		node.CreateChild(L"LockedTimerALoad");
	}
	if(timerAStateLocking.enable)
	{
		node.CreateChild(L"LockedTimerAEnable");
	}
	if(timerAStateLocking.overflow)
	{
		node.CreateChild(L"LockedTimerAOverflow");
	}
	if(timerBStateLocking.rate)
	{
		node.CreateChild(L"LockedTimerBRate");
	}
	if(timerBStateLocking.counter)
	{
		node.CreateChild(L"LockedTimerBCounter");
	}
	if(timerBStateLocking.load)
	{
		node.CreateChild(L"LockedTimerBLoad");
	}
	if(timerBStateLocking.enable)
	{
		node.CreateChild(L"LockedTimerBEnable");
	}
	if(timerBStateLocking.overflow)
	{
		node.CreateChild(L"LockedTimerBOverflow");
	}
}

//----------------------------------------------------------------------------------------
//Data read/write functions
//----------------------------------------------------------------------------------------
bool YM2612::ReadGenericData(unsigned int dataID, const DataContext* dataContext, IGenericAccessDataValue& dataValue) const
{
	ApplyGenericDataValueDisplaySettings(dataID, dataValue);
	switch((IYM2612DataSource)dataID)
	{
	case IYM2612DataSource::RawRegister:{
		const RegisterDataContext& registerDataContext = *((RegisterDataContext*)dataContext);
		Data registerData = GetRegisterData(registerDataContext.registerNo, AccessTarget().AccessLatest());
		return dataValue.SetValue(registerData.GetData());}
	case IYM2612DataSource::TestData:
		return dataValue.SetValue(GetTestData(AccessTarget().AccessLatest()));
	case IYM2612DataSource::LFOEnabled:
		return dataValue.SetValue(GetLFOEnabled(AccessTarget().AccessLatest()));
	case IYM2612DataSource::LFOData:
		return dataValue.SetValue(GetLFOData(AccessTarget().AccessLatest()));
	case IYM2612DataSource::TimerAData:
		return dataValue.SetValue(GetTimerAData(AccessTarget().AccessLatest()));
	case IYM2612DataSource::TimerBData:
		return dataValue.SetValue(GetTimerBData(AccessTarget().AccessLatest()));
	case IYM2612DataSource::CH3Mode:
		return dataValue.SetValue(GetCH3Mode(AccessTarget().AccessLatest()));
	case IYM2612DataSource::TimerBReset:
		return dataValue.SetValue(GetTimerBReset(AccessTarget().AccessLatest()));
	case IYM2612DataSource::TimerAReset:
		return dataValue.SetValue(GetTimerAReset(AccessTarget().AccessLatest()));
	case IYM2612DataSource::TimerBEnable:
		return dataValue.SetValue(timerBEnable);
	case IYM2612DataSource::TimerAEnable:
		return dataValue.SetValue(timerAEnable);
	case IYM2612DataSource::TimerBLoad:
		return dataValue.SetValue(timerBLoad);
	case IYM2612DataSource::TimerALoad:
		return dataValue.SetValue(timerALoad);
	case IYM2612DataSource::DACData:
		return dataValue.SetValue(GetDACData(AccessTarget().AccessLatest()));
	case IYM2612DataSource::DACEnabled:
		return dataValue.SetValue(GetDACEnabled(AccessTarget().AccessLatest()));
	case IYM2612DataSource::DetuneData:{
		const OperatorDataContext& operatorDataContext = *((OperatorDataContext*)dataContext);
		unsigned int operatorAddressOffset = GetOperatorBlockAddressOffset(operatorDataContext.channelNo, operatorDataContext.operatorNo);
		return dataValue.SetValue(GetDetuneData(operatorAddressOffset, AccessTarget().AccessLatest()));}
	case IYM2612DataSource::MultipleData:{
		const OperatorDataContext& operatorDataContext = *((OperatorDataContext*)dataContext);
		unsigned int operatorAddressOffset = GetOperatorBlockAddressOffset(operatorDataContext.channelNo, operatorDataContext.operatorNo);
		return dataValue.SetValue(GetMultipleData(operatorAddressOffset, AccessTarget().AccessLatest()));}
	case IYM2612DataSource::TotalLevelData:{
		const OperatorDataContext& operatorDataContext = *((OperatorDataContext*)dataContext);
		unsigned int operatorAddressOffset = GetOperatorBlockAddressOffset(operatorDataContext.channelNo, operatorDataContext.operatorNo);
		return dataValue.SetValue(GetTotalLevelData(operatorAddressOffset, AccessTarget().AccessLatest()));}
	case IYM2612DataSource::KeyScaleData:{
		const OperatorDataContext& operatorDataContext = *((OperatorDataContext*)dataContext);
		unsigned int operatorAddressOffset = GetOperatorBlockAddressOffset(operatorDataContext.channelNo, operatorDataContext.operatorNo);
		return dataValue.SetValue(GetKeyScaleData(operatorAddressOffset, AccessTarget().AccessLatest()));}
	case IYM2612DataSource::AttackRateData:{
		const OperatorDataContext& operatorDataContext = *((OperatorDataContext*)dataContext);
		unsigned int operatorAddressOffset = GetOperatorBlockAddressOffset(operatorDataContext.channelNo, operatorDataContext.operatorNo);
		return dataValue.SetValue(GetAttackRateData(operatorAddressOffset, AccessTarget().AccessLatest()));}
	case IYM2612DataSource::AmplitudeModulationEnabled:{
		const OperatorDataContext& operatorDataContext = *((OperatorDataContext*)dataContext);
		unsigned int operatorAddressOffset = GetOperatorBlockAddressOffset(operatorDataContext.channelNo, operatorDataContext.operatorNo);
		return dataValue.SetValue(GetAmplitudeModulationEnabled(operatorAddressOffset, AccessTarget().AccessLatest()));}
	case IYM2612DataSource::DecayRateData:{
		const OperatorDataContext& operatorDataContext = *((OperatorDataContext*)dataContext);
		unsigned int operatorAddressOffset = GetOperatorBlockAddressOffset(operatorDataContext.channelNo, operatorDataContext.operatorNo);
		return dataValue.SetValue(GetDecayRateData(operatorAddressOffset, AccessTarget().AccessLatest()));}
	case IYM2612DataSource::SustainRateData:{
		const OperatorDataContext& operatorDataContext = *((OperatorDataContext*)dataContext);
		unsigned int operatorAddressOffset = GetOperatorBlockAddressOffset(operatorDataContext.channelNo, operatorDataContext.operatorNo);
		return dataValue.SetValue(GetSustainRateData(operatorAddressOffset, AccessTarget().AccessLatest()));}
	case IYM2612DataSource::SustainLevelData:{
		const OperatorDataContext& operatorDataContext = *((OperatorDataContext*)dataContext);
		unsigned int operatorAddressOffset = GetOperatorBlockAddressOffset(operatorDataContext.channelNo, operatorDataContext.operatorNo);
		return dataValue.SetValue(GetSustainLevelData(operatorAddressOffset, AccessTarget().AccessLatest()));}
	case IYM2612DataSource::ReleaseRateData:{
		const OperatorDataContext& operatorDataContext = *((OperatorDataContext*)dataContext);
		unsigned int operatorAddressOffset = GetOperatorBlockAddressOffset(operatorDataContext.channelNo, operatorDataContext.operatorNo);
		return dataValue.SetValue(GetReleaseRateData(operatorAddressOffset, AccessTarget().AccessLatest()));}
	case IYM2612DataSource::SSGData:{
		const OperatorDataContext& operatorDataContext = *((OperatorDataContext*)dataContext);
		unsigned int operatorAddressOffset = GetOperatorBlockAddressOffset(operatorDataContext.channelNo, operatorDataContext.operatorNo);
		return dataValue.SetValue(GetSSGData(operatorAddressOffset, AccessTarget().AccessLatest()));}
	case IYM2612DataSource::SSGEnabled:{
		const OperatorDataContext& operatorDataContext = *((OperatorDataContext*)dataContext);
		unsigned int operatorAddressOffset = GetOperatorBlockAddressOffset(operatorDataContext.channelNo, operatorDataContext.operatorNo);
		return dataValue.SetValue(GetSSGEnabled(operatorAddressOffset, AccessTarget().AccessLatest()));}
	case IYM2612DataSource::SSGAttack:{
		const OperatorDataContext& operatorDataContext = *((OperatorDataContext*)dataContext);
		unsigned int operatorAddressOffset = GetOperatorBlockAddressOffset(operatorDataContext.channelNo, operatorDataContext.operatorNo);
		return dataValue.SetValue(GetSSGAttack(operatorAddressOffset, AccessTarget().AccessLatest()));}
	case IYM2612DataSource::SSGAlternate:{
		const OperatorDataContext& operatorDataContext = *((OperatorDataContext*)dataContext);
		unsigned int operatorAddressOffset = GetOperatorBlockAddressOffset(operatorDataContext.channelNo, operatorDataContext.operatorNo);
		return dataValue.SetValue(GetSSGAlternate(operatorAddressOffset, AccessTarget().AccessLatest()));}
	case IYM2612DataSource::SSGHold:{
		const OperatorDataContext& operatorDataContext = *((OperatorDataContext*)dataContext);
		unsigned int operatorAddressOffset = GetOperatorBlockAddressOffset(operatorDataContext.channelNo, operatorDataContext.operatorNo);
		return dataValue.SetValue(GetSSGHold(operatorAddressOffset, AccessTarget().AccessLatest()));}
	case IYM2612DataSource::FrequencyData:{
		const ChannelDataContext& channelDataContext = *((ChannelDataContext*)dataContext);
		unsigned int channelAddressOffset = GetChannelBlockAddressOffset(channelDataContext.channelNo);
		return dataValue.SetValue(GetFrequencyData(channelAddressOffset, AccessTarget().AccessLatest()));}
	case IYM2612DataSource::BlockData:{
		const ChannelDataContext& channelDataContext = *((ChannelDataContext*)dataContext);
		unsigned int channelAddressOffset = GetChannelBlockAddressOffset(channelDataContext.channelNo);
		return dataValue.SetValue(GetBlockData(channelAddressOffset, AccessTarget().AccessLatest()));}
	case IYM2612DataSource::FrequencyDataChannel3:{
		const OperatorDataContext& operatorDataContext = *((OperatorDataContext*)dataContext);
		return dataValue.SetValue(GetFrequencyDataChannel3(operatorDataContext.operatorNo, AccessTarget().AccessLatest()));}
	case IYM2612DataSource::BlockDataChannel3:{
		const OperatorDataContext& operatorDataContext = *((OperatorDataContext*)dataContext);
		return dataValue.SetValue(GetBlockDataChannel3(operatorDataContext.operatorNo, AccessTarget().AccessLatest()));}
	case IYM2612DataSource::FeedbackData:{
		const ChannelDataContext& channelDataContext = *((ChannelDataContext*)dataContext);
		unsigned int channelAddressOffset = GetChannelBlockAddressOffset(channelDataContext.channelNo);
		return dataValue.SetValue(GetFeedbackData(channelAddressOffset, AccessTarget().AccessLatest()));}
	case IYM2612DataSource::AlgorithmData:{
		const ChannelDataContext& channelDataContext = *((ChannelDataContext*)dataContext);
		unsigned int channelAddressOffset = GetChannelBlockAddressOffset(channelDataContext.channelNo);
		return dataValue.SetValue(GetAlgorithmData(channelAddressOffset, AccessTarget().AccessLatest()));}
	case IYM2612DataSource::OutputLeft:{
		const ChannelDataContext& channelDataContext = *((ChannelDataContext*)dataContext);
		unsigned int channelAddressOffset = GetChannelBlockAddressOffset(channelDataContext.channelNo);
		return dataValue.SetValue(GetOutputLeft(channelAddressOffset, AccessTarget().AccessLatest()));}
	case IYM2612DataSource::OutputRight:{
		const ChannelDataContext& channelDataContext = *((ChannelDataContext*)dataContext);
		unsigned int channelAddressOffset = GetChannelBlockAddressOffset(channelDataContext.channelNo);
		return dataValue.SetValue(GetOutputRight(channelAddressOffset, AccessTarget().AccessLatest()));}
	case IYM2612DataSource::AMSData:{
		const ChannelDataContext& channelDataContext = *((ChannelDataContext*)dataContext);
		unsigned int channelAddressOffset = GetChannelBlockAddressOffset(channelDataContext.channelNo);
		return dataValue.SetValue(GetAMSData(channelAddressOffset, AccessTarget().AccessLatest()));}
	case IYM2612DataSource::PMSData:{
		const ChannelDataContext& channelDataContext = *((ChannelDataContext*)dataContext);
		unsigned int channelAddressOffset = GetChannelBlockAddressOffset(channelDataContext.channelNo);
		return dataValue.SetValue(GetPMSData(channelAddressOffset, AccessTarget().AccessLatest()));}
	case IYM2612DataSource::KeyState:{
		const OperatorDataContext& operatorDataContext = *((OperatorDataContext*)dataContext);
		return dataValue.SetValue(operatorData[operatorDataContext.channelNo][operatorDataContext.operatorNo].keyon);}
	case IYM2612DataSource::StatusRegister:
		return dataValue.SetValue(status.GetData());
	case IYM2612DataSource::BusyFlag:
		return dataValue.SetValue(GetBusyFlag());
	case IYM2612DataSource::TimerBOverflow:
		return dataValue.SetValue(GetTimerBOverflow());
	case IYM2612DataSource::TimerAOverflow:
		return dataValue.SetValue(GetTimerAOverflow());
	case IYM2612DataSource::TimerACurrentCounter:
		return dataValue.SetValue(timerACounter);
	case IYM2612DataSource::TimerBCurrentCounter:
		return dataValue.SetValue(timerBCounter);
	case IYM2612DataSource::ExternalClockRate:
		return dataValue.SetValue(externalClockRate);
	case IYM2612DataSource::FMClockDivider:
		return dataValue.SetValue(fmClockDivider);
	case IYM2612DataSource::EGClockDivider:
		return dataValue.SetValue(egClockDivider);
	case IYM2612DataSource::OutputClockDivider:
		return dataValue.SetValue(outputClockDivider);
	case IYM2612DataSource::TimerAClockDivider:
		return dataValue.SetValue(timerAClockDivider);
	case IYM2612DataSource::TimerBClockDivider:
		return dataValue.SetValue(timerBClockDivider);
	case IYM2612DataSource::AudioLoggingEnabled:
		return dataValue.SetValue(wavLoggingEnabled);
	case IYM2612DataSource::ChannelAudioLoggingEnabled:{
		const ChannelDataContext& channelDataContext = *((ChannelDataContext*)dataContext);
		return dataValue.SetValue(wavLoggingChannelEnabled[channelDataContext.channelNo]);}
	case IYM2612DataSource::OperatorAudioLoggingEnabled:{
		const OperatorDataContext& operatorDataContext = *((OperatorDataContext*)dataContext);
		return dataValue.SetValue(wavLoggingOperatorEnabled[operatorDataContext.channelNo][operatorDataContext.operatorNo]);}
	case IYM2612DataSource::AudioLoggingPath:
		return dataValue.SetValue(wavLoggingPath);
	case IYM2612DataSource::ChannelAudioLoggingPath:{
		const ChannelDataContext& channelDataContext = *((ChannelDataContext*)dataContext);
		return dataValue.SetValue(wavLoggingChannelPath[channelDataContext.channelNo]);}
	case IYM2612DataSource::OperatorAudioLoggingPath:{
		const OperatorDataContext& operatorDataContext = *((OperatorDataContext*)dataContext);
		return dataValue.SetValue(wavLoggingOperatorPath[operatorDataContext.channelNo][operatorDataContext.operatorNo]);}
	}
	return false;
}

//----------------------------------------------------------------------------------------
bool YM2612::WriteGenericData(unsigned int dataID, const DataContext* dataContext, IGenericAccessDataValue& dataValue)
{
	ApplyGenericDataValueLimitSettings(dataID, dataValue);
	IGenericAccessDataValue::DataType dataType = dataValue.GetType();
	switch((IYM2612DataSource)dataID)
	{
	case IYM2612DataSource::RawRegister:{
		if(dataType != IGenericAccessDataValue::DataType::UInt) return false;
		IGenericAccessDataValueUInt& dataValueAsUInt = (IGenericAccessDataValueUInt&)dataValue;
		const RegisterDataContext& registerDataContext = *((RegisterDataContext*)dataContext);
		Data registerData(8, dataValueAsUInt.GetValue());
		std::unique_lock<std::mutex> lock(accessMutex);
		RegisterSpecialUpdateFunction(registerDataContext.registerNo, registerData, timersLastUpdateTime, GetDeviceContext(), 0);
		SetRegisterData(registerDataContext.registerNo, registerData, AccessTarget().AccessLatest());
		return true;}
	case IYM2612DataSource::TestData:{
		if(dataType != IGenericAccessDataValue::DataType::UInt) return false;
		IGenericAccessDataValueUInt& dataValueAsUInt = (IGenericAccessDataValueUInt&)dataValue;
		SetTestData(dataValueAsUInt.GetValue(), AccessTarget().AccessLatest());
		return true;}
	case IYM2612DataSource::LFOEnabled:{
		if(dataType != IGenericAccessDataValue::DataType::Bool) return false;
		IGenericAccessDataValueBool& dataValueAsBool = (IGenericAccessDataValueBool&)dataValue;
		SetLFOEnabled(dataValueAsBool.GetValue(), AccessTarget().AccessLatest());
		return true;}
	case IYM2612DataSource::LFOData:{
		if(dataType != IGenericAccessDataValue::DataType::UInt) return false;
		IGenericAccessDataValueUInt& dataValueAsUInt = (IGenericAccessDataValueUInt&)dataValue;
		SetLFOData(dataValueAsUInt.GetValue(), AccessTarget().AccessLatest());
		return true;}
	case IYM2612DataSource::TimerAData:{
		if(dataType != IGenericAccessDataValue::DataType::UInt) return false;
		IGenericAccessDataValueUInt& dataValueAsUInt = (IGenericAccessDataValueUInt&)dataValue;
		SetTimerAData(dataValueAsUInt.GetValue(), AccessTarget().AccessLatest());
		timerAInitialCounter = dataValueAsUInt.GetValue();
		return true;}
	case IYM2612DataSource::TimerBData:{
		if(dataType != IGenericAccessDataValue::DataType::UInt) return false;
		IGenericAccessDataValueUInt& dataValueAsUInt = (IGenericAccessDataValueUInt&)dataValue;
		SetTimerBData(dataValueAsUInt.GetValue(), AccessTarget().AccessLatest());
		timerBInitialCounter = dataValueAsUInt.GetValue();
		return true;}
	case IYM2612DataSource::CH3Mode:{
		if(dataType != IGenericAccessDataValue::DataType::UInt) return false;
		IGenericAccessDataValueUInt& dataValueAsUInt = (IGenericAccessDataValueUInt&)dataValue;
		SetCH3Mode(dataValueAsUInt.GetValue(), AccessTarget().AccessLatest());
		return true;}
	case IYM2612DataSource::TimerBReset:{
		if(dataType != IGenericAccessDataValue::DataType::Bool) return false;
		IGenericAccessDataValueBool& dataValueAsBool = (IGenericAccessDataValueBool&)dataValue;
		SetTimerBReset(dataValueAsBool.GetValue(), AccessTarget().AccessLatest());
		return true;}
	case IYM2612DataSource::TimerAReset:{
		if(dataType != IGenericAccessDataValue::DataType::Bool) return false;
		IGenericAccessDataValueBool& dataValueAsBool = (IGenericAccessDataValueBool&)dataValue;
		SetTimerAReset(dataValueAsBool.GetValue(), AccessTarget().AccessLatest());
		return true;}
	case IYM2612DataSource::TimerBEnable:{
		if(dataType != IGenericAccessDataValue::DataType::Bool) return false;
		IGenericAccessDataValueBool& dataValueAsBool = (IGenericAccessDataValueBool&)dataValue;
		SetTimerBEnable(dataValueAsBool.GetValue(), AccessTarget().AccessLatest());
		timerBEnable = dataValueAsBool.GetValue();
		return true;}
	case IYM2612DataSource::TimerAEnable:{
		if(dataType != IGenericAccessDataValue::DataType::Bool) return false;
		IGenericAccessDataValueBool& dataValueAsBool = (IGenericAccessDataValueBool&)dataValue;
		SetTimerAEnable(dataValueAsBool.GetValue(), AccessTarget().AccessLatest());
		timerAEnable = dataValueAsBool.GetValue();
		return true;}
	case IYM2612DataSource::TimerBLoad:{
		if(dataType != IGenericAccessDataValue::DataType::Bool) return false;
		IGenericAccessDataValueBool& dataValueAsBool = (IGenericAccessDataValueBool&)dataValue;
		SetTimerBLoad(dataValueAsBool.GetValue(), AccessTarget().AccessLatest());
		timerBLoad = dataValueAsBool.GetValue();
		return true;}
	case IYM2612DataSource::TimerALoad:{
		if(dataType != IGenericAccessDataValue::DataType::Bool) return false;
		IGenericAccessDataValueBool& dataValueAsBool = (IGenericAccessDataValueBool&)dataValue;
		SetTimerALoad(dataValueAsBool.GetValue(), AccessTarget().AccessLatest());
		timerALoad = dataValueAsBool.GetValue();
		return true;}
	case IYM2612DataSource::DACData:{
		if(dataType != IGenericAccessDataValue::DataType::UInt) return false;
		IGenericAccessDataValueUInt& dataValueAsUInt = (IGenericAccessDataValueUInt&)dataValue;
		SetDACData(dataValueAsUInt.GetValue(), AccessTarget().AccessLatest());
		return true;}
	case IYM2612DataSource::DACEnabled:{
		if(dataType != IGenericAccessDataValue::DataType::Bool) return false;
		IGenericAccessDataValueBool& dataValueAsBool = (IGenericAccessDataValueBool&)dataValue;
		SetDACEnabled(dataValueAsBool.GetValue(), AccessTarget().AccessLatest());
		return true;}
	case IYM2612DataSource::DetuneData:{
		if(dataType != IGenericAccessDataValue::DataType::UInt) return false;
		IGenericAccessDataValueUInt& dataValueAsUInt = (IGenericAccessDataValueUInt&)dataValue;
		const OperatorDataContext& operatorDataContext = *((OperatorDataContext*)dataContext);
		unsigned int operatorAddressOffset = GetOperatorBlockAddressOffset(operatorDataContext.channelNo, operatorDataContext.operatorNo);
		SetDetuneData(operatorAddressOffset, dataValueAsUInt.GetValue(), AccessTarget().AccessLatest());
		return true;}
	case IYM2612DataSource::MultipleData:{
		if(dataType != IGenericAccessDataValue::DataType::UInt) return false;
		IGenericAccessDataValueUInt& dataValueAsUInt = (IGenericAccessDataValueUInt&)dataValue;
		const OperatorDataContext& operatorDataContext = *((OperatorDataContext*)dataContext);
		unsigned int operatorAddressOffset = GetOperatorBlockAddressOffset(operatorDataContext.channelNo, operatorDataContext.operatorNo);
		SetMultipleData(operatorAddressOffset, dataValueAsUInt.GetValue(), AccessTarget().AccessLatest());
		return true;}
	case IYM2612DataSource::TotalLevelData:{
		if(dataType != IGenericAccessDataValue::DataType::UInt) return false;
		IGenericAccessDataValueUInt& dataValueAsUInt = (IGenericAccessDataValueUInt&)dataValue;
		const OperatorDataContext& operatorDataContext = *((OperatorDataContext*)dataContext);
		unsigned int operatorAddressOffset = GetOperatorBlockAddressOffset(operatorDataContext.channelNo, operatorDataContext.operatorNo);
		SetTotalLevelData(operatorAddressOffset, dataValueAsUInt.GetValue(), AccessTarget().AccessLatest());
		return true;}
	case IYM2612DataSource::KeyScaleData:{
		if(dataType != IGenericAccessDataValue::DataType::UInt) return false;
		IGenericAccessDataValueUInt& dataValueAsUInt = (IGenericAccessDataValueUInt&)dataValue;
		const OperatorDataContext& operatorDataContext = *((OperatorDataContext*)dataContext);
		unsigned int operatorAddressOffset = GetOperatorBlockAddressOffset(operatorDataContext.channelNo, operatorDataContext.operatorNo);
		SetKeyScaleData(operatorAddressOffset, dataValueAsUInt.GetValue(), AccessTarget().AccessLatest());
		return true;}
	case IYM2612DataSource::AttackRateData:{
		if(dataType != IGenericAccessDataValue::DataType::UInt) return false;
		IGenericAccessDataValueUInt& dataValueAsUInt = (IGenericAccessDataValueUInt&)dataValue;
		const OperatorDataContext& operatorDataContext = *((OperatorDataContext*)dataContext);
		unsigned int operatorAddressOffset = GetOperatorBlockAddressOffset(operatorDataContext.channelNo, operatorDataContext.operatorNo);
		SetAttackRateData(operatorAddressOffset, dataValueAsUInt.GetValue(), AccessTarget().AccessLatest());
		return true;}
	case IYM2612DataSource::AmplitudeModulationEnabled:{
		if(dataType != IGenericAccessDataValue::DataType::Bool) return false;
		IGenericAccessDataValueBool& dataValueAsBool = (IGenericAccessDataValueBool&)dataValue;
		const OperatorDataContext& operatorDataContext = *((OperatorDataContext*)dataContext);
		unsigned int operatorAddressOffset = GetOperatorBlockAddressOffset(operatorDataContext.channelNo, operatorDataContext.operatorNo);
		SetAmplitudeModulationEnabled(operatorAddressOffset, dataValueAsBool.GetValue(), AccessTarget().AccessLatest());
		return true;}
	case IYM2612DataSource::DecayRateData:{
		if(dataType != IGenericAccessDataValue::DataType::UInt) return false;
		IGenericAccessDataValueUInt& dataValueAsUInt = (IGenericAccessDataValueUInt&)dataValue;
		const OperatorDataContext& operatorDataContext = *((OperatorDataContext*)dataContext);
		unsigned int operatorAddressOffset = GetOperatorBlockAddressOffset(operatorDataContext.channelNo, operatorDataContext.operatorNo);
		SetDecayRateData(operatorAddressOffset, dataValueAsUInt.GetValue(), AccessTarget().AccessLatest());
		return true;}
	case IYM2612DataSource::SustainRateData:{
		if(dataType != IGenericAccessDataValue::DataType::UInt) return false;
		IGenericAccessDataValueUInt& dataValueAsUInt = (IGenericAccessDataValueUInt&)dataValue;
		const OperatorDataContext& operatorDataContext = *((OperatorDataContext*)dataContext);
		unsigned int operatorAddressOffset = GetOperatorBlockAddressOffset(operatorDataContext.channelNo, operatorDataContext.operatorNo);
		SetSustainRateData(operatorAddressOffset, dataValueAsUInt.GetValue(), AccessTarget().AccessLatest());
		return true;}
	case IYM2612DataSource::SustainLevelData:{
		if(dataType != IGenericAccessDataValue::DataType::UInt) return false;
		IGenericAccessDataValueUInt& dataValueAsUInt = (IGenericAccessDataValueUInt&)dataValue;
		const OperatorDataContext& operatorDataContext = *((OperatorDataContext*)dataContext);
		unsigned int operatorAddressOffset = GetOperatorBlockAddressOffset(operatorDataContext.channelNo, operatorDataContext.operatorNo);
		SetSustainLevelData(operatorAddressOffset, dataValueAsUInt.GetValue(), AccessTarget().AccessLatest());
		return true;}
	case IYM2612DataSource::ReleaseRateData:{
		if(dataType != IGenericAccessDataValue::DataType::UInt) return false;
		IGenericAccessDataValueUInt& dataValueAsUInt = (IGenericAccessDataValueUInt&)dataValue;
		const OperatorDataContext& operatorDataContext = *((OperatorDataContext*)dataContext);
		unsigned int operatorAddressOffset = GetOperatorBlockAddressOffset(operatorDataContext.channelNo, operatorDataContext.operatorNo);
		SetReleaseRateData(operatorAddressOffset, dataValueAsUInt.GetValue(), AccessTarget().AccessLatest());
		return true;}
	case IYM2612DataSource::SSGData:{
		if(dataType != IGenericAccessDataValue::DataType::UInt) return false;
		IGenericAccessDataValueUInt& dataValueAsUInt = (IGenericAccessDataValueUInt&)dataValue;
		const OperatorDataContext& operatorDataContext = *((OperatorDataContext*)dataContext);
		unsigned int operatorAddressOffset = GetOperatorBlockAddressOffset(operatorDataContext.channelNo, operatorDataContext.operatorNo);
		SetSSGData(operatorAddressOffset, dataValueAsUInt.GetValue(), AccessTarget().AccessLatest());
		return true;}
	case IYM2612DataSource::SSGEnabled:{
		if(dataType != IGenericAccessDataValue::DataType::Bool) return false;
		IGenericAccessDataValueBool& dataValueAsBool = (IGenericAccessDataValueBool&)dataValue;
		const OperatorDataContext& operatorDataContext = *((OperatorDataContext*)dataContext);
		unsigned int operatorAddressOffset = GetOperatorBlockAddressOffset(operatorDataContext.channelNo, operatorDataContext.operatorNo);
		SetSSGEnabled(operatorAddressOffset, dataValueAsBool.GetValue(), AccessTarget().AccessLatest());
		return true;}
	case IYM2612DataSource::SSGAttack:{
		if(dataType != IGenericAccessDataValue::DataType::Bool) return false;
		IGenericAccessDataValueBool& dataValueAsBool = (IGenericAccessDataValueBool&)dataValue;
		const OperatorDataContext& operatorDataContext = *((OperatorDataContext*)dataContext);
		unsigned int operatorAddressOffset = GetOperatorBlockAddressOffset(operatorDataContext.channelNo, operatorDataContext.operatorNo);
		SetSSGAttack(operatorAddressOffset, dataValueAsBool.GetValue(), AccessTarget().AccessLatest());
		return true;}
	case IYM2612DataSource::SSGAlternate:{
		if(dataType != IGenericAccessDataValue::DataType::Bool) return false;
		IGenericAccessDataValueBool& dataValueAsBool = (IGenericAccessDataValueBool&)dataValue;
		const OperatorDataContext& operatorDataContext = *((OperatorDataContext*)dataContext);
		unsigned int operatorAddressOffset = GetOperatorBlockAddressOffset(operatorDataContext.channelNo, operatorDataContext.operatorNo);
		SetSSGAlternate(operatorAddressOffset, dataValueAsBool.GetValue(), AccessTarget().AccessLatest());
		return true;}
	case IYM2612DataSource::SSGHold:{
		if(dataType != IGenericAccessDataValue::DataType::Bool) return false;
		IGenericAccessDataValueBool& dataValueAsBool = (IGenericAccessDataValueBool&)dataValue;
		const OperatorDataContext& operatorDataContext = *((OperatorDataContext*)dataContext);
		unsigned int operatorAddressOffset = GetOperatorBlockAddressOffset(operatorDataContext.channelNo, operatorDataContext.operatorNo);
		SetSSGHold(operatorAddressOffset, dataValueAsBool.GetValue(), AccessTarget().AccessLatest());
		return true;}
	case IYM2612DataSource::FrequencyData:{
		if(dataType != IGenericAccessDataValue::DataType::UInt) return false;
		IGenericAccessDataValueUInt& dataValueAsUInt = (IGenericAccessDataValueUInt&)dataValue;
		const OperatorDataContext& operatorDataContext = *((OperatorDataContext*)dataContext);
		unsigned int channelAddressOffset = GetChannelBlockAddressOffset(operatorDataContext.channelNo);
		SetFrequencyData(channelAddressOffset, dataValueAsUInt.GetValue(), AccessTarget().AccessLatest());
		return true;}
	case IYM2612DataSource::BlockData:{
		if(dataType != IGenericAccessDataValue::DataType::UInt) return false;
		IGenericAccessDataValueUInt& dataValueAsUInt = (IGenericAccessDataValueUInt&)dataValue;
		const OperatorDataContext& operatorDataContext = *((OperatorDataContext*)dataContext);
		unsigned int channelAddressOffset = GetChannelBlockAddressOffset(operatorDataContext.channelNo);
		SetBlockData(channelAddressOffset, dataValueAsUInt.GetValue(), AccessTarget().AccessLatest());
		return true;}
	case IYM2612DataSource::FrequencyDataChannel3:{
		if(dataType != IGenericAccessDataValue::DataType::UInt) return false;
		IGenericAccessDataValueUInt& dataValueAsUInt = (IGenericAccessDataValueUInt&)dataValue;
		const OperatorDataContext& operatorDataContext = *((OperatorDataContext*)dataContext);
		SetFrequencyDataChannel3(operatorDataContext.operatorNo, dataValueAsUInt.GetValue(), AccessTarget().AccessLatest());
		return true;}
	case IYM2612DataSource::BlockDataChannel3:{
		if(dataType != IGenericAccessDataValue::DataType::UInt) return false;
		IGenericAccessDataValueUInt& dataValueAsUInt = (IGenericAccessDataValueUInt&)dataValue;
		const OperatorDataContext& operatorDataContext = *((OperatorDataContext*)dataContext);
		SetBlockDataChannel3(operatorDataContext.operatorNo, dataValueAsUInt.GetValue(), AccessTarget().AccessLatest());
		return true;}
	case IYM2612DataSource::FeedbackData:{
		if(dataType != IGenericAccessDataValue::DataType::UInt) return false;
		IGenericAccessDataValueUInt& dataValueAsUInt = (IGenericAccessDataValueUInt&)dataValue;
		const ChannelDataContext& channelDataContext = *((ChannelDataContext*)dataContext);
		unsigned int channelAddressOffset = GetChannelBlockAddressOffset(channelDataContext.channelNo);
		SetFeedbackData(channelAddressOffset, dataValueAsUInt.GetValue(), AccessTarget().AccessLatest());
		return true;}
	case IYM2612DataSource::AlgorithmData:{
		if(dataType != IGenericAccessDataValue::DataType::UInt) return false;
		IGenericAccessDataValueUInt& dataValueAsUInt = (IGenericAccessDataValueUInt&)dataValue;
		const ChannelDataContext& channelDataContext = *((ChannelDataContext*)dataContext);
		unsigned int channelAddressOffset = GetChannelBlockAddressOffset(channelDataContext.channelNo);
		SetAlgorithmData(channelAddressOffset, dataValueAsUInt.GetValue(), AccessTarget().AccessLatest());
		return true;}
	case IYM2612DataSource::OutputLeft:{
		if(dataType != IGenericAccessDataValue::DataType::Bool) return false;
		IGenericAccessDataValueBool& dataValueAsBool = (IGenericAccessDataValueBool&)dataValue;
		const ChannelDataContext& channelDataContext = *((ChannelDataContext*)dataContext);
		unsigned int channelAddressOffset = GetChannelBlockAddressOffset(channelDataContext.channelNo);
		SetOutputLeft(channelAddressOffset, dataValueAsBool.GetValue(), AccessTarget().AccessLatest());
		return true;}
	case IYM2612DataSource::OutputRight:{
		if(dataType != IGenericAccessDataValue::DataType::Bool) return false;
		IGenericAccessDataValueBool& dataValueAsBool = (IGenericAccessDataValueBool&)dataValue;
		const ChannelDataContext& channelDataContext = *((ChannelDataContext*)dataContext);
		unsigned int channelAddressOffset = GetChannelBlockAddressOffset(channelDataContext.channelNo);
		SetOutputRight(channelAddressOffset, dataValueAsBool.GetValue(), AccessTarget().AccessLatest());
		return true;}
	case IYM2612DataSource::AMSData:{
		if(dataType != IGenericAccessDataValue::DataType::UInt) return false;
		IGenericAccessDataValueUInt& dataValueAsUInt = (IGenericAccessDataValueUInt&)dataValue;
		const ChannelDataContext& channelDataContext = *((ChannelDataContext*)dataContext);
		unsigned int channelAddressOffset = GetChannelBlockAddressOffset(channelDataContext.channelNo);
		SetAMSData(channelAddressOffset, dataValueAsUInt.GetValue(), AccessTarget().AccessLatest());
		return true;}
	case IYM2612DataSource::PMSData:{
		if(dataType != IGenericAccessDataValue::DataType::UInt) return false;
		IGenericAccessDataValueUInt& dataValueAsUInt = (IGenericAccessDataValueUInt&)dataValue;
		const ChannelDataContext& channelDataContext = *((ChannelDataContext*)dataContext);
		unsigned int channelAddressOffset = GetChannelBlockAddressOffset(channelDataContext.channelNo);
		SetPMSData(channelAddressOffset, dataValueAsUInt.GetValue(), AccessTarget().AccessLatest());
		return true;}
	case IYM2612DataSource::KeyState:{
		if(dataType != IGenericAccessDataValue::DataType::Bool) return false;
		IGenericAccessDataValueBool& dataValueAsBool = (IGenericAccessDataValueBool&)dataValue;
		const OperatorDataContext& operatorDataContext = *((OperatorDataContext*)dataContext);
		operatorData[operatorDataContext.channelNo][operatorDataContext.operatorNo].keyon = dataValueAsBool.GetValue();
		return true;}
	case IYM2612DataSource::StatusRegister:{
		if(dataType != IGenericAccessDataValue::DataType::UInt) return false;
		IGenericAccessDataValueUInt& dataValueAsUInt = (IGenericAccessDataValueUInt&)dataValue;
		status = dataValueAsUInt.GetValue();
		return true;}
	case IYM2612DataSource::BusyFlag:{
		if(dataType != IGenericAccessDataValue::DataType::Bool) return false;
		IGenericAccessDataValueBool& dataValueAsBool = (IGenericAccessDataValueBool&)dataValue;
		SetBusyFlag(dataValueAsBool.GetValue());
		return true;}
	case IYM2612DataSource::TimerBOverflow:{
		if(dataType != IGenericAccessDataValue::DataType::Bool) return false;
		IGenericAccessDataValueBool& dataValueAsBool = (IGenericAccessDataValueBool&)dataValue;
		SetTimerBOverflow(dataValueAsBool.GetValue());
		return true;}
	case IYM2612DataSource::TimerAOverflow:{
		if(dataType != IGenericAccessDataValue::DataType::Bool) return false;
		IGenericAccessDataValueBool& dataValueAsBool = (IGenericAccessDataValueBool&)dataValue;
		SetTimerAOverflow(dataValueAsBool.GetValue());
		return true;}
	case IYM2612DataSource::TimerACurrentCounter:{
		if(dataType != IGenericAccessDataValue::DataType::UInt) return false;
		IGenericAccessDataValueUInt& dataValueAsUInt = (IGenericAccessDataValueUInt&)dataValue;
		timerACounter = dataValueAsUInt.GetValue();
		return true;}
	case IYM2612DataSource::TimerBCurrentCounter:{
		if(dataType != IGenericAccessDataValue::DataType::UInt) return false;
		IGenericAccessDataValueUInt& dataValueAsUInt = (IGenericAccessDataValueUInt&)dataValue;
		timerBCounter = dataValueAsUInt.GetValue();
		return true;}
	case IYM2612DataSource::ExternalClockRate:{
		if(dataType != IGenericAccessDataValue::DataType::Double) return false;
		IGenericAccessDataValueDouble& dataValueAsDouble = (IGenericAccessDataValueDouble&)dataValue;
		externalClockRate = dataValueAsDouble.GetValue();
		return true;}
	case IYM2612DataSource::FMClockDivider:{
		if(dataType != IGenericAccessDataValue::DataType::UInt) return false;
		IGenericAccessDataValueUInt& dataValueAsUInt = (IGenericAccessDataValueUInt&)dataValue;
		fmClockDivider = dataValueAsUInt.GetValue();
		return true;}
	case IYM2612DataSource::EGClockDivider:{
		if(dataType != IGenericAccessDataValue::DataType::UInt) return false;
		IGenericAccessDataValueUInt& dataValueAsUInt = (IGenericAccessDataValueUInt&)dataValue;
		egClockDivider = dataValueAsUInt.GetValue();
		return true;}
	case IYM2612DataSource::OutputClockDivider:{
		if(dataType != IGenericAccessDataValue::DataType::UInt) return false;
		IGenericAccessDataValueUInt& dataValueAsUInt = (IGenericAccessDataValueUInt&)dataValue;
		outputClockDivider = dataValueAsUInt.GetValue();
		return true;}
	case IYM2612DataSource::TimerAClockDivider:{
		if(dataType != IGenericAccessDataValue::DataType::UInt) return false;
		IGenericAccessDataValueUInt& dataValueAsUInt = (IGenericAccessDataValueUInt&)dataValue;
		timerAClockDivider = dataValueAsUInt.GetValue();
		return true;}
	case IYM2612DataSource::TimerBClockDivider:{
		if(dataType != IGenericAccessDataValue::DataType::UInt) return false;
		IGenericAccessDataValueUInt& dataValueAsUInt = (IGenericAccessDataValueUInt&)dataValue;
		timerBClockDivider = dataValueAsUInt.GetValue();
		return true;}
	case IYM2612DataSource::AudioLoggingEnabled:{
		if(dataType != IGenericAccessDataValue::DataType::Bool) return false;
		IGenericAccessDataValueBool& dataValueAsBool = (IGenericAccessDataValueBool&)dataValue;
		SetAudioLoggingEnabled(dataValueAsBool.GetValue());
		return true;}
	case IYM2612DataSource::ChannelAudioLoggingEnabled:{
		if(dataType != IGenericAccessDataValue::DataType::Bool) return false;
		IGenericAccessDataValueBool& dataValueAsBool = (IGenericAccessDataValueBool&)dataValue;
		const ChannelDataContext& channelDataContext = *((ChannelDataContext*)dataContext);
		SetChannelAudioLoggingEnabled(channelDataContext.channelNo, dataValueAsBool.GetValue());
		return true;}
	case IYM2612DataSource::OperatorAudioLoggingEnabled:{
		if(dataType != IGenericAccessDataValue::DataType::Bool) return false;
		IGenericAccessDataValueBool& dataValueAsBool = (IGenericAccessDataValueBool&)dataValue;
		const OperatorDataContext& operatorDataContext = *((OperatorDataContext*)dataContext);
		SetOperatorAudioLoggingEnabled(operatorDataContext.channelNo, operatorDataContext.operatorNo, dataValueAsBool.GetValue());
		return true;}
	case IYM2612DataSource::AudioLoggingPath:{
		if(dataType != IGenericAccessDataValue::DataType::FilePath) return false;
		IGenericAccessDataValueFilePath& dataValueAsFilePath = (IGenericAccessDataValueFilePath&)dataValue;
		wavLoggingPath = dataValueAsFilePath.GetValue();
		return true;}
	case IYM2612DataSource::ChannelAudioLoggingPath:{
		if(dataType != IGenericAccessDataValue::DataType::FilePath) return false;
		IGenericAccessDataValueFilePath& dataValueAsFilePath = (IGenericAccessDataValueFilePath&)dataValue;
		const ChannelDataContext& channelDataContext = *((ChannelDataContext*)dataContext);
		wavLoggingChannelPath[channelDataContext.channelNo] = dataValueAsFilePath.GetValue();
		return true;}
	case IYM2612DataSource::OperatorAudioLoggingPath:{
		if(dataType != IGenericAccessDataValue::DataType::FilePath) return false;
		IGenericAccessDataValueFilePath& dataValueAsFilePath = (IGenericAccessDataValueFilePath&)dataValue;
		const OperatorDataContext& operatorDataContext = *((OperatorDataContext*)dataContext);
		wavLoggingOperatorPath[operatorDataContext.channelNo][operatorDataContext.operatorNo] = dataValueAsFilePath.GetValue();
		return true;}
	}
	return false;
}

//----------------------------------------------------------------------------------------
//Data locking functions
//----------------------------------------------------------------------------------------
bool YM2612::GetGenericDataLocked(unsigned int dataID, const DataContext* dataContext) const
{
	std::unique_lock<std::mutex> lock(registerLockMutex);
	switch((IYM2612DataSource)dataID)
	{
	case IYM2612DataSource::RawRegister:{
		const RegisterDataContext& registerDataContext = *((RegisterDataContext*)dataContext);
		return rawRegisterLocking[registerDataContext.registerNo];}
	case IYM2612DataSource::KeyState:{
		const OperatorDataContext& operatorDataContext = *((OperatorDataContext*)dataContext);
		return keyStateLocking[operatorDataContext.channelNo][operatorDataContext.operatorNo];}
	case IYM2612DataSource::TestData:
	case IYM2612DataSource::LFOEnabled:
	case IYM2612DataSource::LFOData:
	case IYM2612DataSource::CH3Mode:
	case IYM2612DataSource::DACData:
	case IYM2612DataSource::DACEnabled:
	case IYM2612DataSource::TimerBReset:
	case IYM2612DataSource::TimerAReset:{
		std::map<unsigned int, std::list<RegisterLocking>>::const_iterator lockedRegisterStateIterator = lockedRegisterState.find(dataID);
		if(lockedRegisterStateIterator != lockedRegisterState.end())
		{
			return true;
		}
		break;}
	case IYM2612DataSource::TimerBEnable:
		return timerBStateLocking.enable;
	case IYM2612DataSource::TimerAEnable:
		return timerAStateLocking.enable;
	case IYM2612DataSource::TimerBLoad:
		return timerBStateLocking.load;
	case IYM2612DataSource::TimerALoad:
		return timerAStateLocking.load;
	case IYM2612DataSource::TimerBData:
		return timerBStateLocking.rate;
	case IYM2612DataSource::TimerAData:
		return timerAStateLocking.rate;
	case IYM2612DataSource::TimerBCurrentCounter:
		return timerBStateLocking.counter;
	case IYM2612DataSource::TimerACurrentCounter:
		return timerAStateLocking.counter;
	case IYM2612DataSource::TimerBOverflow:
		return timerBStateLocking.overflow;
	case IYM2612DataSource::TimerAOverflow:
		return timerAStateLocking.overflow;
	case IYM2612DataSource::FeedbackData:
	case IYM2612DataSource::AlgorithmData:
	case IYM2612DataSource::OutputLeft:
	case IYM2612DataSource::OutputRight:
	case IYM2612DataSource::AMSData:
	case IYM2612DataSource::PMSData:{
		const ChannelDataContext& channelDataContext = *((ChannelDataContext*)dataContext);
		std::map<unsigned int, std::list<RegisterLocking>>::const_iterator lockedRegisterStateIterator = lockedRegisterState.find(dataID);
		if(lockedRegisterStateIterator != lockedRegisterState.end())
		{
			for(std::list<RegisterLocking>::const_iterator i = lockedRegisterStateIterator->second.begin(); i != lockedRegisterStateIterator->second.end(); ++i)
			{
				if(i->channelDataContext.channelNo == channelDataContext.channelNo)
				{
					return true;
				}
			}
		}
		break;}
	case IYM2612DataSource::DetuneData:
	case IYM2612DataSource::MultipleData:
	case IYM2612DataSource::TotalLevelData:
	case IYM2612DataSource::KeyScaleData:
	case IYM2612DataSource::AttackRateData:
	case IYM2612DataSource::AmplitudeModulationEnabled:
	case IYM2612DataSource::DecayRateData:
	case IYM2612DataSource::SustainRateData:
	case IYM2612DataSource::SustainLevelData:
	case IYM2612DataSource::ReleaseRateData:
	case IYM2612DataSource::SSGData:
	case IYM2612DataSource::SSGEnabled:
	case IYM2612DataSource::SSGAttack:
	case IYM2612DataSource::SSGAlternate:
	case IYM2612DataSource::SSGHold:
	case IYM2612DataSource::FrequencyData:
	case IYM2612DataSource::BlockData:
	case IYM2612DataSource::FrequencyDataChannel3:
	case IYM2612DataSource::BlockDataChannel3:{
		const OperatorDataContext& operatorDataContext = *((OperatorDataContext*)dataContext);
		std::map<unsigned int, std::list<RegisterLocking>>::const_iterator lockedRegisterStateIterator = lockedRegisterState.find(dataID);
		if(lockedRegisterStateIterator != lockedRegisterState.end())
		{
			for(std::list<RegisterLocking>::const_iterator i = lockedRegisterStateIterator->second.begin(); i != lockedRegisterStateIterator->second.end(); ++i)
			{
				if((i->operatorDataContext.channelNo == operatorDataContext.channelNo) && (i->operatorDataContext.operatorNo == operatorDataContext.operatorNo))
				{
					return true;
				}
			}
		}
		break;}
	}
	return false;
}

//----------------------------------------------------------------------------------------
bool YM2612::SetGenericDataLocked(unsigned int dataID, const DataContext* dataContext, bool state)
{
	std::unique_lock<std::mutex> lock2(registerLockMutex);
	switch((IYM2612DataSource)dataID)
	{
	case IYM2612DataSource::RawRegister:{
		const RegisterDataContext& registerDataContext = *((RegisterDataContext*)dataContext);
		rawRegisterLocking[registerDataContext.registerNo] = state;
		return true;}
	case IYM2612DataSource::KeyState:{
		const OperatorDataContext& operatorDataContext = *((OperatorDataContext*)dataContext);
		keyStateLocking[operatorDataContext.channelNo][operatorDataContext.operatorNo] = state;
		return true;}
	case IYM2612DataSource::TestData:
	case IYM2612DataSource::LFOEnabled:
	case IYM2612DataSource::LFOData:
	case IYM2612DataSource::CH3Mode:
	case IYM2612DataSource::TimerBReset:
	case IYM2612DataSource::TimerAReset:
	case IYM2612DataSource::DACData:
	case IYM2612DataSource::DACEnabled:{
		if(!state)
		{
			lockedRegisterState.erase(dataID);
		}
		else
		{
			std::wstring lockedDataValue;
			if(!ReadGenericData(dataID, 0, lockedDataValue))
			{
				return false;
			}
			lockedRegisterState[dataID].push_back(RegisterLocking(dataID, lockedDataValue));
		}
		return true;}
	case IYM2612DataSource::TimerBEnable:
		timerBStateLocking.enable = state;
		return true;
	case IYM2612DataSource::TimerAEnable:
		timerAStateLocking.enable = state;
		return true;
	case IYM2612DataSource::TimerBLoad:
		timerBStateLocking.load = state;
		return true;
	case IYM2612DataSource::TimerALoad:
		timerAStateLocking.load = state;
		return true;
	case IYM2612DataSource::TimerBData:
		timerBStateLocking.rate = state;
		return true;
	case IYM2612DataSource::TimerAData:
		timerAStateLocking.rate = state;
		return true;
	case IYM2612DataSource::TimerBCurrentCounter:
		timerBStateLocking.counter = state;
		return true;
	case IYM2612DataSource::TimerACurrentCounter:
		timerAStateLocking.counter = state;
		return true;
	case IYM2612DataSource::TimerBOverflow:
		timerBStateLocking.overflow = state;
		return true;
	case IYM2612DataSource::TimerAOverflow:
		timerAStateLocking.overflow = state;
		return true;
	case IYM2612DataSource::FeedbackData:
	case IYM2612DataSource::AlgorithmData:
	case IYM2612DataSource::OutputLeft:
	case IYM2612DataSource::OutputRight:
	case IYM2612DataSource::AMSData:
	case IYM2612DataSource::PMSData:{
		const ChannelDataContext& channelDataContext = *((ChannelDataContext*)dataContext);
		std::list<RegisterLocking>& lockedRegisterList = lockedRegisterState[dataID];
		std::list<RegisterLocking>::iterator lockedRegisterListIterator = lockedRegisterList.begin();
		while(lockedRegisterListIterator != lockedRegisterList.end())
		{
			if(lockedRegisterListIterator->channelDataContext.channelNo == channelDataContext.channelNo)
			{
				lockedRegisterList.erase(lockedRegisterListIterator);
				if(lockedRegisterList.empty())
				{
					lockedRegisterState.erase(dataID);
				}
				break;
			}
			++lockedRegisterListIterator;
		}
		if(state)
		{
			std::wstring lockedDataValue;
			if(!ReadGenericData(dataID, &channelDataContext, lockedDataValue))
			{
				return false;
			}
			lockedRegisterState[dataID].push_back(RegisterLocking(dataID, channelDataContext, lockedDataValue));
		}
		return true;}
	case IYM2612DataSource::DetuneData:
	case IYM2612DataSource::MultipleData:
	case IYM2612DataSource::TotalLevelData:
	case IYM2612DataSource::KeyScaleData:
	case IYM2612DataSource::AttackRateData:
	case IYM2612DataSource::AmplitudeModulationEnabled:
	case IYM2612DataSource::DecayRateData:
	case IYM2612DataSource::SustainRateData:
	case IYM2612DataSource::SustainLevelData:
	case IYM2612DataSource::ReleaseRateData:
	case IYM2612DataSource::SSGData:
	case IYM2612DataSource::SSGEnabled:
	case IYM2612DataSource::SSGAttack:
	case IYM2612DataSource::SSGAlternate:
	case IYM2612DataSource::SSGHold:
	case IYM2612DataSource::FrequencyData:
	case IYM2612DataSource::BlockData:
	case IYM2612DataSource::FrequencyDataChannel3:
	case IYM2612DataSource::BlockDataChannel3:{
		const OperatorDataContext& operatorDataContext = *((OperatorDataContext*)dataContext);
		std::list<RegisterLocking>& lockedRegisterList = lockedRegisterState[dataID];
		std::list<RegisterLocking>::iterator lockedRegisterListIterator = lockedRegisterList.begin();
		while(lockedRegisterListIterator != lockedRegisterList.end())
		{
			if((lockedRegisterListIterator->operatorDataContext.channelNo == operatorDataContext.channelNo) && (lockedRegisterListIterator->operatorDataContext.operatorNo == operatorDataContext.operatorNo))
			{
				lockedRegisterList.erase(lockedRegisterListIterator);
				if(lockedRegisterList.empty())
				{
					lockedRegisterState.erase(dataID);
				}
				break;
			}
			++lockedRegisterListIterator;
		}
		if(state)
		{
			std::wstring lockedDataValue;
			if(!ReadGenericData(dataID, &operatorDataContext, lockedDataValue))
			{
				return false;
			}
			lockedRegisterState[dataID].push_back(RegisterLocking(dataID, operatorDataContext, lockedDataValue));
		}
		return true;}
	}
	return false;
}

//----------------------------------------------------------------------------------------
//Audio logging functions
//----------------------------------------------------------------------------------------
void YM2612::SetAudioLoggingEnabled(bool state)
{
	double fmClock = (externalClockRate / fmClockDivider) / outputClockDivider;
	ToggleLoggingEnabledState(wavLog, wavLoggingPath, wavLoggingEnabled, state, 2, 16, (unsigned int)fmClock);
	wavLoggingEnabled = state;
}

//----------------------------------------------------------------------------------------
void YM2612::SetChannelAudioLoggingEnabled(unsigned int channelNo, bool state)
{
	double fmClock = (externalClockRate / fmClockDivider) / outputClockDivider;
	ToggleLoggingEnabledState(wavLogChannel[channelNo], wavLoggingChannelPath[channelNo], wavLoggingChannelEnabled[channelNo], state, 2, 16, (unsigned int)fmClock);
	wavLoggingChannelEnabled[channelNo] = state;
}

//----------------------------------------------------------------------------------------
void YM2612::SetOperatorAudioLoggingEnabled(unsigned int channelNo, unsigned int operatorNo, bool state)
{
	double fmClock = (externalClockRate / fmClockDivider) / outputClockDivider;
	ToggleLoggingEnabledState(wavLogOperator[channelNo][operatorNo], wavLoggingOperatorPath[channelNo][operatorNo], wavLoggingOperatorEnabled[channelNo][operatorNo], state, 1, 16, (unsigned int)fmClock);
	wavLoggingOperatorEnabled[channelNo][operatorNo] = state;
}

//----------------------------------------------------------------------------------------
bool YM2612::ToggleLoggingEnabledState(Stream::WAVFile& wavFile, const std::wstring& fileName, bool currentState, bool newState, unsigned int channelCount, unsigned int bitsPerSample, unsigned int samplesPerSec)
{
	if(newState != currentState)
	{
		if(newState)
		{
			wavFile.SetDataFormat(channelCount, bitsPerSample, samplesPerSec);
			wavFile.Open(fileName, Stream::WAVFile::OpenMode::WriteOnly, Stream::WAVFile::CreateMode::Create);
		}
		else
		{
			wavFile.Close();
		}
	}
	return newState;
}
