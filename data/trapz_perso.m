function  z = trapz_perso(x,sample_rate)
% Return area under curve of the absolute value of signal in vector x
% sample_rate in Hz, scalar
% z is the integral of vector x

x = abs(x);

z = (x(1:end-1) + x(2:end)) ./ sample_rate ./2;

z = sum(z);