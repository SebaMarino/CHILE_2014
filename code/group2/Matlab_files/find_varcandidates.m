function varcanddata = find_varcandidates(data, Jindcut, show_fit)

datafld_names = {'source', 'MJD', 'RA', 'DEC', 'x', 'y', 'flux','e_flux', 'radius', 'bg', 'sky', 'trans', 'modflux', 'errest', 'mag', 'magerr', 'Jinds'};
save_fit = 1;

for fld_ind = 1:numel(data)
    data{fld_ind}.Jinds = stetson_j(data{fld_ind}.MJD, data{fld_ind}.mag, data{fld_ind}.magerr*data{fld_ind}.alphacorr);
    
    data{fld_ind}.varcands = find(abs(data{fld_ind}.Jinds)>Jindcut);
    data{fld_ind}.candobj = data{fld_ind}.source(data{fld_ind}.varcands,1);
    
    fprintf('%d candidates in field %s\n', numel(data{fld_ind}.varcands), data{fld_ind}.fieldname);
    fprintf('%8s %6s %10s\n','FLDID', 'Obj', 'stetson_J');
    for i = 1:numel(data{fld_ind}.varcands)
        fprintf('%8s %6i %10.2f\n', data{fld_ind}.fieldname, data{fld_ind}.candobj(i), data{fld_ind}.Jinds(data{fld_ind}.varcands(i)));
    end
    if show_fit
        figure(1)
        clf
        meanmag = mean(data{fld_ind}.mag,2);
        scatter(meanmag, data{fld_ind}.Jinds, 'bo')
        hold on
        scatter(meanmag(data{fld_ind}.varcands), data{fld_ind}.Jinds(data{fld_ind}.varcands), 'r*')
        hold off
        xlabel('mag')
        ylabel('Stetson J variability index')
        title(sprintf('Stars in Field ID %s', data{fld_ind}.fieldname),'Interpreter','None')
        legend({'All point sources', 'Variable candiates'}, 'Location', 'Best')
        if save_fit
           print(gcf, ['./varcands_',data{fld_ind}.fieldname,'.eps'],'-depsc2');
        end
    end
    
    varcanddata{fld_ind}.fieldname = data{fld_ind}.fieldname;
    varcanddata{fld_ind}.alphacorr = data{fld_ind}.alphacorr;
    for datafld_ind = 1:numel(datafld_names)
        varcanddata{fld_ind}.(datafld_names{datafld_ind}) = data{fld_ind}.(datafld_names{datafld_ind})(data{fld_ind}.varcands,:);
    end
end


end