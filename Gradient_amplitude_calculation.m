function result = Gradient_amplitude_calculation(t1)
hx = [-1,0,1];
hy = -hx';

% hx = [-1,0,1;-2,0,2;-1,0,1];
% hy = -hx';

grad_x = imfilter(double(t1),hx);
grad_y = imfilter(double(t1),hy);
result = sqrt(grad_x.^2+grad_y.^2);

end

