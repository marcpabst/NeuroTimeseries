module MNETimeseries

using PyMNE
import Base: size, getindex, show

export MNEChannelInfo, MNERaw

struct MNEChannelInfo <: AbstractEEGChannelInfo
    inner::PyMNE.Py
    index::Int
    info::PyMNE.Py
end

struct MNERaw <: AbstractEEGRaw{Float64}
    inner::PyMNE.Py
    _data::PyMNE.PyArray

    function MNERaw(data::PyMNE.Py)
        new(data, PyMNE.pyconvert(PyMNE.PyArray, data._data))
    end

    function MNERaw(fname::String, preload::Bool=true)
        data = PyMNE.io.read_raw(fname, preload=preload)
        new(data, PyMNE.pyconvert(PyMNE.PyArray, data._data))
end

function samplingrate(d::MNERaw)
    return PyMNE.pyconvert(Float64, d.inner.info.get("sfreq"))
end

function data(d::MNERaw)
    return d._data
end

function channels(d::MNERaw)
    return [MNEChannelInfo(ch, i - 1, d.inner.info) for (i, ch) in enumerate(d.inner.info.get("chs"))]
end

function name(ch::MNEChannelInfo)
    return pyconvert(String, ch.inner.get("ch_name"))
end

function type(ch::MNEChannelInfo)
    return Symbol(pyconvert(String, PyMNE.channel_type(ch.info, ch.index)))
end

function Base.size(d::MNERaw)
    return size(data(d))
end

function getindex(A::MNERaw, inds...)
    return getindex(data(A), inds...)
end

function Base.setindex!(A::MNERaw, value, inds...)
    return Base.setindex!(data(A), value, inds...)
end




end # module MNETimeseries
