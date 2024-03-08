module MNE

using PyMNE
using Unitful
using NeuroTimeseries
import Base: size, getindex, setindex!, show

export MNEChannelInfo, MNERaw

struct MNEChannelInfo <: AbstractSensorInfo
    inner::PyMNE.Py
    index::Int
    info::PyMNE.Py
end

struct MNERaw <: AbstractMultivariateTimeseries{Float64,2}
    inner::PyMNE.Py
    _data::PyMNE.PyArray

    function MNERaw(data::PyMNE.Py)
        new(data, PyMNE.pyconvert(PyMNE.PyArray, data._data))
    end

    function MNERaw(fname::String, preload::Bool=true)
        data = PyMNE.io.read_raw(fname, preload=preload)
        new(data, PyMNE.pyconvert(PyMNE.PyArray, data._data))
    end
end

# implement _data, _axes and _units and samplingrate
NeuroTimeseries._axes(::MNERaw) = (:sensor, :time)
NeuroTimeseries._data(d::MNERaw) = d._data
NeuroTimeseries._units(::MNERaw) = (:, :, u"s")
NeuroTimeseries.samplingrate(d::MNERaw) = PyMNE.pyconvert(Float64, d.inner.info.get("sfreq"))

end # module MNETimeseries