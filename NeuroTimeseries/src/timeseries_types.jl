# Abstract types and functions for working with timeseries data.
using Unitful


"""
Abstract type for multivariate timeseries data.

Allows for indexing the data as `data[i..., sensors, observations, time]`.

If you want to implement a new type of multivariate timeseries, the easiest way is to
do so is to implement the following methods:
    - `_data`: returns the underlying data (or a view of the data) in the form of an AbstractArray.
        E.g. `data(d::MyTimeseries) = d._data`
    - `_axes`: returns the types of the dimensions of the AbstractArray returned by `data()`.    
        E.g. `axes(d::MyTimeseries) = (:sensors, :time)`
    - `_units`: returns the unit of the data.
        E.g. `units(d::MyTimeseries) = Unitful.V
    - axisunits: returns the units of the axes.
        E.g. `axisunits(d::MyTimeseries) = (None, Unitful.s)
"""
abstract type AbstractMultivariateTimeseries{N,T} <: AbstractArray{T,N} end
abstract type AbstractSensorInfo end


@mustimplement _data(d::AbstractMultivariateTimeseries)
@mustimplement _axes(d::AbstractMultivariateTimeseries)
@mustimplement _units(d::AbstractMultivariateTimeseries)
_axisunits(d::AbstractMultivariateTimeseries) = [Unitful.V for _ in _axes(d)]

# Base methods for AbstractMultivariateTimeseries
Base.show(io::IO, d::AbstractMultivariateTimeseries) = print(io, "Multivariate timeseries with $(nchannels(d)) channels and $(nsamples(d)) samples")

# implement all the necessary methods for AbstractArray
Base.eltype(d::AbstractMultivariateTimeseries) = eltype(_data(d))
Base.size(d::AbstractMultivariateTimeseries) = size(_data(d))
Base.size(d::AbstractMultivariateTimeseries, I...) = size(_data(d), I...)
Base.getindex(d::AbstractMultivariateTimeseries, inds...) = getindex(dataview(d), inds...)
Base.setindex!(d::AbstractMultivariateTimeseries, value, inds...) = setindex!(dataview(d), value, inds...)
Base.ndims(d::AbstractMultivariateTimeseries) = ndims(_data(d))

"""
Returns a view of the data with the given order of dimensions.

If not all are present in the tuple `dims`, the missing ones are prepended.
If there are dimensions in `dims` that are not present in the data, the 
data is reshaped to include them as singleton dimensions.

It is advisable to implement this method for your own types in a way that 
avoids unnecessary work when repeatedly calling `dataview` with the same
`dims` argument.
"""
function dataview(d::AbstractMultivariateTimeseries, inds...; dims=(:sensor, :observation, :time))
    axes = _axes(d)
    data = _data(d)
    units = _units(d)

    # reshape the data to include the dimensions in dims
    newdims = Int[]
    newdims_sizes = Int[]

    for dim in dims
        if !(dim in axes)
            push!(newdims_sizes, 1)
        else
            i = findfirst(axes .== dim)
            push!(newdims, i)
            push!(newdims_sizes, size(data, i))
        end
    end

    # if the data is already in the right shape, return it
    if newdims == axes
        return data
    end

    return reshape(data, newdims_sizes...)

end

"""
Returns the timepoints of the data.
"""
timepoints(d::AbstractMultivariateTimeseries) = dataview(d, :time)

"""
Returns the number of channels in a multivariate timeseries.
"""
nsensors(d::AbstractMultivariateTimeseries) = size(d, ndims(d) - 1)

"""
Returns the number of samples in a multivariate timeseries.
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
@mustimplement sensors(d::AbstractMultivariateTimeseries)
channels(d::AbstractMultivariateTimeseries) = sensors(d)

"""
Returns the name of all channels.
"""
sensornames(d::AbstractMultivariateTimeseries) = ["Sensor $i" for i in 1:nsensors(d)]
channelnames(d::AbstractMultivariateTimeseries) = sensornames(d)



