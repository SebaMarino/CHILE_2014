function Pinfo = get_Pinfo(data)
for fld_ind = 1:numel(data)
    [nobj, Nnights] = size(data{fld_ind}.MJD);
    for obj = 1:numel(data{fld_ind}.Jinds)
        time = data{fld_ind}.MJD(obj,:) - data{fld_ind}.MJD(obj,1);
        lc = data{fld_ind}.mag(obj,:);
        
        [omega, lspower] = lombscargle(time, lc, 8);
        npeaks = 3;
        [peakperiods, peakperioderrs, peakpowers, peakomegas] = ls_peaks(omega, lspower, npeaks);
        peakpower_falsealarm = falsealarm(peakpowers, numel(lc));
        Pinfo{fld_ind}.peakperiods(obj,:) = peakperiods;
        Pinfo{fld_ind}.peakperioderrs(obj,:) = peakperioderrs;
        Pinfo{fld_ind}.peakpowers(obj,:) = peakpowers;
        Pinfo{fld_ind}.peakpower_falsealarm(obj,:) = peakpower_falsealarm;
    end
    
end