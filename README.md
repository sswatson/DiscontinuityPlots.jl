# DiscontinuityPlots.jl

## Usage

```julia
using Plots, DiscontinuityPlots
plot(-5:0.01:5, floor, seriestype = :jump, rightcontinuous = true)
```

![floor-function](https://raw.githubusercontent.com/sswatson/DiscontinuityPlots.jl/main/example.svg)

## Installation

```julia
using Pkg
Pkg.add("https://github.com/sswatson/DiscontinuityPlots.jl")
```
