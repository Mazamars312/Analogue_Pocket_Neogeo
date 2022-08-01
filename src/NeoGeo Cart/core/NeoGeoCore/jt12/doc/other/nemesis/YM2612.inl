//----------------------------------------------------------------------------------------
//Enumerations
//----------------------------------------------------------------------------------------
enum class YM2612::LineID
{
	IRQ = 1,
	IC
};

//----------------------------------------------------------------------------------------
enum class YM2612::ClockID
{
	C0M = 1
};

//----------------------------------------------------------------------------------------
enum class YM2612::AccessContext
{
	IRQ
};

//----------------------------------------------------------------------------------------
//Raw register functions
//----------------------------------------------------------------------------------------
Data YM2612::GetRegisterData(unsigned int location, const AccessTarget& accessTarget) const
{
	return reg.Read(location, accessTarget);
}

//----------------------------------------------------------------------------------------
void YM2612::SetRegisterData(unsigned int location, const Data& data, const AccessTarget& accessTarget)
{
	reg.Write(location, data, accessTarget);
}

//----------------------------------------------------------------------------------------
unsigned int YM2612::GetChannelBlockAddressOffset(unsigned int channelNo) const
{
	return channelAddressOffsets[channelNo];
}

//----------------------------------------------------------------------------------------
unsigned int YM2612::GetOperatorBlockAddressOffset(unsigned int channelNo, unsigned int operatorNo) const
{
	return operatorAddressOffsets[channelNo][operatorNo];
}

//----------------------------------------------------------------------------------------
unsigned int YM2612::GetAddressChannel3FrequencyBlock1(unsigned int operatorNo) const
{
	return channel3OperatorFrequencyAddressOffsets[0][operatorNo];
}

//----------------------------------------------------------------------------------------
unsigned int YM2612::GetAddressChannel3FrequencyBlock2(unsigned int operatorNo) const
{
	return channel3OperatorFrequencyAddressOffsets[1][operatorNo];
}

//----------------------------------------------------------------------------------------
//Register functions
//----------------------------------------------------------------------------------------
//      ---------------------------------
//      | 7 | 6 | 5 | 4 | 3 | 2 | 1 | 0 |
//21H   |-------------------------------|
//      |             Test              |
//      ---------------------------------
//----------------------------------------------------------------------------------------
unsigned int YM2612::GetTestData(const AccessTarget& accessTarget) const
{
	return GetRegisterData(0x21, accessTarget).GetData();
}

//----------------------------------------------------------------------------------------
void YM2612::SetTestData(unsigned int data, const AccessTarget& accessTarget)
{
	SetRegisterData(0x21, GetRegisterData(0x21, accessTarget).SetData(data), accessTarget);
}

//----------------------------------------------------------------------------------------
//      ---------------------------------
//      | 7 | 6 | 5 | 4 | 3 | 2 | 1 | 0 |
//22H   |-------------------------------|
//      | /   /   /   / |EN | FREQ CONT |
//      ---------------------------------
//----------------------------------------------------------------------------------------
bool YM2612::GetLFOEnabled(const AccessTarget& accessTarget) const
{
	return GetRegisterData(0x22, accessTarget).GetBit(3);
}

//----------------------------------------------------------------------------------------
void YM2612::SetLFOEnabled(bool data, const AccessTarget& accessTarget)
{
	SetRegisterData(0x22, GetRegisterData(0x22, accessTarget).SetBit(3, data), accessTarget);
}

//----------------------------------------------------------------------------------------
unsigned int YM2612::GetLFOData(const AccessTarget& accessTarget) const
{
	return GetRegisterData(0x22, accessTarget).GetDataSegment(0, 3);
}

//----------------------------------------------------------------------------------------
void YM2612::SetLFOData(unsigned int data, const AccessTarget& accessTarget)
{
	SetRegisterData(0x22, GetRegisterData(0x22, accessTarget).SetDataSegment(0, 3, data), accessTarget);
}

//----------------------------------------------------------------------------------------
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
//----------------------------------------------------------------------------------------
unsigned int YM2612::GetTimerAData(const AccessTarget& accessTarget) const
{
	Data data(10);
	data.SetUpperBits(8, GetRegisterData(0x24, accessTarget).GetData()); //Get MSBs
	data.SetLowerBits(2, GetRegisterData(0x25, accessTarget).GetDataSegment(0, 2)); //Get LSBs
	return data.GetData();
}

//----------------------------------------------------------------------------------------
void YM2612::SetTimerAData(unsigned int data, const AccessTarget& accessTarget)
{
	Data temp(10, data);
	SetRegisterData(0x24, GetRegisterData(0x24, accessTarget).SetData(temp.GetDataSegment(2, 8)), accessTarget);				//Set MSBs
	SetRegisterData(0x25, GetRegisterData(0x25, accessTarget).SetDataSegment(0, 2, temp.GetDataSegment(0, 2)), accessTarget);	//Set LSBs
}

//----------------------------------------------------------------------------------------
//      ---------------------------------
//      | 7 | 6 | 5 | 4 | 3 | 2 | 1 | 0 |
//26H   |-------------------------------|
//      |            Timer B            |
//      ---------------------------------
//----------------------------------------------------------------------------------------
unsigned int YM2612::GetTimerBData(const AccessTarget& accessTarget) const
{
	return GetRegisterData(0x26, accessTarget).GetData();
}

//----------------------------------------------------------------------------------------
void YM2612::SetTimerBData(unsigned int data, const AccessTarget& accessTarget)
{
	SetRegisterData(0x26, GetRegisterData(0x26, accessTarget).SetData(data), accessTarget);
}

//----------------------------------------------------------------------------------------
//      ---------------------------------
//      | 7 | 6 | 5 | 4 | 3 | 2 | 1 | 0 |
//      |-------------------------------|
//      |       | Timer | Timer | Timer |
//27H   |  CH3  | Reset | Enable| Load  |
//      |  Mode |-------|-------|-------|
//      |       | B | A | B | A | B | A |
//      ---------------------------------
//----------------------------------------------------------------------------------------
unsigned int YM2612::GetCH3Mode(const AccessTarget& accessTarget) const
{
	return GetRegisterData(0x27, accessTarget).GetDataSegment(6, 2);
}

//----------------------------------------------------------------------------------------
void YM2612::SetCH3Mode(unsigned int data, const AccessTarget& accessTarget)
{
	SetRegisterData(0x27, GetRegisterData(0x27, accessTarget).SetDataSegment(6, 2, data), accessTarget);
}

//----------------------------------------------------------------------------------------
bool YM2612::GetTimerBReset(const AccessTarget& accessTarget) const
{
	return GetRegisterData(0x27, accessTarget).GetBit(5);
}

//----------------------------------------------------------------------------------------
void YM2612::SetTimerBReset(bool data, const AccessTarget& accessTarget)
{
	SetRegisterData(0x27, GetRegisterData(0x27, accessTarget).SetBit(5, data), accessTarget);
}

//----------------------------------------------------------------------------------------
bool YM2612::GetTimerAReset(const AccessTarget& accessTarget) const
{
	return GetRegisterData(0x27, accessTarget).GetBit(4);
}

//----------------------------------------------------------------------------------------
void YM2612::SetTimerAReset(bool data, const AccessTarget& accessTarget)
{
	SetRegisterData(0x27, GetRegisterData(0x27, accessTarget).SetBit(4, data), accessTarget);
}

//----------------------------------------------------------------------------------------
bool YM2612::GetTimerBEnable(const AccessTarget& accessTarget) const
{
	return GetRegisterData(0x27, accessTarget).GetBit(3);
}

//----------------------------------------------------------------------------------------
void YM2612::SetTimerBEnable(bool data, const AccessTarget& accessTarget)
{
	SetRegisterData(0x27, GetRegisterData(0x27, accessTarget).SetBit(3, data), accessTarget);
}

//----------------------------------------------------------------------------------------
bool YM2612::GetTimerAEnable(const AccessTarget& accessTarget) const
{
	return GetRegisterData(0x27, accessTarget).GetBit(2);
}

//----------------------------------------------------------------------------------------
void YM2612::SetTimerAEnable(bool data, const AccessTarget& accessTarget)
{
	SetRegisterData(0x27, GetRegisterData(0x27, accessTarget).SetBit(2, data), accessTarget);
}

//----------------------------------------------------------------------------------------
bool YM2612::GetTimerBLoad(const AccessTarget& accessTarget) const
{
	return GetRegisterData(0x27, accessTarget).GetBit(1);
}

//----------------------------------------------------------------------------------------
void YM2612::SetTimerBLoad(bool data, const AccessTarget& accessTarget)
{
	SetRegisterData(0x27, GetRegisterData(0x27, accessTarget).SetBit(1, data), accessTarget);
}

//----------------------------------------------------------------------------------------
bool YM2612::GetTimerALoad(const AccessTarget& accessTarget) const
{
	return GetRegisterData(0x27, accessTarget).GetBit(0);
}

//----------------------------------------------------------------------------------------
void YM2612::SetTimerALoad(bool data, const AccessTarget& accessTarget)
{
	SetRegisterData(0x27, GetRegisterData(0x27, accessTarget).SetBit(0, data), accessTarget);
}

//----------------------------------------------------------------------------------------
//      ---------------------------------
//      | 7 | 6 | 5 | 4 | 3 | 2 | 1 | 0 |
//2AH   |-------------------------------|
//      |           DAC Data            |
//      ---------------------------------
//----------------------------------------------------------------------------------------
unsigned int YM2612::GetDACData(const AccessTarget& accessTarget) const
{
	return GetRegisterData(0x2A, accessTarget).GetData();
}

//----------------------------------------------------------------------------------------
void YM2612::SetDACData(unsigned int data, const AccessTarget& accessTarget)
{
	SetRegisterData(0x2A, GetRegisterData(0x2A, accessTarget).SetData(data), accessTarget);
}

//----------------------------------------------------------------------------------------
//      ---------------------------------
//      | 7 | 6 | 5 | 4 | 3 | 2 | 1 | 0 |
//2BH   |-------------------------------|
//      |DAC| /   /   /   /   /   /   / |
//      |EN |                           |
//      ---------------------------------
//----------------------------------------------------------------------------------------
bool YM2612::GetDACEnabled(const AccessTarget& accessTarget) const
{
	return GetRegisterData(0x2B, accessTarget).GetBit(7);
}

//----------------------------------------------------------------------------------------
void YM2612::SetDACEnabled(bool data, const AccessTarget& accessTarget)
{
	SetRegisterData(0x2B, GetRegisterData(0x2B, accessTarget).SetBit(7, data), accessTarget);
}

//----------------------------------------------------------------------------------------
//      ---------------------------------
//      | 7 | 6 | 5 | 4 | 3 | 2 | 1 | 0 |
//30H-  |-------------------------------|
//3FH   | / |  Detune   |   Multiple    |
//      ---------------------------------
//----------------------------------------------------------------------------------------
unsigned int YM2612::GetDetuneData(unsigned int operatorAddressOffset, const AccessTarget& accessTarget) const
{
	unsigned int registerNo = operatorAddressOffset + 0x30;
	return GetRegisterData(registerNo, accessTarget).GetDataSegment(4, 3);
}

//----------------------------------------------------------------------------------------
void YM2612::SetDetuneData(unsigned int operatorAddressOffset, unsigned int data, const AccessTarget& accessTarget)
{
	unsigned int registerNo = operatorAddressOffset + 0x30;
	SetRegisterData(registerNo, GetRegisterData(registerNo, accessTarget).SetDataSegment(4, 3, data), accessTarget);
}

//----------------------------------------------------------------------------------------
unsigned int YM2612::GetMultipleData(unsigned int operatorAddressOffset, const AccessTarget& accessTarget) const
{
	unsigned int registerNo = operatorAddressOffset + 0x30;
	return GetRegisterData(registerNo, accessTarget).GetDataSegment(0, 4);
}

//----------------------------------------------------------------------------------------
void YM2612::SetMultipleData(unsigned int operatorAddressOffset, unsigned int data, const AccessTarget& accessTarget)
{
	unsigned int registerNo = operatorAddressOffset + 0x30;
	SetRegisterData(registerNo, GetRegisterData(registerNo, accessTarget).SetDataSegment(0, 4, data), accessTarget);
}

//----------------------------------------------------------------------------------------
//      ---------------------------------
//      | 7 | 6 | 5 | 4 | 3 | 2 | 1 | 0 |
//40H-  |-------------------------------|
//4FH   | / |        Total Level        |
//      ---------------------------------
//----------------------------------------------------------------------------------------
unsigned int YM2612::GetTotalLevelData(unsigned int operatorAddressOffset, const AccessTarget& accessTarget) const
{
	unsigned int registerNo = operatorAddressOffset + 0x40;
	return GetRegisterData(registerNo, accessTarget).GetDataSegment(0, 7);
}

//----------------------------------------------------------------------------------------
void YM2612::SetTotalLevelData(unsigned int operatorAddressOffset, unsigned int data, const AccessTarget& accessTarget)
{
	unsigned int registerNo = operatorAddressOffset + 0x40;
	SetRegisterData(registerNo, GetRegisterData(registerNo, accessTarget).SetDataSegment(0, 7, data), accessTarget);
}

//----------------------------------------------------------------------------------------
//      ---------------------------------
//      | 7 | 6 | 5 | 4 | 3 | 2 | 1 | 0 |
//50H-  |-------------------------------|
//5FH   |  KS   | / |    Attack Rate    |
//      ---------------------------------
//----------------------------------------------------------------------------------------
unsigned int YM2612::GetKeyScaleData(unsigned int operatorAddressOffset, const AccessTarget& accessTarget) const
{
	unsigned int registerNo = operatorAddressOffset + 0x50;
	return GetRegisterData(registerNo, accessTarget).GetDataSegment(6, 2);
}

//----------------------------------------------------------------------------------------
void YM2612::SetKeyScaleData(unsigned int operatorAddressOffset, unsigned int data, const AccessTarget& accessTarget)
{
	unsigned int registerNo = operatorAddressOffset + 0x50;
	SetRegisterData(registerNo, GetRegisterData(registerNo, accessTarget).SetDataSegment(6, 2, data), accessTarget);
}

//----------------------------------------------------------------------------------------
unsigned int YM2612::GetAttackRateData(unsigned int operatorAddressOffset, const AccessTarget& accessTarget) const
{
	unsigned int registerNo = operatorAddressOffset + 0x50;
	return GetRegisterData(registerNo, accessTarget).GetDataSegment(0, 5);
}

//----------------------------------------------------------------------------------------
void YM2612::SetAttackRateData(unsigned int operatorAddressOffset, unsigned int data, const AccessTarget& accessTarget)
{
	unsigned int registerNo = operatorAddressOffset + 0x50;
	SetRegisterData(registerNo, GetRegisterData(registerNo, accessTarget).SetDataSegment(0, 5, data), accessTarget);
}

//----------------------------------------------------------------------------------------
//      ---------------------------------
//      | 7 | 6 | 5 | 4 | 3 | 2 | 1 | 0 |
//60H-  |-------------------------------|
//6FH   |AM | /   / |    Decay Rate     |
//      ---------------------------------
//----------------------------------------------------------------------------------------
bool YM2612::GetAmplitudeModulationEnabled(unsigned int operatorAddressOffset, const AccessTarget& accessTarget) const
{
	unsigned int registerNo = operatorAddressOffset + 0x60;
	return GetRegisterData(registerNo, accessTarget).GetBit(7);
}

//----------------------------------------------------------------------------------------
void YM2612::SetAmplitudeModulationEnabled(unsigned int operatorAddressOffset, bool data, const AccessTarget& accessTarget)
{
	unsigned int registerNo = operatorAddressOffset + 0x60;
	SetRegisterData(registerNo, GetRegisterData(registerNo, accessTarget).SetBit(7, data), accessTarget);
}

//----------------------------------------------------------------------------------------
unsigned int YM2612::GetDecayRateData(unsigned int operatorAddressOffset, const AccessTarget& accessTarget) const
{
	unsigned int registerNo = operatorAddressOffset + 0x60;
	return GetRegisterData(registerNo, accessTarget).GetDataSegment(0, 5);
}

//----------------------------------------------------------------------------------------
void YM2612::SetDecayRateData(unsigned int operatorAddressOffset, unsigned int data, const AccessTarget& accessTarget)
{
	unsigned int registerNo = operatorAddressOffset + 0x60;
	SetRegisterData(registerNo, GetRegisterData(registerNo, accessTarget).SetDataSegment(0, 5, data), accessTarget);
}

//----------------------------------------------------------------------------------------
//      ---------------------------------
//      | 7 | 6 | 5 | 4 | 3 | 2 | 1 | 0 |
//70H-  |-------------------------------|
//7FH   | /   /   / |   Sustain Rate    |
//      ---------------------------------
//----------------------------------------------------------------------------------------
unsigned int YM2612::GetSustainRateData(unsigned int operatorAddressOffset, const AccessTarget& accessTarget) const
{
	unsigned int registerNo = operatorAddressOffset + 0x70;
	return GetRegisterData(registerNo, accessTarget).GetDataSegment(0, 5);
}

//----------------------------------------------------------------------------------------
void YM2612::SetSustainRateData(unsigned int operatorAddressOffset, unsigned int data, const AccessTarget& accessTarget)
{
	unsigned int registerNo = operatorAddressOffset + 0x70;
	SetRegisterData(registerNo, GetRegisterData(registerNo, accessTarget).SetDataSegment(0, 5, data), accessTarget);
}

//----------------------------------------------------------------------------------------
//      ---------------------------------
//      | 7 | 6 | 5 | 4 | 3 | 2 | 1 | 0 |
//80H-  |-------------------------------|
//8FH   | Sustain Level | Release Rate  |
//      ---------------------------------
//----------------------------------------------------------------------------------------
unsigned int YM2612::GetSustainLevelData(unsigned int operatorAddressOffset, const AccessTarget& accessTarget) const
{
	unsigned int registerNo = operatorAddressOffset + 0x80;
	return GetRegisterData(registerNo, accessTarget).GetDataSegment(4, 4);
}

//----------------------------------------------------------------------------------------
void YM2612::SetSustainLevelData(unsigned int operatorAddressOffset, unsigned int data, const AccessTarget& accessTarget)
{
	unsigned int registerNo = operatorAddressOffset + 0x80;
	SetRegisterData(registerNo, GetRegisterData(registerNo, accessTarget).SetDataSegment(4, 4, data), accessTarget);
}

//----------------------------------------------------------------------------------------
unsigned int YM2612::GetReleaseRateData(unsigned int operatorAddressOffset, const AccessTarget& accessTarget) const
{
	unsigned int registerNo = operatorAddressOffset + 0x80;
	return GetRegisterData(registerNo, accessTarget).GetDataSegment(0, 4);
}

//----------------------------------------------------------------------------------------
void YM2612::SetReleaseRateData(unsigned int operatorAddressOffset, unsigned int data, const AccessTarget& accessTarget)
{
	unsigned int registerNo = operatorAddressOffset + 0x80;
	SetRegisterData(registerNo, GetRegisterData(registerNo, accessTarget).SetDataSegment(0, 4, data), accessTarget);
}

//----------------------------------------------------------------------------------------
//      ---------------------------------
//      | 7 | 6 | 5 | 4 | 3 | 2 | 1 | 0 |
//      |-------------------------------|
//90H-  |               |    SSG-EG     |
//9FH   | /   /   /   / |---------------|
//      |               | E |ATT|ALT|HLD|
//      ---------------------------------
//----------------------------------------------------------------------------------------
unsigned int YM2612::GetSSGData(unsigned int operatorAddressOffset, const AccessTarget& accessTarget) const
{
	unsigned int registerNo = operatorAddressOffset + 0x90;
	return GetRegisterData(registerNo, accessTarget).GetDataSegment(0, 4);
}

//----------------------------------------------------------------------------------------
void YM2612::SetSSGData(unsigned int operatorAddressOffset, unsigned int data, const AccessTarget& accessTarget)
{
	unsigned int registerNo = operatorAddressOffset + 0x90;
	SetRegisterData(registerNo, GetRegisterData(registerNo, accessTarget).SetDataSegment(0, 4, data), accessTarget);
}

//----------------------------------------------------------------------------------------
bool YM2612::GetSSGEnabled(unsigned int operatorAddressOffset, const AccessTarget& accessTarget) const
{
	unsigned int registerNo = operatorAddressOffset + 0x90;
	return GetRegisterData(registerNo, accessTarget).GetBit(3);
}

//----------------------------------------------------------------------------------------
void YM2612::SetSSGEnabled(unsigned int operatorAddressOffset, bool data, const AccessTarget& accessTarget)
{
	unsigned int registerNo = operatorAddressOffset + 0x90;
	SetRegisterData(registerNo, GetRegisterData(registerNo, accessTarget).SetBit(3, data), accessTarget);
}

//----------------------------------------------------------------------------------------
bool YM2612::GetSSGAttack(unsigned int operatorAddressOffset, const AccessTarget& accessTarget) const
{
	unsigned int registerNo = operatorAddressOffset + 0x90;
	return GetRegisterData(registerNo, accessTarget).GetBit(2);
}

//----------------------------------------------------------------------------------------
void YM2612::SetSSGAttack(unsigned int operatorAddressOffset, bool data, const AccessTarget& accessTarget)
{
	unsigned int registerNo = operatorAddressOffset + 0x90;
	SetRegisterData(registerNo, GetRegisterData(registerNo, accessTarget).SetBit(2, data), accessTarget);
}

//----------------------------------------------------------------------------------------
bool YM2612::GetSSGAlternate(unsigned int operatorAddressOffset, const AccessTarget& accessTarget) const
{
	unsigned int registerNo = operatorAddressOffset + 0x90;
	return GetRegisterData(registerNo, accessTarget).GetBit(1);
}

//----------------------------------------------------------------------------------------
void YM2612::SetSSGAlternate(unsigned int operatorAddressOffset, bool data, const AccessTarget& accessTarget)
{
	unsigned int registerNo = operatorAddressOffset + 0x90;
	SetRegisterData(registerNo, GetRegisterData(registerNo, accessTarget).SetBit(1, data), accessTarget);
}

//----------------------------------------------------------------------------------------
bool YM2612::GetSSGHold(unsigned int operatorAddressOffset, const AccessTarget& accessTarget) const
{
	unsigned int registerNo = operatorAddressOffset + 0x90;
	return GetRegisterData(registerNo, accessTarget).GetBit(0);
}

//----------------------------------------------------------------------------------------
void YM2612::SetSSGHold(unsigned int operatorAddressOffset, bool data, const AccessTarget& accessTarget)
{
	unsigned int registerNo = operatorAddressOffset + 0x90;
	SetRegisterData(registerNo, GetRegisterData(registerNo, accessTarget).SetBit(0, data), accessTarget);
}

//----------------------------------------------------------------------------------------
//      ---------------------------------
//      | 7 | 6 | 5 | 4 | 3 | 2 | 1 | 0 |
//A0H-  |-------------------------------|
//A3H   |   Freq Num LSB's (bits 0-7)   |
//      ---------------------------------
//      ---------------------------------
//      | 7 | 6 | 5 | 4 | 3 | 2 | 1 | 0 |
//A4H-  |-------------------------------|
//A7H   | /   / |  Block    | Freq Num  |
//      |       | (octave)  |  MSB's    |
//      ---------------------------------
//----------------------------------------------------------------------------------------
unsigned int YM2612::GetFrequencyData(unsigned int channelAddressOffset, const AccessTarget& accessTarget) const
{
	unsigned int register1 = channelAddressOffset + 0xA0;
	unsigned int register2 = channelAddressOffset + 0xA4;

	Data data(11);
	data.SetLowerBits(8, GetRegisterData(register1, accessTarget).GetData());
	data.SetUpperBits(3, GetRegisterData(register2, accessTarget).GetDataSegment(0, 3));
	return data.GetData();
}

//----------------------------------------------------------------------------------------
void YM2612::SetFrequencyData(unsigned int channelAddressOffset, unsigned int data, const AccessTarget& accessTarget)
{
	unsigned int register1 = channelAddressOffset + 0xA0;
	unsigned int register2 = channelAddressOffset + 0xA4;

	Data temp(11, data);
	SetRegisterData(register1, GetRegisterData(register1, accessTarget).SetData(temp.GetDataSegment(0, 8)), accessTarget);
	SetRegisterData(register2, GetRegisterData(register2, accessTarget).SetDataSegment(0, 3, temp.GetDataSegment(8, 3)), accessTarget);
}

//----------------------------------------------------------------------------------------
unsigned int YM2612::GetBlockData(unsigned int channelAddressOffset, const AccessTarget& accessTarget) const
{
	unsigned int registerNo = channelAddressOffset + 0xA4;
	return GetRegisterData(registerNo, accessTarget).GetDataSegment(3, 3);
}

//----------------------------------------------------------------------------------------
void YM2612::SetBlockData(unsigned int channelAddressOffset, unsigned int data, const AccessTarget& accessTarget)
{
	unsigned int registerNo = channelAddressOffset + 0xA4;
	SetRegisterData(registerNo, GetRegisterData(registerNo, accessTarget).SetDataSegment(3, 3, data), accessTarget);
}

//----------------------------------------------------------------------------------------
//      ---------------------------------
//      | 7 | 6 | 5 | 4 | 3 | 2 | 1 | 0 |
//A8H-  |-------------------------------|
//ABH   |   Freq Num LSB's (bits 0-7)   |
//      ---------------------------------
//      ---------------------------------
//      | 7 | 6 | 5 | 4 | 3 | 2 | 1 | 0 |
//ACH-  |-------------------------------|
//AFH   | /   / |  Block    | Freq Num  |
//      |       | (octave)  |  MSB's    |
//      ---------------------------------
//----------------------------------------------------------------------------------------
unsigned int YM2612::GetFrequencyDataChannel3(unsigned int operatorNo, const AccessTarget& accessTarget) const
{
	unsigned int register1 = GetAddressChannel3FrequencyBlock1(operatorNo);
	unsigned int register2 = GetAddressChannel3FrequencyBlock2(operatorNo);

	Data data(11);
	data.SetLowerBits(8, GetRegisterData(register1, accessTarget).GetData());
	data.SetUpperBits(3, GetRegisterData(register2, accessTarget).GetDataSegment(0, 3));
	return data.GetData();
}

//----------------------------------------------------------------------------------------
void YM2612::SetFrequencyDataChannel3(unsigned int operatorNo, unsigned int data, const AccessTarget& accessTarget)
{
	unsigned int register1 = GetAddressChannel3FrequencyBlock1(operatorNo);
	unsigned int register2 = GetAddressChannel3FrequencyBlock2(operatorNo);

	Data temp(11, data);
	SetRegisterData(register1, GetRegisterData(register1, accessTarget).SetData(temp.GetDataSegment(0, 8)), accessTarget);
	SetRegisterData(register2, GetRegisterData(register2, accessTarget).SetDataSegment(0, 3, temp.GetDataSegment(8, 3)), accessTarget);
}

//----------------------------------------------------------------------------------------
unsigned int YM2612::GetBlockDataChannel3(unsigned int operatorNo, const AccessTarget& accessTarget) const
{
	unsigned int registerNo = GetAddressChannel3FrequencyBlock2(operatorNo);
	return GetRegisterData(registerNo, accessTarget).GetDataSegment(3, 3);
}

//----------------------------------------------------------------------------------------
void YM2612::SetBlockDataChannel3(unsigned int operatorNo, unsigned int data, const AccessTarget& accessTarget)
{
	unsigned int registerNo = GetAddressChannel3FrequencyBlock2(operatorNo);
	SetRegisterData(registerNo, GetRegisterData(registerNo, accessTarget).SetDataSegment(3, 3, data), accessTarget);
}

//----------------------------------------------------------------------------------------
//      ---------------------------------
//      | 7 | 6 | 5 | 4 | 3 | 2 | 1 | 0 |
//B0H-  |-------------------------------|
//B3H   | /   / | Feedback  | Algorithm |
//      ---------------------------------
//----------------------------------------------------------------------------------------
unsigned int YM2612::GetFeedbackData(unsigned int channelAddressOffset, const AccessTarget& accessTarget) const
{
	unsigned int registerNo = channelAddressOffset + 0xB0;
	return GetRegisterData(registerNo, accessTarget).GetDataSegment(3, 3);
}

//----------------------------------------------------------------------------------------
void YM2612::SetFeedbackData(unsigned int channelAddressOffset, unsigned int data, const AccessTarget& accessTarget)
{
	unsigned int registerNo = channelAddressOffset + 0xB0;
	SetRegisterData(registerNo, GetRegisterData(registerNo, accessTarget).SetDataSegment(3, 3, data), accessTarget);
}

//----------------------------------------------------------------------------------------
unsigned int YM2612::GetAlgorithmData(unsigned int channelAddressOffset, const AccessTarget& accessTarget) const
{
	unsigned int registerNo = channelAddressOffset + 0xB0;
	return GetRegisterData(registerNo, accessTarget).GetDataSegment(0, 3);
}

//----------------------------------------------------------------------------------------
void YM2612::SetAlgorithmData(unsigned int channelAddressOffset, unsigned int data, const AccessTarget& accessTarget)
{
	unsigned int registerNo = channelAddressOffset + 0xB0;
	SetRegisterData(registerNo, GetRegisterData(registerNo, accessTarget).SetDataSegment(0, 3, data), accessTarget);
}

//----------------------------------------------------------------------------------------
//      ---------------------------------
//      | 7 | 6 | 5 | 4 | 3 | 2 | 1 | 0 |
//B4H-  |-------------------------------|
//B7H   | L | R |  AMS  | / |    PMS    |
//      ---------------------------------
//----------------------------------------------------------------------------------------
bool YM2612::GetOutputLeft(unsigned int channelAddressOffset, const AccessTarget& accessTarget) const
{
	unsigned int registerNo = channelAddressOffset + 0xB4;
	return GetRegisterData(registerNo, accessTarget).GetBit(7);
}

//----------------------------------------------------------------------------------------
void YM2612::SetOutputLeft(unsigned int channelAddressOffset, bool data, const AccessTarget& accessTarget)
{
	unsigned int registerNo = channelAddressOffset + 0xB4;
	SetRegisterData(registerNo, GetRegisterData(registerNo, accessTarget).SetBit(7, data), accessTarget);
}

//----------------------------------------------------------------------------------------
bool YM2612::GetOutputRight(unsigned int channelAddressOffset, const AccessTarget& accessTarget) const
{
	unsigned int registerNo = channelAddressOffset + 0xB4;
	return GetRegisterData(registerNo, accessTarget).GetBit(6);
}

//----------------------------------------------------------------------------------------
void YM2612::SetOutputRight(unsigned int channelAddressOffset, bool data, const AccessTarget& accessTarget)
{
	unsigned int registerNo = channelAddressOffset + 0xB4;
	SetRegisterData(registerNo, GetRegisterData(registerNo, accessTarget).SetBit(6, data), accessTarget);
}

//----------------------------------------------------------------------------------------
unsigned int YM2612::GetAMSData(unsigned int channelAddressOffset, const AccessTarget& accessTarget) const
{
	unsigned int registerNo = channelAddressOffset + 0xB4;
	return GetRegisterData(registerNo, accessTarget).GetDataSegment(4, 2);
}

//----------------------------------------------------------------------------------------
void YM2612::SetAMSData(unsigned int channelAddressOffset, unsigned int data, const AccessTarget& accessTarget)
{
	unsigned int registerNo = channelAddressOffset + 0xB4;
	SetRegisterData(registerNo, GetRegisterData(registerNo, accessTarget).SetDataSegment(4, 2, data), accessTarget);
}

//----------------------------------------------------------------------------------------
unsigned int YM2612::GetPMSData(unsigned int channelAddressOffset, const AccessTarget& accessTarget) const
{
	unsigned int registerNo = channelAddressOffset + 0xB4;
	return GetRegisterData(registerNo, accessTarget).GetDataSegment(0, 3);
}

//----------------------------------------------------------------------------------------
void YM2612::SetPMSData(unsigned int channelAddressOffset, unsigned int data, const AccessTarget& accessTarget)
{
	unsigned int registerNo = channelAddressOffset + 0xB4;
	SetRegisterData(registerNo, GetRegisterData(registerNo, accessTarget).SetDataSegment(0, 3, data), accessTarget);
}

//----------------------------------------------------------------------------------------
//Status register functions
//----------------------------------------------------------------------------------------
//      ------------------------------------
//      | 7  | 6 | 5 | 4 | 3 | 2 | 1  | 0  |
//      |----------------------------------|
//Status|    |                   |Overflow |
//Reg   |Busy| /   /   /   /   / |---------|
//      |    |                   | B  | A  |
//      ------------------------------------
//----------------------------------------------------------------------------------------
Data YM2612::GetStatusRegister() const
{
	return status;
}

//----------------------------------------------------------------------------------------
void YM2612::SetStatusRegister(unsigned int adata)
{
	status = adata;
}

//----------------------------------------------------------------------------------------
bool YM2612::GetBusyFlag() const
{
	return status.GetBit(7);
}

//----------------------------------------------------------------------------------------
void YM2612::SetBusyFlag(bool astate)
{
	status.SetBit(7, astate);
}

//----------------------------------------------------------------------------------------
bool YM2612::GetTimerBOverflow() const
{
	return status.GetBit(1);
}

//----------------------------------------------------------------------------------------
void YM2612::SetTimerBOverflow(bool astate)
{
	status.SetBit(1, astate);
}

//----------------------------------------------------------------------------------------
bool YM2612::GetTimerAOverflow() const
{
	return status.GetBit(0);
}

//----------------------------------------------------------------------------------------
void YM2612::SetTimerAOverflow(bool astate)
{
	status.SetBit(0, astate);
}
