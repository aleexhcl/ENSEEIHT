function [d,c0]=decomposition(cj)
    n = length(cj(:));
    j = log(n)/log(2);

    d = zeros(j,n);
    c = zeros(j,n);
    c(j,:) = cj;

    for i=j-1:-1:1
        for k=1:n
            c(i,k) = (c(i+1,2*k) + c(i+1,2*k+1))/sqrt(2);
            d(i,k) = (c(i+1,2*k) - c(i+1,2*k+1))/sqrt(2);
        end
    end

    c0 = c(1,1);

end