function random_pre = preview_randomness(preview)

random_pre = preview;
A = randi(3);

if A ==1
    B = randperm(10,1);
    random_pre(B) = 1;
end

if A ==2
    B = randperm(10,2);
    random_pre(B(1)) = 1;
    random_pre(B(2)) = 1;
end

if A ==3
    B = randperm(10,3);
    random_pre(B(1)) = 1;
    random_pre(B(2)) = 1;
    random_pre(B(3)) = 1;
end

end