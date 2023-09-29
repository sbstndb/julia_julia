using LinearAlgebra
using Images
using BenchmarkTools

using ColorSchemes
using Colors

BenchmarkTools.DEFAULT_PARAMETERS.seconds = 1

MAX_ITER = 100

RE_START = -2
RE_END = -1
IM_START = -1
IM_END = 1



function mandelbrot(c::Complex{Float64})
    z::Complex{Float64} = 0 
    n::Int64 = 0 
    while (abs(z) <= 2) & (n < MAX_ITER)
        z = z*z + c
        n += 1
    end
    return n 
end


function compute_mandelbrot(WIDTH ,HEIGHT)
    result = zeros(WIDTH, HEIGHT)
    for i in 1:WIDTH
        for j in 1:HEIGHT
            c::Complex{Float64} = RE_START + (i/WIDTH) * (RE_END - RE_START) + ( IM_START + (j/HEIGHT) * (IM_END - IM_START) )*im
            m = mandelbrot(c)
            color = 255 - floor(m * 255 / MAX_ITER)
            result[i,j] = color
        end
    end
    return result 
end

function threaded_compute_mandelbrot(WIDTH ,HEIGHT)
    result = zeros(WIDTH, HEIGHT)
    Threads.@threads for i in 1:WIDTH
        for j in 1:HEIGHT
            c = RE_START + (i/WIDTH) * (RE_END - RE_START) + ( IM_START + (j/HEIGHT) * (IM_END - IM_START) )*im
            m = mandelbrot(c)
            color = 255 - floor(m * 255 / MAX_ITER)
            result[i,j] = color
        end
    end
    return result 
end

x = 800
y = 800
#bench = @benchmark compute_mandelbrot(x, y)
#display(bench)
#bench = @benchmark threaded_compute_mandelbrot(x, y)
#display(bench)

x = 2560
y = 2560

#x = 10000
#y = 10000

println("Compute ...")
result = threaded_compute_mandelbrot(x, y)
println("Save ...")
cv = colorview(Gray, result/255)
cv_rgb = RGB.(cv)
save("gray.png", cv)
save("color.png", cv_rgb)

cs  = get(ColorSchemes.leonardo, result/255)
save("leonardo.png", cs)


cs  = get(ColorSchemes.solar, result/255)
save("solar.png", cs)

cs  = get(ColorSchemes.speed, result/255)
save("speed.png", cs)




