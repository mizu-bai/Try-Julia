# PSO

# Import Packages

using Interpolations
using PyPlot

pygui(true)

# Form Camber

x = y = 0: 10: 100
z = rand(length(x), length(y)) .* 10
# fig1 = surf(x, y, z)
xq = yq = 0: 100
interp_cubic = CubicSplineInterpolation((x, y), z)
zq = interp_cubic(xq, yq)
fig1 = surf(xq, yq, zq)

# Create Pops

N = 100
iter = 1000
ω = 0.8
c1 = 1
c2 = 1
poplimit = [x[1], x[end]]
vlimit = [-3, 3]

pop = zeros(N, 3)
v = zeros(N, 2)
localBest = zeros(N, 3)
globalBest = zeros(N, 3)

for ii = 1: N

    global pop, v, localBest

    pop[ii, 1: 2] = rand(1, 2) * 100
    pop[ii, 3] = interp_cubic(pop[ii, 1], pop[ii, 2])
    localBest[ii, :] = pop[ii, :]
    v[ii, :] = rand(1, 2) * 2 .* vlimit[1] .+ vlimit[2]

end

scatter3D(pop[:, 1], pop[:, 2], pop[:, 3])

for jj = 1: 2

    for kk = 1: N

        global pop, v, localBest, globalBest

        # Update Pops

        popnew = zeros(1, 3)
        popnew[1: 2] = pop[kk, 1: 2] .+ v[kk, :]

        if (poplimit[1] ≤ popnew[1, 1] ≤ poplimit[2]) && (poplimit[1] ≤ popnew[1, 2] ≤ poplimit[2])

            popnew[3] = interp_cubic(popnew[1], popnew[2])
            pop[kk, :] = popnew[1, :]

            if pop[kk, 3] ≥ localBest[kk, 3]

                localBest[kk, :] = pop[kk, :]

                if localBest[kk, 3] ≥ globalBest[3]

                    globalBest = localBest[kk, :]

                end

            end

        else

            popnew[3] = 0
            pop[kk, :] = popnew[1, :]

        end

        # Update v

        vnew = zeros(1, 2)
        vrand = rand(2, 2) .* 2 .- 1
        vchange = [c1 * (globalBest[1] - pop[kk, 1]) c2 * (localBest[kk, 1] - pop[kk, 1]); c1 * (globalBest[2] - pop[kk, 2]) c2 * (localBest[kk, 2] - pop[kk, 2])]
        vnew = ω * v[kk, :] .+ vrand .* vchange

        if (vlimit[1] ≤ vnew[1, 1] ≤ vlimit[2]) && (vlimit[1] ≤ vnew[1, 2] ≤ vlimit[2])

            v[kk, :] = vnew[1, :]

        end

    end

end

scatter3D(globalBest[1], globalBest[2], globalBest[3])

println("max is at $(globalBest)")
