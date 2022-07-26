clear

Q = [2 2 2;2 4 5;2 5 7];
[n,m] = size(Q);
I = zeros(3,1);
Isol = I;
Ib = [0.1;0.2;0.3];

R = chol(Q);

chi = phi(round(I),Ib,Q);
min = chi;
minold = min;

g3 = ceil((-sqrt(chi)/R(3,3)) + Ib(3));
d3 = floor((sqrt(chi)/R(3,3)) + Ib(3));
for i_3 = g3:d3
    val3 = (R(3,3)*(i_3 - Ib(3)))^2;
    if chi <= val3 
        g2 = ceil(((-sqrt(chi-val3) - R(2,3)*(i_3-Ib(3)))/R(2,2)) + Ib(2));
        d2 = floor(((sqrt(chi-val3) - R(2,3)*(i_3-Ib(3)))/R(2,2)) + Ib(2));
        for i_2 = g2:d2
            val2 = val3 + (R(2,2)*(i_2-Ibar(2))+R(2,3)*(i_3-Ibar(3)))^2;
            if chi <= val2
                g1 = ceil(((-sqrt(chi-val2))-R(1,2)*(i_2-Ib(2))-R(1,3)*(i_3-Ib(3))-R(1,2)*(i_2-Ib(2)))/R(1,1) + Ib(1));
                d1 = floor(((sqrt(chi-val2))-R(1,2)*(i_2-Ib(2))-R(1,3)*(i_3-Ib(3))-R(1,2)*(i_2-Ib(2)))/R(1,1) + Ib(1));
                for i_1 = g1:d1
                    I = [i_1;i_2;i_3];
                    minold = min;
                    min = minimum(min,phi(I,Ib,Q));
                    chi = min;
                    if minold ~= min
                        Isol = I;
                    end
                end
            end
        end
    end
end

phi1 = phi([0;1;0],Ib,Q);
phi2 = phi([1;-1;1],Ib,Q);

%%
clear

% general 
A = [100; 200; 300; 400];
G = [1 1 1; 2 2 4; 3 4 5; 1 0 1];
b = [-151.66; 96.534; -253.27; -1202.7];
[m,n] = size(G); 
[m,p] = size(A);
res = [A G]\b; 
Ib = res(p+1:end);
Q = G'*G - G'*A*pinv(A)*G;

% Ib = [.1; .2; .3]; 
% Q = [2 2 2;2 4 5;2 5 7];
% [n,m] = size(Q);

I = zeros(n,1);

R = chol(Q);
chi = phi(round(I),Ib,Q);
val = 0;
g = ceil((-sqrt(chi))/R(n,n)+Ib(n));
d = floor((sqrt(chi))/R(n,n)+Ib(n));

[Isol, min] = calcI(n, chi, g, d, val, I, Ib, Q, R); 

function [Isol, min] = calcI(ite, chi, g, d, val, I, Ib, Q, R)
    min = chi;
    Isol = I;
    if ite < 1
        phinv = phi(I,Ib,Q);
        if phinv < chi
            min = chi;
            Isol = I;
        end
    else
        for i = g:d
            I(ite) = i;
            vali = val + (sum(R(ite,ite:end)*(I(ite:end)-Ib(ite:end))))^2;
            if vali < chi
                gi = ceil( (-sqrt(chi-vali) - sqrt(vali - val)) /R(ite,ite) + Ib(ite));  %sum(R(ite,ite:end)*(I(ite:end)+Ib(ite:end)))
                di = floor( (sqrt(chi-vali) - sqrt(vali - val)) /R(ite,ite) + Ib(ite));
                [Icalc, mincalc] = calcI(ite-1, chi, gi, di, vali, I, Ib, Q, R); 
                if mincalc < min
                    min = mincalc;
                    chi = min;
                    Isol = Icalc;
                end
            end
        end
    end
end

function chi = phi(I,Ib,Q)
    chi = (I-Ib)'*Q*(I-Ib);
end

