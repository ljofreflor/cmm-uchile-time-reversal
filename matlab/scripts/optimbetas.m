function [betas] = optimbetas(A, U, indices, betasinicial, eta)
%optimbetas(A, U, indices) Encuentra pesos optimos para estimar fuente

% maxstep = 1;

K=size(betasinicial,1);

initbetas=zeros(K,1);

for kk=1:K
    samplek = sum(indices(kk,:));
    if samplek ~= 0
        initbetas(kk)=1/samplek;
    end
end
initbetas = initbetas/norm(initbetas);

diagB=zeros(size(U,2),1);

for kk=1:size(initbetas,1)
    for componente=1:3
        diagB = diagB + sqrt(initbetas(kk))*squeeze(indices(kk,componente,:));
    end
end

B = repmat(diagB',size(A,1),1);

normalizedA = A.*B;
tA = normalizedA;

normalizedU = U.*diagB';
tU = normalizedU;

% newbetas = initbetas;
% newbetas = rand(K,1) ;
% newbetas = betasinicial;
% newerror = errorbetas(tA, tU, indices, newbetas, eta)
% grad = graderror(tA, tU, indices, newbetas, eta);
% 
% Dir = grad/norm(grad);
% 
% oldbetas = newbetas + maxstep*Dir;
% olderror = errorbetas(tA, tU, indices, oldbetas, eta)
% 
% while (abs(newerror-olderror)/newerror > tol)
%     oldbetas = newbetas;
%     olderror = newerror;
%     
%     newbetas = linemin(tA, tU, indices, oldbetas, Dir, maxstep, tol, eta);
%     newerror = errorbetas(tA, tU, indices, newbetas, eta)
%     grad = graderror(tA,tU, indices, newbetas, eta);
%     Dir = grad/norm(grad);
% end 
% 
% betas = newbetas;

options = optimset('Display','iter','LargeScale','on','MaxIter',100,'GradObj','on');
betas = fminunc(@errorngrad, betasinicial, options);

    function [err gradiente] = errorngrad(inputbetas)

           err = errorbetas(tA, tU, indices, inputbetas, eta);
           if nargout > 1 % gradient required
               gradiente = graderror(tA, tU, indices, inputbetas, eta);
           end
    end

end

function [errorinU] = errorbetas(A, U, indices, betas, eta)
%errorbetas(A, U, Indices) calcula el error correspondiente a betas
% Para un vector de pesos betas, errorbetas calcula el error entre los
% sensores originales y los sensores correspondientes a una estimacion de
% fuente "precondicionando" con los pesos betas.

K = size(betas,1);

diagB2=zeros(size(U,2),1);


for kk=1:K
    for componente=1:3
        diagB2 = diagB2 + betas(kk)*squeeze(indices(kk,componente,:));
    end
end

B2 = repmat(diagB2',size(A,1),1);

M = pinv((A.*B2)*A');
AM=A'*M;

alphas_betas = (U.*diagB2')*AM;

errorinU = sum((alphas_betas*A-U).^2) + eta*sum(betas.^2);

end

function [graderrorinU] = graderror(A, U, indices, betas, eta)

K = size(betas,1);

diagB2=zeros(size(U,2),1);

for kk=1:K
    for componente=1:3
        diagB2 = diagB2 + betas(kk)*squeeze(indices(kk,componente,:));
    end
end

B2 = repmat(diagB2',size(A,1),1);

M = pinv((A.*B2)*A');
AM=A'*M;

alphas_betas = (U.*diagB2')*AM;

graderrorinU = zeros(K,1);

for kk = 1:K
    Ik = squeeze(sum(indices(kk,:,:),2))';
    IIk = repmat(Ik,size(A,1),1);
    dalphas_dbetak = ((U.*Ik)*AM-((U.*diagB2')*AM*(A.*IIk)*AM));
    graderrorinU(kk) = (alphas_betas*A-U)*A'*dalphas_dbetak' + eta*betas(kk);
end
end

function newbetas = linemin(tA, tU, indices, oldbetas, Dir, maxstep, tol, eta)


downbetas = oldbetas - maxstep*Dir;
downerror = errorbetas(tA, tU, indices, downbetas, eta);

upbetas = oldbetas + maxstep*Dir;
uperror = errorbetas(tA, tU, indices, upbetas, eta);

while (2*abs(uperror-downerror)/(uperror+downerror) > tol)
    midbetas = (downbetas + upbetas)/2;
    miderror = errorbetas(tA, tU, indices, midbetas, eta);
    if (uperror < downerror)
        downbetas = midbetas;
        downerror = miderror;
    else
        upbetas = midbetas;
        uperror = miderror;
    end
end
if (uperror < downerror)
    newbetas = upbetas;
else
    newbetas = downbetas;
end
end
