# NeuroTimeseries.jl

Abstractions for working with neuroimaging, physiological, and behavioral time series data in Julia.

This package is designed to be lightweight and flexible, and to work with other packages in the Julia ecosystem. It is not intended to be a standalone package for analyzing time series data, but rather to provide a set of abstractions and tools that can be used in conjunction with other packages.

## Example

```julia
using PyMNE 
using MNETimeseries

# load data
raw = MNERaw("path/to/raw.bdf")

# number of channels
nchannels(raw) # > 64

# channel names
name.(channels(raw)) # > ["Fp1", "Fp2", "F3", "F4", ...]
```
