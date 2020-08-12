# TSP & Simulated Annealing

# Import Packages and Files

using Plots
using Distances

include("sumLen.jl")
include("plotPath.jl")

# Constants

n = 20                              # Number of Cities
temperature = Float64(100 * n)      # Starting Temperature
iter = 100                          # Iteration Times

# Randomizing Coordinates

city = rand(n, 2) * 100 .+ 1

# Interation Notes

l = 1                               # Interation Times
len = []                            # Sum of Distance

plot()
plotPath(city)                      # Plot the Path

# Iteration

while true

    global n, temperature, iter, city, cityNew, l, len

    for ii = 1: iter

        len1 = sumLen(city)         # Sum of Distance before Exchange

        cityNew = copy(city)        # Exchange Coordinates

        while true

            p =  Int64.(floor.(n * rand(2, 1) .+ 1))

            if p[1] != p[2]

                cityNew[p[1], :] = city[p[2], :]
                cityNew[p[2], :] = city[p[1], :]

                break

            end

        end

        len2 = sumLen(cityNew)      # Sum of Distance after Exchange

        deltaE = len2 - len1        # Energy difference

        if (deltaE < 0) || (exp(- deltaE / temperature) > rand())

            city = cityNew          # Accept

        end

    end

    len = [len; sumLen(city)]       # New Length
    l += 1
    temperature *= 0.99             # Lower Temperature

    if temperature < 0.001

        break                       # Stop

    end

end

# Output

plotPath(city)                      # Plot Result
println("min = $(len[end])")
