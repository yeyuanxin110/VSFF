function Is = pixel_saliency(I)

[a,b] = imhist(I);
a(1,1)=0;

k = zeros(256,1);
for i=0:255
    vp = 0;
    for j=0:255
        if a(i+1)>0 && a(j+1)>0
            va = abs(i-j)*a(j+1);
            vp = vp+va;
        end
    end
    k(i+1,1) = vp;
end

[m,n] = size(I);
for i=1:m
    for j=1:n
        Is(i,j) = k(I(i,j)+1,1);
    end
end

end

