function k = calc_Kernel(hyp, x, z)
    len = exp(hyp.cov(1));  % char length
    sf  = exp(hyp.cov(2));  % signal var
    val = (x-z)*(x-z)'/(len*len);
    k   = sf*sf*exp(-0.5*val);

    % sn  = exp(hyp.lik);
    % n   = size(z,2);
    % P   = eye(n)*(len*len);
    % [size((x-z)') size(P) size(x-z)]
    % val = (x-z)*pinv(P)*(x-z)';
    
end