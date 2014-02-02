clear all
clc
dir = '~/CHILE_project/TimeSeries_Francisco/';
% fieldID = {'01_N1'};
% 
% clear data
% clear varcanddata
% data = read_franlc(dir, fieldID);
% Jindcut = 1;
% show_fit = 1;
% varcanddata = find_varcandidates(data, Jindcut, show_fit);
% JindP(varcanddata);


directionstr = {'N','S'};
Jindcut = 1;
Nseries = 3;
outdir = '~/CHILE_project/JPF/';
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
            fieldID = {fldid};
            data = read_franlc(dir, fieldID);
            if numel(data) == 0
                continue
            else
                show_fit = 0;
                varcanddata = find_varcandidates(data, Jindcut, show_fit);
                if numel(varcanddata{1}.Jinds) > 0 %if there is candidates
                    Pinfo = get_Pinfo(varcanddata);
                    Fcoeff = get_Fcoeff(varcanddata, Pinfo,Nseries);
                    print_info(outdir, varcanddata, Pinfo, Fcoeff);
                    save(['~/CHILE_project/matfiles/',fldid,'.mat'], 'fldid','data','varcanddata','Pinfo','Fcoeff');
                end
            end
        end
    end
end
