function  [peakperiods, peakperioderrs, peakpowers, peakomegas] = ls_peaks(omega, lspower, npeaks)
    [peakpowers, peaklocs] = findpeaks(lspower, 'NPEAKS', npeaks,'SORTSTR','descend');
    peakomegas = omega(peaklocs);
    peakperiods = 2*pi./peakomegas;
    omegastep = omega(2) - omega(1);
    peakperioderrs = peakperiods.^2/2/pi*omegastep;
end