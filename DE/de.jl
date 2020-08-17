# DE

# Import Packages

using PyCall
using PyPlot
@pyimport numpy as np

pygui(true)

# Drop Wave Function

f(x) = -(1 + cos(12 * x)) / (0.5 * x ^ 2 + 2)

limit = [-5, 5]
x = np.linspace(limit[1], limit[2], 500)
y = f.(x)

plot(x, y)

# Rats 

N = 50
iter = 100
AC = 0.5
CR = 0.8

rat = zeros(N, 2)

for ii = 1: N

    global rat

    rat[ii, 1] = rand() * 2 * limit[2] + limit[1]
    rat[ii, 2] = f.(rat[ii, 1])

end

scatter(rat[:, 1], rat[:, 2])

globalBest = zeros(1, 2)
globalBest[1, 1] = rand() * 2 + 0.5
globalBest[1, 2] = f(globalBest[1, 1])

# Iteration

for jj = 1: iter

    for kk = 1: N

        global rat, globalBest

        ratCR = zeros(3, 1)

        while true

            ratCR = Int64.(floor.(rand(3, 1) * 30) .+ 1)

            if ratCR[1] ≠ ratCR[2] ≠ ratCR[3] ≠ kk

                break

            end

        end

        ratNew = zeros(1, 2)

        if rand() > CR

            ratNew[1, 1] = rat[ratCR[1]] + AC * (rat[ratCR[2]] - rat[ratCR[3]])

            if limit[1] ≤ ratNew[1, 1] ≤ limit[2]

                ratNew[1, 2] = f(ratNew[1, 1])

            else

                ratNew[1, 2] = 0

            end

        else

            ratNew[1, :] = rat[kk, :]

        end

        if ratNew[1, 2] ≤ rat[kk, 2]

            rat[kk, :] = ratNew[1, :]

            if rat[kk, 2] ≤ globalBest[1, 2]

                globalBest[1, :] = rat[kk, :]

            end

        end

    end

end

scatter(globalBest[1, 1], globalBest[1, 2])
println("min = $globalBest")
