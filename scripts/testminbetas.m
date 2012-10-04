distl1 = @(a) sum(10^(3)*abs(a*A-U));
betas0=ones(1,size(A,1));
options = optimset('LargeScale','on');
betas = fminunc(distl1,betas0,options);