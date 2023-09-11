function result = texture_fusion(D1,D2,T)

fullpath = mfilename('fullpath');
[file_path] = fileparts( fullpath);
currentFolder = file_path;

D2 = D2.*T;

%% Feature description
%Gabor
g = gabor([4,8],[0:45:135]);
[Gd1,phase] = imgaborfilt(D1,g);
[Gd2,phase] = imgaborfilt(D2,g);
[m,n,so] = size(Gd1);

%% Noise removal of DTF in SAR images
%Most stable main scale and orientation
sigma = 3;
Wg = fspecial('gaussian',[ceil(sigma*3/2)*2+1,ceil(sigma*3/2)*2+1],sigma);

Gd1_f = convn(Gd1, Wg, 'same');
Gd2_f = convn(Gd2, Wg, 'same');

Gd1_max = zeros(size(Gd1_f));
Gd2_max = zeros(size(Gd2_f));

[v_max1,s_o1]=  max(Gd1_f,[],3);
[v_max2,s_o2] =  max(Gd2_f,[],3);

for i = 1:m
    for j = 1:n
       Gd1_max(i,j,s_o1(i,j)) = v_max1(i,j);
       Gd2_max(i,j,s_o2(i,j)) = v_max2(i,j);
    end
end

%Eliminate the SAR random noise
s = 5;
ns_g = ones(s,s);
Gd2_max_flag = zeros(size(Gd2_max)); %Noise-free flag
Gd2_max_flag(Gd2_max>0) = 1;

Gd2_ns = convn(Gd2_max_flag, ns_g, 'same');

Gd2_max(Gd2_ns<ceil((s*s)/2)) = 0;

%% Histogram statistics
wid = 4;
block = 4;
Wg = ones(wid,wid);

Gd1_max_f = convn(Gd1_max, Wg, 'same');
Gd2_max_f = convn(Gd2_max, Wg, 'same');

Gd1_n = Gd1_max_f./sum(Gd1_max_f,3);
Gd2_n = Gd2_max_f./sum(Gd2_max_f,3);

%Convert format
[m,n,z] = size(Gd1_n);
Feature1 = zeros(z,m*n);
Feature2 = zeros(z,m*n);

for k = 1:z
    Feature1(k,:) = reshape(Gd1_n(:,:,k)',1,m*n);
    Feature2(k,:) = reshape(Gd2_n(:,:,k)',1,m*n);
end

%Zero vector
no_texture2 = sum(Feature2);

%% Similarity measure
%KL divergence
klsize = size(Feature1);
klmat = zeros(1,klsize(2));
result = D2;

for i=1:klsize(2)
        Dkl=KL(Feature1(:,i),Feature2(:,i));
        klmat(i)= Dkl;
end

klmat(isnan(klmat))=0;
klmean = mean(klmat); 

[height,width,dimention]=size(D1);

GAC1 = Gradient_amplitude_calculation(D1);
GAC2 = Gradient_amplitude_calculation(D2);

GAC1 = GAC1./double(D1);
GAC2 = GAC2./double(D2);

GAC1(isinf(GAC1)) =0;
GAC2(isinf(GAC2)) =0;
GAC1(isnan(GAC1)) =0;
GAC2(isnan(GAC2)) =0;

for i=1:klsize(2)
    m = fix((i-1) / width);
    n = mod((i-1), width);
    if klmat(i)<klmean
        if no_texture2(i)>0
           result(m+1,n+1) = (D1(m+1,n+1)+D2(m+1,n+1))/2;
        else
           result(m+1,n+1) = D1(m+1,n+1);
        end
    else
        if GAC1(m+1,n+1)<GAC2(m+1,n+1) && no_texture2(i)>0
            result(m+1,n+1) = D2(m+1,n+1);
        else
            result(m+1,n+1) = D1(m+1,n+1);
        end
    end
end

end