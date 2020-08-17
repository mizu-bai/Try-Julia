# K-Means

# Import Packages

using Distances
using Distributions
using PyPlot

pygui(true)

# Randomize Data

N = 100
K = 3
D = 2

randCenter = rand(K, D) * 100
dataDistributionMode = Distributions.Normal(0, 5)
randShifting = rand(dataDistributionMode, N, D)
data = zeros(N, D + K + 1)

# PyPlot.scatter(randCenter[:, 1], randCenter[:, 2])

for ii = 1: N

    global data

    k = Int64(floor(rand() * K) + 1)
    data[ii, D + 1] = k
    data[ii, 1: D] = randCenter[k, 1: D] .+ randShifting[ii, 1: D]

end

PyPlot.scatter(data[:, 1], data[:, 2])

# Simulate Artificial Selection after Observing Data Distribution

centerDistributionMode = Distributions.Normal(0, 10)
centerShifting = rand(centerDistributionMode, K, D)
center = randCenter[:, 1: D] .+ centerShifting[:, 1: D]

PyPlot.scatter(center[:, 1], center[:, 2])

# Run

iter = 100

for jj = 1: iter

    for kk = 1: N

        global data, center

        for mm = (D + 2): (D + K + 1)

            data[kk, mm] = Distances.euclidean(data[kk, 1: D], center[mm - D - 1, 1: D])

        end

        for nn = (D + 2): (D + K + 1)

            if data[kk, nn] == minimum(data[kk, (D + 2): (D + K + 1)])

                data[kk, D + 1] = nn - D - 1

            end

        end

    end

    centerNew = zeros(K, D + 1)

    for pp = 1: N

        kind = Int64(data[pp, D + 1])

        for qq = 1: K

            if kind == qq

                centerNew[qq, 1: D] += data[pp, 1: D]
                centerNew[qq, D + 1] += 1

            end

        end

    end

    centerNew[:, 1: D] = centerNew[:, 1: D] ./ centerNew[:, D + 1]
    center[:, 1: D] = centerNew[:, 1: D]

end

PyPlot.scatter(center[:, 1], center[:, 2])
