function JindP(data)
for fld_ind = 1:numel(data)
    outname = ['~/CHILE_project/JindP/JindP_',data{fld_ind}.fieldname,'.txt'];
    fid = fopen(outname,'w');
    fprintf(fid, '%8s %8s %8s %8s %8s %8s %8s %8s %8s %8s %8s %8s %8s\n','#fied_CCD','source', 'alpha', 'Jind', 'P1', 'P2', 'P3', 'dP1', 'dP2', 'dP3','Conf1', 'Conf2','Conf3');
    
    [nobj, Nnights] = size(data{fld_ind}.MJD);
    for obj = 1:numel(data{fld_ind}.Jinds)
        time = data{fld_ind}.MJD(obj,:) - data{fld_ind}.MJD(obj,1);
        lc = data{fld_ind}.mag(obj,:);
        %if isreal(lc)
            [omega, lspower] = lombscargle(time, lc, 8);
            npeaks = 3;
            [peakperiods, peakperioderrs, peakpowers, peakomegas] = ls_peaks(omega, lspower, npeaks);
            peakpower_falsealarm = falsealarm(peakpowers, numel(lc));
            %
            %         maxomega = peakomegas(1);
            %         maxperiod = peakperiods(1);
            %         maxfalsealarm = peakpower_falsealarm(1);
            
            
            data{fld_ind}.period(obj) = peakperiods(1);
            data{fld_ind}.maxpower(obj) = peakpowers(1);
            data{fld_ind}.falsealarm(obj) = peakpower_falsealarm(1);
            
            fprintf(fid, '%8s %8i %8.4f %8.4f %8.4f %8.4f %8.4f %8.4f %8.4f %8.4f %8.4f %8.3f %8.4f\n', ...
                data{fld_ind}.fieldname, ...
                data{fld_ind}.source(obj,1), ...
                data{fld_ind}.alphacorr, ...
                data{fld_ind}.Jinds(obj),...
                peakperiods, ...
                peakperioderrs, ...
                (1-peakpower_falsealarm)*100 ...
                );
    end
    fclose(fid);
end
end