
import Base: size, show


abstract type AbstractMultivariateTimeseries{N,T} <: AbstractArray{T,N} end
abstract type AbstractTimeseriesChannelInfo end


@mustimplement Base.size(d::AbstractMultivariateTimeseries)

"""
Return the number of channels in a multivariate timeseries.
"""
nchannels(d::AbstractMultivariateTimeseries) = size(d, ndims(d) - 1)

"""
Return the number of samples in a multivariate timeseries.
"""
nsamples(d::AbstractMultivariateTimeseries) = size(d, ndims(d))

"""
Returns the the sampling rate of the data in Hz.
"""
@mustimplement samplingrate(d::AbstractMultivariateTimeseries)

"""
Returns the duration of the data in seconds.
"""
function duration(d::AbstractMultivariateTimeseries)
    return nsamples(d) / samplingrate(d)
end

"""
Returns information about the channels.
"""
@mustimplement channels(d::AbstractMultivariateTimeseries)

"""
Returns the name of all channels.
"""
function channelnames(d::AbstractMultivariateTimeseries)
    return [name(c) for c in channels(d)]
end


