clc
dir = '~/CHILE_project/matfiles/';
directionstr = {'N','S'};

figure(1)
clf 
hold on
for obsfldnum = 1:31
    obsfldstr = sprintf('%02i',obsfldnum);
    for directionnum=1:2
        for ccdnum = 1:15
            ccdstr = sprintf('%i',ccdnum);
            fldid = [obsfldstr,'_',directionstr{directionnum},ccdstr];
            clear fieldID
            clear data
            clear varcanddata
            clear Pinfo
            clear Fcoeff
            matfile = [dir,fldid,'.mat'];
            fld_ind = 1;
            if exist(matfile)
               load(matfile)
               data{fld_ind}.Jinds = stetson_j(data{fld_ind}.MJD, data{fld_ind}.mag, data{fld_ind}.magerr*data{fld_ind}.alphacorr);    
               meanmag = mean(data{fld_ind}.mag,2);
               scatter(meanmag, data{fld_ind}.Jinds, 'bo')
               scatter(mean(varcanddata{fld_ind}.mag,2), varcanddata{fld_ind}.Jinds, 'r*')
            else
                continue
            end
        end
    end
end
%%
xlabel('<mag>')
ylabel('Stetson J variability index')
legend({'All Point Sources', 'Variable Candidates'},'Location','Best', 'FontSize', 20)
