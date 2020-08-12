# Link the Cities

function plotPath(city)

        n = size(city)[1]

        path = zeros(n + 1, 2)
        path[1: n, :] = city
        path[n + 1, :] = city[1, :]

        plot!(path[:, 1], path[:, 2])

end
