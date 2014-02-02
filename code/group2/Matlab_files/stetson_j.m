function Jind = stetson_j(time, mag, err)
    magi = mag(:, 1:end-1);
    erri = err(:, 1:end-1);
    magj = mag(:, 2:end);
    errj = err(:, 2:end);
    weights = ones(size(magi));    
    nobs = numel(mag(1,:));
    meanmag = repmat(mean(mag, 2), [1,nobs-1] );
    deltai = sqrt(nobs/(nobs-1)).*(magi-meanmag)./erri;
    deltaj = sqrt(nobs/(nobs-1)).*(magj-meanmag)./errj;
    Pk = deltai.*deltaj;
    Jind = sum(weights.*sign(Pk).*sqrt(abs(Pk)),2)./sum(weights, 2);
end
