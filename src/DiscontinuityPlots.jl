module DiscontinuityPlots

using Plots

function jumpify(x, y, jumpsize)
    xs = Float64[]
    ys = Float64[]
    for (new_x, new_y) in zip(x, y)
        if length(ys) > 0 && new_y > ys[end] + jumpsize;
            push!(xs, NaN)
            push!(ys, NaN)
        end
        push!(xs, new_x)
        push!(ys, new_y)
    end
    xs, ys
end

@recipe function f(::Type{Val{:jump}}, x, y, z)
    rightcontinuous --> true
    markersize --> 4
    jumpsize --> 1e-3
    seriescolor --> first(get_color_palette(:auto, 1))
    x, y = jumpify(x, y, plotattributes[:jumpsize])
    dashedlines = Tuple{Float64, Float64}[]
    filleddots = Tuple{Float64, Float64}[]
    hollowdots = Tuple{Float64, Float64}[]
    for i in 2:length(x)-1
        if isnan(x[i])
            midx = 0.5(x[i - 1]+x[i + 1])
            leftendpoint = (midx, y[i - 1])
            rightendpoint = (midx, y[i + 1])
            push!(hollowdots, plotattributes[:rightcontinuous] ? leftendpoint : rightendpoint)
            push!(filleddots, plotattributes[:rightcontinuous] ? rightendpoint : leftendpoint)
            append!(dashedlines, [leftendpoint, rightendpoint, (NaN, NaN)])
        end
    end
    @series begin
        x := x
        y := y
        seriestype := :path
        legend := :false
        ()
    end
    @series begin
        x := first.(dashedlines)
        y := last.(dashedlines)
        seriestype := :line
        primary := false
        linestyle := :dash
    end
    @series begin
        x := first.(hollowdots)
        y := last.(hollowdots)
        seriestype := :scatter
        markerstrokewidth := 1
        markerstrokecolor := plotattributes[:seriescolor]
        seriescolor := :white
        primary := false
    end
    @series begin
        x := first.(filleddots)
        y := last.(filleddots)
        seriestype := :scatter
        markerstrokewidth := 0
        primary := false
    end
end

end # module
