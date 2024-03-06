# Abstract types and functions for working with timeseries data.
abstract type AbstractMultivariateTimeseries{N,T} <: AbstractArray{T,N} end
abstract type AbstractTimeseriesChannelInfo end


@mustimplement Base.size(d::AbstractMultivariateTimeseries)

"""
Returns the number of channels in a multivariate timeseries.
"""
nchannels(d::AbstractMultivariateTimeseries) = size(d, ndims(d) - 1)

"""
Returna the number of samples in a multivariate timeseries.
"""
nsamples(d::AbstractMultivariateTimeseries) = size(d, ndims(d))

"""
Returns the dimensionality of the data. This refers to the actual number of dimensions in the data,
not the logical dimensionality. For example, if you are dealing with EEG data from a single channel,
the logical dimensionality is 1, but the actual dimensionality is typically 2 (samples x channels).
"""
dimensionality(d::AbstractMultivariateTimeseries) = ndims(d) - 1

"""
Returns the the sampling rate of the data in Hz.
"""
@mustimplement samplingrate(d::AbstractMultivariateTimeseries)

"""
Returns the duration of the data in seconds.
"""
function duration(d::AbstractMultivariateTimeseries)
    # by default, assume the duration is the number of samples divided by the sampling rate
    # if the space is not uniform, this should be overridden
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


