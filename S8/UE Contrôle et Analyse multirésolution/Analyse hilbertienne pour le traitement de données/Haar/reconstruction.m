function [dt,c]=reconstruction(d,c0,eps)
     [j,n] = size(d);
     dt = zeros(j,n);
     c  = zeros(j,n);

     c(1,1) = c0;

     [lign,col] = find(abs(d) >= eps);
     dt(l,c) = d(l,c);

     for i=1:j
         for k=1:n
             c(i+1,2*k) = (c(i,k) + d(i,k))/sqrt(2);
             c(i+1,2*k+1) = (c(i,k) - d(i,k))/sqrt(2);
         end
     end
end