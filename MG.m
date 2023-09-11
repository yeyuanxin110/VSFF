function result = MG(U,layel)

result = zeros([size(U),layel]);

for i = 1:layel
    
    sigma = 4*i-1;
    U_f = wiener2(U,[sigma sigma]);    
    U_G = Gradient_amplitude_calculation(U_f);
    
    % Normalization
    U_GN = U_G./double(U_f);
    U_GN(isinf(U_GN)) = 0;
    U_GN(isnan(U_GN)) = 0;
    
    % Remove large gradient
    U_GN(U_GN>1) = 0;
    % Remove noise
    U_GN(U_GN<0.1) = 0;
    
    % Calculate the structural features
    Wg = ones(5,5);
    U_GN = convn(U_GN, Wg, 'same');
    U_GN = U_GN./25;
    U_GN(U_GN < 0.05) = 0;
    
    result(:,:,i) = U_GN;
end