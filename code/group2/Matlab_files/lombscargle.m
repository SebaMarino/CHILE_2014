function [omega, lspower] = lombscargle(time, lc, varargin)
    if numel(varargin) == 0
        ofac = 4.;
    else
        ofac = double(varargin{1});
    end

    T = max(time) - min(time);
    ndata = numel(lc);
    deltatmin = min( time(2:end) - time(1:end-1) );
    freqmin = 1/T;
    freqmax = 1/2/deltatmin;
    freqstep = 1/(ofac*T);

    lc_normed = normData(lc);
    omegamin = 2*pi*freqmin;
    omegamax = 2*pi*freqmax;
    omegastep = 2*pi*freqstep;

    omega = omegamin:omegastep:omegamax;
    lspower = zeros(size(omega));

    for i = 1: numel(omega);
        tau = computeTau(omega(i), time);
        lspower(i) = LSpower( omega(i), lc_normed, time, tau);
    end

end