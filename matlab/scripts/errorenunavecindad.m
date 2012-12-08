% error en una vecindad

% seleccionamos una vecindad alrededor de LocR de un metro de 10x10x10
LocR = Ev(1).LocR;
x = LocR(1);
y = LocR(2);
z = LocR(3);
dx = 10;
dy = 10;
dz = 10;
n = 3;
[~, ~, err0] = source(Ev(1), 100, 0.5,0.09);
for kk = 1:10
    X = linspace(x - dx, x + dx, 10);
    Y = linspace(y - dy, y + dy, 10);
    Z = linspace(z - dz, z + dz, 10);
    tempEv = Ev(1);
    err = ones([n n n]);
    err(:) = err0;
    for ii = 1:length(X)
        for jj = 1:length(Y)
            for ww = 1:length(Z)
                tempEv.LocR(1) = X(ii);
                tempEv.LocR(2) = Y(jj);
                tempEv.LocR(3) = Z(ww);
                [tempEv.src, ~, errtemp] = source(tempEv, 100, 0.5,0.09);
                if errtemp < min(err(:))
                    err(ii,jj,ww) = errtemp;
                    err0 = errtemp;
                    break;
                else
                    err(ii,jj,ww) = errtemp;
                end
                
            end
            if errtemp <= min(err(:))
                break;
            end
        end
        if errtemp <= min(err)
            break;
        end
    end
    % punto de minimo error de estimacion
    in = find(err(:) == min(err(:)));
    [xindex, yindex, zindex] = ind2sub(size(err),in);
    
    if x ~= X(xindex)
        x = X(xindex);
    else
        dx = dx/2;
    end
    
    if y ~= Y(yindex)
        y = Y(yindex);
    else
        dy = dy/2;
    end
    
    if z ~= Z(zindex)
        z = Z(zindex);
    else
        dz = dz/2;
    end    
end