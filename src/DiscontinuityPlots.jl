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
    jumpsize --> 1e-2
    x, y = jumpify(x, y, plotattributes[:jumpsize])
    dottedlines = Tuple{Float64, Float64}[]
    filleddots = Tuple{Float64, Float64}[]
    hollowdots = Tuple{Float64, Float64}[]
    for i in 2:length(x)-1
        if isnan(x[i])
            midx = 0.5(x[i - 1]+x[i + 1])
            leftendpoint = (midx, y[i - 1])
            rightendpoint = (midx, y[i + 1])
            push!(hollowdots, plotattributes[:rightcontinuous] ? leftendpoint : rightendpoint)
            push!(filleddots, plotattributes[:rightcontinuous] ? rightendpoint : leftendpoint)
            append!(dottedlines, [leftendpoint, rightendpoint, (NaN, NaN)])
        end
    end
    markersize --> 5
    linewidth --> 2.5
    markerstrokewidth --> 1
    @series begin
        x := x
        y := y
        seriestype := :path
        ()
    end
    @series begin
        x := first.(dottedlines)
        y := last.(dottedlines)
        seriestype := :line
        primary := false
        linestyle := :dot
    end
    @series begin
        x := first.(hollowdots)
        y := last.(hollowdots)
        seriestype := :scatter
        primary := false
        markerstrokecolor := Plots.get_series_color(
            plotattributes[:seriescolor],
            plotattributes[:subplot],
            plotattributes[:series_plotindex],
            :path
        )
        markercolor := RGBA(1, 1, 1, 0)
        markerstrokewidth := plotattributes[:linewidth]
    end
    @series begin
        x := first.(filleddots)
        y := last.(filleddots)
        markerstrokewidth := 0
        seriestype := :scatter
        primary := false
    end
end

end # module
