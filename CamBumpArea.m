function area = CamBumpArea(mu,x,nos)

if nos == 4
    bumpEnd = mu + nos*0.05;
    J = bumpEnd -x;
    if J <= 1.21 && J > 0
        area = (((0.25 - 0.01)/1.2)*(1.2 - J)) + 0.01;
    else
        area = 0.01;
    end
elseif nos == 1
    bumpEnd = mu + nos*0.05;
    J = bumpEnd -x;
    if J < 1.21 && J > 0
        area = (((0.15 - 0.01)/1.2)*(1.2 - J)) + 0.01;
    else
        area = 0.01;
    end
end

        
