module NeuroTimeseries

export AbstractMultivariateTimeseries,
    AbstractTimeseriesChannelInfo,
    AbstractEEGRaw, AbstractEEGEpochs,
    AbstractEEGChannelInfo,
    nchannels,
    nsamples,
    nepochs,
    samplingrate,
    duration, channels,
    channelnames, name, type

include("macros.jl")
include("timeseries_types.jl")
include("eeg_types.jl")

end # module NeuroTimeseries
