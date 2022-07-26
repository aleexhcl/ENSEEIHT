clear all;

N = pow2(5);

cj = zeros(1,N);
for k = 1:N
    cj(k) = sqrt(abs(cos(k/N)));
end

[d,c0] = haar_decomposition(cj);
[c] = haar_reconstruction(d,c0,eps);

figure 
plot(cj)
figure 
plot(c,'red')