module NeuroTimeseries

export AbstractMultivariateTimeseries,
    AbstractEEGRaw, AbstractEEGEpochs,
    AbstractSensorInfo,
    nsensors,
    nsamples,
    nepochs,
    samplingrate,
    duration, channels,
    sensornames,
    sensors,
    channelnames, name, type

include("macros.jl")
include("timeseries_types.jl")

end # module NeuroTimeseries
