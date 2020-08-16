# Calculate the Sum of Distance between the Cities

function sumLen(city)

    n = size(city)[1]
    len = 0

    for ii = 1: (n - 1)

        len += euclidean(city[ii, :], city[ii + 1, :])

    end

    len += euclidean(city[1, :], city[n, :])

    return len

end
