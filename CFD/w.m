function [result] = w(lamda)

lamda = double(lamda);
result = zeros(size(lamda));
a1 = 0.25;
a2 = 0.5;
[m,n] = size(lamda);
for i = 1 : m
    for j = 1 : n
        if lamda(i,j) < a1
           result(i,j) = 0;
        end
        if lamda(i,j) >= a1 && lamda(i,j) <= a2
           result(i,j) = (lamda(i,j) - a1) / (a2 - a1);
        end
        if lamda(i,j) > a2
           result(i,j) = 1;
        end
    end
end

end

