
# Abstract types for EEG data
abstract type AbstractEEGRaw{T} <: AbstractMultivariateTimeseries{2,T} end
abstract type AbstractEEGEpochs{T} <: AbstractMultivariateTimeseries{3,T} end
abstract type AbstractEEGChannelInfo <: AbstractTimeseriesChannelInfo end

"""
Return the number of epochs.
"""
nepochs(d::AbstractEEGEpochs) = size(d, 3)

"""
Returns the name of the channel.
"""
@mustimplement name(channel::AbstractEEGChannelInfo)

"""
Returns the type of the channel.
"""
@mustimplement type(channel::AbstractEEGChannelInfo)


# Custom printing method for EEG data
function Base.show(io::IO, d::AbstractEEGRaw)
    println(io, "Raw EEG data with $(nchannels(d)) channels and $(nsamples(d)) samples at $(samplingrate(d)) Hz")
end

function Base.show(io::IO, d::AbstractEEGRaw)
    println(io, "EEGRaw with $(nchannels(d)) channels and $(nsamples(d)) samples at $(samplingrate(d)) Hz")
end

function Base.show(io::IO, d::AbstractEEGEpochs)
    println(io, "EEGEpochs with $(nchannels(d)) channels, $(nepochs(d)) epochs, and $(nsamples(d)) samples at $(samplingrate(d)) Hz")
end

function Base.show(io::IO, ch::AbstractEEGChannelInfo)
    print(io, "Channel '$(name(ch))' of type $(type(ch))")
end