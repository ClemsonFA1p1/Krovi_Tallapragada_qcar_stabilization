function preview_flag = CameraPreview(position_x,mu)

P = zeros(10,1);

min_distance = 0.3048;
max_distance = 0.9144;
discretization = (max_distance - min_distance)/10;

J = mu - position_x;

if J > 0

    if J > max_distance
        P = zeros(10,1);
    end

    if J < min_distance
        P = zeros(10,1);
    end

    if max_distance>=J && J > (max_distance-discretization)
        P(1) = 1;
    end

    if max_distance-discretization>=J && J > (max_distance- 2*discretization)
        P(2) = 1;
    end

    if max_distance- 2*discretization>=J && J > (max_distance- 3*discretization)
        P(3) = 1;
    end

    if max_distance- 3*discretization>=J && J > (max_distance- 4*discretization)
        P(4) = 1;
    end

    if max_distance- 4*discretization>=J && J > (max_distance- 5*discretization)
        P(5) = 1;
    end

    if max_distance- 5*discretization>=J && J > (max_distance- 6*discretization)
        P(6) = 1;
    end

    if max_distance- 6*discretization>=J && J > (max_distance- 7*discretization)
        P(7) = 1;
    end

    if max_distance- 7*discretization>=J && J > (max_distance- 8*discretization)
        P(8) = 1;
    end

    if max_distance- 8*discretization>=J && J > (max_distance- 9*discretization)
        P(9) = 1;
    end

    if max_distance- 9*discretization>=J && J > (max_distance- 10*discretization)
        P(10) = 1;
    end
end

    preview_flag = P;

end