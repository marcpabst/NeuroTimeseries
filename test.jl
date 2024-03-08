using NeuroTimeseries, MNE
using Unitful
using Test

# DEFINE A NEW TYPE OF MULTIVARIATE TIMESERIES
struct EEGRaw{T,N} <: AbstractMultivariateTimeseries{N,T}
    data::AbstractArray{T,N}
    samplingrate::Float64
end

# implement _data, _axes and _units and samplingrate
NeuroTimeseries._axes(::EEGRaw) = (:sensor, :time)
NeuroTimeseries._data(d::EEGRaw) = d.data
NeuroTimeseries._units(::EEGRaw) = (:, :, u"s")
NeuroTimeseries.samplingrate(d::EEGRaw) = d.samplingrate

# TEST THE NEW TYPE

@testset "Custom EEGRaw" begin
    # create a new EEGRaw
    data = rand(4, 10_0000)
    raw = EEGRaw(data, 1000.0)

    # we can index in :sensor, :observation, :time order
    @test raw[1, 1, 1] == data[1, 1]

    @test size(raw) == (4, 10_0000)

    # we can get the duration of the timeseries
    @test duration(raw) == 100.0

    # we can get the number of sensors
    @test nsensors(raw) == 4

    # we can get the number of samples
    @test nsamples(raw) == samplingrate(raw) * duration(raw)

    # we can get stand-in channel names
    @test sensornames(raw) == ["Sensor 1", "Sensor 2", "Sensor 3", "Sensor 4"]

    # but we cant get the actual channel info because we haven't implemented it
    @test_throws ErrorException channels(raw)
end;

# TEST MNE INTEGRATION
@testset "MNE" begin
    # create a new MNERaw
    mne_raw = MNERaw("test.edf")

    # we can index in :sensor, :observation, :time order
    @test size(mne_raw) == size(mne_raw._data)

    # we can get the duration of the timeseries
    @test duration(mne_raw) == 6.0

    # we can get the number of sensors
    @test nsensors(mne_raw) == 139

    # we can get the number of samples
    @test nsamples(mne_raw) == samplingrate(mne_raw) * duration(mne_raw)
end;

