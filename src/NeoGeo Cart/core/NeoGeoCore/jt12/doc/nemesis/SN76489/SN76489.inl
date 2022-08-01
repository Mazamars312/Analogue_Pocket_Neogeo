//----------------------------------------------------------------------------------------
//Enumerations
//----------------------------------------------------------------------------------------
enum class SN76489::ClockID
{
	Clock = 1
};

//----------------------------------------------------------------------------------------
//Raw register functions
//----------------------------------------------------------------------------------------
Data SN76489::GetVolumeRegister(unsigned int channelNo, const AccessTarget& accessTarget) const
{
	Data data(volumeRegisterBitCount);
	data = reg.Read((channelNo * 2) + 0, accessTarget);
	return data;
}

//----------------------------------------------------------------------------------------
void SN76489::SetVolumeRegister(unsigned int channelNo, const Data& adata, const AccessTarget& accessTarget)
{
	reg.Write((channelNo * 2) + 0, adata, accessTarget);
}

//----------------------------------------------------------------------------------------
Data SN76489::GetToneRegister(unsigned int channelNo, const AccessTarget& accessTarget) const
{
	Data data(toneRegisterBitCount);
	data = reg.Read((channelNo * 2) + 1, accessTarget);
	return data;
}

//----------------------------------------------------------------------------------------
void SN76489::SetToneRegister(unsigned int channelNo, const Data& adata, const AccessTarget& accessTarget)
{
	reg.Write((channelNo * 2) + 1, adata, accessTarget);
}
