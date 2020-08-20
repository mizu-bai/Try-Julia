# GA

#=

LeetCode 198. House Robber

You are a professional robber planning to rob houses along a street. Each house has a certain amount of money stashed, the only constraint stopping you from robbing each of them is that adjacent houses have security system connected and it will automatically contact the police if two adjacent houses were broken into on the same night.

Given a list of non-negative integers representing the amount of money of each house, determine the maximum amount of money you can rob tonight without alerting the police.

=#

# Import Packages

# GA Parameters

NP = 20
L = 10
Pc = 0.8
Pv = 0.2
G = 100

# Example

house = Int64.(floor.(rand(1, L) * 10) .+ 1)

# Initalization

f = Int64.(zeros(NP, L))
money = zeros(NP, 1)
moneyFit = zeros(NP, 1)
fBest = Int64.(zeros(1, L))

for ii = 1: NP

    f[ii, :] = Int64.(floor.(rand(1, L) .+ 0.5))

end

# Start

nf = Int64.(zeros(NP, L))

for ii = 1: G

    for jj = 1: NP

        global moneyFit, fBest, f, nf

        # Fitness (money)

        for kk = 1: (L - 1)

            if f[jj, kk] & f[jj, kk + 1] == 1

                money[jj, 1] = 0

                break

            else

                money[jj, 1] = sum(f[jj, :] .* house[1, :])

            end

        end

        moneyMin = minimum(money[:, 1]) # Max
        moneyMax = maximum(money[:, 1]) # Min

        if money[jj, 1] == moneyMax

            fBest[1, :] = f[jj, :] # Best

        end

        moneyFit[jj, 1] = (money[jj, 1] - moneyMin) / (moneyMax - moneyMin) # Normalization

        # Roulette

        sumFit = sum(moneyFit)
        fitValue = moneyFit ./ sumFit
        cumFitValue = cumsum(fitValue[:, 1])

        for mm = 1: NP

            roll = rand()

            for nn = 1: (length(cumFitValue) - 1)

                if cumFitValue[mm] < roll < cumFitValue[mm + 1]

                    nf[mm, :] =  f[nn, :]

                else

                    nf[mm, :] =  f[1, :]

                end

            end

        end

        # Crossing

        for kk = 1: 2: NP

            c = rand()

            if c < Pc

                selection = Int64.(floor.(rand(1, L) .+ 0.5))
                new1 = nf[kk, :] .* selection[1, :] .+ nf[kk + 1, :] .* (1 .- selection[1, :])
                new2 = nf[kk, :] .* (1 .- selection[1, :]) .+ nf[kk + 1, :] .* selection[1, :]
                nf[kk, :] = new1
                nf[kk + 1, :] = new2

            end
        end

        # Variation

        for pp = 1: NP

            for qq = 1: L

                v = rand()

                if v < Pv

                    nf[pp, qq] = 1 - nf[pp, qq]

                end

            end

        end

        # Replacing

        f = nf
        nf[1, :] = fBest[1, :]

    end

end

moneyBest = sum(fBest[1, :] .* house[1, :])

println("Best Selection is $(fBest), money is $(moneyBest).")
