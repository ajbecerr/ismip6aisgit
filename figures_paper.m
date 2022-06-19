%Routine to reproduce figures of manuscript https://tc.copernicus.org/articles/14/3033/2020/
%Contact: Helene Seroussi helene.seroussi@jpl.nasa.gov

function figures_paper(step)
    step=str2num(step);
    %error('Add the correct paths where the scalars outputs and regridded datasets can be found on the lines below')
    scalarpath='ComputedScalarsPaper'; %Change path for ISMIP6 regridded outputs
    gridpath='/projects/grid/ghub/ISMIP6/Projections/CMIP6_Archive_Final/AIS'; %Change path for ISMIP6 gridded outputs
    
    %model_list={'AWI_PISM1','DOE_MALI','ILTS_PIK_SICOPOLIS','IMAU_IMAUICE1','IMAU_IMAUICE2','JPL1_ISSM','LSCE_GRISLI','NCAR_CISM','PIK_PISM1','PIK_PISM2','UCIJPL_ISSM','ULB_FETISH32','ULB_FETISH16','UTAS_ElmerIce','VUB_AISMPALEO','VUW_PISM'};
    model_list={'AWI_PISM1','DOE_MALI','ILTS_PIK_SICOPOLIS','NCAR_CISM','PIK_PISM1','PIK_PISM2','UCIJPL_ISSM','ULB_FETISH32','ULB_FETISH16','UTAS_ElmerIce'};
    
    model_list2=model_list;
    for i=1:numel(model_list2)
    	   model_list2{i} = strrep(model_list2{i},'_','\_');
    end
    
    %Figure 1: evolution of historical and unforced control 
    if step==1 % {{{Figure 1a
    
    	figure(1); set(gcf,'color','w'); set(gcf,'Position',[400 400 900 450]);
    	colors = distinguishable_colors(length(model_list)*2);
    	experiments_list={'ctrl_proj_std','ctrl_proj_open'};
    
    	number=0;
    	results_model={};
    	max_acabf=-10; min_acabf=10^6;
    
    	if 1,
    		for imodel=1:length(model_list),
    			modelname=model_list{imodel};
    
    			for iexp=1:length(experiments_list),
    				expename=experiments_list{iexp};
    				[group,simul,resolution,ice_density,ocean_density,initial_model_year,expe_model_year,yearday_model,ishist_std,hist_std_name,hist_std_regrid,ishist_open,hist_open_name,hist_open_regrid,isctrl_proj_std,ctrl_proj_std_name,ctrl_proj_std_regrid,isctrl_proj_open,ctrl_proj_open_name,ctrl_proj_open_regrid,isexp01,exp01_name,exp01_regrid,isexp02,exp02_name,exp02_regrid,isexp03,exp03_name,exp03_regrid,isexp04,exp04_name,exp04_regrid,isexp05,exp05_name,exp05_regrid,isexp06,exp06_name,exp06_regrid,isexp07,exp07_name,exp07_regrid,isexp08,exp08_name,exp08_regrid,isexp09,exp09_name,exp09_regrid,isexp10,exp10_name,exp10_regrid,isexp11,exp11_name,exp11_regrid,isexp12,exp12_name,exp12_regrid,isexp13,exp13_name,exp13_regrid,isexpA1,expA1_name,expA1_regrid,isexpA2,expA2_name,expA2_regrid,isexpA3,expA3_name,expA3_regrid,isexpA4,expA4_name,expA4_regrid,isexpA5,expA5_name,expA5_regrid,isexpA6,expA6_name,expA6_regrid,isexpA7,expA7_name,expA7_regrid,isexpA8,expA8_name,expA8_regrid] = specifics(modelname)
    				
    				eval(['isexp=is' expename ';'])
    				if isexp,
    					number=number+1;
    					exptendacabf_file=['' scalarpath '/' group '/' simul '/' expename '/computed_smb_AIS_' group '_' simul '_' expename '.nc'];
    					time_model=ncread(exptendacabf_file,'time');
    					tendacabf_model=ncread(exptendacabf_file,'smb');
    					if strcmpi(expename,'ctrl_proj_std') 
    						if ishist_std,
    							exptendacabf_file=['' scalarpath '/' group '/' simul '/hist_std/computed_smb_AIS_' group '_' simul '_hist_std.nc'];
    							time_model=[ncread(exptendacabf_file,'time');time_model];
    							tendacabf_model=[ncread(exptendacabf_file,'smb'); tendacabf_model];
    							if strcmpi(modelname,'PIK_PISM1'), %Take every other step before 1950 to focus mostly on recent past
    								pos=find(time_model<1950);
    								time_model(1:length(pos)/2)=[];
    								tendacabf_model(pos(1:2:end))=[];
    							end
    						end
    						plot(time_model,tendacabf_model*yearday_model*3600*24/(10^9*1000),'color',colors(number,:)); hold on % from kg/s to Gt/yr
    						results_model{end+1}=[model_list2{imodel} '\_std'] ;
    					elseif strcmpi(expename,'ctrl_proj_open'),
    						if ishist_open,
    							exptendacabf_file=['' scalarpath '/' group '/' simul '/hist_open/computed_smb_AIS_' group '_' simul '_hist_open.nc'];
    							time_model=[ncread(exptendacabf_file,'time');time_model];
    							tendacabf_model=[ncread(exptendacabf_file,'smb');tendacabf_model];
    						end
    						plot(time_model,tendacabf_model*yearday_model*3600*24/(10^9*1000),'color',colors(number,:)); hold on % from kg/s to Gr/yr
    						results_model{end+1}=[model_list2{imodel} '\_open'] ;
    					end
    				end
    
    			end %end of model
    		end %end of isexp
    
    		x = [1900.5 2015 2015 1900.5];
    		y = [2010 2010 3290 3290];
    		text(1950,2050,'historical','VerticalAlignment','middle','HorizontalAlignment','center','color','k','fontweight','b');
    		text(2055,2050,'future','VerticalAlignment','middle','HorizontalAlignment','center','color','k','fontweight','b');
    		patch(x,y,[-1 -1 -1 -1],[0.9 0.9 0.9],'edgecolor',[0.9 0.9 0.9]); hold on
    		xticks([1900 1925 1950 2000 2050 2100])
    		xticklabels({'1850','1900','1950','2000','2050','2100'})
    		xlim([1900 2100])
    		ylim([2000 3300])
    		xlabel('Time (yr)');
    		ylabel('SMB (Gt/yr)');
    		set(gcf,'Position',[400 400 900 450]);
    		text(1880,1900,'a','VerticalAlignment','middle','HorizontalAlignment','right','fontsize',18,'fontweight','b');
    		hPlots = flip(findall(gcf,'Type','Line'));
    		plot([1950 1950],[2010 3290],'--k');
    		legend_str =results_model;
    		legend(results_model,'location','EastOutside'); 
    		legend boxoff
    		h = gcf;
    		set(h,'Units','Inches');
    		pos = get(h,'Position');
    		set(h,'PaperPositionMode','Auto','PaperUnits','Inches','PaperSize',[pos(3), pos(4)]);
    		print(gcf, '-dpng', '-painters', 'FiguresPaperFinal/Figure1a.png');
    	end
    
    end %}}}
    if step==2 % {{{Figure 1b
    
    	figure(1); set(gcf,'color','w'); set(gcf,'Position',[400 400 900 450]);
    	colors = distinguishable_colors(length(model_list)*2);
    	experiments_list={'ctrl_proj_std','ctrl_proj_open'};
    
    	number=0;
    	results_model={};
    	%Ctr + hist special case
    	if 1,
    		for imodel=1:length(model_list),
    			modelname=model_list{imodel};
    
    			for iexp=1:length(experiments_list),
    				expename=experiments_list{iexp};
    				[group,simul,resolution,ice_density,ocean_density,initial_model_year,expe_model_year,yearday_model,ishist_std,hist_std_name,hist_std_regrid,ishist_open,hist_open_name,hist_open_regrid,isctrl_proj_std,ctrl_proj_std_name,ctrl_proj_std_regrid,isctrl_proj_open,ctrl_proj_open_name,ctrl_proj_open_regrid,isexp01,exp01_name,exp01_regrid,isexp02,exp02_name,exp02_regrid,isexp03,exp03_name,exp03_regrid,isexp04,exp04_name,exp04_regrid,isexp05,exp05_name,exp05_regrid,isexp06,exp06_name,exp06_regrid,isexp07,exp07_name,exp07_regrid,isexp08,exp08_name,exp08_regrid,isexp09,exp09_name,exp09_regrid,isexp10,exp10_name,exp10_regrid,isexp11,exp11_name,exp11_regrid,isexp12,exp12_name,exp12_regrid,isexp13,exp13_name,exp13_regrid,isexpA1,expA1_name,expA1_regrid,isexpA2,expA2_name,expA2_regrid,isexpA3,expA3_name,expA3_regrid,isexpA4,expA4_name,expA4_regrid,isexpA5,expA5_name,expA5_regrid,isexpA6,expA6_name,expA6_regrid,isexpA7,expA7_name,expA7_regrid,isexpA8,expA8_name,expA8_regrid] = specifics(modelname)
    				
    				eval(['isexp=is' expename ';'])
    				if isexp,
    					number=number+1;
    					exptendlibmassbffl_file=['' scalarpath '/' group '/' simul '/' expename '/computed_bmbfl_AIS_' group '_' simul '_' expename '.nc'];
    					time_model=ncread(exptendlibmassbffl_file,'time');
    					tendlibmassbffl_model=ncread(exptendlibmassbffl_file,'bmbfl');
    					if strcmpi(expename,'ctrl_proj_std') 
    						if ishist_std,
    							exptendlibmassbffl_file=['' scalarpath '/' group '/' simul '/hist_std/computed_bmbfl_AIS_' group '_' simul '_hist_std.nc'];
    							time_model=[ncread(exptendlibmassbffl_file,'time');time_model];
    							tendlibmassbffl_model=[ncread(exptendlibmassbffl_file,'bmbfl'); tendlibmassbffl_model];
    							if strcmpi(modelname,'PIK_PISM1'), %Take every other step before 1950 to focus mostly on recent past
    								pos=find(time_model<1950);
    								time_model(1:length(pos)/2)=[];
    								tendlibmassbffl_model(pos(1:2:end))=[];
    							end
    						end
    						plot(time_model,-tendlibmassbffl_model*yearday_model*3600*24/(10^9*1000),'color',colors(number,:)); hold on
    						results_model{end+1}=[model_list2{imodel} '\_std'] ;
    					elseif strcmpi(expename,'ctrl_proj_open'),
    						if ishist_open,
    							exptendlibmassbffl_file=['' scalarpath '/' group '/' simul '/hist_open/computed_bmbfl_AIS_' group '_' simul '_hist_open.nc'];
    							time_model=[ncread(exptendlibmassbffl_file,'time');time_model];
    							tendlibmassbffl_model=[ncread(exptendlibmassbffl_file,'bmbfl');tendlibmassbffl_model];
    						end
    						plot(time_model,-tendlibmassbffl_model*yearday_model*3600*24/(10^9*1000),'color',colors(number,:)); hold on
    						results_model{end+1}=[model_list2{imodel} '\_open'] ;
    					end
    				end
    
    			end %end of model
    		end %end of isexp
    		x = [1900.5 2015 2015 1900.5];
    		y = [4480 4480 10 10];
    		text(1950,100,'historical','VerticalAlignment','middle','HorizontalAlignment','center','color','k','fontweight','b');
    		text(2055,100,'future','VerticalAlignment','middle','HorizontalAlignment','center','color','k','fontweight','b');
    		xticks([1900 1925 1950 2000 2050 2100])
    		xticklabels({'1850','1900','1950','2000','2050','2100'})
    		patch(x,y,[-1 -1 -1 -1],[0.9 0.9 0.9],'edgecolor',[0.9 0.9 0.9]); hold on
    		xlim([1900 2100])
    		ylim([-10 4500])
    		xlabel('Time (yr)');
    		ylabel('Basal Melt (Gt/yr)');
    		set(gcf,'Position',[400 400 900 450]);
    		plot([1950 1950],[0 2290],'--k');
    		text(1880,-350,'b','VerticalAlignment','middle','HorizontalAlignment','right','fontsize',18,'fontweight','b');
    		hPlots = flip(findall(gcf,'Type','Line'));
    		plot([1950 1950],[0 4500],'--k');
    		legend_str =results_model;
    		legend(results_model,'location','EastOutside'); 
    		legend boxoff
    		h = gcf;
    		set(h,'Units','Inches');
    		pos = get(h,'Position');
    		set(h,'PaperPositionMode','Auto','PaperUnits','Inches','PaperSize',[pos(3), pos(4)]);
    		print(gcf, '-dpng', '-painters', 'FiguresPaperFinal/Figure1b.png');
    	end
    
    end %}}}
    if step==3 % {{{Figure 1c
    
    	figure(1); set(gcf,'color','w'); set(gcf,'Position',[400 400 900 450]);
    	colors = distinguishable_colors(length(model_list)*2);
    	experiments_list={'ctrl_proj_std','ctrl_proj_open'};
    
    	number=0;
    	results_model={};
    	%Ctr + hist special case
    	if 1,
    		for imodel=1:length(model_list),
    			modelname=model_list{imodel};
    
    			for iexp=1:length(experiments_list),
    				expename=experiments_list{iexp};
    				[group,simul,resolution,ice_density,ocean_density,initial_model_year,expe_model_year,yearday_model,ishist_std,hist_std_name,hist_std_regrid,ishist_open,hist_open_name,hist_open_regrid,isctrl_proj_std,ctrl_proj_std_name,ctrl_proj_std_regrid,isctrl_proj_open,ctrl_proj_open_name,ctrl_proj_open_regrid,isexp01,exp01_name,exp01_regrid,isexp02,exp02_name,exp02_regrid,isexp03,exp03_name,exp03_regrid,isexp04,exp04_name,exp04_regrid,isexp05,exp05_name,exp05_regrid,isexp06,exp06_name,exp06_regrid,isexp07,exp07_name,exp07_regrid,isexp08,exp08_name,exp08_regrid,isexp09,exp09_name,exp09_regrid,isexp10,exp10_name,exp10_regrid,isexp11,exp11_name,exp11_regrid,isexp12,exp12_name,exp12_regrid,isexp13,exp13_name,exp13_regrid,isexpA1,expA1_name,expA1_regrid,isexpA2,expA2_name,expA2_regrid,isexpA3,expA3_name,expA3_regrid,isexpA4,expA4_name,expA4_regrid,isexpA5,expA5_name,expA5_regrid,isexpA6,expA6_name,expA6_regrid,isexpA7,expA7_name,expA7_regrid,isexpA8,expA8_name,expA8_regrid] = specifics(modelname)
    				
    				eval(['isexp=is' expename ';'])
    				if isexp,
    					number=number+1;
    					explimnsw_file=['' scalarpath '/' group '/' simul '/' expename '/computed_ivaf_AIS_' group '_' simul '_' expename '.nc'];
    					time_model=ncread(explimnsw_file,'time');
    					limnsw_model=ncread(explimnsw_file,'ivaf');
    					if strcmpi(expename,'ctrl_proj_std') 
    						if ishist_std,
    							explimnsw_file=['' scalarpath '/' group '/' simul '/hist_std/computed_ivaf_AIS_' group '_' simul '_hist_std.nc'];
    							time_model=[ncread(explimnsw_file,'time');time_model];
    							limnsw_model=[ncread(explimnsw_file,'ivaf'); limnsw_model];
    							if strcmpi(modelname,'PIK_PISM1'), %Take every other step before 1950 to focus mostly on recent past
    								pos=find(time_model<1950);
    								time_model(1:length(pos)/2)=[];
    								limnsw_model(pos(1:2:end))=[];
    							end
    						end
    						plot(time_model,limnsw_model*ice_density/(10^9*1000),'color',colors(number,:)); hold on %from m^3 to Gt
    						results_model{end+1}=[model_list2{imodel} '\_std'] ;
    					elseif strcmpi(expename,'ctrl_proj_open'),
    						if ishist_open,
    							explimnsw_file=['' scalarpath '/' group '/' simul '/hist_open/computed_ivaf_AIS_' group '_' simul '_hist_open.nc'];
    							time_model=[ncread(explimnsw_file,'time');time_model];
    							limnsw_model=[ncread(explimnsw_file,'ivaf');limnsw_model];
    						end
    						plot(time_model,limnsw_model*ice_density/(10^9*1000),'color',colors(number,:)); hold on %from m^3 to Gt
    						results_model{end+1}=[model_list2{imodel} '\_open'] ;
    					end
    				end
    
    			end %end of model
    		end %end of isexp
    		x = [1900.5 2015 2015 1900.5];
    		y = [1.981*10^7 1.981*10^7 2.159*10^7 2.159*10^7];
    		text(1950,1.985*10^7,'historical','VerticalAlignment','middle','HorizontalAlignment','center','color','k','fontweight','b');
    		text(2055,1.985*10^7,'future','VerticalAlignment','middle','HorizontalAlignment','center','color','k','fontweight','b');
    		patch(x,y,[-1 -1 -1 -1],[0.9 0.9 0.9],'edgecolor',[0.9 0.9 0.9]); hold on
    		h2=plot([1950 1950],[1.981*10^7 2.159*10^7],'--k');
    		xticks([1900 1925 1950 2000 2050 2100])
    		xticklabels({'1850','1900','1950','2000','2050','2100'})
    		xlim([1900 2100])
    		ylim([1.98 2.16]*10^7)
    		xlabel('Time (yr)');
    		ylabel('Ice Volume Above Floatation (Gt)');
    		set(gcf,'Position',[400 400 900 450]);
    		text(1880,1.97*10^7,'c','VerticalAlignment','middle','HorizontalAlignment','right','fontsize',18,'fontweight','b');
    		hPlots = flip(findall(gcf,'Type','Line'));
    		legend_str =results_model;
    		legend(results_model,'location','EastOutside'); 
    		legend boxoff
    		h = gcf;
    		set(h,'Units','Inches');
    		pos = get(h,'Position');
    		set(h,'PaperPositionMode','Auto','PaperUnits','Inches','PaperSize',[pos(3), pos(4)]);
    		print(gcf, '-dpng', '-painters', 'FiguresPaperFinal/Figure1c.png');
    	end
    
    end %}}}
    
    %Figure 2: ice and ice shelf extent
    if step==4 % {{{Figure 2a
    
    	experiments_list={'ctrl_proj_std','ctrl_proj_open'};
    
    	numcases=0;
    	ice_extent=zeros(761,761);
    
    	for imodel=1:length(model_list),
    		modelname=model_list{imodel};
    		
    		for iexp=1:length(experiments_list),
    			expename=experiments_list{iexp};
    			exp_params = specifics(modelname)
    			if strcmpi(expename,'ctrl_proj_std') 
    				ctrl_directory=['' gridpath '/' group '/' simul '/' ctrl_proj_std_regrid];
    			elseif strcmpi(expename,'ctrl_proj_open') 
    				ctrl_directory=['' gridpath '/' group '/' simul '/' ctrl_proj_open_regrid];
    			end
    
    			eval(['isexp=is' expename ';'])
    			if isexp,
    				if is_sftgif==1,
    					field='sftgif';
    					if strcmpi(expename,'ctrl_proj_std') 
    						ctrl_file=[ctrl_directory '/' field '_AIS_' group '_' simul '_ctrl_proj_std.nc'];
    					elseif strcmpi(expename,'ctrl_proj_open') 
    						ctrl_file=[ctrl_directory '/' field '_AIS_' group '_' simul '_ctrl_proj_open.nc'];
    					end
    					data = rot90(double(ncread(ctrl_file,field)));
    					data_init=data(:,:,1);
    					[data_nan]=find(isnan(data_init)); %Make sure there is no NaN data
    					data_init(data_nan)=0;
    					ice_extent=ice_extent+data_init;
    					numcases=numcases+1;
    				end
    			end
    		end
    	end
    	
    	set(gcf,'color','w'); set(gcf,'Position',[400 400 700 500]);
    	[pos_nani pos_nanj]=find(ice_extent==0);
    	data_min=0; data_max=numcases;
    	colorm   =flipud( parula(numcases));
    	image_rgb = ind2rgb(uint16((max(data_min,min(data_max,ice_extent)) - data_min)*(size(colorm,1)/(data_max-data_min))),colorm);
    	image_rgb(sub2ind(size(image_rgb),repmat(pos_nani,1,3),repmat(pos_nanj,1,3),repmat(1:3,size(pos_nani,1),1))) = repmat([1 1 1],size(pos_nani,1),1);
    	imagesc(-3040:6080/size(ice_extent,2):3040,-3040:6080/size(ice_extent,1):3040,image_rgb); colorbar('off');
    	set(gca,'fontsize',14)
    	axis('equal','off'); xlim([-3040 3040]); ylim([-3040 3040]);
    	caxis([data_min data_max]); colorbar
    	text(-2400,2400,'a','VerticalAlignment','middle','HorizontalAlignment','right','fontsize',18,'fontweight','b');
    	x0=-1.70*10^3; y0=1.80*10^3;
    	lengthscale=5*10^2; widthscale=2*10^1;
    	patch([x0 x0+lengthscale x0+lengthscale x0],[y0 y0 y0+widthscale y0+widthscale],2*ones(1,4),'k','Edgecolor','k');
    	text(x0,y0-10*widthscale,'500 km','fontsize',12)
    	h = gcf;
    	set(h,'Units','Inches');
    	pos = get(h,'Position');
    	set(h,'PaperPositionMode','Auto','PaperUnits','Inches','PaperSize',[pos(3), pos(4)]);
    	print(gcf, '-dpng', '-painters', 'FiguresPaperFinal/Figure2a.png');
    
    end %}}}
    if step==5 % {{{Figure 2b
    
    	experiments_list={'ctrl_proj_std','ctrl_proj_open'};
    
    	ice_extent=zeros(761,761);
    	numcases=0;
    
    	for imodel=1:length(model_list),
    		modelname=model_list{imodel};
    		
    		for iexp=1:length(experiments_list),
    			expename=experiments_list{iexp};
    			exp_params = specifics(modelname)
    			if strcmpi(expename,'ctrl_proj_std') 
    				ctrl_directory=['' gridpath '/' group '/' simul '/' ctrl_proj_std_regrid '/'];
    			elseif strcmpi(expename,'ctrl_proj_open') 
    				ctrl_directory=['' gridpath '/' group '/' simul '/' ctrl_proj_open_regrid '/'];
    			end
    
    			eval(['isexp=is' expename ';'])
    			if isexp,
    				if is_sftflf==1,
    					field='sftflf';
    					if strcmpi(expename,'ctrl_proj_std') 
    						ctrl_file=[ctrl_directory '/' field '_AIS_' group '_' simul '_ctrl_proj_std.nc'];
    						if strcmpi(modelname,'UCIJPL_ISSM'),
    							mask_file=[ctrl_directory '/sftgif_AIS_' group '_' simul '_ctrl_proj_std.nc'];
    						end
    					elseif strcmpi(expename,'ctrl_proj_open') 
    						ctrl_file=[ctrl_directory '/' field '_AIS_' group '_' simul '_ctrl_proj_open.nc'];
    						if strcmpi(modelname,'UCIJPL_ISSM'),
    							mask_file=[ctrl_directory '/sftgif_AIS_' group '_' simul '_ctrl_proj_open.nc'];
    						end
    					end
    					data = rot90(double(ncread(ctrl_file,field)));
    					data_init=data(:,:,1);
    					if strcmpi(modelname,'UCIJPL_ISSM'),
    						mask = rot90(double(ncread(mask_file,'sftgif')));
    						mask_init=mask(:,:,1);
    						data_init=data_init.*mask_init;
    					end
    					[data_nan]=find(isnan(data_init));
    					data_init(data_nan)=0;
    					ice_extent=ice_extent+data_init;
    					numcases=numcases+1;
    				end
    			end
    		end
    	end
    	
    	set(gcf,'color','w'); set(gcf,'Position',[400 400 700 500]);
    	[pos_nani pos_nanj]=find(ice_extent==0 | isnan(ice_extent));
    	data_min=0; data_max=numcases;
    	colorm   =flipud( parula(numcases));
    	image_rgb = ind2rgb(uint16((max(data_min,min(data_max,ice_extent)) - data_min)*(size(colorm,1)/(data_max-data_min))),colorm);
    	image_rgb(sub2ind(size(image_rgb),repmat(pos_nani,1,3),repmat(pos_nanj,1,3),repmat(1:3,size(pos_nani,1),1))) = repmat([1 1 1],size(pos_nani,1),1);
    	imagesc(-3040:6080/size(ice_extent,2):3040,-3040:6080/size(ice_extent,1):3040,image_rgb); colorbar('off');
    	set(gca,'fontsize',14)
    	axis('equal','off'); xlim([-3040 3040]); ylim([-3040 3040]);
    	caxis([data_min data_max]); colorbar
    	text(-2400,2400,'b','VerticalAlignment','middle','HorizontalAlignment','right','fontsize',18,'fontweight','b');
    	x0=-1.70*10^3; y0=1.80*10^3;
    	lengthscale=5*10^2; widthscale=2*10^1;
    	patch([x0 x0+lengthscale x0+lengthscale x0],[y0 y0 y0+widthscale y0+widthscale],2*ones(1,4),'k','Edgecolor','k');
    	text(x0,y0-10*widthscale,'500 km','fontsize',12)
    	h = gcf;
    	set(h,'Units','Inches');
    	pos = get(h,'Position');
    	set(h,'PaperPositionMode','Auto','PaperUnits','Inches','PaperSize',[pos(3), pos(4)]);
    	print(gcf, '-dpng', '-painters', 'FiguresPaperFinal/Figure2b.png');
    
    end %}}}
    
    %Figure 3: errors in vel and thickness 
    if step==6 % {{{Figure 3a
    
    	experiments_list={'ctrl_proj_std','ctrl_proj_open'};
    	rms_thickness=[];
    	thickness_grid=[];
    	error('Need to create thickness grid observations on the 8 km standard ISMIP6-Antarctic grid, for example using BedMarchineAntarctica (https://nsidc.org/data/nsidc-0756) and the associated Matlab toolbox (https://www.mathworks.com/matlabcentral/fileexchange/69159-bedmachine) ');
    	if size(thickness_grid,1)~=761 | size(thickness_grid,1)~=761, error('size of the thickness 8 km grid should be 761*761'); end
    	number=0;
    	results_model={};
    
    	for imodel=1:length(model_list),
    		thickness_mod=[];
    		thickness_obs=[];
    		modelname=model_list{imodel};
    		
    		for iexp=1:length(experiments_list),
    			expename=experiments_list{iexp};
    			exp_params = specifics(modelname)
    
    			eval(['isexp=is' expename ';'])
    			if isexp,
    				number=number+1;
    				if strcmpi(expename,'ctrl_proj_std') 
    					ctrl_directory=['' gridpath '/' group '/' simul '/' ctrl_proj_std_regrid '/'];
    				elseif strcmpi(expename,'ctrl_proj_open') 
    					ctrl_directory=['' gridpath '/' group '/' simul '/' ctrl_proj_open_regrid '/'];
    				end
    
    				field='lithk';
    				if strcmpi(expename,'ctrl_proj_std') 
    					ctrl_file=[ctrl_directory '/' field '_AIS_' group '_' simul '_ctrl_proj_std.nc'];
    					results_model{end+1}=[model_list2{imodel} '\_std'] ;
    				elseif strcmpi(expename,'ctrl_proj_open') 
    					ctrl_file=[ctrl_directory '/' field '_AIS_' group '_' simul '_ctrl_proj_open.nc'];
    					results_model{end+1}=[model_list2{imodel} '\_open'] ;
    				end
    				data = rot90(double(ncread(ctrl_file,field)));
    				data_init=data(:,:,1);
    				pos=find(data_init~=0 & ~isnan(data_init) & ~isnan(thickness_grid));
    				thickness_mod=data_init(pos);
    				thickness_obs=thickness_grid(pos);
    				rms_thickness(number)=rms(thickness_obs-thickness_mod);
    			end
    		end
    	end
    
    	close all
    	figure(1); set(gcf,'color','w'); set(gcf,'Position',[400 400 470 800]); hold on;
    	ylim([0 number+1]);
    	xlim([0 400]);
    	for i=0:100:500,
    		plot([i i],[0 number+1],':k')
    	end
    	b=barh(rms_thickness);  set(gca, 'XAxisLocation', 'top'); xlabel('RMSE Thickness (m)'); box('on');
    	set(gca, 'YTickLabel', ''); set(gca,'Ydir','Reverse')
    	colors = distinguishable_colors(number);
    	for imodel=1:number,
    		bi=barh(imodel, rms_thickness(imodel),'facecolor',colors(imodel,:));
    		text(-8,imodel,results_model{imodel},'VerticalAlignment','middle','HorizontalAlignment','right','color',colors(imodel,:),'fontweight','b');
    	 end
       set(gca,'position',[0.42 0.1 0.52 0.8])
    	ylim([0 number+1]);
    	text(-250,-1,'a','VerticalAlignment','middle','HorizontalAlignment','right','fontsize',18,'fontweight','b');
    	axis on
    
    	h = gcf;
    	set(h,'Units','Inches');
    	pos = get(h,'Position');
    	set(h,'PaperPositionMode','Auto','PaperUnits','Inches','PaperSize',[pos(3), pos(4)]);
    	print(gcf, '-dpng', '-painters', 'FiguresPaperFinal/Figure3a.png');
    	
    end %}}}
    if step==7 % {{{Figure 3b
    
    	experiments_list={'ctrl_proj_std','ctrl_proj_open'};
    	rms_velocity=[];
    	velocity_grid=[];
    	error('Need to create velocity grid observations on the 8 km standard ISMIP6-Antarctic grid, for example using MEaSUREs Antarctic velocities https://nsidc.org/data/nsidc-0484');
    	if size(velocity_grid,1)~=761 | size(velocity_grid,1)~=761, error('size of the velocity 8 km grid should be 761*761'); end
    	velocity_grid=flipud(velocity_grid);
    	number=0;
    	results_model={};
    
    	for imodel=1:length(model_list),
    		velocity_mod=[];
    		velocity_obs=[];
    		modelname=model_list{imodel};
    
    		for iexp=1:length(experiments_list),
    			expename=experiments_list{iexp};
    			exp_params = specifics(modelname)
    
    			eval(['isexp=is' expename ';'])
    			if isexp,
    				number=number+1;
    				if strcmpi(expename,'ctrl_proj_std') 
    					ctrl_directory=['' gridpath '/' group '/' simul '/' ctrl_proj_std_regrid '/'];
    				elseif strcmpi(expename,'ctrl_proj_open') 
    					ctrl_directory=['' gridpath '/' group '/' simul '/' ctrl_proj_open_regrid '/'];
    				end
    
    				if is_xvelsurf==1,
    					field='xvelsurf'; field2='yvelsurf';
    				elseif is_xvelmean==1, 
    					field='xvelmean'; field2='yvelmean';
    				else error('should have some velocity fields');
    				end
    				if strcmpi(expename,'ctrl_proj_std') 
    					ctrl_file=[ctrl_directory '/' field '_AIS_' group '_' simul '_ctrl_proj_std.nc'];
    					ctrl_file2=[ctrl_directory '/' field2 '_AIS_' group '_' simul '_ctrl_proj_std.nc'];
    					results_model{end+1}=[model_list2{imodel} '\_std'] ;
    				elseif strcmpi(expename,'ctrl_proj_open') 
    					ctrl_file=[ctrl_directory '/' field '_AIS_' group '_' simul '_ctrl_proj_open.nc'];
    					ctrl_file2=[ctrl_directory '/' field2 '_AIS_' group '_' simul '_ctrl_proj_open.nc'];
    					results_model{end+1}=[model_list2{imodel} '\_open'] ;
    				end
    				datau = rot90(double(ncread(ctrl_file,field)));
    				datav = rot90(double(ncread(ctrl_file2,field2)));
    				data=sqrt(datau.^2+datav.^2)*31556926;
    				if size(data)~=[761,761,21];
    					error(['warming: file ' ctrl_file ' has the wrong size']);
    				end
    				data_init=data(:,:,1);
    				pos=find(data_init~=0 & ~isnan(data_init) & ~isnan(velocity_grid));
    				velocity_mod=data_init(pos);
    				velocity_obs=velocity_grid(pos);
    				rms_velocity(number)=rms(velocity_obs-velocity_mod);
    				rms_velocity_log(number)=rms(log(velocity_obs)-log(velocity_mod));
    			end
    
    		end
    	end
    
    	figure(1); set(gcf,'color','w'); set(gcf,'Position',[400 400 450 800]); hold on;
    	for i=0:100:500,
    		plot([i i],[0 number+1],':k')
    	end
    	b=barh(rms_velocity);  set(gca, 'XAxisLocation', 'top'); xlabel('RMSE Velocity (m/yr)'); box('on'); xlim([0 400]);
    	set(gca, 'YTickLabel', ''); set(gca,'Ydir','Reverse')
    	colors = distinguishable_colors(number+10);
    	for imodel=1:number,
    		bi=barh(imodel, rms_velocity(imodel),'facecolor',colors(imodel,:));
    		text(-10,imodel,results_model{imodel},'VerticalAlignment','middle','HorizontalAlignment','right','color',colors(imodel,:),'fontweight','b');
    	end
    	set(gca,'position',[0.43 0.1 0.52 0.8])
    	ylim([0 number+1]);
    	xlim([0 500]);
    	text(-335,-1,'b','VerticalAlignment','middle','HorizontalAlignment','right','fontsize',18,'fontweight','b');
    
    	h = gcf;
    	set(h,'Units','Inches');
    	pos = get(h,'Position');
    	set(h,'PaperPositionMode','Auto','PaperUnits','Inches','PaperSize',[pos(3), pos(4)]);
    	print(gcf, '-dpng', '-painters', 'FiguresPaperFinal/Figure3b.png');
    
    end %}}}
    
    %Figures 4: NorESM open and standard
    if step==8 % {{{Figure 4
    
    	figure(1); set(gcf,'color','w'); set(gcf,'Position',[400 500 800 450]);
    	colors = distinguishable_colors(length(model_list)+10);
    	experiments_list={'exp05','exp01'}; %open and standard NorESM
    
    	number=0;
    	results_model={};
    
    	if 1,
    		for imodel=1:length(model_list),
    			modelname=model_list{imodel};
    			for iexp=1:length(experiments_list),
    				expename=experiments_list{iexp};
    				[group,simul,resolution,ice_density,ocean_density,initial_model_year,expe_model_year,yearday_model,ishist_std,hist_std_name,hist_std_regrid,ishist_open,hist_open_name,hist_open_regrid,isctrl_proj_std,ctrl_proj_std_name,ctrl_proj_std_regrid,isctrl_proj_open,ctrl_proj_open_name,ctrl_proj_open_regrid,isexp01,exp01_name,exp01_regrid,isexp02,exp02_name,exp02_regrid,isexp03,exp03_name,exp03_regrid,isexp04,exp04_name,exp04_regrid,isexp05,exp05_name,exp05_regrid,isexp06,exp06_name,exp06_regrid,isexp07,exp07_name,exp07_regrid,isexp08,exp08_name,exp08_regrid,isexp09,exp09_name,exp09_regrid,isexp10,exp10_name,exp10_regrid,isexp11,exp11_name,exp11_regrid,isexp12,exp12_name,exp12_regrid,isexp13,exp13_name,exp13_regrid,isexpA1,expA1_name,expA1_regrid,isexpA2,expA2_name,expA2_regrid,isexpA3,expA3_name,expA3_regrid,isexpA4,expA4_name,expA4_regrid,isexpA5,expA5_name,expA5_regrid,isexpA6,expA6_name,expA6_regrid,isexpA7,expA7_name,expA7_regrid,isexpA8,expA8_name,expA8_regrid] = specifics(modelname)
    				
    				eval(['isexp=is' expename ';'])
    				if isexp,
    					number=number+1;
    					explimnsw_file=['' scalarpath '/' group '/' simul '/' expename '/computed_ivaf_minus_ctrl_proj_AIS_' group '_' simul '_' expename '.nc'];
    					time_model=ncread(explimnsw_file,'time');
    					limnsw_model=ncread(explimnsw_file,'ivaf');
    					if strcmpi(expename,'exp05'),
    						results_model{end+1}=[model_list2{imodel} '\_std'] ;
    					elseif strcmpi(expename,'exp01'),
    						results_model{end+1}=[model_list2{imodel} '\_open'] ;
    					end
    					plot([2015;time_model],[0;-limnsw_model/362.5*ice_density/(10^9*1000)],'color',colors(number,:)); hold on % in mm SLE
    				end
    
    			end %end of model
    		end %end of isexp
    		legend(results_model,'location','EastOutside'); 
    		legend boxoff
    		xlim([2015 2100])
    		ylim([-50 200])
    		xlabel('Time (yr)');
    		ylabel('Sea Level Contribution (mm SLE)');
    		set(gcf,'Position',[400 500 800 450]);
    		h = gcf;
    		set(h,'Units','Inches');
    		pos = get(h,'Position');
    		set(h,'PaperPositionMode','Auto','PaperUnits','Inches','PaperSize',[pos(3), pos(4)]);
    		print(gcf, '-dpng', '-painters', 'FiguresPaperFinal/Figure4.png');
    	end
    
    end %}}}
    
    %Figure 5: NorESM by region
    if step==9 % {{{Figure 5
    
    	colors = distinguishable_colors(length(model_list)*2);
    	experiments_list={'exp05','exp01'}; %open and standard NorESM
    
    	results_west=[]; results_east=[]; results_penin=[]; 
    	resultstendacabfgr_west=[]; resultstendacabfgr_east=[]; resultstendacabfgr_penin=[]; 
    	results_model={}; results_meltparam={};
    
    	if 1,
    		for imodel=1:length(model_list),
    			modelname=model_list{imodel};
    			for iexp=1:length(experiments_list),
    				expename=experiments_list{iexp};
    				[group,simul,resolution,ice_density,ocean_density,initial_model_year,expe_model_year,yearday_model,ishist_std,hist_std_name,hist_std_regrid,ishist_open,hist_open_name,hist_open_regrid,isctrl_proj_std,ctrl_proj_std_name,ctrl_proj_std_regrid,isctrl_proj_open,ctrl_proj_open_name,ctrl_proj_open_regrid,isexp01,exp01_name,exp01_regrid,isexp02,exp02_name,exp02_regrid,isexp03,exp03_name,exp03_regrid,isexp04,exp04_name,exp04_regrid,isexp05,exp05_name,exp05_regrid,isexp06,exp06_name,exp06_regrid,isexp07,exp07_name,exp07_regrid,isexp08,exp08_name,exp08_regrid,isexp09,exp09_name,exp09_regrid,isexp10,exp10_name,exp10_regrid,isexp11,exp11_name,exp11_regrid,isexp12,exp12_name,exp12_regrid,isexp13,exp13_name,exp13_regrid,isexpA1,expA1_name,expA1_regrid,isexpA2,expA2_name,expA2_regrid,isexpA3,expA3_name,expA3_regrid,isexpA4,expA4_name,expA4_regrid,isexpA5,expA5_name,expA5_regrid,isexpA6,expA6_name,expA6_regrid,isexpA7,expA7_name,expA7_regrid,isexpA8,expA8_name,expA8_regrid] = specifics(modelname)
    				
    				eval(['isexp=is' expename ';'])
    				if isexp,
    					explimnsw_file=['' scalarpath '/' group '/' simul '/' expename '/computed_ivaf_minus_ctrl_proj_AIS_' group '_' simul '_' expename '.nc'];
    					exptendacabfgr_file=['' scalarpath '/' group '/' simul '/' expename '/computed_smbgr_minus_ctrl_proj_AIS_' group '_' simul '_' expename '.nc'];
    					time_model=ncread(explimnsw_file,'time');
    					limnsw_west=ncread(explimnsw_file,'ivaf_region_1');
    					limnsw_east=ncread(explimnsw_file,'ivaf_region_2');
    					limnsw_penin=ncread(explimnsw_file,'ivaf_region_3');
    					tendacabfgr_west=ncread(exptendacabfgr_file,'smbgr_region_1');
    					tendacabfgr_east=ncread(exptendacabfgr_file,'smbgr_region_2');
    					tendacabfgr_penin=ncread(exptendacabfgr_file,'smbgr_region_3');
    					results_west(end+1)=limnsw_west(85);
    					results_east(end+1)=limnsw_east(85);
    					results_penin(end+1)=limnsw_penin(85);
    					resultstendacabfgr_west(end+1)=sum(tendacabfgr_west(1:85));
    					resultstendacabfgr_east(end+1)=sum(tendacabfgr_east(1:85));
    					resultstendacabfgr_penin(end+1)=sum(tendacabfgr_penin(1:85));
    					if strcmpi(expename,'exp05'),
    						results_model{end+1}=[model_list2{imodel} '\_std'] ;
    						results_meltparam{end+1}='standard';
    					elseif strcmpi(expename,'exp01'),
    						results_model{end+1}=[model_list2{imodel} '\_open'] ;
    						results_meltparam{end+1}='open';
    					end
    				end
    			end %end of model
    		end %end of isexp
    
    		results=[results_west;results_east;results_penin];
    		%Plot results
    		figure(1); set(gcf,'color','w'); set(gcf,'Position',[400 500 900 400]);
    		hb=bar(results*(-1/362.5)*ice_density/(10^9*1000),'grouped'); hold on  %in mm SLE
    		for iresults=1:length(results_model),
    			hb(iresults).FaceColor=colors(iresults,:);
    		end
    		set(gca, 'XTickLabel', '');
    		h=text(1,-48,'WAIS','VerticalAlignment','middle','HorizontalAlignment','center','color','k','fontweight','b');
    		h=text(2,-48,'EAIS','VerticalAlignment','middle','HorizontalAlignment','center','color','k','fontweight','b');
    		h=text(3,-48,'Peninsula','VerticalAlignment','middle','HorizontalAlignment','center','color','k','fontweight','b');
    		ylabel('Sea Level Contribution (mm SLE)');
    		xlim([0.5 3.5]);
    		ylim([-40 160]);
    		hold on
    
    		%Add SMB results
    		resultstendacabfgr=[resultstendacabfgr_west,resultstendacabfgr_east,resultstendacabfgr_penin];
    		for ib = 1:numel(hb)
    			%XData property is the tick labels/group centers; XOffset is the offset of each distinct group
    			xData = hb(ib).XData+hb(ib).XOffset;
    			plot(xData(1),resultstendacabfgr_west(ib)*(-1/362.5)*yearday_model*3600*24/(10^9*1000),'d','MarkerFaceColor',colors(ib,:),'MarkerSize',6,'MarkerEdgeColor','k') %from kg/s to mm SLE
    			plot(xData(2),resultstendacabfgr_east(ib)*(-1/362.5)*yearday_model*3600*24/(10^9*1000),'d','MarkerFaceColor',colors(ib,:),'MarkerSize',6,'MarkerEdgeColor','k')
    			plot(xData(3),resultstendacabfgr_penin(ib)*(-1/362.5)*yearday_model*3600*24/(10^9*1000),'d','MarkerFaceColor',colors(ib,:),'MarkerSize',6,'MarkerEdgeColor','k')
    		end
    		legend(results_model,'location','EastOutside')
    
    		h = gcf;
    		set(h,'Units','Inches');
    		pos = get(h,'Position');
    		set(h,'PaperPositionMode','Auto','PaperUnits','Inches','PaperSize',[pos(3), pos(4)]);
    		print(gcf, '-dpng', '-painters', 'FiguresPaperFinal/Figure5.png');
    	end
    
    end %}}}
    
    %Figure 6: DeltaH and DeltaVel NorESM 
    if step==10 % {{{Figure 6a
    
    	nummodels=zeros(761,761);
    	totalthicknesschange=zeros(761,761);
    	thicknessstd=zeros(761,761);
    
    	experiments_list={'exp01','exp05'}; %NorESM RCP8.5
    
    	for iexp=1:length(experiments_list),
    		expename=experiments_list{iexp};
    
    		for imodel=1:length(model_list),
    			modelname=model_list{imodel};
    			exp_params = specifics(modelname)
    			eval(['exp_name=' expename '_regrid;'])
    			exp_directory=['' gridpath '/' group '/' simul '/' exp_name '/'];
    			if strcmp(expename,'exp01'),
    				ctrl_directory=['' gridpath '/' group '/' simul '/' ctrl_proj_open_regrid '/'];
    			elseif strcmp(expename,'exp05'),
    				ctrl_directory=['' gridpath '/' group '/' simul '/' ctrl_proj_std_regrid '/'];
    			end
    
    			eval(['isexp=is' expename ';'])
    			if isexp,
    				if exist(exp_directory,'dir')==0,
    					error(['directory ' exp_directory ' not found']);
    				end
    
    				if is_lithk==1,
    					field='lithk';
    					exp_file=[exp_directory '/' field '_AIS_' group '_' simul '_' expename '.nc'];
    					mask_file=[exp_directory '/sftgif_AIS_' group '_' simul '_' expename '.nc'];
    					if strcmp(expename,'exp01'),
    						ctrl_file=[ctrl_directory '/' field '_AIS_' group '_' simul '_ctrl_proj_open.nc'];
    						maskctrl_file=[ctrl_directory '/sftgif_AIS_' group '_' simul '_ctrl_proj_open.nc'];
    					elseif strcmp(expename,'exp05'),
    						ctrl_file=[ctrl_directory '/' field '_AIS_' group '_' simul '_ctrl_proj_std.nc'];
    						maskctrl_file=[ctrl_directory '/sftgif_AIS_' group '_' simul '_ctrl_proj_std.nc'];
    					end
    
    					data = rot90(double(ncread(exp_file,field)));
    					datac = rot90(double(ncread(ctrl_file,field)));
    					mask = rot90(double(ncread(mask_file,'sftgif')));
    					maskc = rot90(double(ncread(maskctrl_file,'sftgif')));
    					if size(data)~=[761,761,21];
    						error(['warming: file ' exp_file ' has the wrong size']);
    					end
    					data_init=data(:,:,1).*mask(:,:,1);
    					data_end=data(:,:,86).*mask(:,:,86);
    					datac_init=datac(:,:,1).*maskc(:,:,1);
    					datac_end=datac(:,:,86).*maskc(:,:,86);
    					pos=find(data_init~=0 & ~isnan(data_init) & data_end~=0 & ~isnan(data_end) & datac_init~=0 & ~isnan(datac_init) & datac_end~=0 & ~isnan(datac_end));
    					nummodels(pos)=nummodels(pos)+1;
    					totalthicknesschange(pos)=totalthicknesschange(pos)+data_end(pos)-data_init(pos)-(datac_end(pos)-datac_init(pos));
    
    				end
    			end
    		end
    	end
    	mean_thicknesschange=totalthicknesschange./nummodels;
    	pos=find(nummodels<5);
    	mean_thicknesschange(pos)=NaN;
    
    	if 1,
    		set(gcf,'color','w');
    		[pos_nani pos_nanj]=find(isnan(mean_thicknesschange));
    		data_min=-100; data_max=100;
    		colorm = jet(100);
    		%colormap used in the paper can be found here: https://www.mathworks.com/matlabcentral/fileexchange/17555-light-bartlein-color-maps
    		image_rgb = ind2rgb(uint16((max(data_min,min(data_max,mean_thicknesschange)) - data_min)*(size(colorm,1)/(data_max-data_min))),colorm);
    		image_rgb(sub2ind(size(image_rgb),repmat(pos_nani,1,3),repmat(pos_nanj,1,3),repmat(1:3,size(pos_nani,1),1))) = repmat([1 1 1],size(pos_nani,1),1);
    		imagesc(-3040:6080/size(mean_thicknesschange,2):3040,-3040:6080/size(mean_thicknesschange,1):3040,image_rgb);
    		set(gca,'fontsize',14); caxis([data_min data_max]); colormap(jet); hcb=colorbar; title(hcb,'m');
    		axis('equal','off'); xlim([-3040 3040]); ylim([-3040 3040]);
    		text(-2400,2400,'a','VerticalAlignment','middle','HorizontalAlignment','right','fontsize',18,'fontweight','b');
    
    		h = gcf;
    		set(h,'Units','Inches');
    		pos = get(h,'Position');
    		set(h,'PaperPositionMode','Auto','PaperUnits','Inches','PaperSize',[pos(3), pos(4)]);
    		print(gcf, '-dpng', '-painters', 'FiguresPaperFinal/Figure6a.png');
    	end
    
    	for iexp=1:length(experiments_list),
    		expename=experiments_list{iexp};
    
    		for imodel=1:length(model_list),
    			modelname=model_list{imodel};
    			exp_params = specifics(modelname)
    			eval(['exp_name=' expename '_regrid;'])
    			exp_directory=[path '/' exp_name '/'];
    			exp_directory=['' gridpath '/' group '/' simul '/' exp_name '/'];
    			if strcmp(expename,'exp01'),
    				ctrl_directory=['' gridpath '/' group '/' simul '/' ctrl_proj_open_regrid '/'];
    			elseif strcmp(expename,'exp05'),
    				ctrl_directory=['' gridpath '/' group '/' simul '/' ctrl_proj_std_regrid '/'];
    			end
    
    			eval(['isexp=is' expename ';'])
    			if isexp,
    				if exist(exp_directory,'dir')==0,
    					error(['directory ' exp_directory ' not found']);
    				end
    
    				if is_lithk==1,
    					field='lithk';
    					exp_file=[exp_directory '/' field '_AIS_' group '_' simul '_' expename '.nc'];
    					if strcmp(expename,'exp01'),
    						ctrl_file=[ctrl_directory '/' field '_AIS_' group '_' simul '_ctrl_proj_open.nc'];
    					elseif strcmp(expename,'exp05'),
    						ctrl_file=[ctrl_directory '/' field '_AIS_' group '_' simul '_ctrl_proj_std.nc'];
    					end
    
    					data = rot90(double(ncread(exp_file,field)));
    					datac = rot90(double(ncread(ctrl_file,field)));
    					if size(data)~=[761,761,21];
    						error(['warming: file ' exp_file ' has the wrong size']);
    					end
    					data_init=data(:,:,end-85);
    					data_end=data(:,:,end);
    					datac_init=datac(:,:,end-85);
    					datac_end=datac(:,:,end);
    					pos=find(data_init~=0 & ~isnan(data_init) & data_end~=0 & ~isnan(data_end) & datac_init~=0 & ~isnan(datac_init) & datac_end~=0 & ~isnan(datac_end));
    					thicknessstd(pos)=thicknessstd(pos)+((data_end(pos)-data_init(pos))-(datac_end(pos)-datac_init(pos))-mean_thicknesschange(pos)).^2;
    
    				end
    			end
    		end
    	end
    	thicknessstd=sqrt(thicknessstd./(nummodels-1));
    	pos=find(nummodels<5);
    	thicknessstd(pos)=NaN;
    
    	close; set(gcf,'color','w'); set(gcf,'Position',[400 400 700 500]);
    	[pos_nani pos_nanj]=find(isnan(thicknessstd));
    	data_min=0; data_max=200;
    	colorm = flipud(hot(100));
    	image_rgb = ind2rgb(uint16((max(data_min,min(data_max,thicknessstd)) - data_min)*(size(colorm,1)/(data_max-data_min))),colorm);
    	image_rgb(sub2ind(size(image_rgb),repmat(pos_nani,1,3),repmat(pos_nanj,1,3),repmat(1:3,size(pos_nani,1),1))) = repmat([1 1 1],size(pos_nani,1),1);
    	imagesc(-3040:6080/size(thicknessstd,2):3040,-3040:6080/size(thicknessstd,1):3040,image_rgb); 
    	set(gca,'fontsize',14); colormap(flipud(hot));  hcb=colorbar; title(hcb,'m'); 
    	axis('equal','off'); caxis([data_min data_max]); xlim([-3040 3040]); ylim([-3040 3040]);
    	text(-2400,2400,'c','VerticalAlignment','middle','HorizontalAlignment','right','fontsize',18,'fontweight','b');
    
    	h = gcf;
    	set(h,'Units','Inches');
    	pos = get(h,'Position');
    	set(h,'PaperPositionMode','Auto','PaperUnits','Inches','PaperSize',[pos(3), pos(4)]);
    	print(gcf, '-dpng', '-painters', 'FiguresPaperFinal/Figure6c.png');
    	
    end %}}}
    if step==11 % {{{Figure 6b
    
    	experiments_list={'exp01','exp05'}; %NorESM RCP8.5
    
    	nummodels=zeros(761,761);
    	totalvelocitychange=zeros(761,761);
    	velocitystd=zeros(761,761);
    
    	for iexp=1:length(experiments_list),
    		expename=experiments_list{iexp};
    
    		for imodel=1:length(model_list),
    			modelname=model_list{imodel};
    			exp_params = specifics(modelname)
    			eval(['exp_name=' expename '_regrid;'])
    			exp_directory=['' gridpath '/' group '/' simul '/' exp_name '/'];
    			if strcmp(expename,'exp01'),
    				ctrl_directory=['' gridpath '/' group '/' simul '/' ctrl_proj_open_regrid '/'];
    			elseif strcmp(expename,'exp05'),
    				ctrl_directory=['' gridpath '/' group '/' simul '/' ctrl_proj_std_regrid '/'];
    			end
    
    			eval(['isexp=is' expename ';'])
    			if isexp,
    				if exist(exp_directory,'dir')==0,
    					error(['directory ' exp_directory ' not found']);
    				end
    
    				if is_xvelmean==1, 
    					field='xvelmean'; field2='yvelmean';
    				else 
    					error('should have some velocity fields');
    				end
    				exp_file=[exp_directory '/' field '_AIS_' group '_' simul '_' expename '.nc'];
    				exp_file2=[exp_directory '/' field2 '_AIS_' group '_' simul '_' expename '.nc'];
    				if strcmp(expename,'exp01'),
    					ctrl_file=[ctrl_directory '/' field '_AIS_' group '_' simul '_ctrl_proj_open.nc'];
    					ctrl_file2=[ctrl_directory '/' field2 '_AIS_' group '_' simul '_ctrl_proj_open.nc'];
    				elseif strcmp(expename,'exp05'),
    					ctrl_file=[ctrl_directory '/' field '_AIS_' group '_' simul '_ctrl_proj_std.nc'];
    					ctrl_file2=[ctrl_directory '/' field2 '_AIS_' group '_' simul '_ctrl_proj_std.nc'];
    				end
    
    				datau = rot90(double(ncread(exp_file,field)));
    				datav = rot90(double(ncread(exp_file2,field2)));
    				data=sqrt(datau.^2+datav.^2)*31556926; %in m/yr
    				datacu = rot90(double(ncread(ctrl_file,field)));
    				datacv = rot90(double(ncread(ctrl_file2,field2)));
    				datac=sqrt(datacu.^2+datacv.^2)*31556926; % in m/yr
    				if size(data)~=[761,761,21];
    					error(['warming: file ' abmb_file ' has the wrong size']);
    				end
    				data_init=data(:,:,1);
    				data_end=data(:,:,end);
    				datac_init=datac(:,:,1);
    				datac_end=datac(:,:,end);
    				[data_nan]=find(isnan(data_init)); data_init(data_nan)=0;
    				[data_nan]=find(isnan(data_end)); data_end(data_nan)=0;
    				[datac_nan]=find(isnan(datac_init)); datac_init(datac_nan)=0;
    				[datac_nan]=find(isnan(datac_end)); datac_end(datac_nan)=0;
    				pos=find(datac_init~=0 & ~isnan(datac_init) & datac_end~=0 & ~isnan(datac_end) & datac_init~=0 & ~isnan(datac_init) & datac_end~=0 & ~isnan(datac_end)); 
    				nummodels(pos)=nummodels(pos)+1;
    				totalvelocitychange(pos)=totalvelocitychange(pos)+(data_end(pos)-data_init(pos)) - (datac_end(pos)-datac_init(pos));
    
    			end
    		end
    	end
    	mean_velocitychange=totalvelocitychange./nummodels;
    	pos=find(nummodels<5);
    	mean_velocitychange(pos)=NaN;
    
    	if 1,
    		set(gcf,'color','w');
    		[pos_nani pos_nanj]=find(isnan(mean_velocitychange));
    		data_min=-100; data_max=100;
    		%colormap used in the paper can be found here: https://www.mathworks.com/matlabcentral/fileexchange/17555-light-bartlein-color-maps
    		colorm = jet(100);
    		image_rgb = ind2rgb(uint16((max(data_min,min(data_max,mean_velocitychange)) - data_min)*(size(colorm,1)/(data_max-data_min))),colorm);
    		image_rgb(sub2ind(size(image_rgb),repmat(pos_nani,1,3),repmat(pos_nanj,1,3),repmat(1:3,size(pos_nani,1),1))) = repmat([1 1 1],size(pos_nani,1),1);
    		imagesc(-3040:6080/size(mean_velocitychange,2):3040,-3040:6080/size(mean_velocitychange,1):3040,image_rgb);
    		axis('equal','off'); xlim([-3040 3040]); ylim([-3040 3040]);
    		colormap(jet); caxis([data_min data_max]); hcb=colorbar; title(hcb,'m yr^{-1}');
    		text(-2400,2400,'b','VerticalAlignment','middle','HorizontalAlignment','right','fontsize',18,'fontweight','b');
    
    		h = gcf;
    		set(h,'Units','Inches');
    		pos = get(h,'Position');
    		set(h,'PaperPositionMode','Auto','PaperUnits','Inches','PaperSize',[pos(3), pos(4)]);
    		print(gcf, '-dpng', '-painters', 'FiguresPaperFinal/Figure6b.png');
    	end
    
    	for iexp=1:length(experiments_list),
    		expename=experiments_list{iexp};
    
    		for imodel=1:length(model_list),
    			modelname=model_list{imodel};
    			exp_params = specifics(modelname)
    			eval(['exp_name=' expename '_regrid;'])
    			exp_directory=['' gridpath '/' group '/' simul '/' exp_name '/'];
    			if strcmp(expename,'exp01'),
    				ctrl_directory=['' gridpath '/' group '/' simul '/' ctrl_proj_open_regrid '/'];
    			elseif strcmp(expename,'exp05'),
    				ctrl_directory=['' gridpath '/' group '/' simul '/' ctrl_proj_std_regrid '/'];
    			end
    
    			eval(['isexp=is' expename ';'])
    			if isexp,
    				if exist(exp_directory,'dir')==0,
    					error(['directory ' exp_directory ' not found']);
    				end
    
    				if is_xvelmean==1, 
    					field='xvelmean'; field2='yvelmean';
    				else error('should have some velocity fields');
    				end
    				exp_file=[exp_directory '/' field '_AIS_' group '_' simul '_' expename '.nc'];
    				exp_file2=[exp_directory '/' field2 '_AIS_' group '_' simul '_' expename '.nc'];
    				mask_file2=[exp_directory '/sftgif_AIS_' group '_' simul '_' expename '.nc'];
    				if strcmp(expename,'exp01'),
    						ctrl_file=[ctrl_directory '/' field '_AIS_' group '_' simul '_ctrl_proj_open.nc'];
    						ctrl_file2=[ctrl_directory '/' field2 '_AIS_' group '_' simul '_ctrl_proj_open.nc'];
    						maskctrl_file=[ctrl_directory '/sftgif_AIS_' group '_' simul '_ctrl_proj_open.nc'];
    				elseif strcmp(expename,'exp05'),
    					ctrl_file=[ctrl_directory '/' field '_AIS_' group '_' simul '_ctrl_proj_std.nc'];
    					ctrl_file2=[ctrl_directory '/' field2 '_AIS_' group '_' simul '_ctrl_proj_std.nc'];
    						maskctrl_file=[ctrl_directory '/sftgif_AIS_' group '_' simul '_ctrl_proj_std.nc'];
    				end
    
    				datau = rot90(double(ncread(exp_file,field)));
    				datav = rot90(double(ncread(exp_file2,field2)));
    				data=sqrt(datau.^2+datav.^2)*31556926;
    				datacu = rot90(double(ncread(ctrl_file,field)));
    				datacv = rot90(double(ncread(ctrl_file2,field2)));
    				datac=sqrt(datacu.^2+datacv.^2)*31556926;
    				if size(data)~=[761,761,21];
    					error(['warming: file ' abmb_file ' has the wrong size']);
    				end
    				data_init=data(:,:,1); %.*mask(:,:,1);
    				data_end=data(:,:,end); %.*mask(:,:,end);
    				datac_init=datac(:,:,1); %.*maskctrl(:,:,1);
    				datac_end=datac(:,:,end); %.*maskctrl(:,:,end);
    				[data_nan]=find(isnan(data_init)); data_init(data_nan)=0;
    				[data_nan]=find(isnan(data_end)); data_end(data_nan)=0;
    				[datac_nan]=find(isnan(datac_init)); datac_init(datac_nan)=0;
    				[datac_nan]=find(isnan(datac_end)); datac_end(datac_nan)=0;
    				pos=find(datac_init~=0 & ~isnan(datac_init) & datac_end~=0 & ~isnan(datac_end) & datac_init~=0 & ~isnan(datac_init) & datac_end~=0 & ~isnan(datac_end)); 
    				velocitystd(pos)=velocitystd(pos)+(data_end(pos)-data_init(pos) -(datac_end(pos)-datac_init(pos)) -mean_velocitychange(pos)).^2;
    			end
    		end
    	end
    
    	velocitystd=sqrt(velocitystd./(nummodels));
    	pos=find(nummodels<5);
    
    	close; set(gcf,'color','w'); set(gcf,'Position',[400 400 700 500]);
    	[pos_nani pos_nanj]=find(isnan(velocitystd));
    	data_min=0; data_max=200;
    	colorm = flipud(hot(100));
    	image_rgb = ind2rgb(uint16((max(data_min,min(data_max,velocitystd)) - data_min)*(size(colorm,1)/(data_max-data_min))),colorm);
    	image_rgb(sub2ind(size(image_rgb),repmat(pos_nani,1,3),repmat(pos_nanj,1,3),repmat(1:3,size(pos_nani,1),1))) = repmat([1 1 1],size(pos_nani,1),1);
    	imagesc(-3040:6080/size(velocitystd,2):3040,-3040:6080/size(velocitystd,1):3040,image_rgb);
    	axis('equal','off'); xlim([-3040 3040]); ylim([-3040 3040]);
    	colormap(flipud(hot)); caxis([data_min data_max]); hcb=colorbar; title(hcb,'m yr^{-1}');
    	text(-2400,2400,'d','VerticalAlignment','middle','HorizontalAlignment','right','fontsize',18,'fontweight','b');
    
    	h = gcf;
    	set(h,'Units','Inches');
    	pos = get(h,'Position');
    	set(h,'PaperPositionMode','Auto','PaperUnits','Inches','PaperSize',[pos(3), pos(4)]);
    	print(gcf, '-dpng', '-painters', 'FiguresPaperFinal/Figure6d.png');
    end %}}}
    
    %Figure 7: all RCP8.5 evolution 
    if step==12 % {{{Figure 7
    
    	figure(1); set(gcf,'color','w'); set(gcf,'Position',[400 500 800 450]);
    	colors_order = get(gca,'colororder');
    	colors_long_list = [colors_order(1:3,:);colors_order(1:3,:);colors_order(4:6,:);colors_order(4:6,:)];
    	colors = colors_long_list + 0.75*(1-colors_long_list);
    	colors_exp = colors_order(1:6,:);
    
    	experiments_list={'exp01','exp02','exp04','exp05','exp06','exp08','expA1','expA2','expA3','expA5','expA6','expA7'}; %open and standard RCP8.5
    
    	for i=1:6,
    		plot([0 1],[0 1],'color',colors_exp(i,:),'linewidth',1); hold on
    	end
    	mean_vaf=zeros(86,length(experiments_list));
    	min_vaf=9999*ones(86,length(experiments_list));
    	max_vaf=-9999*ones(86,length(experiments_list));
    	num_models=zeros(length(experiments_list),1);
    	if 1,
    
    		for iexp=1:length(experiments_list),
    			expename=experiments_list{iexp};
    
    			for imodel=1:length(model_list),
    				modelname=model_list{imodel};
    				[group,simul,resolution,ice_density,ocean_density,initial_model_year,expe_model_year,yearday_model,ishist_std,hist_std_name,hist_std_regrid,ishist_open,hist_open_name,hist_open_regrid,isctrl_proj_std,ctrl_proj_std_name,ctrl_proj_std_regrid,isctrl_proj_open,ctrl_proj_open_name,ctrl_proj_open_regrid,isexp01,exp01_name,exp01_regrid,isexp02,exp02_name,exp02_regrid,isexp03,exp03_name,exp03_regrid,isexp04,exp04_name,exp04_regrid,isexp05,exp05_name,exp05_regrid,isexp06,exp06_name,exp06_regrid,isexp07,exp07_name,exp07_regrid,isexp08,exp08_name,exp08_regrid,isexp09,exp09_name,exp09_regrid,isexp10,exp10_name,exp10_regrid,isexp11,exp11_name,exp11_regrid,isexp12,exp12_name,exp12_regrid,isexp13,exp13_name,exp13_regrid,isexpA1,expA1_name,expA1_regrid,isexpA2,expA2_name,expA2_regrid,isexpA3,expA3_name,expA3_regrid,isexpA4,expA4_name,expA4_regrid,isexpA5,expA5_name,expA5_regrid,isexpA6,expA6_name,expA6_regrid,isexpA7,expA7_name,expA7_regrid,isexpA8,expA8_name,expA8_regrid] = specifics(modelname)
    				
    				eval(['isexp=is' expename ';'])
    				if isexp,
    					num_models(iexp)=num_models(iexp)+1;
    					explimnsw_file=['' scalarpath '/' group '/' simul '/' expename '/computed_ivaf_minus_ctrl_proj_AIS_' group '_' simul '_' expename '.nc'];
    					time_model=ncread(explimnsw_file,'time');
    					limnsw_model=ncread(explimnsw_file,'ivaf')*ice_density/(10^9*1000); %in Gt
    					mean_vaf(:,iexp)=mean_vaf(:,iexp)+[0;limnsw_model(1:85)];
    					min_vaf(:,iexp)=min(min_vaf(:,iexp),[0;limnsw_model(1:85)]);
    					max_vaf(:,iexp)=max(max_vaf(:,iexp),[0;limnsw_model(1:85)]);
    					limnsw_model=[0;limnsw_model];
    					plot([2015;time_model(1:85)],[0;-limnsw_model(1:85)/362.5],'color',colors(iexp,:),'linewidth',1); hold on %in mm SLE
    				else
    				end
    
    			end %end of model
    		end %end of isexp
    		mean_exp=zeros(86,6);
    		min_exp=zeros(86,6);
    		max_exp=zeros(86,6);
    		exp_models=zeros(6,1);
    		mean_exp(:,1)=mean_vaf(:,1)+mean_vaf(:,4); exp_models(1)=num_models(1)+num_models(4);
    		mean_exp(:,2)=mean_vaf(:,2)+mean_vaf(:,5); exp_models(2)=num_models(2)+num_models(5);
    		mean_exp(:,3)=mean_vaf(:,3)+mean_vaf(:,6); exp_models(3)=num_models(3)+num_models(6);
    		mean_exp(:,4)=mean_vaf(:,7)+mean_vaf(:,10); exp_models(4)=num_models(7)+num_models(10);
    		mean_exp(:,5)=mean_vaf(:,8)+mean_vaf(:,11); exp_models(5)=num_models(8)+num_models(11);
    		mean_exp(:,6)=mean_vaf(:,9)+mean_vaf(:,12); exp_models(6)=num_models(9)+num_models(12);
    		mean_exp=mean_exp./exp_models';
    		for i=1:6,
    			plot([2015;time_model(1:85)],-mean_exp(:,i)/362.5,'color',colors_exp(i,:),'linewidth',2); hold on
    		end
    		ax = gca; ax.Clipping = 'off';
    		x = [2100.5 2100.5 2101 2101];
    		y = [min(min_vaf(85,1),min_vaf(85,4))  max(max_vaf(85,1),max_vaf(85,4)) max(max_vaf(85,1),max_vaf(85,4)) min(min_vaf(85,1),min_vaf(85,4))]/-362.5;
    		patch(x,y,[-1 -1 -1 -1],colors(1,:),'edgecolor',colors(1,:)); hold on
    		y = mean_exp(85,1)/-362.5+[0.4 -0.4 -0.4 0.4];
    		patch(x,y,[-1 -1 -1 -1],colors_exp(1,:),'edgecolor',colors_exp(1,:)); hold on
    		x = [2101.5 2101.5 2102 2102];
    		y = [min(min_vaf(85,2),min_vaf(85,5))  max(max_vaf(85,2),max_vaf(85,5)) max(max_vaf(85,2),max_vaf(85,5)) min(min_vaf(85,2),min_vaf(85,5))]/-362.5;
    		patch(x,y,[-1 -1 -1 -1],colors(2,:),'edgecolor',colors(2,:)); hold on
    		y = mean_exp(85,2)/-362.5+[0.4 -0.4 -0.4 0.4];
    		patch(x,y,[-1 -1 -1 -1],colors_exp(2,:),'edgecolor',colors_exp(2,:)); hold on
    		x = [2102.5 2102.5 2103 2103];
    		y = [min(min_vaf(85,3),min_vaf(85,6))  max(max_vaf(85,3),max_vaf(85,6)) max(max_vaf(85,3),max_vaf(85,6)) min(min_vaf(85,3),min_vaf(85,6))]/-362.5;
    		patch(x,y,[-1 -1 -1 -1],colors(3,:),'edgecolor',colors(3,:)); hold on
    		y = mean_exp(85,3)/-362.5+[0.4 -0.4 -0.4 0.4];
    		patch(x,y,[-1 -1 -1 -1],colors_exp(3,:),'edgecolor',colors_exp(3,:)); hold on
    		x = [2103.5 2103.5 2104 2104];
    		y = [min(min_vaf(85,7),min_vaf(85,10))  max(max_vaf(85,7),max_vaf(85,10)) max(max_vaf(85,7),max_vaf(85,10)) min(min_vaf(85,7),min_vaf(85,10))]/-362.5;
    		patch(x,y,[-1 -1 -1 -1],colors(7,:),'edgecolor',colors(7,:)); hold on
    		y = mean_exp(85,4)/-362.5+[0.4 -0.4 -0.4 0.4];
    		patch(x,y,[-1 -1 -1 -1],colors_exp(4,:),'edgecolor',colors_exp(4,:)); hold on
    		x = [2104.5 2104.5 2105 2105];
    		y = [min(min_vaf(85,8),min_vaf(85,11))  max(max_vaf(85,8),max_vaf(85,11)) max(max_vaf(85,8),max_vaf(85,11)) min(min_vaf(85,8),min_vaf(85,11))]/-362.5;
    		patch(x,y,[-1 -1 -1 -1],colors(8,:),'edgecolor',colors(8,:)); hold on
    		y = mean_exp(85,5)/-362.5+[0.4 -0.4 -0.4 0.4];
    		patch(x,y,[-1 -1 -1 -1],colors_exp(5,:),'edgecolor',colors_exp(5,:)); hold on
    		x = [2105.5 2105.5 2106 2106];
    		y = [min(min_vaf(85,9),min_vaf(85,12))  max(max_vaf(85,9),max_vaf(85,12)) max(max_vaf(85,9),max_vaf(85,12)) min(min_vaf(85,9),min_vaf(85,12))]/-362.5;
    		patch(x,y,[-1 -1 -1 -1],colors(9,:),'edgecolor',colors(9,:)); hold on
    		y = mean_exp(85,6)/-362.5+[0.4 -0.4 -0.4 0.4];
    		patch(x,y,[-1 -1 -1 -1],colors_exp(6,:),'edgecolor',colors_exp(6,:)); hold on
    		legend({'NorESM1','MIROC','CCSM4','HadGEM2','CSIRO','IPSL'},'location','NorthWest')
    		legend boxoff
    		xlim([2015 2100])
    		xlabel('Time (yr)');
    		ylabel('Sea Level Contribution (mm SLE)');
    		set(gcf,'Position',[400 500 800 450]);
    
    		h = gcf;
    		set(h,'Units','Inches');
    		pos = get(h,'Position');
    		set(h,'PaperPositionMode','Auto','PaperUnits','Inches','PaperSize',[pos(3), pos(4)]);
    		pos = get(h,'Position');
    		print(gcf, '-dpng', '-painters', 'FiguresPaperFinal/Figure7.png');
    	end
    
    end %}}}
    
    %Figure 8: all RCP8.5 by region 
    if step==13 % {{{Figure 8
    
    	experiments_list={'exp01','exp02','exp04','exp05','exp06','exp08','expA1','expA2','expA3','expA5','expA6','expA7'}; %open and standard RCP8.5
    
    	results_west_1=[]; results_east_1=[]; results_penin_1=[]; 
    	results_west_2=[]; results_east_2=[]; results_penin_2=[]; 
    	results_west_3=[]; results_east_3=[]; results_penin_3=[]; 
    	results_west_4=[]; results_east_4=[]; results_penin_4=[]; 
    	results_west_5=[]; results_east_5=[]; results_penin_5=[]; 
    	results_west_6=[]; results_east_6=[]; results_penin_6=[]; 
    
    	if 1,
    		for imodel=1:length(model_list),
    			modelname=model_list{imodel};
    			for iexp=1:length(experiments_list),
    				expename=experiments_list{iexp};
    				[group,simul,resolution,ice_density,ocean_density,initial_model_year,expe_model_year,yearday_model,ishist_std,hist_std_name,hist_std_regrid,ishist_open,hist_open_name,hist_open_regrid,isctrl_proj_std,ctrl_proj_std_name,ctrl_proj_std_regrid,isctrl_proj_open,ctrl_proj_open_name,ctrl_proj_open_regrid,isexp01,exp01_name,exp01_regrid,isexp02,exp02_name,exp02_regrid,isexp03,exp03_name,exp03_regrid,isexp04,exp04_name,exp04_regrid,isexp05,exp05_name,exp05_regrid,isexp06,exp06_name,exp06_regrid,isexp07,exp07_name,exp07_regrid,isexp08,exp08_name,exp08_regrid,isexp09,exp09_name,exp09_regrid,isexp10,exp10_name,exp10_regrid,isexp11,exp11_name,exp11_regrid,isexp12,exp12_name,exp12_regrid,isexp13,exp13_name,exp13_regrid,isexpA1,expA1_name,expA1_regrid,isexpA2,expA2_name,expA2_regrid,isexpA3,expA3_name,expA3_regrid,isexpA4,expA4_name,expA4_regrid,isexpA5,expA5_name,expA5_regrid,isexpA6,expA6_name,expA6_regrid,isexpA7,expA7_name,expA7_regrid,isexpA8,expA8_name,expA8_regrid] = specifics(modelname)
    				
    				eval(['isexp=is' expename ';'])
    				if isexp,
    					explimnsw_file=['' scalarpath '/' group '/' simul '/' expename '/computed_ivaf_minus_ctrl_proj_AIS_' group '_' simul '_' expename '.nc'];
    					time_model=ncread(explimnsw_file,'time');
    					limnsw_west=ncread(explimnsw_file,'ivaf_region_1')*ice_density/(10^9*1000); %in Gt
    					limnsw_east=ncread(explimnsw_file,'ivaf_region_2')*ice_density/(10^9*1000);
    					limnsw_penin=ncread(explimnsw_file,'ivaf_region_3')*ice_density/(10^9*1000);
    					if strcmpi(expename,'exp01') |strcmpi(expename,'exp05'),
    						results_west_1(end+1)=limnsw_west(85);
    						results_east_1(end+1)=limnsw_east(85);
    						results_penin_1(end+1)=limnsw_penin(85);
    					elseif strcmpi(expename,'exp02') |strcmpi(expename,'exp06'),
    						results_west_2(end+1)=limnsw_west(85);
    						results_east_2(end+1)=limnsw_east(85);
    						results_penin_2(end+1)=limnsw_penin(85);
    					elseif strcmpi(expename,'exp04') |strcmpi(expename,'exp08'),
    						results_west_3(end+1)=limnsw_west(85);
    						results_east_3(end+1)=limnsw_east(85);
    						results_penin_3(end+1)=limnsw_penin(85);
    					elseif strcmpi(expename,'expA1') |strcmpi(expename,'expA5'),
    						results_west_4(end+1)=limnsw_west(85);
    						results_east_4(end+1)=limnsw_east(85);
    						results_penin_4(end+1)=limnsw_penin(85);
    					elseif strcmpi(expename,'expA2') |strcmpi(expename,'expA6'),
    						results_west_5(end+1)=limnsw_west(85);
    						results_east_5(end+1)=limnsw_east(85);
    						results_penin_5(end+1)=limnsw_penin(85);
    					elseif strcmpi(expename,'expA3') |strcmpi(expename,'expA7'),
    						results_west_6(end+1)=limnsw_west(85);
    						results_east_6(end+1)=limnsw_east(85);
    						results_penin_6(end+1)=limnsw_penin(85);
    					else error('exp not supported');
    					end
    				end
    
    			end %end of model
    		end %end of isexp
    
    		results=[mean(results_west_1), mean(results_west_2),mean(results_west_3) mean(results_west_4),mean(results_west_5), mean(results_west_6);...
    			mean(results_east_1),mean(results_east_2),mean(results_east_3),mean(results_east_4),mean(results_east_5),mean(results_east_6);...
    			mean(results_penin_1),mean(results_penin_2),mean(results_penin_3),mean(results_penin_4),mean(results_penin_5),mean(results_penin_6)];
    		results_std=[std(results_west_1), std(results_west_2),std(results_west_3) std(results_west_4),std(results_west_5), std(results_west_6);...
    			std(results_east_1),std(results_east_2),std(results_east_3),std(results_east_4),std(results_east_5),std(results_east_6);...
    			std(results_penin_1),std(results_penin_2),std(results_penin_3),std(results_penin_4),std(results_penin_5),std(results_penin_6)];
    		%Plot results
    		close all; clf;
    		colors = get(gca,'colororder');
    		figure(1); set(gcf,'color','w'); set(gcf,'Position',[400 500 900 400]);
    		hb=bar(results*(-1/362.5)); hold on 
    		for ib = 1:numel(hb)
    			%XData property is the tick labels/group centers; XOffset is the offset of each distinct group
    			xData = hb(ib).XData+hb(ib).XOffset;
    		   errorbar(xData(1),results(1,ib)*(-1/362.5),results_std(1,ib)*(-1/362.5),'color','k'); 
    		   errorbar(xData(2),results(2,ib)*(-1/362.5),results_std(2,ib)*(-1/362.5),'color','k'); 
    		   errorbar(xData(3),results(3,ib)*(-1/362.5),results_std(3,ib)*(-1/362.5),'color','k'); 
    		end
    		set(gca, 'XTickLabel', '');
    		h=text(1,-78,'WAIS','VerticalAlignment','middle','HorizontalAlignment','center','color','k','fontweight','b');
    		h=text(2,-78,'EAIS','VerticalAlignment','middle','HorizontalAlignment','center','color','k','fontweight','b');
    		h=text(3,-78,'Peninsula','VerticalAlignment','middle','HorizontalAlignment','center','color','k','fontweight','b');
    		for i=1:6,
    			hb(i).FaceColor = colors(i,:);
    		end
    		ylabel('Sea Level Contribution (mm SLE)');
    		xlim([0.5 3.5]);
    		ylim([-70 150]);
    		legend({'NorESM1','MIROC','CCSM','HadGEM2','CSIRO','IPSL'},'location','NorthEast')
    
    		h = gcf;
    		set(h,'Units','Inches');
    		pos = get(h,'Position');
    		set(h,'PaperPositionMode','Auto','PaperUnits','Inches','PaperSize',[pos(3), pos(4)]);
    		print(gcf, '-dpng', '-painters', 'FiguresPaperFinal/Figure8.png');
    	end
    
    end %}}}
    
    %Figure 9: RCP8.5 vs RCP2.6
    if step==14 % {{{Figure 9
    
    	%Remove UTAS and expA7 in VUB to have models that did both 8.5 and 2.6
    	model_list={'AWI_PISM1','DOE_MALI','ILTS_PIK_SICOPOLIS','IMAU_IMAUICE1','IMAU_IMAUICE2','JPL1_ISSM','LSCE_GRISLI','NCAR_CISM','PIK_PISM1','PIK_PISM2','UCIJPL_ISSM','ULB_FETISH32','ULB_FETISH16','VUB_AISMPALEO','VUW_PISM'};
    	figure(1); set(gcf,'color','w'); set(gcf,'Position',[400 500 800 450]);
    
    	experiments_list={'exp01','exp03','exp05','exp07','expA3','expA4','expA7','expA8'}; %open and standard NorESM and IPSL (8.5 vs 2.6)
    
    	mean_vaf=zeros(86,length(experiments_list));
    	std_total=zeros(86,length(experiments_list));
    	num_models=zeros(length(experiments_list),1);
    	time=[2015:2100];
    	if 1,
    
    		for iexp=1:length(experiments_list),
    			expename=experiments_list{iexp};
    
    			for imodel=1:length(model_list),
    				modelname=model_list{imodel};
    				[group,simul,resolution,ice_density,ocean_density,initial_model_year,expe_model_year,yearday_model,ishist_std,hist_std_name,hist_std_regrid,ishist_open,hist_open_name,hist_open_regrid,isctrl_proj_std,ctrl_proj_std_name,ctrl_proj_std_regrid,isctrl_proj_open,ctrl_proj_open_name,ctrl_proj_open_regrid,isexp01,exp01_name,exp01_regrid,isexp02,exp02_name,exp02_regrid,isexp03,exp03_name,exp03_regrid,isexp04,exp04_name,exp04_regrid,isexp05,exp05_name,exp05_regrid,isexp06,exp06_name,exp06_regrid,isexp07,exp07_name,exp07_regrid,isexp08,exp08_name,exp08_regrid,isexp09,exp09_name,exp09_regrid,isexp10,exp10_name,exp10_regrid,isexp11,exp11_name,exp11_regrid,isexp12,exp12_name,exp12_regrid,isexp13,exp13_name,exp13_regrid,isexpA1,expA1_name,expA1_regrid,isexpA2,expA2_name,expA2_regrid,isexpA3,expA3_name,expA3_regrid,isexpA4,expA4_name,expA4_regrid,isexpA5,expA5_name,expA5_regrid,isexpA6,expA6_name,expA6_regrid,isexpA7,expA7_name,expA7_regrid,isexpA8,expA8_name,expA8_regrid] = specifics(modelname)
    				
    				eval(['isexp=is' expename ';'])
    				if strcmp(expename,'expA7') & strcmp(modelname,'VUB_AISMPALEO'),
    					%do nothing as RCP 2.6 is missing
    				elseif isexp,
    					explimnsw_file=['' scalarpath '/' group '/' simul '/' expename '/computed_ivaf_minus_ctrl_proj_AIS_' group '_' simul '_' expename '.nc'];
    					time_model=ncread(explimnsw_file,'time');
    					limnsw_model=ncread(explimnsw_file,'ivaf')*ice_density/(10^9*1000); %from m^3 to Gt
    					mean_vaf(:,iexp)=mean_vaf(:,iexp)+[0;limnsw_model(1:85)];
    					num_models(iexp)=num_models(iexp)+1;
    				else
    					%Experiment not done by this model, do nothing
    				end
    
    			end %end of model
    		end %end of isexp
    		mean_exp=zeros(86,4);
    		mean_exp_extended=zeros(86,8);
    		mean_exp(:,1)=(mean_vaf(:,1)+mean_vaf(:,3))/(num_models(1)+num_models(3)); 
    		mean_exp(:,2)=(mean_vaf(:,2)+mean_vaf(:,4))/(num_models(2)+num_models(4)); 
    		mean_exp(:,3)=(mean_vaf(:,5)+mean_vaf(:,7))/(num_models(5)+num_models(7)); 
    		mean_exp(:,4)=(mean_vaf(:,6)+mean_vaf(:,8))/(num_models(6)+num_models(8)); 
    		mean_exp_extended(:,1)=mean_exp(:,1);
    		mean_exp_extended(:,2)=mean_exp(:,2);
    		mean_exp_extended(:,3)=mean_exp(:,1);
    		mean_exp_extended(:,4)=mean_exp(:,2);
    		mean_exp_extended(:,5)=mean_exp(:,3);
    		mean_exp_extended(:,6)=mean_exp(:,4);
    		mean_exp_extended(:,7)=mean_exp(:,3);
    		mean_exp_extended(:,8)=mean_exp(:,4);
    
    		for iexp=1:length(experiments_list),
    			expename=experiments_list{iexp};
    
    			for imodel=1:length(model_list),
    				modelname=model_list{imodel};
    				[group,simul,resolution,ice_density,ocean_density,initial_model_year,expe_model_year,yearday_model,ishist_std,hist_std_name,hist_std_regrid,ishist_open,hist_open_name,hist_open_regrid,isctrl_proj_std,ctrl_proj_std_name,ctrl_proj_std_regrid,isctrl_proj_open,ctrl_proj_open_name,ctrl_proj_open_regrid,isexp01,exp01_name,exp01_regrid,isexp02,exp02_name,exp02_regrid,isexp03,exp03_name,exp03_regrid,isexp04,exp04_name,exp04_regrid,isexp05,exp05_name,exp05_regrid,isexp06,exp06_name,exp06_regrid,isexp07,exp07_name,exp07_regrid,isexp08,exp08_name,exp08_regrid,isexp09,exp09_name,exp09_regrid,isexp10,exp10_name,exp10_regrid,isexp11,exp11_name,exp11_regrid,isexp12,exp12_name,exp12_regrid,isexp13,exp13_name,exp13_regrid,isexpA1,expA1_name,expA1_regrid,isexpA2,expA2_name,expA2_regrid,isexpA3,expA3_name,expA3_regrid,isexpA4,expA4_name,expA4_regrid,isexpA5,expA5_name,expA5_regrid,isexpA6,expA6_name,expA6_regrid,isexpA7,expA7_name,expA7_regrid,isexpA8,expA8_name,expA8_regrid] = specifics(modelname)
    				
    				eval(['isexp=is' expename ';'])
    				if strcmp(expename,'expA7') & strcmp(modelname,'VUB_AISMPALEO'),
    					%do nothing as RCP 2.6 is missing
    				elseif isexp,
    					explimnsw_file=['' scalarpath '/' group '/' simul '/' expename '/computed_ivaf_minus_ctrl_proj_AIS_' group '_' simul '_' expename '.nc'];
    					time_model=ncread(explimnsw_file,'time');
    					limnsw_model=ncread(explimnsw_file,'ivaf')*ice_density/(10^9*1000); %from m^3 to Gt
    					std_total(:,iexp)=std_total(:,iexp)+([0;limnsw_model(1:85)]-mean_exp_extended(:,iexp)).^2;
    				else
    					%Experiment not done by this model, do nothing
    				end
    
    			end %end of model
    		end %end of isexp
    
    		std_exp=zeros(86,3);
    		std_exp(:,1)=sqrt((std_total(:,1)+std_total(:,3))/(num_models(1)+num_models(3)));
    		std_exp(:,2)=sqrt((std_total(:,2)+std_total(:,4))/(num_models(2)+num_models(4)));
    		std_exp(:,3)=sqrt((std_total(:,5)+std_total(:,7))/(num_models(5)+num_models(7)));
    		std_exp(:,4)=sqrt((std_total(:,6)+std_total(:,8))/(num_models(6)+num_models(8)));
    
    		mean_exp=-mean_exp/362.5; %vaf in SLE mm
    		std_exp=std_exp/362.5; %in SLE mm
    		if 1, %Figure NorESM
    			plot(time,mean_exp(:,1),'color','r','linewidth',2); hold on
    			plot(time,mean_exp(:,2),'color','b','linewidth',2); hold on
    			patch([time';flipud(time')],[mean_exp(:,1)-std_exp(:,1);flipud(mean_exp(:,1)+std_exp(:,1))],[1 0 0]+(1-[1 0 0])*0.25,'FaceAlpha',.3,'EdgeColor','None')
    			patch([time';flipud(time')],[mean_exp(:,2)-std_exp(:,2);flipud(mean_exp(:,2)+std_exp(:,2))],[0 0 1]+(1-[0 0 1])*0.25,'FaceAlpha',.3,'EdgeColor','None')
    			legend({'NorESM1 RCP 8.5 (exp01 & exp05)','NorESM1 RCP 2.6 (exp03 & exp07)'},'location','NorthWest')
    			text(2010,-45,'a','VerticalAlignment','middle','HorizontalAlignment','right','fontsize',18,'fontweight','b');
    			legend boxoff
    			xlim([2015 2100])
    			xlabel('Time (yr)');
    			ylabel('Sea Level Contribution (mm SLE)');
    			set(gcf,'Position',[400 500 800 450]);
    
    			h = gcf;
    			set(h,'Units','Inches');
    			pos = get(h,'Position');
    			set(h,'PaperPositionMode','Auto','PaperUnits','Inches','PaperSize',[pos(3), pos(4)]);
    			print(gcf, '-dpng', '-painters', 'FiguresPaperFinal/Figure9a.png');
    		end
    
    		if 1, %Figure IPSL
    			close
    			plot(time,mean_exp(:,3),'color','r','linewidth',2); hold on
    			plot(time,mean_exp(:,4),'color','b','linewidth',2); hold on
    			patch([time';flipud(time')],[mean_exp(:,3)-std_exp(:,3);flipud(mean_exp(:,3)+std_exp(:,3))],[1 0 0]+(1-[1 0 0])*0.25,'FaceAlpha',.3,'EdgeColor','None')
    			patch([time';flipud(time')],[mean_exp(:,4)-std_exp(:,4);flipud(mean_exp(:,4)+std_exp(:,4))],[0 0 1]+(1-[0 0 1])*0.25,'FaceAlpha',.3,'EdgeColor','None')
    			legend({'IPSL RCP 8.5 (expA3 & expA7)','IPSL RCP 2.6 (expA4 & expA8)'},'location','NorthWest')
    			text(2010,-55,'b','VerticalAlignment','middle','HorizontalAlignment','right','fontsize',18,'fontweight','b');
    			legend boxoff
    			xlim([2015 2100])
    			xlabel('Time (yr)');
    			ylabel('Sea Level Contribution (mm SLE)');
    			set(gcf,'Position',[400 500 800 450]);
    
    			h = gcf;
    			set(h,'Units','Inches');
    			pos = get(h,'Position');
    			set(h,'PaperPositionMode','Auto','PaperUnits','Inches','PaperSize',[pos(3), pos(4)]);
    			print(gcf, '-dpng', '-painters', 'FiguresPaperFinal/Figure9b.png');
    		end
    
    	end
    
    end %}}}
    
    %Figure 10: RCP8.5 vs RCP2.6 by region
    if step==15 % {{{Figure 10a
    
    	%Remove UTAS exp05 have models that did both 8.5 and 2.6
    	model_list={'AWI_PISM1','DOE_MALI','ILTS_PIK_SICOPOLIS','IMAU_IMAUICE1','IMAU_IMAUICE2','JPL1_ISSM','LSCE_GRISLI','NCAR_CISM','PIK_PISM1','PIK_PISM2','UCIJPL_ISSM','ULB_FETISH32','ULB_FETISH16','VUB_AISMPALEO','VUW_PISM'};
    	colors = distinguishable_colors(length(model_list));
    	experiments_list={'exp05','exp01','exp07','exp03'}; %open and standard NorESM
    
    	results_west_85=[]; results_east_85=[]; results_penin_85=[]; 
    	resultstendacabfgr_west_85=[]; resultstendacabfgr_east_85=[]; resultstendacabfgr_penin_85=[]; 
    	results_west_26=[]; results_east_26=[]; results_penin_26=[]; 
    	resultstendacabfgr_west_26=[]; resultstendacabfgr_east_26=[]; resultstendacabfgr_penin_26=[]; 
    	results_model={}; 
    
    	if 1,
    		for imodel=1:length(model_list),
    			modelname=model_list{imodel};
    			for iexp=1:length(experiments_list),
    				expename=experiments_list{iexp};
    				[group,simul,resolution,ice_density,ocean_density,initial_model_year,expe_model_year,yearday_model,ishist_std,hist_std_name,hist_std_regrid,ishist_open,hist_open_name,hist_open_regrid,isctrl_proj_std,ctrl_proj_std_name,ctrl_proj_std_regrid,isctrl_proj_open,ctrl_proj_open_name,ctrl_proj_open_regrid,isexp01,exp01_name,exp01_regrid,isexp02,exp02_name,exp02_regrid,isexp03,exp03_name,exp03_regrid,isexp04,exp04_name,exp04_regrid,isexp05,exp05_name,exp05_regrid,isexp06,exp06_name,exp06_regrid,isexp07,exp07_name,exp07_regrid,isexp08,exp08_name,exp08_regrid,isexp09,exp09_name,exp09_regrid,isexp10,exp10_name,exp10_regrid,isexp11,exp11_name,exp11_regrid,isexp12,exp12_name,exp12_regrid,isexp13,exp13_name,exp13_regrid,isexpA1,expA1_name,expA1_regrid,isexpA2,expA2_name,expA2_regrid,isexpA3,expA3_name,expA3_regrid,isexpA4,expA4_name,expA4_regrid,isexpA5,expA5_name,expA5_regrid,isexpA6,expA6_name,expA6_regrid,isexpA7,expA7_name,expA7_regrid,isexpA8,expA8_name,expA8_regrid] = specifics(modelname)
    				
    				eval(['isexp=is' expename ';'])
    				if isexp,
    					explimnsw_file=['' scalarpath '/' group '/' simul '/' expename '/computed_ivaf_minus_ctrl_proj_AIS_' group '_' simul '_' expename '.nc'];
    					exptendacabfgr_file=['' scalarpath '/' group '/' simul '/' expename '/computed_smbgr_minus_ctrl_proj_AIS_' group '_' simul '_' expename '.nc'];
    					time_model=ncread(explimnsw_file,'time');
    					limnsw_west=ncread(explimnsw_file,'ivaf_region_1')*ice_density/(10^9*1000); %from m^3 to Gt
    					limnsw_east=ncread(explimnsw_file,'ivaf_region_2')*ice_density/(10^9*1000); %from m^3 to Gt
    					limnsw_penin=ncread(explimnsw_file,'ivaf_region_3')*ice_density/(10^9*1000); %from m^3 to Gt
    					tendacabfgr_west=ncread(exptendacabfgr_file,'smbgr_region_1')*yearday_model*3600*24/(10^9*1000); %from kg/s to Gt/yr
    					tendacabfgr_east=ncread(exptendacabfgr_file,'smbgr_region_2')*yearday_model*3600*24/(10^9*1000); %from kg/s to Gt/yr
    					tendacabfgr_penin=ncread(exptendacabfgr_file,'smbgr_region_3')*yearday_model*3600*24/(10^9*1000); %from kg/s to Gt/yr
    					if strcmpi(expename,'exp05'),
    						results_west_85(end+1)=limnsw_west(85);
    						results_east_85(end+1)=limnsw_east(85);
    						results_penin_85(end+1)=limnsw_penin(85);
    						resultstendacabfgr_west_85(end+1)=sum(tendacabfgr_west(1:85));
    						resultstendacabfgr_east_85(end+1)=sum(tendacabfgr_east(1:85));
    						resultstendacabfgr_penin_85(end+1)=sum(tendacabfgr_penin(1:85));
    						results_model{end+1}=[model_list2{imodel} '\_std'] ;
    					elseif strcmpi(expename,'exp01'),
    						results_west_85(end+1)=limnsw_west(85);
    						results_east_85(end+1)=limnsw_east(85);
    						results_penin_85(end+1)=limnsw_penin(85);
    						resultstendacabfgr_west_85(end+1)=sum(tendacabfgr_west(1:85));
    						resultstendacabfgr_east_85(end+1)=sum(tendacabfgr_east(1:85));
    						resultstendacabfgr_penin_85(end+1)=sum(tendacabfgr_penin(1:85));
    						results_model{end+1}=[model_list2{imodel} '\_open'] ;
    					elseif strcmpi(expename,'exp07') | strcmpi(expename,'exp03'),
    						results_west_26(end+1)=limnsw_west(85);
    						results_east_26(end+1)=limnsw_east(85);
    						results_penin_26(end+1)=limnsw_penin(85);
    						resultstendacabfgr_west_26(end+1)=sum(tendacabfgr_west(1:85));
    						resultstendacabfgr_east_26(end+1)=sum(tendacabfgr_east(1:85));
    						resultstendacabfgr_penin_26(end+1)=sum(tendacabfgr_penin(1:85));
    					end
    				end
    			end
    
    		end %end of model
    	end %end of isexp
    
    	results_west=[results_west_85; results_west_26]; results_west=results_west(:)';
    	results_east=[results_east_85; results_east_26]; results_east=results_east(:)';
    	results_penin=[results_penin_85; results_penin_26]; results_penin=results_penin(:)';
    	results=[results_west;results_east;results_penin];
    	resultstendacabfgr_west=[resultstendacabfgr_west_85; resultstendacabfgr_west_26];
    	resultstendacabfgr_west=resultstendacabfgr_west(:)';
    	resultstendacabfgr_east=[resultstendacabfgr_east_85; resultstendacabfgr_east_26];
    	resultstendacabfgr_east=resultstendacabfgr_east(:)';
    	resultstendacabfgr_penin=[resultstendacabfgr_penin_85; resultstendacabfgr_penin_26];
    	resultstendacabfgr_penin=resultstendacabfgr_penin(:)';
    	resultstendacabfgr=[resultstendacabfgr_west;resultstendacabfgr_east;resultstendacabfgr_penin];
    
    	%Plot results
    	figure(1); set(gcf,'color','w'); set(gcf,'Position',[400 500 1200 550]);
    	hb=bar(results*(-1/362.5),'grouped'); hold on 
    	for iresults=1:numel(hb),
    		if mod(iresults,2)==1,
    			hb(iresults).FaceColor=[1 0 0]+(1-[1 0 0])*0.5;
    		else
    			hb(iresults).FaceColor=[0 0 1];
    		end
    	end
    	set(gca, 'XTickLabel', '');
    	h=text(1,170,'WAIS','VerticalAlignment','middle','HorizontalAlignment','center','color','k','fontweight','b');
    	h=text(2,170,'EAIS','VerticalAlignment','middle','HorizontalAlignment','center','color','k','fontweight','b');
    	h=text(3,170,'Peninsula','VerticalAlignment','middle','HorizontalAlignment','center','color','k','fontweight','b');
    	ylabel('Sea Level Contribution (mm SLE)');
    	text(0.4,-160,'a','VerticalAlignment','middle','HorizontalAlignment','right','fontsize',18,'fontweight','b');
    	xlim([0.5 3.5]);
    	ylim([-50 160]);
    	set(gca,'position',[0.10 0.35 0.835 0.585]);
    	hold on
    
    	%Add SMB results
    	color_scenario=[0 0 1;[1 0 0]+(1-[1 0 0])*0.5];
    	for ib = 1:numel(hb)
    		%XData property is the tick labels/group centers; XOffset is the offset of each distinct group
    		xData = hb(ib).XData+hb(ib).XOffset;
    		plot(xData(1),resultstendacabfgr_west(ib)*(-1/362.5),'d','MarkerFaceColor',color_scenario(mod(ib,2)+1,:),'MarkerSize',6,'MarkerEdgeColor','k')
    		plot(xData(2),resultstendacabfgr_east(ib)*(-1/362.5),'d','MarkerFaceColor',color_scenario(mod(ib,2)+1,:),'MarkerSize',6,'MarkerEdgeColor','k')
    		plot(xData(3),resultstendacabfgr_penin(ib)*(-1/362.5),'d','MarkerFaceColor',color_scenario(mod(ib,2)+1,:),'MarkerSize',6,'MarkerEdgeColor','k')
    	end
    	for ib = 1:numel(hb)
    		if mod(ib,2)==1,
    			xData = (hb(ib).XData+hb(ib).XOffset + hb(ib+1).XData+hb(ib+1).XOffset)/2;
    			h=text(xData(1),-50,results_model{(ib+1)/2},'VerticalAlignment','middle','HorizontalAlignment','right','color','k','fontweight','n');
    			set(h,'Rotation',90);
    			h=text(xData(2),-50,results_model{(ib+1)/2},'VerticalAlignment','middle','HorizontalAlignment','right','color','k','fontweight','n');
    			set(h,'Rotation',90);
    			h=text(xData(3),-50,results_model{(ib+1)/2},'VerticalAlignment','middle','HorizontalAlignment','right','color','k','fontweight','n');
    			set(h,'Rotation',90);
    		end
    	end
    	yticks([-50 0 50 100 150])
    	legend({'RCP 8.5','RCP 2.6'},'location','NorthEast')
    	h = gcf;
    	set(h,'Units','Inches');
    	pos = get(h,'Position');
    	set(h,'PaperPositionMode','Auto','PaperUnits','Inches','PaperSize',[pos(3), pos(4)]);
    	print(gcf, '-dpng', '-painters', 'FiguresPaperFinal/Figure10a.png');
    
    end %}}}
    if step==16 % {{{Figure 10b
    
    	%Remove expA7 in VUB to have models that did both 8.5 and 2.6
    	colors = distinguishable_colors(length(model_list));
    	experiments_list={'expA7','expA3','expA8','expA4'}; %open and standard NorESM
    
    	results_west_85=[]; results_east_85=[]; results_penin_85=[]; 
    	resultstendacabfgr_west_85=[]; resultstendacabfgr_east_85=[]; resultstendacabfgr_penin_85=[]; 
    	results_west_26=[]; results_east_26=[]; results_penin_26=[]; 
    	resultstendacabfgr_west_26=[]; resultstendacabfgr_east_26=[]; resultstendacabfgr_penin_26=[]; 
    	results_model={}; results_meltparam={};
    
    	if 1,
    		for imodel=1:length(model_list),
    			modelname=model_list{imodel};
    			for iexp=1:length(experiments_list),
    				expename=experiments_list{iexp};
    				[group,simul,resolution,ice_density,ocean_density,initial_model_year,expe_model_year,yearday_model,ishist_std,hist_std_name,hist_std_regrid,ishist_open,hist_open_name,hist_open_regrid,isctrl_proj_std,ctrl_proj_std_name,ctrl_proj_std_regrid,isctrl_proj_open,ctrl_proj_open_name,ctrl_proj_open_regrid,isexp01,exp01_name,exp01_regrid,isexp02,exp02_name,exp02_regrid,isexp03,exp03_name,exp03_regrid,isexp04,exp04_name,exp04_regrid,isexp05,exp05_name,exp05_regrid,isexp06,exp06_name,exp06_regrid,isexp07,exp07_name,exp07_regrid,isexp08,exp08_name,exp08_regrid,isexp09,exp09_name,exp09_regrid,isexp10,exp10_name,exp10_regrid,isexp11,exp11_name,exp11_regrid,isexp12,exp12_name,exp12_regrid,isexp13,exp13_name,exp13_regrid,isexpA1,expA1_name,expA1_regrid,isexpA2,expA2_name,expA2_regrid,isexpA3,expA3_name,expA3_regrid,isexpA4,expA4_name,expA4_regrid,isexpA5,expA5_name,expA5_regrid,isexpA6,expA6_name,expA6_regrid,isexpA7,expA7_name,expA7_regrid,isexpA8,expA8_name,expA8_regrid] = specifics(modelname)
    				
    				eval(['isexp=is' expename ';'])
    				if strcmp(expename,'expA7') & strcmp(modelname,'VUB_AISMPALEO'),
    					%do nothing as RCP 2.6 is missing
    				elseif isexp,
    					explimnsw_file=['' scalarpath '/' group '/' simul '/' expename '/computed_ivaf_minus_ctrl_proj_AIS_' group '_' simul '_' expename '.nc'];
    					exptendacabfgr_file=['' scalarpath '/' group '/' simul '/' expename '/computed_smbgr_minus_ctrl_proj_AIS_' group '_' simul '_' expename '.nc'];
    					time_model=ncread(explimnsw_file,'time');
    					limnsw_west=ncread(explimnsw_file,'ivaf_region_1')*ice_density/(10^9*1000); %from m^3 to Gt
    					limnsw_east=ncread(explimnsw_file,'ivaf_region_2')*ice_density/(10^9*1000); %from m^3 to Gt
    					limnsw_penin=ncread(explimnsw_file,'ivaf_region_3')*ice_density/(10^9*1000); %from m^3 to Gt 
    					tendacabfgr_west=ncread(exptendacabfgr_file,'smbgr_region_1')*yearday_model*3600*24/(10^9*1000); %from kg/s to Gt/yr
    					tendacabfgr_east=ncread(exptendacabfgr_file,'smbgr_region_2')*yearday_model*3600*24/(10^9*1000); %from kg/s to Gt/yr
    					tendacabfgr_penin=ncread(exptendacabfgr_file,'smbgr_region_3')*yearday_model*3600*24/(10^9*1000); %from kg/s to Gt/yr
    					if strcmpi(expename,'expA7'),
    						results_west_85(end+1)=limnsw_west(85);
    						results_east_85(end+1)=limnsw_east(85);
    						results_penin_85(end+1)=limnsw_penin(85);
    						resultstendacabfgr_west_85(end+1)=sum(tendacabfgr_west(1:85));
    						resultstendacabfgr_east_85(end+1)=sum(tendacabfgr_east(1:85));
    						resultstendacabfgr_penin_85(end+1)=sum(tendacabfgr_penin(1:85));
    						results_model{end+1}=[model_list2{imodel} '\_std'] ;
    					elseif strcmpi(expename,'expA3'),
    						results_west_85(end+1)=limnsw_west(85);
    						results_east_85(end+1)=limnsw_east(85);
    						results_penin_85(end+1)=limnsw_penin(85);
    						resultstendacabfgr_west_85(end+1)=sum(tendacabfgr_west(1:85));
    						resultstendacabfgr_east_85(end+1)=sum(tendacabfgr_east(1:85));
    						resultstendacabfgr_penin_85(end+1)=sum(tendacabfgr_penin(1:85));
    						results_model{end+1}=[model_list2{imodel} '\_open'] ;
    					elseif strcmpi(expename,'expA8'),
    						results_west_26(end+1)=limnsw_west(85);
    						results_east_26(end+1)=limnsw_east(85);
    						results_penin_26(end+1)=limnsw_penin(85);
    						resultstendacabfgr_west_26(end+1)=sum(tendacabfgr_west(1:85));
    						resultstendacabfgr_east_26(end+1)=sum(tendacabfgr_east(1:85));
    						resultstendacabfgr_penin_26(end+1)=sum(tendacabfgr_penin(1:85));
    					elseif strcmpi(expename,'expA4'),
    						results_west_26(end+1)=limnsw_west(85);
    						results_east_26(end+1)=limnsw_east(85);
    						results_penin_26(end+1)=limnsw_penin(85);
    						resultstendacabfgr_west_26(end+1)=sum(tendacabfgr_west(1:85));
    						resultstendacabfgr_east_26(end+1)=sum(tendacabfgr_east(1:85));
    						resultstendacabfgr_penin_26(end+1)=sum(tendacabfgr_penin(1:85));
    					end
    				end
    
    			end %end of model
    		end %end of isexp
    
    		results_west=[results_west_85; results_west_26]; results_west=results_west(:)';
    		results_east=[results_east_85; results_east_26]; results_east=results_east(:)';
    		results_penin=[results_penin_85; results_penin_26]; results_penin=results_penin(:)';
    		results=[results_west;results_east;results_penin];
    		resultstendacabfgr_west=[resultstendacabfgr_west_85; resultstendacabfgr_west_26];
    		resultstendacabfgr_west=resultstendacabfgr_west(:)';
    		resultstendacabfgr_east=[resultstendacabfgr_east_85; resultstendacabfgr_east_26];
    		resultstendacabfgr_east=resultstendacabfgr_east(:)';
    		resultstendacabfgr_penin=[resultstendacabfgr_penin_85; resultstendacabfgr_penin_26];
    		resultstendacabfgr_penin=resultstendacabfgr_penin(:)';
    		resultstendacabfgr=[resultstendacabfgr_west;resultstendacabfgr_east;resultstendacabfgr_penin];
    
    		%Plot results
    		figure(1); set(gcf,'color','w'); set(gcf,'Position',[400 500 1200 550]);
    		hb=bar(results*(-1/362.5),'grouped'); hold on 
    		for iresults=1:numel(hb),
    			if mod(iresults,2)==1,
    				hb(iresults).FaceColor=[1 0 0]+(1-[1 0 0])*0.5;
    			else
    				hb(iresults).FaceColor=[0 0 1];
    			end
    		end
    		set(gca, 'XTickLabel', '');
    		h=text(1,170,'WAIS','VerticalAlignment','middle','HorizontalAlignment','center','color','k','fontweight','b');
    		h=text(2,170,'EAIS','VerticalAlignment','middle','HorizontalAlignment','center','color','k','fontweight','b');
    		h=text(3,170,'Peninsula','VerticalAlignment','middle','HorizontalAlignment','center','color','k','fontweight','b');
    		ylabel('Sea Level Contribution (mm SLE)');
    		xlim([0.5 3.5]);
    		ylim([-50 160]);
    		set(gca,'position',[0.10 0.32 0.835 0.555]);
    		text(0.4,-100,'b','VerticalAlignment','middle','HorizontalAlignment','right','fontsize',18,'fontweight','b');
    		hold on
    
    		%Add SMB results
    		color_scenario=[0 0 1;[1 0 0]+(1-[1 0 0])*0.5];
    		for ib = 1:numel(hb)
    			%XData property is the tick labels/group centers; XOffset is the offset of each distinct group
    			xData = hb(ib).XData+hb(ib).XOffset;
    			plot(xData(1),resultstendacabfgr_west(ib)*(-1/362.5),'d','MarkerFaceColor',color_scenario(mod(ib,2)+1,:),'MarkerSize',6,'MarkerEdgeColor','k')
    			plot(xData(2),resultstendacabfgr_east(ib)*(-1/362.5),'d','MarkerFaceColor',color_scenario(mod(ib,2)+1,:),'MarkerSize',6,'MarkerEdgeColor','k')
    			plot(xData(3),resultstendacabfgr_penin(ib)*(-1/362.5),'d','MarkerFaceColor',color_scenario(mod(ib,2)+1,:),'MarkerSize',6,'MarkerEdgeColor','k')
    		end
    		for ib = 1:numel(hb)
    			if mod(ib,2)==1,
    				xData = (hb(ib).XData+hb(ib).XOffset + hb(ib+1).XData+hb(ib+1).XOffset)/2;
    				h=text(xData(1),-50,results_model{(ib+1)/2},'VerticalAlignment','middle','HorizontalAlignment','right','color','k','fontweight','n');
    				set(h,'Rotation',90);
    				h=text(xData(2),-50,results_model{(ib+1)/2},'VerticalAlignment','middle','HorizontalAlignment','right','color','k','fontweight','n');
    				set(h,'Rotation',90);
    				h=text(xData(3),-50,results_model{(ib+1)/2},'VerticalAlignment','middle','HorizontalAlignment','right','color','k','fontweight','n');
    				set(h,'Rotation',90);
    			end
    		end
    		legend({'RCP 8.5','RCP 2.6'},'location','NorthEast')
    
    		h = gcf;
    		set(h,'Units','Inches');
    		pos = get(h,'Position');
    		set(h,'PaperPositionMode','Auto','PaperUnits','Inches','PaperSize',[pos(3), pos(4)]);
    		print(gcf, '-dpng', '-painters', 'FiguresPaperFinal/Figure10b.png');
    	end
    
    end %}}}
    
    %Figure 11: Open vs standard melt parameterization
    if step==17 % {{{Figure 11a
    
    	colors = get(gca,'colororder');
    	experiments_list={'exp01','exp05','exp02','exp06','exp04','exp08','expA1','expA5','expA2','expA6','expA3','expA7'}; %open and standard RCP8.5
     
    	for iexp=1:length(experiments_list),
    		eval(['results_west_' int2str(iexp) '=[];'])
    		eval(['results_east_' int2str(iexp) '=[];'])
    		eval(['results_penin_' int2str(iexp) '=[];'])
    	end
    
    	for imodel=1:length(model_list),
    		modelname=model_list{imodel};
    		for iexp=1:length(experiments_list),
    			expename=experiments_list{iexp};
    			exp_params = specifics(modelname)
    
    			eval(['isexp=is' expename ';'])
    			if isexp,
    				exptendlibmassbffl_file=['' scalarpath '/' group '/' simul '/' expename '/computed_bmbfl_minus_ctrl_proj_AIS_' group '_' simul '_' expename '.nc'];
    				time_model=ncread(exptendlibmassbffl_file,'time');
    				tendlibmassbffl_west=ncread(exptendlibmassbffl_file,'bmbfl_region_1')*yearday_model*3600*24/(10^9*1000); %from kg/s to Gt/yr
    				tendlibmassbffl_east=ncread(exptendlibmassbffl_file,'bmbfl_region_2')*yearday_model*3600*24/(10^9*1000); %from kg/s to Gt/yr
    				tendlibmassbffl_penin=ncread(exptendlibmassbffl_file,'bmbfl_region_3')*yearday_model*3600*24/(10^9*1000); %from kg/s to Gt/yr
    				eval(['results_west_' int2str(iexp) '(end+1)=sum(tendlibmassbffl_west(1:85));'])
    				eval(['results_east_' int2str(iexp) '(end+1)=sum(tendlibmassbffl_east(1:85));'])
    				eval(['results_penin_' int2str(iexp) '(end+1)=sum(tendlibmassbffl_penin(1:85));'])
    			end
    		end %end of model
    	end %end of isexp
    
    	results=[mean(results_west_1), mean(results_west_2),mean(results_west_3), mean(results_west_4),mean(results_west_5), mean(results_west_6),...
    		mean(results_west_7), mean(results_west_8),mean(results_west_9), mean(results_west_10),mean(results_west_11), mean(results_west_12);...
    		mean(results_east_1),mean(results_east_2),mean(results_east_3),mean(results_east_4),mean(results_east_5),mean(results_east_6),...
    		mean(results_east_7), mean(results_east_8),mean(results_east_9), mean(results_east_10),mean(results_east_11), mean(results_east_12);...
    		mean(results_penin_1),mean(results_penin_2),mean(results_penin_3),mean(results_penin_4),mean(results_penin_5),mean(results_penin_6),...
    		mean(results_penin_7), mean(results_penin_8),mean(results_penin_9), mean(results_penin_10),mean(results_penin_11), mean(results_penin_12)];
    	results_std=[std(results_west_1), std(results_west_2),std(results_west_3), std(results_west_4),std(results_west_5), std(results_west_6),...
    		std(results_west_7), std(results_west_8),std(results_west_9), std(results_west_10),std(results_west_11), std(results_west_12);...
    		std(results_east_1),std(results_east_2),std(results_east_3),std(results_east_4),std(results_east_5),std(results_east_6),...
    		std(results_east_7), std(results_east_8),std(results_east_9), std(results_east_10),std(results_east_11), std(results_east_12);...
    		std(results_penin_1),std(results_penin_2),std(results_penin_3),std(results_penin_4),std(results_penin_5),std(results_penin_6),...
    		std(results_penin_7), std(results_penin_8),std(results_penin_9), std(results_penin_10),std(results_penin_11), std(results_penin_12)];
    	%Plot results
    	figure(1); set(gcf,'color','w'); set(gcf,'Position',[400 500 800 450]);
    	hb=bar(-results); hold on 
    
    	for ib = 1:numel(hb)
    		%XData property is the tick labels/group centers; XOffset is the offset of each distinct group
    		xData = hb(ib).XData+hb(ib).XOffset;
    		errorbar(xData(1),-results(1,ib),results_std(1,ib)*(-1),'color','k'); 
    		errorbar(xData(2),-results(2,ib),results_std(2,ib)*(-1),'color','k'); 
    		errorbar(xData(3),-results(3,ib),results_std(3,ib)*(-1),'color','k'); 
    	end
    	set(gca, 'XTickLabel', '');
    	h=text(1,-0.63*10^5,'WAIS','VerticalAlignment','middle','HorizontalAlignment','center','color','k','fontweight','b');
    	h=text(2,-0.63*10^5,'EAIS','VerticalAlignment','middle','HorizontalAlignment','center','color','k','fontweight','b');
    	h=text(3,-0.63*10^5,'Peninsula','VerticalAlignment','middle','HorizontalAlignment','center','color','k','fontweight','b');
    	for i=1:6,
    		hb(2*i-1).FaceColor = colors(i,:);
    		hb(2*i).FaceColor = colors(i,:);
    	end
    	ylabel('Total ocean melt (Gt)');
    	xlim([0.5 3.5]);
    	ylim([-5 30]*10^4);
    	text(0.35,-0.65*10^5,'a','VerticalAlignment','middle','HorizontalAlignment','right','fontsize',18,'fontweight','b');
    	legend({'NorESM open','NorESM standard','MIROC open','MIROC standard','CCSM open','CCSM standard',...
    		'HadGEM2 open','HadGEM2 standard','CSIRO open','CSIRO standard','IPSL open','IPSL standard'},'location','EastOutside')
    
    	h = gcf;
    	set(h,'Units','Inches');
    	pos = get(h,'Position');
    	set(h,'PaperPositionMode','Auto','PaperUnits','Inches','PaperSize',[pos(3), pos(4)]);
    	print(gcf, '-dpng', '-painters', 'FiguresPaperFinal/Figure11a.png');
    
    end %}}}
    if step==18 % {{{Figure 11b
    
    	colors = get(gca,'colororder');
    	experiments_list={'exp01','exp05','exp02','exp06','exp04','exp08','expA1','expA5','expA2','expA6','expA3','expA7'}; %open and standard RCP8.5
     
    	for iexp=1:length(experiments_list),
    		eval(['results_west_' int2str(iexp) '=[];'])
    		eval(['results_east_' int2str(iexp) '=[];'])
    		eval(['results_penin_' int2str(iexp) '=[];'])
    	end
    
    	for imodel=1:length(model_list),
    		modelname=model_list{imodel};
    		for iexp=1:length(experiments_list),
    			expename=experiments_list{iexp};
    			exp_params = specifics(modelname)
    
    			eval(['isexp=is' expename ';'])
    			if isexp,
    				explimnsw_file=['' scalarpath '/' group '/' simul '/' expename '/computed_ivaf_minus_ctrl_proj_AIS_' group '_' simul '_' expename '.nc'];
    				time_model=ncread(explimnsw_file,'time');
    				limnsw_west=ncread(explimnsw_file,'ivaf_region_1')*ice_density/(10^9*1000); %from m^3 to Gt
    				limnsw_east=ncread(explimnsw_file,'ivaf_region_2')*ice_density/(10^9*1000); %from m^3 to Gt
    				limnsw_penin=ncread(explimnsw_file,'ivaf_region_3')*ice_density/(10^9*1000); %from m^3 to Gt
    				eval(['results_west_' int2str(iexp) '(end+1)=limnsw_west(85);'])
    				eval(['results_east_' int2str(iexp) '(end+1)=limnsw_east(85);'])
    				eval(['results_penin_' int2str(iexp) '(end+1)=limnsw_penin(85);'])
    			end
    		end %end of model
    	end %end of isexp
    
    	results=[mean(results_west_1), mean(results_west_2),mean(results_west_3), mean(results_west_4),mean(results_west_5), mean(results_west_6),...
    		mean(results_west_7), mean(results_west_8),mean(results_west_9), mean(results_west_10),mean(results_west_11), mean(results_west_12);...
    		mean(results_east_1),mean(results_east_2),mean(results_east_3),mean(results_east_4),mean(results_east_5),mean(results_east_6),...
    		mean(results_east_7), mean(results_east_8),mean(results_east_9), mean(results_east_10),mean(results_east_11), mean(results_east_12);...
    		mean(results_penin_1),mean(results_penin_2),mean(results_penin_3),mean(results_penin_4),mean(results_penin_5),mean(results_penin_6),...
    		mean(results_penin_7), mean(results_penin_8),mean(results_penin_9), mean(results_penin_10),mean(results_penin_11), mean(results_penin_12)];
    	results_std=[std(results_west_1), std(results_west_2),std(results_west_3), std(results_west_4),std(results_west_5), std(results_west_6),...
    		std(results_west_7), std(results_west_8),std(results_west_9), std(results_west_10),std(results_west_11), std(results_west_12);...
    		std(results_east_1),std(results_east_2),std(results_east_3),std(results_east_4),std(results_east_5),std(results_east_6),...
    		std(results_east_7), std(results_east_8),std(results_east_9), std(results_east_10),std(results_east_11), std(results_east_12);...
    		std(results_penin_1),std(results_penin_2),std(results_penin_3),std(results_penin_4),std(results_penin_5),std(results_penin_6),...
    		std(results_penin_7), std(results_penin_8),std(results_penin_9), std(results_penin_10),std(results_penin_11), std(results_penin_12)];
    	%Plot results
    	figure(1); set(gcf,'color','w'); set(gcf,'Position',[400 500 800 450]);
    	hb=bar(results*(-1/361.8)); hold on 
    
    	for ib = 1:numel(hb)
    		%XData property is the tick labels/group centers; XOffset is the offset of each distinct group
    		xData = hb(ib).XData+hb(ib).XOffset;
    		errorbar(xData(1),results(1,ib)*(-1/361.8),results_std(1,ib)*(-1/361.8),'color','k'); 
    		errorbar(xData(2),results(2,ib)*(-1/361.8),results_std(2,ib)*(-1/361.8),'color','k'); 
    		errorbar(xData(3),results(3,ib)*(-1/361.8),results_std(3,ib)*(-1/361.8),'color','k'); 
    	end
    	set(gca, 'XTickLabel', '');
    	h=text(1,-88,'WAIS','VerticalAlignment','middle','HorizontalAlignment','center','color','k','fontweight','b');
    	h=text(2,-88,'EAIS','VerticalAlignment','middle','HorizontalAlignment','center','color','k','fontweight','b');
    	h=text(3,-88,'Peninsula','VerticalAlignment','middle','HorizontalAlignment','center','color','k','fontweight','b');
    	for i=1:6,
    		hb(2*i-1).FaceColor = colors(i,:);
    		hb(2*i).FaceColor = colors(i,:);
    	end
    	ylabel('Additional SLE (mm)');
    	xlim([0.5 3.5]);
    	ylim([-80 200]);
    	text(0.35,-85,'b','VerticalAlignment','middle','HorizontalAlignment','right','fontsize',18,'fontweight','b');
    	legend({'NorESM open','NorESM standard','MIROC open','MIROC standard','CCSM4 open','CCSM4 standard',...
    		'HadGEM2 open','HadGEM2 standard','CSIRO open','CSIRO standard','IPSL open','IPSL standard'},'location','EastOutside')
    
    	h = gcf;
    	set(h,'Units','Inches');
    	pos = get(h,'Position');
    	set(h,'PaperPositionMode','Auto','PaperUnits','Inches','PaperSize',[pos(3), pos(4)]);
    	print(gcf, '-dpng', '-painters', 'FiguresPaperFinal/Figure11b.png');
    end %}}}
    
    %Figure 12: Melt parameterization
    if step==19 % {{{Figure 12a
    
    	%Remove UTAS to include only models that did both the 3 model uncertainty NorESM
    	model_list={'AWI_PISM1','DOE_MALI','ILTS_PIK_SICOPOLIS','IMAU_IMAUICE1','IMAU_IMAUICE2','JPL1_ISSM','LSCE_GRISLI','NCAR_CISM','PIK_PISM1','PIK_PISM2','UCIJPL_ISSM','ULB_FETISH32','ULB_FETISH16','VUB_AISMPALEO','VUW_PISM'};
    	experiments_list={'exp05','exp09','exp10'}; %standard NorESM 
    
    	mean_basalmelt=zeros(86,length(experiments_list));
    	min_basalmelt=9999*ones(86,length(experiments_list));
    	max_basalmelt=-9999*ones(86,length(experiments_list));
    	num_models=zeros(length(experiments_list),1);
    	time=[2015:2100];
    
    	for iexp=1:length(experiments_list),
    		expename=experiments_list{iexp};
    
    		for imodel=1:length(model_list),
    			modelname=model_list{imodel};
    			[group,simul,resolution,ice_density,ocean_density,initial_model_year,expe_model_year,yearday_model,ishist_std,hist_std_name,hist_std_regrid,ishist_open,hist_open_name,hist_open_regrid,isctrl_proj_std,ctrl_proj_std_name,ctrl_proj_std_regrid,isctrl_proj_open,ctrl_proj_open_name,ctrl_proj_open_regrid,isexp01,exp01_name,exp01_regrid,isexp02,exp02_name,exp02_regrid,isexp03,exp03_name,exp03_regrid,isexp04,exp04_name,exp04_regrid,isexp05,exp05_name,exp05_regrid,isexp06,exp06_name,exp06_regrid,isexp07,exp07_name,exp07_regrid,isexp08,exp08_name,exp08_regrid,isexp09,exp09_name,exp09_regrid,isexp10,exp10_name,exp10_regrid,isexp11,exp11_name,exp11_regrid,isexp12,exp12_name,exp12_regrid,isexp13,exp13_name,exp13_regrid,isexpA1,expA1_name,expA1_regrid,isexpA2,expA2_name,expA2_regrid,isexpA3,expA3_name,expA3_regrid,isexpA4,expA4_name,expA4_regrid,isexpA5,expA5_name,expA5_regrid,isexpA6,expA6_name,expA6_regrid,isexpA7,expA7_name,expA7_regrid,isexpA8,expA8_name,expA8_regrid] = specifics(modelname)
    			
    			eval(['isexp=is' expename ';'])
    			if isexp,
    				num_models(iexp)=num_models(iexp)+1;
    				exptendlibmassbffl_file=['' scalarpath '/' group '/' simul '/' expename '/computed_bmbfl_minus_ctrl_proj_AIS_' group '_' simul '_' expename '.nc'];
    				time_model=ncread(exptendlibmassbffl_file,'time');
    				tendlibmassbffl_model=ncread(exptendlibmassbffl_file,'bmbfl')*yearday_model*3600*24/(10^9*1000); %from kg/s to Gt/yr
    				mean_basalmelt(:,iexp)=mean_basalmelt(:,iexp)+[0;tendlibmassbffl_model(1:85)];
    				min_basalmelt(:,iexp)=min(min_basalmelt(:,iexp),[0;tendlibmassbffl_model(1:85)]);
    				max_basalmelt(:,iexp)=max(max_basalmelt(:,iexp),[0;tendlibmassbffl_model(1:85)]);
    			else
    				%Experiment not done by this model, do nothing
    			end
    
    		end %end of model
    	end %end of isexp
    
    	mean_basalmelt=-(mean_basalmelt./num_models'); %positive ocean melt
    	
    	%Figure NorESM
    	figure(1); set(gcf,'color','w'); set(gcf,'Position',[400 500 800 450]);
    	plot(time,mean_basalmelt(:,1),'color','r','linewidth',2); hold on
    	plot(time,mean_basalmelt(:,2),'color',[0.5172 0.5172 1],'linewidth',2); hold on
    	plot(time,mean_basalmelt(:,3),'color',[0 0.5172 0.5862],'linewidth',2); hold on
    	patch([time';flipud(time')],[-min_basalmelt(:,1);flipud(-max_basalmelt(:,1))],[1 0 0]+(1-[1 0 0])*0.25,'FaceAlpha',.3,'EdgeColor','None')
    	patch([time';flipud(time')],[-min_basalmelt(:,2);flipud(-max_basalmelt(:,2))],[0.5172 0.5172 1]+(1-[0.5172 0.5172 1])*0.25,'FaceAlpha',.3,'EdgeColor','None')
    	patch([time';flipud(time')],[-min_basalmelt(:,3);flipud(-max_basalmelt(:,3))],[0 0.5172 0.5862]+(1-[0 0.5172 0.5862])*0.25,'FaceAlpha',.3,'EdgeColor','None')
    	legend({'Median Melt (exp05)','95% Melt (exp09)','5% Melt (exp10)'},'location','NorthWest')
    	legend boxoff
    	xlim([2015 2100])
    	xlabel('Time (yr)');
    	ylabel('Ocean Basal Melt (Gt/yr)');
    	set(gcf,'Position',[400 500 800 450]);
    	h = gcf;
    	set(h,'Units','Inches');
    	pos = get(h,'Position');
    	set(h,'PaperPositionMode','Auto','PaperUnits','Inches','PaperSize',[pos(3), pos(4)]);
    	text(2010,-1600,'a','VerticalAlignment','middle','HorizontalAlignment','right','fontsize',18,'fontweight','b');
    	print(gcf, '-dpng', '-painters', 'FiguresPaperFinal/Figure12a.png');
    
    end %}}}
    if step==20 % {{{Figure 12b
    
    	%All standard models did these runs, so no need to remove anyone
    
    	experiments_list={'exp05','exp13'}; %standard NorESM 
    
    	mean_basalmelt=zeros(86,length(experiments_list));
    	min_basalmelt=9999*ones(86,length(experiments_list));
    	max_basalmelt=-9999*ones(86,length(experiments_list));
    	num_models=zeros(length(experiments_list),1);
    	time=[2015:2100];
    
    	for iexp=1:length(experiments_list),
    		expename=experiments_list{iexp};
    
    		for imodel=1:length(model_list),
    			modelname=model_list{imodel};
    			[group,simul,resolution,ice_density,ocean_density,initial_model_year,expe_model_year,yearday_model,ishist_std,hist_std_name,hist_std_regrid,ishist_open,hist_open_name,hist_open_regrid,isctrl_proj_std,ctrl_proj_std_name,ctrl_proj_std_regrid,isctrl_proj_open,ctrl_proj_open_name,ctrl_proj_open_regrid,isexp01,exp01_name,exp01_regrid,isexp02,exp02_name,exp02_regrid,isexp03,exp03_name,exp03_regrid,isexp04,exp04_name,exp04_regrid,isexp05,exp05_name,exp05_regrid,isexp06,exp06_name,exp06_regrid,isexp07,exp07_name,exp07_regrid,isexp08,exp08_name,exp08_regrid,isexp09,exp09_name,exp09_regrid,isexp10,exp10_name,exp10_regrid,isexp11,exp11_name,exp11_regrid,isexp12,exp12_name,exp12_regrid,isexp13,exp13_name,exp13_regrid,isexpA1,expA1_name,expA1_regrid,isexpA2,expA2_name,expA2_regrid,isexpA3,expA3_name,expA3_regrid,isexpA4,expA4_name,expA4_regrid,isexpA5,expA5_name,expA5_regrid,isexpA6,expA6_name,expA6_regrid,isexpA7,expA7_name,expA7_regrid,isexpA8,expA8_name,expA8_regrid] = specifics(modelname)
    			
    			eval(['isexp=is' expename ';'])
    			if isexp,
    				num_models(iexp)=num_models(iexp)+1;
    				exptendlibmassbffl_file=['' scalarpath '/' group '/' simul '/' expename '/computed_bmbfl_minus_ctrl_proj_AIS_' group '_' simul '_' expename '.nc'];
    				time_model=ncread(exptendlibmassbffl_file,'time');
    				tendlibmassbffl_model=ncread(exptendlibmassbffl_file,'bmbfl')*yearday_model*3600*24/(10^9*1000); %from kg/s to Gt/yr
    				mean_basalmelt(:,iexp)=mean_basalmelt(:,iexp)+[0;tendlibmassbffl_model(1:85)];
    				min_basalmelt(:,iexp)=min(min_basalmelt(:,iexp),[0;tendlibmassbffl_model(1:85)]);
    				max_basalmelt(:,iexp)=max(max_basalmelt(:,iexp),[0;tendlibmassbffl_model(1:85)]);
    			else
    				%Experiment not done by this model, do nothing
    			end
    
    		end %end of model
    	end %end of isexp
    
    	mean_basalmelt=-(mean_basalmelt./num_models'); %positive ocean melt
    
    	%Figure NorESM
    	figure(1); set(gcf,'color','w'); set(gcf,'Position',[400 500 800 450]);
    	plot(time,mean_basalmelt(:,1),'color','r','linewidth',2); hold on
    	plot(time,mean_basalmelt(:,2),'color',[0.8276 0.069 1],'linewidth',2); hold on
    	patch([time';flipud(time')],[-min_basalmelt(:,1);flipud(-max_basalmelt(:,1))],[1 0 0]+(1-[1 0 0])*0.25,'FaceAlpha',.3,'EdgeColor','None')
    	patch([time';flipud(time')],[-min_basalmelt(:,2);flipud(-max_basalmelt(:,2))],[0.8276 0.069 1]+(1-[0.8276 0.069 1])*0.25,'FaceAlpha',.3,'EdgeColor','None')
    	legend({'MeanAnt (exp05)','PIGL (exp13)'},'location','NorthWest')
    	text(2010,-7000,'b','VerticalAlignment','middle','HorizontalAlignment','right','fontsize',18,'fontweight','b');
    	legend boxoff
    	xlim([2015 2100])
    	xlabel('Time (yr)');
    	ylabel('Ocean Basal Melt (Gt/yr)');
    	set(gcf,'Position',[400 500 800 450]);
    	h = gcf;
    	set(h,'Units','Inches');
    	pos = get(h,'Position');
    	set(h,'PaperPositionMode','Auto','PaperUnits','Inches','PaperSize',[pos(3), pos(4)]);
    	print(gcf, '-dpng', '-painters', 'FiguresPaperFinal/Figure12b.png');
    
    end %}}}
    if step==21 % {{{Figure 12c
    
    	%Remove UTAS to have models that did both the 3 model uncertainty NorESM
    	model_list={'AWI_PISM1','DOE_MALI','ILTS_PIK_SICOPOLIS','IMAU_IMAUICE1','IMAU_IMAUICE2','JPL1_ISSM','LSCE_GRISLI','NCAR_CISM','PIK_PISM1','PIK_PISM2','UCIJPL_ISSM','ULB_FETISH32','ULB_FETISH16','VUB_AISMPALEO','VUW_PISM'};
    	experiments_list={'exp05','exp09','exp10'}; %standard NorESM 
    
    	mean_vaf=zeros(86,length(experiments_list));
    	min_vaf=9999*ones(86,length(experiments_list));
    	max_vaf=-9999*ones(86,length(experiments_list));
    	num_models=zeros(length(experiments_list),1);
    	time=[2015:2100];
    
    	for iexp=1:length(experiments_list),
    		expename=experiments_list{iexp};
    
    		for imodel=1:length(model_list),
    			modelname=model_list{imodel};
    			[group,simul,resolution,ice_density,ocean_density,initial_model_year,expe_model_year,yearday_model,ishist_std,hist_std_name,hist_std_regrid,ishist_open,hist_open_name,hist_open_regrid,isctrl_proj_std,ctrl_proj_std_name,ctrl_proj_std_regrid,isctrl_proj_open,ctrl_proj_open_name,ctrl_proj_open_regrid,isexp01,exp01_name,exp01_regrid,isexp02,exp02_name,exp02_regrid,isexp03,exp03_name,exp03_regrid,isexp04,exp04_name,exp04_regrid,isexp05,exp05_name,exp05_regrid,isexp06,exp06_name,exp06_regrid,isexp07,exp07_name,exp07_regrid,isexp08,exp08_name,exp08_regrid,isexp09,exp09_name,exp09_regrid,isexp10,exp10_name,exp10_regrid,isexp11,exp11_name,exp11_regrid,isexp12,exp12_name,exp12_regrid,isexp13,exp13_name,exp13_regrid,isexpA1,expA1_name,expA1_regrid,isexpA2,expA2_name,expA2_regrid,isexpA3,expA3_name,expA3_regrid,isexpA4,expA4_name,expA4_regrid,isexpA5,expA5_name,expA5_regrid,isexpA6,expA6_name,expA6_regrid,isexpA7,expA7_name,expA7_regrid,isexpA8,expA8_name,expA8_regrid] = specifics(modelname)
    			
    			eval(['isexp=is' expename ';'])
    			if isexp,
    				explimnsw_file=['' scalarpath '/' group '/' simul '/' expename '/computed_ivaf_minus_ctrl_proj_AIS_' group '_' simul '_' expename '.nc'];
    				time_model=ncread(explimnsw_file,'time');
    				limnsw_model=ncread(explimnsw_file,'ivaf')*ice_density/(10^9*1000); %from m^3 to Gt
    				mean_vaf(:,iexp)=mean_vaf(:,iexp)+[0;limnsw_model(1:85)];
    				min_vaf(:,iexp)=min(min_vaf(:,iexp),[0;limnsw_model(1:85)]);
    				max_vaf(:,iexp)=max(max_vaf(:,iexp),[0;limnsw_model(1:85)]);
    				num_models(iexp)=num_models(iexp)+1;
    			else
    				%Experiment not done by this model, do nothing
    			end
    
    		end %end of model
    	end %end of isexp
    
    	mean_vaf=-(mean_vaf./num_models')/362.5; %vaf in SLE mm
    
    	%Figure NorESM
    	figure(1); set(gcf,'color','w'); set(gcf,'Position',[400 500 800 450]);
    	plot(time,mean_vaf(:,1),'color','r','linewidth',2); hold on
    	plot(time,mean_vaf(:,2),'color',[0.5172 0.5172 1],'linewidth',2); hold on
    	plot(time,mean_vaf(:,3),'color',[0 0.5172 0.5862],'linewidth',2); hold on
    	patch([time';flipud(time')],[min_vaf(:,1)/-362.5;flipud(max_vaf(:,1)/-362.5)],[1 0 0]+(1-[1 0 0])*0.25,'FaceAlpha',.3,'EdgeColor','None')
    	patch([time';flipud(time')],[min_vaf(:,2)/-362.5;flipud(max_vaf(:,2)/-362.5)],[0.5172 0.5172 1]+(1-[0.5172 0.5172 1])*0.25,'FaceAlpha',.3,'EdgeColor','None')
    	patch([time';flipud(time')],[min_vaf(:,3)/-362.5;flipud(max_vaf(:,3)/-362.5)],[0 0.5172 0.5862]+(1-[0 0.5172 0.5862])*0.25,'FaceAlpha',.3,'EdgeColor','None')
    	legend({'Median Melt (exp05)','95% Melt (exp09)','5% Melt (exp10)'},'location','NorthWest')
    	text(2010,-37,'c','VerticalAlignment','middle','HorizontalAlignment','right','fontsize',18,'fontweight','b');
    	legend boxoff
    	xlim([2015 2100])
    	xlabel('Time (yr)');
    	ylabel('Sea Level Contribution (mm SLE)');
    	set(gcf,'Position',[400 500 800 450]);
    
    	h = gcf;
    	set(h,'Units','Inches');
    	pos = get(h,'Position');
    	set(h,'PaperPositionMode','Auto','PaperUnits','Inches','PaperSize',[pos(3), pos(4)]);
    	print(gcf, '-dpng', '-painters', 'FiguresPaperFinal/Figure12c.png');
    
    end %}}}
    if step==22 % {{{Figure 12d
    
    	%Evebody did it, no need to remove anyone
    	experiments_list={'exp05','exp13'}; %standard NorESM AllMelt and PIGL calibration
    
    	mean_vaf=zeros(86,length(experiments_list));
    	min_vaf=9999*ones(86,length(experiments_list));
    	max_vaf=-9999*ones(86,length(experiments_list));
    	num_models=zeros(length(experiments_list),1);
    	time=[2015:2100];
    
    	for iexp=1:length(experiments_list),
    		expename=experiments_list{iexp};
    
    		for imodel=1:length(model_list),
    			modelname=model_list{imodel};
    			[group,simul,resolution,ice_density,ocean_density,initial_model_year,expe_model_year,yearday_model,ishist_std,hist_std_name,hist_std_regrid,ishist_open,hist_open_name,hist_open_regrid,isctrl_proj_std,ctrl_proj_std_name,ctrl_proj_std_regrid,isctrl_proj_open,ctrl_proj_open_name,ctrl_proj_open_regrid,isexp01,exp01_name,exp01_regrid,isexp02,exp02_name,exp02_regrid,isexp03,exp03_name,exp03_regrid,isexp04,exp04_name,exp04_regrid,isexp05,exp05_name,exp05_regrid,isexp06,exp06_name,exp06_regrid,isexp07,exp07_name,exp07_regrid,isexp08,exp08_name,exp08_regrid,isexp09,exp09_name,exp09_regrid,isexp10,exp10_name,exp10_regrid,isexp11,exp11_name,exp11_regrid,isexp12,exp12_name,exp12_regrid,isexp13,exp13_name,exp13_regrid,isexpA1,expA1_name,expA1_regrid,isexpA2,expA2_name,expA2_regrid,isexpA3,expA3_name,expA3_regrid,isexpA4,expA4_name,expA4_regrid,isexpA5,expA5_name,expA5_regrid,isexpA6,expA6_name,expA6_regrid,isexpA7,expA7_name,expA7_regrid,isexpA8,expA8_name,expA8_regrid] = specifics(modelname)
    			
    			eval(['isexp=is' expename ';'])
    			if isexp,
    				explimnsw_file=['' scalarpath '/' group '/' simul '/' expename '/computed_ivaf_minus_ctrl_proj_AIS_' group '_' simul '_' expename '.nc'];
    				limnsw_model=ncread(explimnsw_file,'ivaf')*ice_density/(10^9*1000); %from m^3 to Gt
    				mean_vaf(:,iexp)=mean_vaf(:,iexp)+[0;limnsw_model(1:85)];
    				min_vaf(:,iexp)=min(min_vaf(:,iexp),[0;limnsw_model(1:85)]);
    				max_vaf(:,iexp)=max(max_vaf(:,iexp),[0;limnsw_model(1:85)]);
    				num_models(iexp)=num_models(iexp)+1;
    			else
    				%Experiment not done by this model, do nothing
    			end
    
    		end %end of model
    	end %end of isexp
    
    	mean_vaf=-(mean_vaf./num_models')/362.5; %vaf in SLE mm
    
    	%Figure NorESM
    	figure(1); set(gcf,'color','w'); set(gcf,'Position',[400 500 800 450]);
    	plot(time,mean_vaf(:,1),'color','r','linewidth',2); hold on
    	plot(time,mean_vaf(:,2),'color',[0.8276 0.069 1],'linewidth',2); hold on
    	patch([time';flipud(time')],[min_vaf(:,1)/-362.5;flipud(max_vaf(:,1)/-362.5)],[1 0 0]+(1-[1 0 0])*0.25,'FaceAlpha',.3,'EdgeColor','None')
    	patch([time';flipud(time')],[min_vaf(:,2)/-362.5;flipud(max_vaf(:,2)/-362.5)],[0.8276 0.069 1]+(1-[0.8276 0.069 1])*0.25,'FaceAlpha',.3,'EdgeColor','None')
    	legend({'MeanAnt (exp05)','PIGL (exp13)'},'location','NorthWest')
    	text(2010,-75,'d','VerticalAlignment','middle','HorizontalAlignment','right','fontsize',18,'fontweight','b');
    	legend boxoff
    	xlim([2015 2100])
    	xlabel('Time (yr)');
    	ylabel('Sea Level Contribution (mm SLE)');
    	set(gcf,'Position',[400 500 800 450]);
    
    	h = gcf;
    	set(h,'Units','Inches');
    	pos = get(h,'Position');
    	set(h,'PaperPositionMode','Auto','PaperUnits','Inches','PaperSize',[pos(3), pos(4)]);
    	print(gcf, '-dpng', '-painters', 'FiguresPaperFinal/Figure12d.png');
    
    end %}}}
    
    %Figure 13: Ice shelf collapse
    if step==23 % {{{Figure 13a
    
    	%Only models that did ice shelf collapse experiment
    	model_list={'AWI_PISM1','DOE_MALI','ILTS_PIK_SICOPOLIS','IMAU_IMAUICE1','IMAU_IMAUICE2','JPL1_ISSM','LSCE_GRISLI','UCIJPL_ISSM','ULB_FETISH32','ULB_FETISH16'};
    	experiments_list={'exp04','exp11','exp08','exp12'}; %open and standard NorESM with and without shelf collapse
    
    	mean_floatingarea=zeros(86,length(experiments_list));
    	std_total=zeros(86,length(experiments_list));
    	num_models=zeros(length(experiments_list),1);
    	time=[2015:2100];
    
    	for iexp=1:length(experiments_list),
    		expename=experiments_list{iexp};
    
    		for imodel=1:length(model_list),
    			modelname=model_list{imodel};
    			[group,simul,resolution,ice_density,ocean_density,initial_model_year,expe_model_year,yearday_model,ishist_std,hist_std_name,hist_std_regrid,ishist_open,hist_open_name,hist_open_regrid,isctrl_proj_std,ctrl_proj_std_name,ctrl_proj_std_regrid,isctrl_proj_open,ctrl_proj_open_name,ctrl_proj_open_regrid,isexp01,exp01_name,exp01_regrid,isexp02,exp02_name,exp02_regrid,isexp03,exp03_name,exp03_regrid,isexp04,exp04_name,exp04_regrid,isexp05,exp05_name,exp05_regrid,isexp06,exp06_name,exp06_regrid,isexp07,exp07_name,exp07_regrid,isexp08,exp08_name,exp08_regrid,isexp09,exp09_name,exp09_regrid,isexp10,exp10_name,exp10_regrid,isexp11,exp11_name,exp11_regrid,isexp12,exp12_name,exp12_regrid,isexp13,exp13_name,exp13_regrid,isexpA1,expA1_name,expA1_regrid,isexpA2,expA2_name,expA2_regrid,isexpA3,expA3_name,expA3_regrid,isexpA4,expA4_name,expA4_regrid,isexpA5,expA5_name,expA5_regrid,isexpA6,expA6_name,expA6_regrid,isexpA7,expA7_name,expA7_regrid,isexpA8,expA8_name,expA8_regrid] = specifics(modelname)
    			
    			eval(['isexp=is' expename ';'])
    			if isexp,
    				num_models(iexp)=num_models(iexp)+1;
    				expiareafl_file=['' scalarpath '/' group '/' simul '/' expename '/computed_iareafl_minus_ctrl_proj_AIS_' group '_' simul '_' expename '.nc'];
    				time_model=ncread(expiareafl_file,'time');
    				iareafl_model=ncread(expiareafl_file,'iareafl')/1000^2; % m^2 to km^2
    				mean_floatingarea(:,iexp)=mean_floatingarea(:,iexp)+[0;iareafl_model(1:85)];
    			else
    				%Experiment not done by this model, do nothing
    			end
    
    		end %end of model
    	end %end of isexp
    	mean_exp=zeros(86,2);
    	mean_exp(:,1)=(mean_floatingarea(:,1)+mean_floatingarea(:,3))/(num_models(1)+num_models(3)); 
    	mean_exp(:,2)=(mean_floatingarea(:,2)+mean_floatingarea(:,4))/(num_models(2)+num_models(4)); 
    	mean_exp_extended=repmat(mean_exp,1,2); %copy twice experiments 4 and 8 and exp 11 and 12
    
    	for iexp=1:length(experiments_list),
    		expename=experiments_list{iexp};
    
    		for imodel=1:length(model_list),
    			modelname=model_list{imodel};
    			exp_params = specifics(modelname)
    
    			eval(['isexp=is' expename ';'])
    			if isexp,
    				expiareafl_file=['' scalarpath '/' group '/' simul '/' expename '/computed_iareafl_minus_ctrl_proj_AIS_' group '_' simul '_' expename '.nc'];
    				time_model=ncread(expiareafl_file,'time');
    				iareafl_model=ncread(expiareafl_file,'iareafl')/1000^2; % m^2 to km^2
    				std_total(:,iexp)=std_total(:,iexp)+([0;iareafl_model(1:85)]-mean_exp_extended(:,iexp)).^2;
    			else
    				%Experiment not done by this model, do nothing
    			end
    
    		end %end of model
    	end %end of isexp
    
    	std_exp=zeros(86,4);
    	std_exp(:,1)=sqrt((std_total(:,1)+std_total(:,3))/(num_models(1)+num_models(3)));
    	std_exp(:,2)=sqrt((std_total(:,2)+std_total(:,4))/(num_models(2)+num_models(4)));
    
    	%Figure NorESM
    	figure(1); set(gcf,'color','w'); set(gcf,'Position',[400 500 800 450]);
    	plot(time,mean_exp(:,1),'color','r','linewidth',2); hold on
    	plot(time,mean_exp(:,2),'color','c','linewidth',2); hold on
    	patch([time';flipud(time')],[mean_exp(:,1)-std_exp(:,1);flipud(mean_exp(:,1)+std_exp(:,1))],[1 0 0]+(1-[1 0 0])*0.25,'FaceAlpha',.3,'EdgeColor','None')
    	patch([time';flipud(time')],[mean_exp(:,2)-std_exp(:,2);flipud(mean_exp(:,2)+std_exp(:,2))],[0 1 1]+(1-[0 1 1])*0.25,'FaceAlpha',.3,'EdgeColor','None')
    	text(2010,-21*10^4,'a','VerticalAlignment','middle','HorizontalAlignment','right','fontsize',18,'fontweight','b');
    	legend({'No shelf collapse (exp04 & exp08)','Ice shelf collapse (exp11 & exp12)'},'location','NorthWest')
    	legend boxoff
    	xlim([2015 2100])
    	xlabel('Time (yr)');
    	ylabel('Floating ice area (km^2)');
    
    	set(gcf,'Position',[400 500 800 450]);
    	h = gcf;
    	set(h,'Units','Inches');
    	pos = get(h,'Position');
    	set(h,'PaperPositionMode','Auto','PaperUnits','Inches','PaperSize',[pos(3), pos(4)]);
    	print(gcf, '-dpng', '-painters', 'FiguresPaperFinal/Figure13a.png');
    
    end %}}}
    if step==24 % {{{Figure 13b
    
    	%Only models that did ice shelf collapse experiment
    	model_list={'AWI_PISM1','DOE_MALI','ILTS_PIK_SICOPOLIS','IMAU_IMAUICE1','IMAU_IMAUICE2','JPL1_ISSM','LSCE_GRISLI','UCIJPL_ISSM','ULB_FETISH32','ULB_FETISH16'};
    
    	experiments_list={'exp04','exp11','exp08','exp12'}; %open and standard NorESM with and without shelf collapse
    
    	mean_vaf=zeros(86,length(experiments_list));
    	std_total=zeros(86,length(experiments_list));
    	num_models=zeros(length(experiments_list),1);
    	time=[2015:2100];
    
    	for iexp=1:length(experiments_list),
    		expename=experiments_list{iexp};
    
    		for imodel=1:length(model_list),
    			modelname=model_list{imodel};
    			[group,simul,resolution,ice_density,ocean_density,initial_model_year,expe_model_year,yearday_model,ishist_std,hist_std_name,hist_std_regrid,ishist_open,hist_open_name,hist_open_regrid,isctrl_proj_std,ctrl_proj_std_name,ctrl_proj_std_regrid,isctrl_proj_open,ctrl_proj_open_name,ctrl_proj_open_regrid,isexp01,exp01_name,exp01_regrid,isexp02,exp02_name,exp02_regrid,isexp03,exp03_name,exp03_regrid,isexp04,exp04_name,exp04_regrid,isexp05,exp05_name,exp05_regrid,isexp06,exp06_name,exp06_regrid,isexp07,exp07_name,exp07_regrid,isexp08,exp08_name,exp08_regrid,isexp09,exp09_name,exp09_regrid,isexp10,exp10_name,exp10_regrid,isexp11,exp11_name,exp11_regrid,isexp12,exp12_name,exp12_regrid,isexp13,exp13_name,exp13_regrid,isexpA1,expA1_name,expA1_regrid,isexpA2,expA2_name,expA2_regrid,isexpA3,expA3_name,expA3_regrid,isexpA4,expA4_name,expA4_regrid,isexpA5,expA5_name,expA5_regrid,isexpA6,expA6_name,expA6_regrid,isexpA7,expA7_name,expA7_regrid,isexpA8,expA8_name,expA8_regrid] = specifics(modelname)
    			
    			eval(['isexp=is' expename ';'])
    			if isexp,
    				num_models(iexp)=num_models(iexp)+1;
    				explimnsw_file=['' scalarpath '/' group '/' simul '/' expename '/computed_ivaf_minus_ctrl_proj_AIS_' group '_' simul '_' expename '.nc'];
    				limnsw_model=ncread(explimnsw_file,'ivaf')*ice_density/(10^9*1000); %from m^3 to Gt
    				time_model=ncread(explimnsw_file,'time');
    				mean_vaf(:,iexp)=mean_vaf(:,iexp)+[0;limnsw_model(1:85)];
    			else
    				%Experiment not done by this model, do nothing
    			end
    
    		end %end of model
    	end %end of isexp
    	mean_exp=zeros(86,2);
    	mean_exp(:,1)=(mean_vaf(:,1)+mean_vaf(:,3))/(num_models(1)+num_models(3)); 
    	mean_exp(:,2)=(mean_vaf(:,2)+mean_vaf(:,4))/(num_models(2)+num_models(4)); 
    	mean_exp_extended=repmat(mean_exp,1,2);
    
    	for iexp=1:length(experiments_list),
    		expename=experiments_list{iexp};
    
    		for imodel=1:length(model_list),
    			modelname=model_list{imodel};
    			exp_params = specifics(modelname)
    
    			eval(['isexp=is' expename ';'])
    			if isexp,
    				explimnsw_file=['' scalarpath '/' group '/' simul '/' expename '/computed_ivaf_minus_ctrl_proj_AIS_' group '_' simul '_' expename '.nc'];
    				time_model=ncread(explimnsw_file,'time');
    				limnsw_model=ncread(explimnsw_file,'ivaf')*ice_density/(10^9*1000); %from m^3 to Gt
    				std_total(:,iexp)=std_total(:,iexp)+([0;limnsw_model(1:85)]-mean_exp_extended(:,iexp)).^2;
    			else
    				%Experiment not done by this model, do nothing
    			end
    
    		end %end of model
    	end %end of isexp
    
    	std_exp=zeros(86,3);
    	std_exp(:,1)=sqrt((std_total(:,1)+std_total(:,3))/(num_models(1)+num_models(3)));
    	std_exp(:,2)=sqrt((std_total(:,2)+std_total(:,4))/(num_models(2)+num_models(4)));
    
    	mean_exp=-mean_exp/362.5; %vaf in SLE mm
    	std_exp=std_exp/362.5; %in SLE mm
    
    	%Figure NorESM
    	figure(1); set(gcf,'color','w'); set(gcf,'Position',[400 500 800 450]);
    	plot(time,mean_exp(:,1),'color','r','linewidth',2); hold on
    	plot(time,mean_exp(:,2),'color','c','linewidth',2); hold on
    	patch([time';flipud(time')],[mean_exp(:,1)-std_exp(:,1);flipud(mean_exp(:,1)+std_exp(:,1))],[1 0 0]+(1-[1 0 0])*0.25,'FaceAlpha',.3,'EdgeColor','None')
    	patch([time';flipud(time')],[mean_exp(:,2)-std_exp(:,2);flipud(mean_exp(:,2)+std_exp(:,2))],[0 1 1]+(1-[0 1 1])*0.25,'FaceAlpha',.3,'EdgeColor','None')
    	text(2010,-85,'b','VerticalAlignment','middle','HorizontalAlignment','right','fontsize',18,'fontweight','b');
    	legend({'No shelf collapse (exp04 & exp08)','Ice shelf collapse (exp11 & exp12)'},'location','NorthWest')
    	legend boxoff
    	xlim([2015 2100])
    	xlabel('Time (yr)');
    	ylabel('Sea Level Contribution (mm SLE)');
    	set(gcf,'Position',[400 500 800 450]);
    	h = gcf;
    	set(h,'Units','Inches');
    	pos = get(h,'Position');
    	set(h,'PaperPositionMode','Auto','PaperUnits','Inches','PaperSize',[pos(3), pos(4)]);
    	print(gcf, '-dpng', '-painters', 'FiguresPaperFinal/Figure13b.png');
    
    end %}}}
    
    %Figure 14: Ice shelf collapse spatial changes
    if step==25 % {{{Figure 14a
    
    	experiments_list={'exp11','exp12'}; %ice shelf collapse experiments
    	nummodels=zeros(761,761);
    	totalthicknesschange=zeros(761,761);
    	thicknessstd=zeros(761,761);
    
    	for iexp=1:length(experiments_list),
    		expename=experiments_list{iexp};
    
    		for imodel=1:length(model_list),
    			modelname=model_list{imodel};
    			exp_params = specifics(modelname)
    			eval(['exp_name=' expename '_regrid;'])
    			exp_directory=['' gridpath '/' group '/' simul '/' exp_name '/'];
    			if strcmp(expename,'exp11'),
    				eval(['ctrl_proj_name=exp04_regrid;'])
    				ctrl_directory=['' gridpath '/' group '/' simul '/' ctrl_proj_name '/'];
    			elseif strcmp(expename,'exp12'),
    				eval(['ctrl_proj_name=exp08_regrid;'])
    				ctrl_directory=['' gridpath '/' group '/' simul '/' ctrl_proj_name '/'];
    			end
    
    			eval(['isexp=is' expename ';'])
    			if isexp,
    				if exist(exp_directory,'dir')==0,
    					error(['directory ' exp_directory ' not found']);
    				end
    
    				if is_lithk==1,
    					field='lithk';
    					exp_file=[exp_directory '/' field '_AIS_' group '_' simul '_' expename '.nc'];
    					mask_file=[exp_directory '/sftgif_AIS_' group '_' simul '_' expename '.nc'];
    					if strcmp(expename,'exp11'),
    						ctrl_file=[ctrl_directory '/' field '_AIS_' group '_' simul '_exp04.nc'];
    						maskctrl_file=[ctrl_directory '/sftgif_AIS_' group '_' simul '_exp04.nc'];
    					elseif strcmp(expename,'exp12'),
    						ctrl_file=[ctrl_directory '/' field '_AIS_' group '_' simul '_exp08.nc'];
    						maskctrl_file=[ctrl_directory '/sftgif_AIS_' group '_' simul '_exp08.nc'];
    					end
    
    					data = rot90(double(ncread(exp_file,field)));
    					datac = rot90(double(ncread(ctrl_file,field)));
    					mask = rot90(double(ncread(mask_file,'sftgif')));
    					maskctrl= rot90(double(ncread(maskctrl_file,'sftgif')));
    					if size(data)~=[761,761,21];
    						error(['warming: file ' exp_file ' has the wrong size']);
    					end
    					data_init=data(:,:,end-85).*mask(:,:,end-85);
    					data_end=data(:,:,end).*mask(:,:,end);
    					datac_init=datac(:,:,end-85).*maskctrl(:,:,end-85);
    					datac_end=datac(:,:,end).*maskctrl(:,:,1);
    					pos=find(data_init~=0 & ~isnan(data_init) & data_end~=0 & ~isnan(data_end) & datac_init~=0 & ~isnan(datac_init) & datac_end~=0 & ~isnan(datac_end));
    					nummodels(pos)=nummodels(pos)+1;
    					totalthicknesschange(pos)=totalthicknesschange(pos)+data_end(pos)-data_init(pos)-(datac_end(pos)-datac_init(pos));
    
    				end
    			end
    		end
    	end
    	mean_thicknesschange=totalthicknesschange./nummodels;
    	pos=find(nummodels<5);
    	mean_thicknesschange(pos)=NaN;
    	collapsed_shelf=rot90(ncread('/u/astrid-r1b/seroussi/issmjpl/proj-seroussi/ISMIP6Projections/ForcingsPrep/OutputFiles/ice_shelf_collapse_mask_CCSM4_1995-2100_08km.nc','mask')); %ice shelf mask provided in ISMIP6 forcings at 8 km resolution
    	collapsed_shelf_end=collapsed_shelf(:,:,end);
    	pos=find(collapsed_shelf_end>0.5);
    	mean_thicknesschange(pos)=NaN;
    
    	%plot results
    	close; set(gcf,'color','w'); set(gcf,'Position',[400 400 700 500]);
    	[pos_nani pos_nanj]=find(isnan(mean_thicknesschange));
    	data_min=-100; data_max=100;
    	colorm = jet(100);
    	%colormap used in the paper can be found here: https://www.mathworks.com/matlabcentral/fileexchange/17555-light-bartlein-color-maps
    	image_rgb = ind2rgb(uint16((max(data_min,min(data_max,mean_thicknesschange)) - data_min)*(size(colorm,1)/(data_max-data_min))),colorm);
    	image_rgb(sub2ind(size(image_rgb),repmat(pos_nani,1,3),repmat(pos_nanj,1,3),repmat(1:3,size(pos_nani,1),1))) = repmat([1 1 1],size(pos_nani,1),1);
    	imagesc(-3040:6080/size(mean_thicknesschange,2):3040,-3040:6080/size(mean_thicknesschange,1):3040,image_rgb);
    	colormap(jet); colorbar; caxis([data_min data_max]); set(gca,'fontsize',14); hcb=colorbar; title(hcb,'m');
    	hold on
    	x=repmat(-3040:6080/size(mean_thicknesschange,2):3040,length(-3040:6080/size(mean_thicknesschange,2):3040),1);
    	y=x';
    	x=(x(1:end-1,1:end-1)+x(2:end,2:end))/2;
    	y=(y(1:end-1,1:end-1)+y(2:end,2:end))/2;
    	[c1, h1]=contourf(x,y,collapsed_shelf_end,[0.5 0.5]);
    	set(h1,'linestyle','none','Tag','HatchingRegion');
    	ax1 = gca;
    	ax1.XLim=[-3040 3032];
    	ax1.YLim=[-3040 3032];
    	hp = findobj(ax1,'Tag','HatchingRegion');
    	hh = hatchfill2(hp,'single','LineWidth',1,'Fill','off','HatchDensity',150,'HatchColor','k');
    	colorbar; axis('equal','off'); xlim([-3040 3040]); ylim([-3040 3040]);
    	text(-2400,2400,'a','VerticalAlignment','middle','HorizontalAlignment','right','fontsize',18,'fontweight','b');
    
    	h = gcf;
    	set(h,'Units','Inches');
    	pos = get(h,'Position');
    	set(h,'PaperPositionMode','Auto','PaperUnits','Inches','PaperSize',[pos(3), pos(4)]);
    	print(gcf, '-dpng', '-painters', 'FiguresPaperFinal/Figure14a.png');
    
    end %}}}
    if step==26 % {{{Figure 14b
    
    	experiments_list={'exp11','exp12'}; %ice shelf collapse experiments
    	nummodels=zeros(761,761);
    	totalvelocitychange=zeros(761,761);
    	velocitystd=zeros(761,761);
    
    	for iexp=1:length(experiments_list),
    		expename=experiments_list{iexp};
    
    		for imodel=1:length(model_list),
    			modelname=model_list{imodel};
    			exp_params = specifics(modelname)
    			eval(['exp_name=' expename '_regrid;'])
    			exp_directory=['' gridpath '/' group '/' simul '/' exp_name '/'];
    			if strcmp(expename,'exp11'),
    				eval(['ctrl_proj_name=exp04_regrid;'])
    				ctrl_directory=['' gridpath '/' group '/' simul '/' ctrl_proj_name '/'];
    			elseif strcmp(expename,'exp12'),
    				eval(['ctrl_proj_name=exp08_regrid;'])
    				ctrl_directory=['' gridpath '/' group '/' simul '/' ctrl_proj_name '/'];
    			end
    
    			eval(['isexp=is' expename ';'])
    			if isexp,
    				if exist(exp_directory,'dir')==0,
    					error(['directory ' exp_directory ' not found']);
    				end
    
    			if is_xvelmean==1, 
    				field='xvelmean'; field2='yvelmean';
    			else error('should have some velocity fields');
    			end
    			exp_file=[exp_directory '/' field '_AIS_' group '_' simul '_' expename '.nc'];
    			exp_file2=[exp_directory '/' field2 '_AIS_' group '_' simul '_' expename '.nc'];
    			if strcmp(expename,'exp11'),
    				ctrl_file=[ctrl_directory '/' field '_AIS_' group '_' simul '_exp04.nc'];
    				ctrl_file2=[ctrl_directory '/' field2 '_AIS_' group '_' simul '_exp04.nc'];
    			elseif strcmp(expename,'exp12'),
    				ctrl_file=[ctrl_directory '/' field '_AIS_' group '_' simul '_exp08.nc'];
    				ctrl_file2=[ctrl_directory '/' field2 '_AIS_' group '_' simul '_exp08.nc'];
    			end
    
    			datau = rot90(double(ncread(exp_file,field)));
    			datav = rot90(double(ncread(exp_file2,field2)));
    			data=sqrt(datau.^2+datav.^2)*31556926;
    			datacu = rot90(double(ncread(ctrl_file,field)));
    			datacv = rot90(double(ncread(ctrl_file2,field2)));
    			datac=sqrt(datacu.^2+datacv.^2)*31556926;
    			if size(data)~=[761,761,21];
    				error(['warming: file ' abmb_file ' has the wrong size']);
    			end
    			data_init=data(:,:,1);
    			data_end=data(:,:,end);
    			datac_init=datac(:,:,1);
    			datac_end=datac(:,:,end);
    			pos=find(datac_init~=0 & ~isnan(datac_init) & datac_end~=0 & ~isnan(datac_end) & datac_init~=0 & ~isnan(datac_init) & datac_end~=0 & ~isnan(datac_end)); 
    			nummodels(pos)=nummodels(pos)+1;
    			totalvelocitychange(pos)=totalvelocitychange(pos)+(data_end(pos)-data_init(pos)) - (datac_end(pos)-datac_init(pos));
    
    		end
    	end
    	end
    	mean_velocitychange=totalvelocitychange./nummodels;
    	pos=find(nummodels<5);
    	mean_velocitychange(pos)=NaN;
    	collapsed_shelf=rot90(ncread('/u/astrid-r1b/seroussi/issmjpl/proj-seroussi/ISMIP6Projections/ForcingsPrep/OutputFiles/ice_shelf_collapse_mask_CCSM4_1995-2100_08km.nc','mask')); %ice shelf mask provided in ISMIP6 forcings at 8 km resolution
    	collapsed_shelf_end=collapsed_shelf(:,:,end);
    	pos=find(collapsed_shelf_end>0.5);
    	mean_velocitychange(pos)=NaN;
    
    	%plot results
    	set(gcf,'color','w'); set(gcf,'Position',[400 400 700 500]);
    	[pos_nani pos_nanj]=find(isnan(mean_velocitychange));
    	data_min=-100; data_max=100;
    	colorm = jet(100);
    	%colormap used in the paper can be found here: https://www.mathworks.com/matlabcentral/fileexchange/17555-light-bartlein-color-maps
    	image_rgb = ind2rgb(uint16((max(data_min,min(data_max,mean_velocitychange)) - data_min)*(size(colorm,1)/(data_max-data_min))),colorm);
    	image_rgb(sub2ind(size(image_rgb),repmat(pos_nani,1,3),repmat(pos_nanj,1,3),repmat(1:3,size(pos_nani,1),1))) = repmat([1 1 1],size(pos_nani,1),1);
    	imagesc(-3040:6080/size(mean_velocitychange,2):3040,-3040:6080/size(mean_velocitychange,1):3040,image_rgb); 
    	hold on
    	x=repmat(-3040:6080/size(mean_velocitychange,2):3040,length(-3040:6080/size(mean_velocitychange,2):3040),1);
    	y=x';
    	x=(x(1:end-1,1:end-1)+x(2:end,2:end))/2;
    	y=(y(1:end-1,1:end-1)+y(2:end,2:end))/2;
    	[c1, h1]=contourf(x,y,collapsed_shelf_end,[0.5 0.5]);
    	set(h1,'linestyle','none','Tag','HatchingRegion');
    	ax1 = gca;
    	ax1.XLim=[-3040 3032];
    	ax1.YLim=[-3040 3032];
    	hp = findobj(ax1,'Tag','HatchingRegion');
    	hh = hatchfill2(hp,'single','LineWidth',1,'Fill','off','HatchDensity',150,'HatchColor','k');
    	axis('equal','off'); xlim([-3040 3040]); ylim([-3040 3040]);
    	colormap(jet); colorbar; caxis([data_min data_max]); set(gca,'fontsize',14); hcb=colorbar; title(hcb,'m/yr');
    	text(-2400,2400,'b','VerticalAlignment','middle','HorizontalAlignment','right','fontsize',18,'fontweight','b');
    
    	h = gcf;
    	set(h,'Units','Inches');
    	pos = get(h,'Position');
    	set(h,'PaperPositionMode','Auto','PaperUnits','Inches','PaperSize',[pos(3), pos(4)]);
    	print(gcf, '-dpng', '-painters', 'FiguresPaperFinal/Figure14b.png');
    end %}}}
    
    %Figure 15: regional sensitivity
    if step==27 % {{{Figure 15
    
    	colors = distinguishable_colors(18); %number of basins
    	experiments_list={'exp01','exp02','exp04','exp05','exp06','exp08','expA1','expA2','expA3','expA5','expA6','expA7'}; %open and standard RCP8.5
    
    	for isector=1:18,
    		eval(['sensitivity_results_limnsw_sector' num2str(isector) '=[];'])
    		eval(['sensitivity_results_tendacabfgr_sector' num2str(isector) '=[];'])
    		eval(['sensitivity_results_tendlibmassbffl_sector' num2str(isector) '=[];'])
    	end
    
    	for imodel=1:length(model_list),
    		modelname=model_list{imodel};
    		for iexp=1:length(experiments_list),
    			expename=experiments_list{iexp};
    			exp_params = specifics(modelname)
    
    			eval(['isexp=is' expename ';'])
    			if isexp,
    				explimnsw_file=['' scalarpath '/' group '/' simul '/' expename '/computed_ivaf_minus_ctrl_proj_AIS_' group '_' simul '_' expename '.nc'];
    				exptendacabfgr_file=['' scalarpath '/' group '/' simul '/' expename '/computed_smbgr_minus_ctrl_proj_AIS_' group '_' simul '_' expename '.nc'];
    				exptendlibmassbffl_file=['' scalarpath '/' group '/' simul '/' expename '/computed_bmbfl_minus_ctrl_proj_AIS_' group '_' simul '_' expename '.nc'];
    
    				for isector=1:18,
    					eval(['results_tendlibmassbffl_sector' num2str(isector) '=ncread(exptendlibmassbffl_file,''bmbfl_sector_' num2str(isector) ''') *yearday_model*3600*24/(10^9*1000);']) %from kg/s to Gt/yr
    					eval(['sensitivity_results_tendlibmassbffl_sector' num2str(isector) '(end+1)=sum(results_tendlibmassbffl_sector' num2str(isector) '(1:85));'])
    
    					eval(['results_tendacabfgr_sector' num2str(isector) '=ncread(exptendacabfgr_file,''smbgr_sector_' num2str(isector) ''')*yearday_model*3600*24/(10^9*1000);']) %from kg/s to Gt/yr
    					eval(['sensitivity_results_tendacabfgr_sector' num2str(isector) '(end+1)=sum(results_tendacabfgr_sector' num2str(isector) '(1:85));'])
    
    					eval(['results_limnsw_sector' num2str(isector) '=ncread(explimnsw_file,''ivaf_sector_' num2str(isector) ''') *ice_density/(10^9*1000);']) %from m^3 to Gt
    					eval(['sensitivity_results_limnsw_sector' num2str(isector) '(end+1)=results_limnsw_sector' num2str(isector) '(85);'])
    				end
    			end
    
    		end %end of model
    	end %end of isexp
    
    	%Plot results per region
    	figure(1); set(gcf,'color','w'); set(gcf,'Position',[400 500 800 500]);
    	for ibasin=1:18,
    		eval(['plot(-sensitivity_results_tendlibmassbffl_sector' num2str(ibasin) ',-(sensitivity_results_limnsw_sector' num2str(ibasin) '-sensitivity_results_tendacabfgr_sector' num2str(ibasin) ')/362.5,''.'',''color'',colors(ibasin,:));'])
    		hold on
    	end
    	ylabel('Dynamic mass loss (mm SLE)');
    	xlabel('Ice shelf melt (Gt)');
    	xlim([-0.1 1.6]*10^5)
    	ylim([-20 140])
    	text(-1.2*10^4,-28,'b','VerticalAlignment','middle','HorizontalAlignment','right','fontsize',18,'fontweight','b');
    	h = gcf;
    	set(h,'Units','Inches');
    	pos = get(h,'Position');
    	set(h,'PaperPositionMode','Auto','PaperUnits','Inches','PaperSize',[pos(3), pos(4)]);
    	print(gcf, '-dpng', '-painters', 'FiguresPaperFinal/Figure15.png');
    
    	%Now create inset map to show the color of each region
    	colorm = distinguishable_colors(18);
    	sectors_8km=flipud(rot90(double(ncread('Data/sectors_8km_iceonly.nc','sectors')))); %18 sectors with ice regions only
    	set(gcf,'color','w');
    	[pos_nani pos_nanj]=find(isnan(sectors_8km) | sectors_8km==0);
    	data_min=1; data_max=19;
    	image_rgb = ind2rgb(uint16((max(data_min,min(data_max,sectors_8km)) - data_min)*(size(colorm,1)/(data_max-data_min))),colorm);
    	image_rgb(sub2ind(size(image_rgb),repmat(pos_nani,1,3),repmat(pos_nanj,1,3),repmat(1:3,size(pos_nani,1),1))) = repmat([1 1 1],size(pos_nani,1),1);
    	imagesc(-3040:6080/size(sectors_8km,2):3040,-3040:6080/size(sectors_8km,1):3040,image_rgb); colorbar('off');
    	set(gca,'fontsize',14);
    	colorbar('off'); axis('equal','off'); xlim([-3040 3040]); ylim([-3040 3040]);
    	h = gcf;
    	set(h,'Units','Inches');
    	pos = get(h,'Position');
    	set(h,'PaperPositionMode','Auto','PaperUnits','Inches','PaperSize',[pos(3), pos(4)]);
    	print(gcf, '-dpng', '-painters', 'FiguresPaperFinal/Figure15inset.png');
    
    end %}}}
    close;
end

function [group,simul,resolution,ice_density,ocean_density,initial_model_year,expe_model_year,yearday_model,ishist_std,hist_std_name,hist_std_regrid,ishist_open,hist_open_name,hist_open_regrid,isctrl_proj_std,ctrl_proj_std_name,ctrl_proj_std_regrid,isctrl_proj_open,ctrl_proj_open_name,ctrl_proj_open_regrid,isexp01,exp01_name,exp01_regrid,isexp02,exp02_name,exp02_regrid,isexp03,exp03_name,exp03_regrid,isexp04,exp04_name,exp04_regrid,isexp05,exp05_name,exp05_regrid,isexp06,exp06_name,exp06_regrid,isexp07,exp07_name,exp07_regrid,isexp08,exp08_name,exp08_regrid,isexp09,exp09_name,exp09_regrid,isexp10,exp10_name,exp10_regrid,isexp11,exp11_name,exp11_regrid,isexp12,exp12_name,exp12_regrid,isexp13,exp13_name,exp13_regrid,isexpA1,expA1_name,expA1_regrid,isexpA2,expA2_name,expA2_regrid,isexpA3,expA3_name,expA3_regrid,isexpA4,expA4_name,expA4_regrid,isexpA5,expA5_name,expA5_regrid,isexpA6,expA6_name,expA6_regrid,isexpA7,expA7_name,expA7_regrid,isexpA8,expA8_name,expA8_regrid] = specifics(modelname)
    if strcmp(modelname,'AWI_PISM1'),
    	group='AWI'; simul='PISM1'; resolution=8; 
    	ice_density=910; ocean_density=1023;
    	initial_model_year=2005;
    	expe_model_year=2005;
    	yearday_model=365;
    	ishist_std=1; hist_std_name='hist_08'; hist_std_regrid='hist_08';
    	ishist_open=1; hist_open_name='hist_open_08'; hist_open_regrid='hist_open_08';
    	isctrl_proj_std=1; ctrl_proj_std_name='ctrl_proj_std_08'; ctrl_proj_std_regrid='ctrl_proj_std_08';
    	isctrl_proj_open=1; ctrl_proj_open_name='ctrl_proj_open_08'; ctrl_proj_open_regrid='ctrl_proj_open_08';
    	isexp01=1; exp01_name='exp01_08'; exp01_regrid='exp01_08';
    	isexp02=1; exp02_name='exp02_08'; exp02_regrid='exp02_08';
    	isexp03=1; exp03_name='exp03_08'; exp03_regrid='exp03_08';
    	isexp04=1; exp04_name='exp04_08'; exp04_regrid='exp04_08';
    	isexp05=1; exp05_name='exp05_08'; exp05_regrid='exp05_08';
    	isexp06=1; exp06_name='exp06_08'; exp06_regrid='exp06_08';
    	isexp07=1; exp07_name='exp07_08'; exp07_regrid='exp07_08';
    	isexp08=1; exp08_name='exp08_08'; exp08_regrid='exp08_08';
    	isexp09=1; exp09_name='exp09_08'; exp09_regrid='exp09_08';
    	isexp10=1; exp10_name='exp10_08'; exp10_regrid='exp10_08';
    	isexp11=1; exp11_name='exp11_08'; exp11_regrid='exp11_08';
    	isexp12=1; exp12_name='exp12_08'; exp12_regrid='exp12_08';
    	isexp13=1; exp13_name='exp13_08'; exp13_regrid='exp13_08';
    	isexpA1=1; expA1_name='expA1_08'; expA1_regrid='expA1_08';
    	isexpA2=1; expA2_name='expA2_08'; expA2_regrid='expA2_08';
    	isexpA3=1; expA3_name='expA3_08'; expA3_regrid='expA3_08';
    	isexpA4=1; expA4_name='expA4_08'; expA4_regrid='expA4_08';
    	isexpA5=1; expA5_name='expA5_08'; expA5_regrid='expA5_08';
    	isexpA6=1; expA6_name='expA6_08'; expA6_regrid='expA6_08';
    	isexpA7=1; expA7_name='expA7_08'; expA7_regrid='expA7_08';
    	isexpA8=1; expA8_name='expA8_08'; expA8_regrid='expA8_08';
    elseif strcmp(modelname,'DOE_MALI'),
    	group='DOE'; simul='MALI'; resolution=8; 
    	ice_density=910; ocean_density=1023;
    	initial_model_year=2015;
    	expe_model_year=2015;
    	yearday_model=365;
    	ishist_std=0; hist_std_name='hist_08'; hist_std_regrid='hist_08';
    	ishist_open=0; hist_open_name='hist_08'; hist_open_regrid='hist_08';
    	isctrl_proj_std=1; ctrl_proj_std_name='ctrl_proj_std_08'; ctrl_proj_std_regrid='ctrl_proj_std_08';
    	isctrl_proj_open=0; ctrl_proj_open_name='ctrl_08'; ctrl_proj_open_regrid='ctrl_08';
    	isexp01=0; exp01_name='exp01_08'; exp01_regrid='exp01_08';
    	isexp02=0; exp02_name='exp02_08'; exp02_regrid='exp02_08';
    	isexp03=0; exp03_name='exp03_08'; exp03_regrid='exp03_08';
    	isexp04=0; exp04_name='exp04_08'; exp04_regrid='exp04_08';
    	isexp05=1; exp05_name='exp05_08'; exp05_regrid='exp05_08';
    	isexp06=1; exp06_name='exp06_08'; exp06_regrid='exp06_08';
    	isexp07=1; exp07_name='exp07_08'; exp07_regrid='exp07_08';
    	isexp08=1; exp08_name='exp08_08'; exp08_regrid='exp08_08';
    	isexp09=1; exp09_name='exp09_08'; exp09_regrid='exp09_08';
    	isexp10=1; exp10_name='exp10_08'; exp10_regrid='exp10_08';
    	isexp11=0; exp11_name='exp11_08'; exp11_regrid='exp11_08';
    	isexp12=1; exp12_name='exp12_08'; exp12_regrid='exp12_08';
    	isexp13=1; exp13_name='exp13_08'; exp13_regrid='exp13_08';
    	isexpA1=0; expA1_name='expA1_08'; expA1_regrid='expA1_08';
    	isexpA2=0; expA2_name='expA2_08'; expA2_regrid='expA2_08';
    	isexpA3=0; expA3_name='expA3_08'; expA3_regrid='expA3_08';
    	isexpA4=0; expA4_name='expA4_08'; expA4_regrid='expA4_08';
    	isexpA5=0; expA5_name='expA5_08'; expA5_regrid='expA5_08';
    	isexpA6=0; expA6_name='expA6_08'; expA6_regrid='expA6_08';
    	isexpA7=0; expA7_name='expA7_08'; expA7_regrid='expA7_08';
    	isexpA8=0; expA8_name='expA8_08'; expA8_regrid='expA8_08';
    elseif strcmp(modelname,'ILTS_PIK_SICOPOLIS'),
    	group='ILTS_PIK'; simul='SICOPOLIS'; resolution=8; 
    	ice_density=910; ocean_density=1028;
    	initial_model_year=1990;
    	expe_model_year=1990;
    	yearday_model=360;
    	ishist_std=1; hist_std_name='hist_08'; hist_std_regrid='hist_08';
    	ishist_open=0; hist_open_name='hist_08'; hist_open_regrid='hist_08';
    	isctrl_proj_std=1; ctrl_proj_std_name='ctrl_proj_std_08'; ctrl_proj_std_regrid='ctrl_proj_std_08';
    	isctrl_proj_open=0; ctrl_proj_open_name='ctrl_08'; ctrl_proj_open_regrid='ctrl_08';
    	isexp01=0; exp01_name='exp01_08'; exp01_regrid='exp01_08';
    	isexp02=0; exp02_name='exp02_08'; exp02_regrid='exp02_08';
    	isexp03=0; exp03_name='exp03_08'; exp03_regrid='exp03_08';
    	isexp04=0; exp04_name='exp04_08'; exp04_regrid='exp04_08';
    	isexp05=1; exp05_name='exp05_08'; exp05_regrid='exp05_08';
    	isexp06=1; exp06_name='exp06_08'; exp06_regrid='exp06_08';
    	isexp07=1; exp07_name='exp07_08'; exp07_regrid='exp07_08';
    	isexp08=1; exp08_name='exp08_08'; exp08_regrid='exp08_08';
    	isexp09=1; exp09_name='exp09_08'; exp09_regrid='exp09_08';
    	isexp10=1; exp10_name='exp10_08'; exp10_regrid='exp10_08';
    	isexp11=0; exp11_name='exp11_08'; exp11_regrid='exp11_08';
    	isexp12=1; exp12_name='exp12_08'; exp12_regrid='exp12_08';
    	isexp13=1; exp13_name='exp13_08'; exp13_regrid='exp13_08';
    	isexpA1=0; expA1_name='expA1_08'; expA1_regrid='expA1_08';
    	isexpA2=0; expA2_name='expA2_08'; expA2_regrid='expA2_08';
    	isexpA3=0; expA3_name='expA3_08'; expA3_regrid='expA3_08';
    	isexpA4=0; expA4_name='expA4_08'; expA4_regrid='expA4_08';
    	isexpA5=1; expA5_name='expA5_08'; expA5_regrid='expA5_08';
    	isexpA6=1; expA6_name='expA6_08'; expA6_regrid='expA6_08';
    	isexpA7=1; expA7_name='expA7_08'; expA7_regrid='expA7_08';
    	isexpA8=1; expA8_name='expA8_08'; expA8_regrid='expA8_08';
    elseif strcmp(modelname,'IMAU_IMAUICE1'),
    	group='IMAU'; simul='IMAUICE1'; resolution=32; 
    	ice_density=910; ocean_density=1028;
    	initial_model_year=1900;
    	expe_model_year=1900;
    	yearday_model=365.25;
    	ishist_std=1; hist_std_name='hist_32'; hist_std_regrid='hist_08';
    	ishist_open=0; hist_open_name='hist_08'; hist_open_regrid='hist_08';
    	isctrl_proj_std=1; ctrl_proj_std_name='ctrl_proj_std_32'; ctrl_proj_std_regrid='ctrl_proj_std_08';
    	isctrl_proj_open=0; ctrl_proj_open_name='ctrl_08'; ctrl_proj_open_regrid='ctrl_08';
    	isexp01=0; exp01_name='exp01_32'; exp01_regrid='exp01_08';
    	isexp02=0; exp02_name='exp02_32'; exp02_regrid='exp02_08';
    	isexp03=0; exp03_name='exp03_32'; exp03_regrid='exp03_08';
    	isexp04=0; exp04_name='exp04_32'; exp04_regrid='exp04_08';
    	isexp05=1; exp05_name='exp05_32'; exp05_regrid='exp05_08';
    	isexp06=1; exp06_name='exp06_32'; exp06_regrid='exp06_08';
    	isexp07=1; exp07_name='exp07_32'; exp07_regrid='exp07_08';
    	isexp08=1; exp08_name='exp08_32'; exp32_regrid='exp08_08';
    	isexp09=1; exp09_name='exp09_32'; exp09_regrid='exp09_08';
    	isexp10=1; exp10_name='exp10_32'; exp10_regrid='exp10_08';
    	isexp11=0; exp11_name='exp11_32'; exp11_regrid='exp11_08';
    	isexp12=1; exp12_name='exp12_32'; exp12_regrid='exp12_08';
    	isexp13=1; exp13_name='exp13_32'; exp13_regrid='exp13_08';
    	isexpA1=0; expA1_name='expA1_08'; expA1_regrid='expA1_08';
    	isexpA2=0; expA2_name='expA2_08'; expA2_regrid='expA2_08';
    	isexpA3=0; expA3_name='expA3_08'; expA3_regrid='expA3_08';
    	isexpA4=0; expA4_name='expA4_08'; expA4_regrid='expA4_08';
    	isexpA5=0; expA5_name='expA5_08'; expA5_regrid='expA5_08';
    	isexpA6=0; expA6_name='expA6_08'; expA6_regrid='expA6_08';
    	isexpA7=0; expA7_name='expA7_08'; expA7_regrid='expA7_08';
    	isexpA8=0; expA8_name='expA8_08'; expA8_regrid='expA8_08';
    elseif strcmp(modelname,'IMAU_IMAUICE2'),
    	group='IMAU'; simul='IMAUICE2'; resolution=32; 
    	ice_density=910; ocean_density=1028;
    	initial_model_year=1900;
    	expe_model_year=1900;
    	yearday_model=365.25;
    	ishist_std=1; hist_std_name='hist_32'; hist_std_regrid='hist_08';
    	ishist_open=0; hist_open_name='hist_08'; hist_open_regrid='hist_08';
    	isctrl_proj_std=1; ctrl_proj_std_name='ctrl_proj_std_32'; ctrl_proj_std_regrid='ctrl_proj_std_08';
    	isctrl_proj_open=0; ctrl_proj_open_name='ctrl_08'; ctrl_proj_open_regrid='ctrl_proj_open_08';
    	isexp01=0; exp01_name='exp01_32'; exp01_regrid='exp01_08';
    	isexp02=0; exp02_name='exp02_32'; exp02_regrid='exp02_08';
    	isexp03=0; exp03_name='exp03_32'; exp03_regrid='exp03_08';
    	isexp04=0; exp04_name='exp04_32'; exp04_regrid='exp04_08';
    	isexp05=1; exp05_name='exp05_32'; exp05_regrid='exp05_08';
    	isexp06=1; exp06_name='exp06_32'; exp06_regrid='exp06_08';
    	isexp07=1; exp07_name='exp07_32'; exp07_regrid='exp07_08';
    	isexp08=1; exp08_name='exp08_32'; exp32_regrid='exp08_08';
    	isexp09=1; exp09_name='exp09_32'; exp09_regrid='exp09_08';
    	isexp10=1; exp10_name='exp10_32'; exp10_regrid='exp10_08';
    	isexp11=0; exp11_name='exp11_32'; exp11_regrid='exp11_08';
    	isexp12=1; exp12_name='exp12_32'; exp12_regrid='exp12_08';
    	isexp13=1; exp13_name='exp13_32'; exp13_regrid='exp13_08';
    	isexpA1=0; expA1_name='expA1_08'; expA1_regrid='expA1_08';
    	isexpA2=0; expA2_name='expA2_08'; expA2_regrid='expA2_08';
    	isexpA3=0; expA3_name='expA3_08'; expA3_regrid='expA3_08';
    	isexpA4=0; expA4_name='expA4_08'; expA4_regrid='expA4_08';
    	isexpA5=1; expA5_name='expA5_32'; expA5_regrid='expA5_08';
    	isexpA6=1; expA6_name='expA6_32'; expA6_regrid='expA6_08';
    	isexpA7=1; expA7_name='expA7_32'; expA7_regrid='expA7_08';
    	isexpA8=1; expA8_name='expA8_32'; expA8_regrid='expA8_08';
    elseif strcmp(modelname,'JPL1_ISSM'),
    	group='JPL1'; simul='ISSM'; resolution=8; 
    	ice_density=917; ocean_density=1023;
    	initial_model_year=2007;
    	expe_model_year=2007;
    	yearday_model=365;
    	ishist_std=1; hist_std_name='hist_08'; hist_std_regrid='hist_08';
    	ishist_open=0; hist_open_name='hist_08'; hist_open_regrid='hist_08';
    	isctrl_proj_std=1; ctrl_proj_std_name='ctrl_proj_std_08'; ctrl_proj_std_regrid='ctrl_proj_std_08';
    	isctrl_proj_open=0; ctrl_proj_open_name='ctrl_08'; ctrl_proj_open_regrid='ctrl_08';
    	isexp01=0; exp01_name='exp01_08'; exp01_regrid='exp01_08';
    	isexp02=0; exp02_name='exp02_08'; exp02_regrid='exp02_08';
    	isexp03=0; exp03_name='exp03_08'; exp03_regrid='exp03_08';
    	isexp04=0; exp04_name='exp04_08'; exp04_regrid='exp04_08';
    	isexp05=1; exp05_name='exp05_08'; exp05_regrid='exp05_08';
    	isexp06=1; exp06_name='exp06_08'; exp06_regrid='exp06_08';
    	isexp07=1; exp07_name='exp07_08'; exp07_regrid='exp07_08';
    	isexpD3=1; expD3_name='expD3_08'; expD3_regrid='expD3_08';
    	isexpD4=1; expD4_name='expD4_08'; expD4_regrid='expD4_08';
    	isexp08=1; exp08_name='exp08_08'; exp08_regrid='exp08_08';
    	isexp09=1; exp09_name='exp09_08'; exp09_regrid='exp09_08';
    	isexp10=1; exp10_name='exp10_08'; exp10_regrid='exp10_08';
    	isexp11=0; exp11_name='exp11_08'; exp11_regrid='exp11_08';
    	isexp12=1; exp12_name='exp12_08'; exp12_regrid='exp12_08';
    	isexp13=1; exp13_name='exp13_08'; exp13_regrid='exp13_08';
    	isexpA1=0; expA1_name='expA1_08'; expA1_regrid='expA1_08';
    	isexpA2=0; expA2_name='expA2_08'; expA2_regrid='expA2_08';
    	isexpA3=0; expA3_name='expA3_08'; expA3_regrid='expA3_08';
    	isexpA4=0; expA4_name='expA4_08'; expA4_regrid='expA4_08';
    	isexpA5=1; expA5_name='expA5_08'; expA5_regrid='expA5_08';
    	isexpA6=1; expA6_name='expA6_08'; expA6_regrid='expA6_08';
    	isexpA7=1; expA7_name='expA7_08'; expA7_regrid='expA7_08';
    	isexpA8=1; expA8_name='expA8_08'; expA8_regrid='expA8_08';
    elseif strcmp(modelname,'LSCE_GRISLI'),
    	group='LSCE'; simul='GRISLI'; resolution=16; 
    	ice_density=918; ocean_density=1023;
    	initial_model_year=1995;
    	expe_model_year=2015;
    	yearday_model=360;
    	ishist_std=1; hist_std_name='hist_16'; hist_std_regrid='hist_08';
    	ishist_open=0; hist_open_name='hist_08'; hist_open_regrid='hist_08';
    	isctrl_proj_std=1; ctrl_proj_std_name='ctrl_proj_std_16'; ctrl_proj_std_regrid='ctrl_proj_std_08';
    	isctrl_proj_open=0; ctrl_proj_open_name='ctrl_08'; ctrl_proj_open_regrid='ctrl_08';
    	isexp01=0; exp01_name='exp01_16'; exp01_regrid='exp01_08';
    	isexp02=0; exp02_name='exp02_16'; exp02_regrid='exp02_08';
    	isexp03=0; exp03_name='exp03_16'; exp03_regrid='exp03_08';
    	isexp04=0; exp04_name='exp04_16'; exp04_regrid='exp04_08';
    	isexp05=1; exp05_name='exp05_16'; exp05_regrid='exp05_08';
    	isexp06=1; exp06_name='exp06_16'; exp06_regrid='exp06_08';
    	isexp07=1; exp07_name='exp07_16'; exp07_regrid='exp07_08';
    	isexp08=1; exp08_name='exp08_16'; exp16_regrid='exp08_08';
    	isexp09=1; exp09_name='exp09_16'; exp09_regrid='exp09_08';
    	isexp10=1; exp10_name='exp10_16'; exp10_regrid='exp10_08';
    	isexp11=0; exp11_name='exp11_16'; exp11_regrid='exp11_08';
    	isexp12=1; exp12_name='exp12_16'; exp12_regrid='exp12_08';
    	isexp13=1; exp13_name='exp13_16'; exp13_regrid='exp13_08';
    	isexpA1=0; expA1_name='expA1_08'; expA1_regrid='expA1_08';
    	isexpA2=0; expA2_name='expA2_08'; expA2_regrid='expA2_08';
    	isexpA3=0; expA3_name='expA3_08'; expA3_regrid='expA3_08';
    	isexpA4=0; expA4_name='expA4_08'; expA4_regrid='expA4_08';
    	isexpA5=1; expA5_name='expA5_16'; expA5_regrid='expA5_08';
    	isexpA6=1; expA6_name='expA6_16'; expA6_regrid='expA6_08';
    	isexpA7=1; expA7_name='expA7_16'; expA7_regrid='expA7_08';
    	isexpA8=1; expA8_name='expA8_16'; expA8_regrid='expA8_08';
    elseif strcmp(modelname,'NCAR_CISM'),
    	group='NCAR'; simul='CISM'; resolution=4; 
    	ice_density=910; ocean_density=1026;
    	initial_model_year=1995;
    	expe_model_year=2015;
    	yearday_model=365;
    	ishist_std=1; hist_std_name='hist_04'; hist_std_regrid='hist_08';
    	ishist_open=1; hist_open_name='hist_open_04'; hist_open_regrid='hist_open_08';
    	isctrl_proj_std=1; ctrl_proj_std_name='ctrl_proj_std_04'; ctrl_proj_std_regrid='ctrl_proj_std_08';
    	isctrl_proj_open=1; ctrl_proj_open_name='ctrl_proj_open_04'; ctrl_proj_open_regrid='ctrl_proj_open_08';
    	isexp01=1; exp01_name='exp01_04'; exp01_regrid='exp01_08';
    	isexp02=1; exp02_name='exp02_04'; exp02_regrid='exp02_08';
    	isexp03=1; exp03_name='exp03_04'; exp03_regrid='exp03_08';
    	isexp04=1; exp04_name='exp04_04'; exp04_regrid='exp04_08';
    	isexp05=1; exp05_name='exp05_04'; exp05_regrid='exp05_08';
    	isexp06=1; exp06_name='exp06_04'; exp06_regrid='exp06_08';
    	isexp07=1; exp07_name='exp07_04'; exp07_regrid='exp07_08';
    	isexp08=1; exp08_name='exp08_04'; exp08_regrid='exp08_08';
    	isexp09=1; exp09_name='exp09_04'; exp09_regrid='exp09_08';
    	isexp10=1; exp10_name='exp10_04'; exp10_regrid='exp10_08';
    	isexp11=0; exp11_name='exp11_04'; exp11_regrid='exp11_08';
    	isexp12=0; exp12_name='exp12_04'; exp12_regrid='exp12_08';
    	isexp13=1; exp13_name='exp13_04'; exp13_regrid='exp13_08';
    	isexpA1=1; expA1_name='expA1_04'; expA1_regrid='expA1_08';
    	isexpA2=1; expA2_name='expA2_04'; expA2_regrid='expA2_08';
    	isexpA3=1; expA3_name='expA3_04'; expA3_regrid='expA3_08';
    	isexpA4=1; expA4_name='expA4_04'; expA4_regrid='expA4_08';
    	isexpA5=1; expA5_name='expA5_04'; expA5_regrid='expA5_08';
    	isexpA6=1; expA6_name='expA6_04'; expA6_regrid='expA6_08';
    	isexpA7=1; expA7_name='expA7_04'; expA7_regrid='expA7_08';
    	isexpA8=1; expA8_name='expA8_04'; expA8_regrid='expA8_08';
    elseif strcmp(modelname,'PIK_PISM1'),
    	group='PIK'; simul='PISM1'; resolution=8; 
    	ice_density=910; ocean_density=1028;
    	initial_model_year=1850; 
    	expe_model_year=1850;
    	yearday_model=365;
    	ishist_std=0; hist_std_name='historical_8'; hist_std_regrid='hist_8';
    	ishist_open=1; hist_open_name='historical_8'; hist_open_regrid='hist_08';
    	isctrl_proj_std=0; ctrl_proj_std_name='ctrl_proj_std_8'; ctrl_proj_std_regrid='ctrl_proj_std_8';
    	isctrl_proj_open=1; ctrl_proj_open_name='ctrl_proj_open_8'; ctrl_proj_open_regrid='ctrl_proj_open_8';
    	isexp01=1; exp01_name='expt01_8'; exp01_regrid='expt01_8';
    	isexp02=1; exp02_name='expt02_8'; exp02_regrid='expt02_8';
    	isexp03=1; exp03_name='expt03_8'; exp03_regrid='expt03_8';
    	isexp04=1; exp04_name='expt04_8'; exp04_regrid='expt04_8';
    	isexp05=0; exp05_name='expt05_8'; exp05_regrid='expt05_8';
    	isexp06=0; exp06_name='expt06_8'; exp06_regrid='expt06_8';
    	isexp07=0; exp07_name='expt07_8'; exp07_regrid='expt07_8';
    	isexp08=0; exp08_name='expt08_8'; exp08_regrid='expt08_8';
    	isexp09=0; exp09_name='expt09_8'; exp09_regrid='expt09_8';
    	isexp10=0; exp10_name='expt10_8'; exp10_regrid='expt10_8';
    	isexp11=0; exp11_name='expt11_8'; exp11_regrid='expt11_8';
    	isexp12=0; exp12_name='expt12_8'; exp12_regrid='expt12_8';
    	isexp13=0; exp13_name='expt13_8'; exp13_regrid='expt13_8';
    	isexpA1=0; expA1_name='expA1_08'; expA1_regrid='expA1_08';
    	isexpA2=0; expA2_name='expA2_08'; expA2_regrid='expA2_08';
    	isexpA3=0; expA3_name='expA3_08'; expA3_regrid='expA3_08';
    	isexpA4=0; expA4_name='expA4_08'; expA4_regrid='expA4_08';
    	isexpA5=0; expA5_name='expA5_08'; expA5_regrid='expA5_08';
    	isexpA6=0; expA6_name='expA6_08'; expA6_regrid='expA6_08';
    	isexpA7=0; expA7_name='expA7_08'; expA7_regrid='expA7_08';
    	isexpA8=0; expA8_name='expA8_08'; expA8_regrid='expA8_08';
    elseif strcmp(modelname,'PIK_PISM2'),
    	group='PIK'; simul='PISM2'; resolution=8; 
    	ice_density=910; ocean_density=1028;
    	initial_model_year=2015;
    	expe_model_year=2015;
    	yearday_model=365;
    	ishist_std=0; hist_std_name='hist_8'; hist_std_regrid='hist_8';
    	ishist_open=0; hist_open_name='hist_08'; hist_open_regrid='hist_08';
    	isctrl_proj_std=0; ctrl_proj_std_name='ctrl_proj_std_8'; ctrl_proj_std_regrid='ctrl_proj_std_8';
    	isctrl_proj_open=1; ctrl_proj_open_name='ctrl_proj_open_8'; ctrl_proj_open_regrid='ctrl_proj_open_8';
    	isexp01=1; exp01_name='expt01_8'; exp01_regrid='expt01_8';
    	isexp02=1; exp02_name='expt02_8'; exp02_regrid='expt02_8';
    	isexp03=1; exp03_name='expt03_8'; exp03_regrid='expt03_8';
    	isexp04=1; exp04_name='expt04_8'; exp04_regrid='expt04_8';
    	isexp05=0; exp05_name='expt05_8'; exp05_regrid='expt05_8';
    	isexp06=0; exp06_name='expt06_8'; exp06_regrid='expt06_8';
    	isexp07=0; exp07_name='expt07_8'; exp07_regrid='expt07_8';
    	isexp08=0; exp08_name='expt08_8'; exp08_regrid='expt08_8';
    	isexp09=0; exp09_name='expt09_8'; exp09_regrid='expt09_8';
    	isexp10=0; exp10_name='expt10_8'; exp10_regrid='expt10_8';
    	isexp11=0; exp11_name='expt11_8'; exp11_regrid='expt11_8';
    	isexp12=0; exp12_name='expt12_8'; exp12_regrid='expt12_8';
    	isexp13=0; exp13_name='expt13_8'; exp13_regrid='expt13_8';
    	isexpA1=0; expA1_name='expA1_08'; expA1_regrid='expA1_08';
    	isexpA2=0; expA2_name='expA2_08'; expA2_regrid='expA2_08';
    	isexpA3=0; expA3_name='expA3_08'; expA3_regrid='expA3_08';
    	isexpA4=0; expA4_name='expA4_08'; expA4_regrid='expA4_08';
    	isexpA5=0; expA5_name='expA5_08'; expA5_regrid='expA5_08';
    	isexpA6=0; expA6_name='expA6_08'; expA6_regrid='expA6_08';
    	isexpA7=0; expA7_name='expA7_08'; expA7_regrid='expA7_08';
    	isexpA8=0; expA8_name='expA8_08'; expA8_regrid='expA8_08';
    elseif strcmp(modelname,'UCIJPL_ISSM'),
    	group='UCIJPL'; simul='ISSM'; resolution=8; 
    	ice_density=917; ocean_density=1023;
    	initial_model_year=2005;
    	expe_model_year=2005;
    	yearday_model=365;
    	ishist_std=1; hist_std_name='histstd'; hist_std_regrid='hist';
    	ishist_open=1; hist_open_name='histopen'; hist_open_regrid='hist_open';
    	isctrl_proj_std=1; ctrl_proj_std_name='ctrlproj_std'; ctrl_proj_std_regrid='ctrlproj_std';
    	isctrl_proj_open=1; ctrl_proj_open_name='ctrlproj_open'; ctrl_proj_open_regrid='ctrlproj_open';
    	isexp01=1; exp01_name='exp01'; exp01_regrid='exp01';
    	isexp02=1; exp02_name='exp02'; exp02_regrid='exp02';
    	isexp03=1; exp03_name='exp03'; exp03_regrid='exp03';
    	isexp04=1; exp04_name='exp04'; exp04_regrid='exp04';
    	isexp05=1; exp05_name='exp05'; exp05_regrid='exp05';
    	isexp06=1; exp06_name='exp06'; exp06_regrid='exp06';
    	isexp07=1; exp07_name='exp07'; exp07_regrid='exp07';
    	isexp08=1; exp08_name='exp08'; exp08_regrid='exp08';
    	isexp09=1; exp09_name='exp09'; exp09_regrid='exp09';
    	isexp10=1; exp10_name='exp10'; exp10_regrid='exp10';
    	isexp11=1; exp11_name='exp11'; exp11_regrid='exp11';
    	isexp12=1; exp12_name='exp12'; exp12_regrid='exp12';
    	isexp13=1; exp13_name='exp13'; exp13_regrid='exp13';
    	isexpA1=0; expA1_name='expA1_08'; expA1_regrid='expA1_08';
    	isexpA2=0; expA2_name='expA2_08'; expA2_regrid='expA2_08';
    	isexpA3=0; expA3_name='expA3_08'; expA3_regrid='expA3_08';
    	isexpA4=0; expA4_name='expA4_08'; expA4_regrid='expA4_08';
    	isexpA5=1; expA5_name='expA5'; expA5_regrid='expA5';
    	isexpA6=1; expA6_name='expA6'; expA6_regrid='expA6';
    	isexpA7=1; expA7_name='expA7'; expA7_regrid='expA7';
    	isexpA8=1; expA8_name='expA8'; expA8_regrid='expA8';
    elseif strcmp(modelname,'ULB_FETISH32'),
    	group='ULB'; simul='fETISh_32km'; resolution=32; 
    	ice_density=910; ocean_density=1028;
    	initial_model_year=2015;
    	expe_model_year=2015;
    	yearday_model=360;
    	ishist_std=1; hist_std_name='hist_32'; hist_std_regrid='hist_08';
    	ishist_open=1; hist_open_name='hist_open_32'; hist_open_regrid='hist_open_08';
    	isctrl_proj_std=1; ctrl_proj_std_name='ctrl_proj_std_32'; ctrl_proj_std_regrid='ctrl_proj_std_08';
    	isctrl_proj_open=1; ctrl_proj_open_name='ctrl_proj_open_32'; ctrl_proj_open_regrid='ctrl_proj_open_08';
    	isexp01=1; exp01_name='exp01_32'; exp01_regrid='exp01_08';
    	isexp02=1; exp02_name='exp02_32'; exp02_regrid='exp02_08';
    	isexp03=1; exp03_name='exp03_32'; exp03_regrid='exp03_08';
    	isexp04=1; exp04_name='exp04_32'; exp04_regrid='exp04_08';
    	isexp05=1; exp05_name='exp05_32'; exp05_regrid='exp05_08';
    	isexp06=1; exp06_name='exp06_32'; exp06_regrid='exp06_08';
    	isexp07=1; exp07_name='exp07_32'; exp07_regrid='exp07_08';
    	isexp08=1; exp08_name='exp08_32'; exp08_regrid='exp08_08';
    	isexp09=1; exp09_name='exp09_32'; exp09_regrid='exp09_08';
    	isexp10=1; exp10_name='exp10_32'; exp10_regrid='exp10_08';
    	isexp11=1; exp11_name='exp11_32'; exp11_regrid='exp11_08';
    	isexp12=1; exp12_name='exp12_32'; exp12_regrid='exp12_08';
    	isexp13=1; exp13_name='exp13_32'; exp13_regrid='exp13_08';
    	isexpA1=1; expA1_name='expA1_32'; expA1_regrid='expA1_08';
    	isexpA2=1; expA2_name='expA2_32'; expA2_regrid='expA2_08';
    	isexpA3=1; expA3_name='expA3_32'; expA3_regrid='expA3_08';
    	isexpA4=1; expA4_name='expA4_32'; expA4_regrid='expA4_08';
    	isexpA5=1; expA5_name='expA5_32'; expA5_regrid='expA5_08';
    	isexpA6=1; expA6_name='expA6_32'; expA6_regrid='expA6_08';
    	isexpA7=1; expA7_name='expA7_32'; expA7_regrid='expA7_08';
    	isexpA8=1; expA8_name='expA8_32'; expA8_regrid='expA8_08';
    elseif strcmp(modelname,'ULB_FETISH16'),
    	group='ULB'; simul='fETISh_16km'; resolution=16; 
    	ice_density=910; ocean_density=1028;
    	initial_model_year=2005;
    	expe_model_year=2005;
    	yearday_model=360;
    	ishist_std=1; hist_std_name='hist_16'; hist_std_regrid='hist_08';
    	ishist_open=1; hist_open_name='hist_open_16'; hist_open_regrid='hist_open_08';
    	isctrl_proj_std=1; ctrl_proj_std_name='ctrl_proj_std_16'; ctrl_proj_std_regrid='ctrl_proj_std_08';
    	isctrl_proj_open=1; ctrl_proj_open_name='ctrl_proj_open_16'; ctrl_proj_open_regrid='ctrl_proj_open_08';
    	isexp01=1; exp01_name='exp01_16'; exp01_regrid='exp01_08';
    	isexp02=1; exp02_name='exp02_16'; exp02_regrid='exp02_08';
    	isexp03=1; exp03_name='exp03_16'; exp03_regrid='exp03_08';
    	isexp04=1; exp04_name='exp04_16'; exp04_regrid='exp04_08';
    	isexp05=1; exp05_name='exp05_16'; exp05_regrid='exp05_08';
    	isexp06=1; exp06_name='exp06_16'; exp06_regrid='exp06_08';
    	isexp07=1; exp07_name='exp07_16'; exp07_regrid='exp07_08';
    	isexp08=1; exp08_name='exp08_16'; exp08_regrid='exp08_08';
    	isexp09=1; exp09_name='exp09_16'; exp09_regrid='exp09_08';
    	isexp10=1; exp10_name='exp10_16'; exp10_regrid='exp10_08';
    	isexp11=1; exp11_name='exp11_16'; exp11_regrid='exp11_08';
    	isexp12=1; exp12_name='exp12_16'; exp12_regrid='exp12_08';
    	isexp13=1; exp13_name='exp13_16'; exp13_regrid='exp13_08';
    	isexpA1=1; expA1_name='expA1_16'; expA1_regrid='expA1_08';
    	isexpA2=1; expA2_name='expA2_16'; expA2_regrid='expA2_08';
    	isexpA3=1; expA3_name='expA3_16'; expA3_regrid='expA3_08';
    	isexpA4=1; expA4_name='expA4_16'; expA4_regrid='expA4_08';
    	isexpA5=1; expA5_name='expA5_16'; expA5_regrid='expA5_08';
    	isexpA6=1; expA6_name='expA6_16'; expA6_regrid='expA6_08';
    	isexpA7=1; expA7_name='expA7_16'; expA7_regrid='expA7_08';
    	isexpA8=1; expA8_name='expA8_16'; expA8_regrid='expA8_08';
    elseif strcmp(modelname,'UTAS_ElmerIce'),
    	group='UTAS'; simul='ElmerIce'; resolution=8; 
    	ice_density=900; ocean_density=1025;
    	initial_model_year=2015;
    	expe_model_year=2015;
    	yearday_model=365.25;
    	ishist_std=0; hist_std_name='hist_8'; hist_std_regrid='hist_8';
    	ishist_open=0; hist_open_name='hist_open_8'; hist_open_regrid='hist_open_8';
    	isctrl_proj_std=1; ctrl_proj_std_name='ctrl_proj_std_8'; ctrl_proj_std_regrid='ctrl_proj_std_8';
    	isctrl_proj_open=0; ctrl_proj_open_name='ctrl_08'; ctrl_proj_open_regrid='ctrl_08';
    	isexp01=0; exp01_name='exp01_8'; exp01_regrid='exp01_8';
    	isexp02=0; exp02_name='exp02_8'; exp02_regrid='exp02_8';
    	isexp03=0; exp03_name='exp03_8'; exp03_regrid='exp03_8';
    	isexp04=0; exp04_name='exp04_8'; exp04_regrid='exp04_8';
    	isexp05=1; exp05_name='exp05_8'; exp05_regrid='exp05_8';
    	isexp06=1; exp06_name='exp06_8'; exp06_regrid='exp06_8';
    	isexp07=0; exp07_name='exp07_8'; exp07_regrid='exp07_8';
    	isexp08=0; exp08_name='exp08_8'; exp08_regrid='exp08_8';
    	isexp09=0; exp09_name='exp09_8'; exp09_regrid='exp09_8';
    	isexp10=0; exp10_name='exp10_8'; exp10_regrid='exp10_8';
    	isexp11=0; exp11_name='exp11_8'; exp11_regrid='exp11_8';
    	isexp12=0; exp12_name='exp12_8'; exp12_regrid='exp12_8';
    	isexp13=1; exp13_name='exp13_8'; exp13_regrid='exp13_8';
    	isexpA1=0; expA1_name='expA1_08'; expA1_regrid='expA1_08';
    	isexpA2=0; expA2_name='expA2_08'; expA2_regrid='expA2_08';
    	isexpA3=0; expA3_name='expA3_08'; expA3_regrid='expA3_08';
    	isexpA4=0; expA4_name='expA4_08'; expA4_regrid='expA4_08';
    	isexpA5=0; expA5_name='expA5_08'; expA5_regrid='expA5_08';
    	isexpA6=0; expA6_name='expA6_08'; expA6_regrid='expA6_08';
    	isexpA7=0; expA7_name='expA7_08'; expA7_regrid='expA7_08';
    	isexpA8=0; expA8_name='expA8_08'; expA8_regrid='expA8_08';
    elseif strcmp(modelname,'VUB_AISMPALEO'),
    	group='VUB'; simul='AISMPALEO'; resolution=16; 
    	ice_density=910; ocean_density=1028;
    	initial_model_year=2000;
    	expe_model_year=2000;
    	yearday_model=365.2422;
    	ishist_std=1; hist_std_name='hist_16'; hist_std_regrid='hist_08';
    	ishist_open=0; hist_open_name='hist_open_16'; hist_open_regrid='hist_open_08';
    	isctrl_proj_std=1; ctrl_proj_std_name='ctrl_proj_std_16'; ctrl_proj_std_regrid='ctrl_proj_std_08';
    	isctrl_proj_open=0; ctrl_proj_open_name='ctrl_08'; ctrl_proj_open_regrid='ctrl_08';
    	isexp01=0; exp01_name='exp01_16'; exp01_regrid='exp01_08';
    	isexp02=0; exp02_name='exp02_16'; exp02_regrid='exp02_08';
    	isexp03=0; exp03_name='exp03_16'; exp03_regrid='exp03_08';
    	isexp04=0; exp04_name='exp04_16'; exp04_regrid='exp04_08';
    	isexp05=1; exp05_name='exp05_16'; exp05_regrid='exp05_08';
    	isexp06=1; exp06_name='exp06_16'; exp06_regrid='exp06_08';
    	isexp07=1; exp07_name='exp07_16'; exp07_regrid='exp07_08';
    	isexp08=1; exp08_name='exp08_16'; exp16_regrid='exp08_08';
    	isexp09=1; exp09_name='exp09_16'; exp09_regrid='exp09_08';
    	isexp10=1; exp10_name='exp10_16'; exp10_regrid='exp10_08';
    	isexp11=0; exp11_name='exp11_16'; exp11_regrid='exp11_08';
    	isexp12=0; exp12_name='exp12_16'; exp12_regrid='exp12_08';
    	isexp13=1; exp13_name='exp13_16'; exp13_regrid='exp13_08';
    	isexpA1=0; expA1_name='expA1_08'; expA1_regrid='expA1_08';
    	isexpA2=0; expA2_name='expA2_08'; expA2_regrid='expA2_08';
    	isexpA3=0; expA3_name='expA3_08'; expA3_regrid='expA3_08';
    	isexpA4=0; expA4_name='expA4_08'; expA4_regrid='expA4_08';
    	isexpA5=1; expA5_name='expA5_16'; expA5_regrid='expA5_08';
    	isexpA6=1; expA6_name='expA6_16'; expA6_regrid='expA6_08';
    	isexpA7=1; expA7_name='expA7_16'; expA7_regrid='expA7_08';
    	isexpA8=0; expA8_name='expA8_08'; expA8_regrid='expA8_08';
    elseif strcmp(modelname,'VUW_PISM'),
    	group='VUW'; simul='PISM'; resolution=8; 
    	ice_density=910; ocean_density=1028;
    	initial_model_year=1;
    	expe_model_year=1;
    	yearday_model=365;
    	ishist_std=0; hist_std_name='hist_08'; hist_std_regrid='hist_08';
    	ishist_open=1; hist_open_name='hist_08'; hist_open_regrid='hist_open_08';
    	isctrl_proj_std=0; ctrl_proj_std_name='ctrl_proj_std_08'; ctrl_proj_std_regrid='ctrl_proj_std_08';
    	isctrl_proj_open=1; ctrl_proj_open_name='ctrl_proj_open_08'; ctrl_proj_open_regrid='ctrl_proj_open_08';
    	isexp01=1; exp01_name='exp01_08'; exp01_regrid='exp01_08';
    	isexp02=1; exp02_name='exp02_08'; exp02_regrid='exp02_08';
    	isexp03=1; exp03_name='exp03_08'; exp03_regrid='exp03_08';
    	isexp04=1; exp04_name='exp04_08'; exp04_regrid='exp04_08';
    	isexp05=0; exp05_name='exp05_08'; exp05_regrid='exp05_08';
    	isexp06=0; exp06_name='exp06_08'; exp06_regrid='exp06_08';
    	isexp07=0; exp07_name='exp07_08'; exp07_regrid='exp07_08';
    	isexp08=0; exp08_name='exp08_08'; exp16_regrid='exp08_08';
    	isexp09=0; exp09_name='exp09_08'; exp09_regrid='exp09_08';
    	isexp10=0; exp10_name='exp10_08'; exp10_regrid='exp10_08';
    	isexp11=0; exp11_name='exp11_08'; exp11_regrid='exp11_08';
    	isexp12=0; exp12_name='exp12_08'; exp12_regrid='exp12_08';
    	isexp13=0; exp13_name='exp13_08'; exp13_regrid='exp13_08';
    	isexpA1=0; expA1_name='expA1_08'; expA1_regrid='expA1_08';
    	isexpA2=0; expA2_name='expA2_08'; expA2_regrid='expA2_08';
    	isexpA3=0; expA3_name='expA3_08'; expA3_regrid='expA3_08';
    	isexpA4=0; expA4_name='expA4_08'; expA4_regrid='expA4_08';
    	isexpA5=0; expA5_name='expA5_08'; expA5_regrid='expA5_08';
    	isexpA6=0; expA6_name='expA6_08'; expA6_regrid='expA6_08';
    	isexpA7=0; expA7_name='expA7_08'; expA7_regrid='expA7_08';
    	isexpA8=0; expA8_name='expA8_08'; expA8_regrid='expA8_08';
    else
    	modelname
    	error('model not supported yet');
    end
	if strcmp(modelname,'AWI_PISM1'),
		is_acabf=1;
		is_base=1;
		is_dlithkdt=1;
		is_hfgeoubed=1;
		is_iareafl=1;
		is_iareagr=1;
		is_libmassbffl=1;
		is_libmassbfgr=1;
		is_licalvf=1;
		is_lifmassbf=1;
		is_ligroundf=1;
		is_lim=1;
		is_limnsw=1;
		is_litempbotfl=1;
		is_litempbotgr=1;
		is_litemptop=1;
		is_lithk=1;
		is_orog=1;
		is_sftflf=1;
		is_sftgif=1;
		is_sftgrf=1;
		is_strbasemag=1;
		is_tendacabf=1;
		is_tendlibmassbf=1;
		is_tendlibmassbffl=1;
		is_tendlicalvf=1;
		is_tendlifmassbf=0;
		is_tendligroundf=1;
		is_topg=1;
		is_xvelbase=1;
		is_xvelmean=1;
		is_xvelsurf=1;
		is_yvelbase=1;
		is_yvelmean=1;
		is_yvelsurf=1;
		is_zvelbase=1;
		is_zvelsurf=1;
	elseif strcmp(modelname,'DOE_MALI'),
		is_acabf=1;
		is_base=1;
		is_dlithkdt=1;
		is_hfgeoubed=1;
		is_iareafl=1;
		is_iareagr=1;
		is_libmassbffl=1;
		is_libmassbfgr=1;
		is_licalvf=1;
		is_lifmassbf=0;
		is_ligroundf=1;
		is_lim=1;
		is_limnsw=1;
		is_litempbotfl=1;
		is_litempbotgr=1;
		is_litemptop=1;
		is_lithk=1;
		is_orog=1;
		is_sftflf=1;
		is_sftgif=1;
		is_sftgrf=1;
		is_strbasemag=1;
		is_tendacabf=1;
		is_tendlibmassbf=1;
		is_tendlibmassbffl=1;
		is_tendlicalvf=1;
		is_tendlifmassbf=0;
		is_tendligroundf=1;
		is_topg=1;
		is_xvelbase=1;
		is_xvelmean=1;
		is_xvelsurf=1;
		is_yvelbase=1;
		is_yvelmean=1;
		is_yvelsurf=1;
		is_zvelbase=0;
		is_zvelsurf=0;
	elseif strcmp(modelname,'ILTS_PIK_SICOPOLIS'),
		is_lithk=1;
		is_orog=1;
		is_base=1;
		is_topg=1;
		is_hfgeoubed=1;
		is_acabf=1;
		is_libmassbffl=1;
		is_libmassbfgr=1;
		is_dlithkdt=1;
		is_xvelsurf=1;
		is_yvelsurf=1;
		is_zvelsurf=1;
		is_xvelbase=1;
		is_yvelbase=1;
		is_zvelbase=1;
		is_xvelmean=1;
		is_yvelmean=1;
		is_litemptop=1;
		is_litempbotfl=1;
		is_litempbotgr=1;
		is_strbasemag=1;
		is_licalvf=1;
		is_lifmassbf=1;
		is_ligroundf=0;
		is_sftgif=1;
		is_sftgrf=1;
		is_sftflf=1;
		is_lim=1;
		is_limnsw=1;
		is_iareagr=1;
		is_iareafl=1;
		is_tendacabf=1;
		is_tendlibmassbf=1;
		is_tendlibmassbffl=1;
		is_tendlicalvf=1;
		is_tendlifmassbf=0;
		is_tendligroundf=0;
	elseif strcmp(modelname,'IMAU_IMAUICE1'),
		is_lithk=1;
		is_orog=1;
		is_base=1;
		is_topg=1;
		is_hfgeoubed=0;
		is_acabf=1;
		is_libmassbffl=1;
		is_libmassbfgr=1;
		is_dlithkdt=1;
		is_xvelsurf=0;
		is_yvelsurf=0;
		is_zvelsurf=0;
		is_xvelbase=0;
		is_yvelbase=0;
		is_zvelbase=0;
		is_xvelmean=1;
		is_yvelmean=1;
		is_litemptop=0;
		is_litempbotfl=0;
		is_litempbotgr=0;
		is_strbasemag=0;
		is_licalvf=1;
		is_lifmassbf=0;
		is_ligroundf=1;
		is_sftgif=1;
		is_sftgrf=1;
		is_sftflf=1;
		is_lim=1;
		is_limnsw=1;
		is_iareagr=1;
		is_iareafl=1;
		is_tendacabf=1;
		is_tendlibmassbf=1;
		is_tendlibmassbffl=0;
		is_tendlicalvf=1;
		is_tendlifmassbf=0;
		is_tendligroundf=1;
	elseif strcmp(modelname,'IMAU_IMAUICE2'),
		is_lithk=1;
		is_orog=1;
		is_base=1;
		is_topg=1;
		is_hfgeoubed=0;
		is_acabf=1;
		is_libmassbffl=1;
		is_libmassbfgr=1;
		is_dlithkdt=1;
		is_xvelsurf=0;
		is_yvelsurf=0;
		is_zvelsurf=0;
		is_xvelbase=0;
		is_yvelbase=0;
		is_zvelbase=0;
		is_xvelmean=1;
		is_yvelmean=1;
		is_litemptop=0;
		is_litempbotfl=0;
		is_litempbotgr=0;
		is_strbasemag=0;
		is_licalvf=1;
		is_lifmassbf=0;
		is_ligroundf=1;
		is_sftgif=1;
		is_sftgrf=1;
		is_sftflf=1;
		is_lim=1;
		is_limnsw=1;
		is_iareagr=1;
		is_iareafl=1;
		is_tendacabf=1;
		is_tendlibmassbf=1;
		is_tendlibmassbffl=0;
		is_tendlicalvf=1;
		is_tendlifmassbf=0;
		is_tendligroundf=1;
	elseif strcmp(modelname,'JPL1_ISSM'),
		is_acabf=1;
		is_base=1;
		is_dlithkdt=1;
		is_hfgeoubed=1;
		is_iareafl=1;
		is_iareagr=1;
		is_libmassbffl=1;
		is_libmassbfgr=0;
		is_licalvf=0;
		is_lifmassbf=0;
		is_ligroundf=0;
		is_lim=1;
		is_limnsw=1;
		is_litempbotfl=0;
		is_litempbotgr=0;
		is_litemptop=0;
		is_lithk=1;
		is_orog=1;
		is_sftflf=1;
		is_sftgif=1;
		is_sftgrf=1;
		is_strbasemag=1;
		is_tendacabf=1;
		is_tendlibmassbf=0;
		is_tendlibmassbffl=1;
		is_tendlicalvf=0;
		is_tendlifmassbf=0;
		is_tendligroundf=0;
		is_topg=1;
		is_xvelbase=0;
		is_xvelmean=1;
		is_xvelsurf=0;
		is_yvelbase=0;
		is_yvelmean=1;
		is_yvelsurf=0;
		is_zvelbase=0;
		is_zvelsurf=0;
	elseif strcmp(modelname,'LSCE_GRISLI'),
		is_acabf=1;
		is_base=1;
		is_dlithkdt=1;
		is_hfgeoubed=0;
		is_iareafl=1;
		is_iareagr=1;
		is_libmassbffl=1;
		is_libmassbfgr=1;
		is_licalvf=1;
		is_lifmassbf=1;
		is_ligroundf=1;
		is_lim=1;
		is_limnsw=1;
		is_litempbotfl=1;
		is_litempbotgr=1;
		is_litemptop=1;
		is_lithk=1;
		is_orog=1;
		is_sftflf=1;
		is_sftgif=1;
		is_sftgrf=1;
		is_strbasemag=1;
		is_tendacabf=1;
		is_tendlibmassbf=1;
		is_tendlibmassbffl=1;
		is_tendlicalvf=1;
		is_tendlifmassbf=1;
		is_tendligroundf=1;
		is_topg=1;
		is_xvelbase=1;
		is_xvelmean=1;
		is_xvelsurf=1;
		is_yvelbase=1;
		is_yvelmean=1;
		is_yvelsurf=1;
		is_zvelbase=1;
		is_zvelsurf=1;
	elseif strcmp(modelname,'NCAR_CISM'),
		is_acabf=1;
		is_base=1;
		is_dlithkdt=1;
		is_hfgeoubed=1;
		is_iareafl=1;
		is_iareagr=1;
		is_libmassbffl=1;
		is_libmassbfgr=1;
		is_licalvf=1;
		is_lifmassbf=1;
		is_ligroundf=1;
		is_lim=1;
		is_limnsw=1;
		is_litempbotfl=1;
		is_litempbotgr=1;
		is_litemptop=1;
		is_lithk=1;
		is_orog=1;
		is_sftflf=1;
		is_sftgif=1;
		is_sftgrf=1;
		is_strbasemag=1;
		is_tendacabf=1;
		is_tendlibmassbf=1;
		is_tendlibmassbffl=1;
		is_tendlicalvf=1;
		is_tendlifmassbf=1;
		is_tendligroundf=1;
		is_topg=1;
		is_xvelbase=1;
		is_xvelmean=1;
		is_xvelsurf=1;
		is_yvelbase=1;
		is_yvelmean=1;
		is_yvelsurf=1;
		is_zvelbase=1;
		is_zvelsurf=1;
	elseif strcmp(modelname,'PIK_PISM1'),
		is_acabf=1;
		is_base=1;
		is_dlithkdt=1;
		is_hfgeoubed=0;
		is_iareafl=1;
		is_iareagr=1;
		is_libmassbffl=1;
		is_libmassbfgr=1;
		is_licalvf=1;
		is_lifmassbf=1;
		is_ligroundf=0;
		is_lim=1;
		is_limnsw=1;
		is_litempbotfl=1;
		is_litempbotgr=1;
		is_litemptop=1;
		is_lithk=1;
		is_orog=1;
		is_sftflf=1;
		is_sftgif=1;
		is_sftgrf=1;
		is_strbasemag=1;
		is_tendacabf=1;
		is_tendlibmassbf=1;
		is_tendlibmassbffl=1;
		is_tendlicalvf=1;
		is_tendlifmassbf=1;
		is_tendligroundf=0;
		is_topg=1;
		is_xvelbase=1;
		is_xvelmean=1;
		is_xvelsurf=1;
		is_yvelbase=1;
		is_yvelmean=1;
		is_yvelsurf=1;
		is_zvelbase=1;
		is_zvelsurf=1;
	elseif strcmp(modelname,'PIK_PISM2'),
		is_acabf=1;
		is_base=1;
		is_dlithkdt=1;
		is_hfgeoubed=0;
		is_iareafl=1;
		is_iareagr=1;
		is_libmassbffl=1;
		is_libmassbfgr=1;
		is_licalvf=1;
		is_lifmassbf=1;
		is_ligroundf=0;
		is_lim=1;
		is_limnsw=1;
		is_litempbotfl=1;
		is_litempbotgr=1;
		is_litemptop=1;
		is_lithk=1;
		is_orog=1;
		is_sftflf=1;
		is_sftgif=1;
		is_sftgrf=1;
		is_strbasemag=1;
		is_tendacabf=1;
		is_tendlibmassbf=1;
		is_tendlibmassbffl=1;
		is_tendlicalvf=1;
		is_tendlifmassbf=1;
		is_tendligroundf=0;
		is_topg=1;
		is_xvelbase=1;
		is_xvelmean=1;
		is_xvelsurf=1;
		is_yvelbase=1;
		is_yvelmean=1;
		is_yvelsurf=1;
		is_zvelbase=1;
		is_zvelsurf=1;
	elseif strcmp(modelname,'UCIJPL_ISSM'),
		is_acabf=1;
		is_base=1;
		is_dlithkdt=1;
		is_hfgeoubed=1;
		is_iareafl=1;
		is_iareagr=1;
		is_libmassbffl=1;
		is_libmassbfgr=0;
		is_licalvf=0;
		is_lifmassbf=0;
		is_ligroundf=0;
		is_lim=1;
		is_limnsw=1;
		is_litempbotfl=0;
		is_litempbotgr=0;
		is_litemptop=0;
		is_lithk=1;
		is_orog=1;
		is_sftflf=1;
		is_sftgif=1;
		is_sftgrf=1;
		is_strbasemag=1;
		is_tendacabf=1;
		is_tendlibmassbf=0;
		is_tendlibmassbffl=1;
		is_tendlicalvf=0;
		is_tendlifmassbf=0;
		is_tendligroundf=0;
		is_topg=1;
		is_xvelbase=0;
		is_xvelmean=1;
		is_xvelsurf=0;
		is_yvelbase=0;
		is_yvelmean=1;
		is_yvelsurf=0;
		is_zvelbase=0;
		is_zvelsurf=0;
	elseif strcmp(modelname,'ULB_FETISH32'),
		is_acabf=1;
		is_base=1;
		is_dlithkdt=1;
		is_hfgeoubed=1;
		is_iareafl=1;
		is_iareagr=1;
		is_libmassbffl=1;
		is_libmassbfgr=1;
		is_licalvf=1;
		is_lifmassbf=1;
		is_ligroundf=1;
		is_lim=1;
		is_limnsw=1;
		is_litempbotfl=1;
		is_litempbotgr=1;
		is_litemptop=1;
		is_lithk=1;
		is_orog=1;
		is_sftflf=1;
		is_sftgif=1;
		is_sftgrf=1;
		is_strbasemag=1;
		is_tendacabf=1;
		is_tendlibmassbf=1;
		is_tendlibmassbffl=1;
		is_tendlicalvf=1;
		is_tendlifmassbf=1;
		is_tendligroundf=1;
		is_topg=1;
		is_xvelbase=1;
		is_xvelmean=1;
		is_xvelsurf=1;
		is_yvelbase=1;
		is_yvelmean=1;
		is_yvelsurf=1;
		is_zvelbase=0;
		is_zvelsurf=0;
	elseif strcmp(modelname,'ULB_FETISH16'),
		is_acabf=1;
		is_base=1;
		is_dlithkdt=1;
		is_hfgeoubed=1;
		is_iareafl=1;
		is_iareagr=1;
		is_libmassbffl=1;
		is_libmassbfgr=1;
		is_licalvf=1;
		is_lifmassbf=1;
		is_ligroundf=1;
		is_lim=1;
		is_limnsw=1;
		is_litempbotfl=1;
		is_litempbotgr=1;
		is_litemptop=1;
		is_lithk=1;
		is_orog=1;
		is_sftflf=1;
		is_sftgif=1;
		is_sftgrf=1;
		is_strbasemag=1;
		is_tendacabf=1;
		is_tendlibmassbf=1;
		is_tendlibmassbffl=1;
		is_tendlicalvf=1;
		is_tendlifmassbf=1;
		is_tendligroundf=1;
		is_topg=1;
		is_xvelbase=1;
		is_xvelmean=1;
		is_xvelsurf=1;
		is_yvelbase=1;
		is_yvelmean=1;
		is_yvelsurf=1;
		is_zvelbase=0;
		is_zvelsurf=0;
	elseif strcmp(modelname,'UTAS_ElmerIce'),
		is_acabf=1;
		is_base=1;
		is_dlithkdt=1;
		is_hfgeoubed=0;
		is_iareafl=1;
		is_iareagr=1;
		is_libmassbffl=1;
		is_libmassbfgr=0;
		is_licalvf=0;
		is_lifmassbf=0;
		is_ligroundf=0;
		is_lim=1;
		is_limnsw=1;
		is_litempbotfl=0;
		is_litempbotgr=0;
		is_litemptop=0;
		is_lithk=1;
		is_orog=1;
		is_sftflf=1;
		is_sftgif=1;
		is_sftgrf=1;
		is_strbasemag=1;
		is_tendacabf=1;
		is_tendlibmassbf=1;
		is_tendlibmassbffl=0;
		is_tendlicalvf=0;
		is_tendlifmassbf=0;
		is_tendligroundf=0;
		is_topg=1;
		is_xvelbase=1;
		is_xvelmean=1;
		is_xvelsurf=1;
		is_yvelbase=1;
		is_yvelmean=1;
		is_yvelsurf=1;
		is_zvelbase=1;
		is_zvelsurf=1;
	elseif strcmp(modelname,'VUB_AISMPALEO'),
		is_acabf=1;
		is_base=1;
		is_dlithkdt=0;
		is_hfgeoubed=1;
		is_iareafl=1;
		is_iareagr=1;
		is_libmassbffl=1;
		is_libmassbfgr=1;
		is_licalvf=0;
		is_lifmassbf=0;
		is_ligroundf=0;
		is_lim=1;
		is_limnsw=1;
		is_litempbotfl=1;
		is_litempbotgr=1;
		is_litemptop=1;
		is_lithk=1;
		is_orog=1;
		is_sftflf=1;
		is_sftgif=1;
		is_sftgrf=1;
		is_strbasemag=1;
		is_tendacabf=1;
		is_tendlibmassbf=1;
		is_tendlibmassbffl=1;
		is_tendlicalvf=0;
		is_tendlifmassbf=0;
		is_tendligroundf=0;
		is_topg=1;
		is_xvelbase=1;
		is_xvelmean=1;
		is_xvelsurf=1;
		is_yvelbase=1;
		is_yvelmean=1;
		is_yvelsurf=1;
		is_zvelbase=0;
		is_zvelsurf=0;
	elseif strcmp(modelname,'VUW_PISM'),
		is_acabf=1;
		is_base=1;
		is_dlithkdt=1;
		is_hfgeoubed=0;
		is_iareafl=0;
		is_iareagr=0;
		is_libmassbffl=1;
		is_libmassbfgr=1;
		is_licalvf=0;
		is_lifmassbf=0;
		is_ligroundf=0;
		is_lim=1;
		is_limnsw=1;
		is_litempbotfl=1;
		is_litempbotgr=1;
		is_litemptop=1;
		is_lithk=1;
		is_orog=1;
		is_sftflf=1;
		is_sftgif=1;
		is_sftgrf=1;
		is_strbasemag=1;
		is_tendacabf=1;
		is_tendlibmassbf=1;
		is_tendlibmassbffl=0;
		is_tendlicalvf=1;
		is_tendlifmassbf=0;
		is_tendligroundf=0;
		is_topg=1;
		is_xvelbase=1;
		is_xvelmean=1;
		is_xvelsurf=1;
		is_yvelbase=1;
		is_yvelmean=1;
		is_yvelsurf=1;
		is_zvelbase=1;
		is_zvelsurf=1;
	else
		error('model not found');
	end
end

function colors = distinguishable_colors(n_colors,bg,func)
% DISTINGUISHABLE_COLORS: pick colors that are maximally perceptually distinct
%
% When plotting a set of lines, you may want to distinguish them by color.
% By default, Matlab chooses a small set of colors and cycles among them,
% and so if you have more than a few lines there will be confusion about
% which line is which. To fix this problem, one would want to be able to
% pick a much larger set of distinct colors, where the number of colors
% equals or exceeds the number of lines you want to plot. Because our
% ability to distinguish among colors has limits, one should choose these
% colors to be "maximally perceptually distinguishable."
%
% This function generates a set of colors which are distinguishable
% by reference to the "Lab" color space, which more closely matches
% human color perception than RGB. Given an initial large list of possible
% colors, it iteratively chooses the entry in the list that is farthest (in
% Lab space) from all previously-chosen entries. While this "greedy"
% algorithm does not yield a global maximum, it is simple and efficient.
% Moreover, the sequence of colors is consistent no matter how many you
% request, which facilitates the users' ability to learn the color order
% and avoids major changes in the appearance of plots when adding or
% removing lines.
%
% Syntax:
%   colors = distinguishable_colors(n_colors)
% Specify the number of colors you want as a scalar, n_colors. This will
% generate an n_colors-by-3 matrix, each row representing an RGB
% color triple. If you don't precisely know how many you will need in
% advance, there is no harm (other than execution time) in specifying
% slightly more than you think you will need.
%
%   colors = distinguishable_colors(n_colors,bg)
% This syntax allows you to specify the background color, to make sure that
% your colors are also distinguishable from the background. Default value
% is white. bg may be specified as an RGB triple or as one of the standard
% "ColorSpec" strings. You can even specify multiple colors:
%     bg = {'w','k'}
% or
%     bg = [1 1 1; 0 0 0]
% will only produce colors that are distinguishable from both white and
% black.
%
%   colors = distinguishable_colors(n_colors,bg,rgb2labfunc)
% By default, distinguishable_colors uses the image processing toolbox's
% color conversion functions makecform and applycform. Alternatively, you
% can supply your own color conversion function.
%
% Example:
%   c = distinguishable_colors(25);
%   figure
%   image(reshape(c,[1 size(c)]))
%
% Example using the file exchange's 'colorspace':
%   func = @(x) colorspace('RGB->Lab',x);
%   c = distinguishable_colors(25,'w',func);

% Copyright 2010-2011 by Timothy E. Holy

  % Parse the inputs
  if (nargin < 2)
    bg = [1 1 1];  % default white background
  else
    if iscell(bg)
      % User specified a list of colors as a cell aray
      bgc = bg;
      for i = 1:length(bgc)
	bgc{i} = parsecolor(bgc{i});
      end
      bg = cat(1,bgc{:});
    else
      % User specified a numeric array of colors (n-by-3)
      bg = parsecolor(bg);
    end
  end
  
  % Generate a sizable number of RGB triples. This represents our space of
  % possible choices. By starting in RGB space, we ensure that all of the
  % colors can be generated by the monitor.
  n_grid = 30;  % number of grid divisions along each axis in RGB space
  x = linspace(0,1,n_grid);
  [R,G,B] = ndgrid(x,x,x);
  rgb = [R(:) G(:) B(:)];
  if (n_colors > size(rgb,1)/3)
    error('You can''t readily distinguish that many colors');
  end
  
  % Convert to Lab color space, which more closely represents human
  % perception
  if (nargin > 2)
    lab = func(rgb);
    bglab = func(bg);
  else
    C = makecform('srgb2lab');
    lab = applycform(rgb,C);
    bglab = applycform(bg,C);
  end

  % If the user specified multiple background colors, compute distances
  % from the candidate colors to the background colors
  mindist2 = inf(size(rgb,1),1);
  for i = 1:size(bglab,1)-1
    dX = bsxfun(@minus,lab,bglab(i,:)); % displacement all colors from bg
    dist2 = sum(dX.^2,2);  % square distance
    mindist2 = min(dist2,mindist2);  % dist2 to closest previously-chosen color
  end
  
  % Iteratively pick the color that maximizes the distance to the nearest
  % already-picked color
  colors = zeros(n_colors,3);
  lastlab = bglab(end,:);   % initialize by making the "previous" color equal to background
  for i = 1:n_colors
    dX = bsxfun(@minus,lab,lastlab); % displacement of last from all colors on list
    dist2 = sum(dX.^2,2);  % square distance
    mindist2 = min(dist2,mindist2);  % dist2 to closest previously-chosen color
    [~,index] = max(mindist2);  % find the entry farthest from all previously-chosen colors
    colors(i,:) = rgb(index,:);  % save for output
    lastlab = lab(index,:);  % prepare for next iteration
  end
end

function c = parsecolor(s)
  if ischar(s)
    c = colorstr2rgb(s);
  elseif isnumeric(s) && size(s,2) == 3
    c = s;
  else
    error('MATLAB:InvalidColorSpec','Color specification cannot be parsed.');
  end
end

function c = colorstr2rgb(c)
  % Convert a color string to an RGB value.
  % This is cribbed from Matlab's whitebg function.
  % Why don't they make this a stand-alone function?
  rgbspec = [1 0 0;0 1 0;0 0 1;1 1 1;0 1 1;1 0 1;1 1 0;0 0 0];
  cspec = 'rgbwcmyk';
  k = find(cspec==c(1));
  if isempty(k)
    error('MATLAB:InvalidColorString','Unknown color string.');
  end
  if k~=3 || length(c)==1,
    c = rgbspec(k,:);
  elseif length(c)>2,
    if strcmpi(c(1:3),'bla')
      c = [0 0 0];
    elseif strcmpi(c(1:3),'blu')
      c = [0 0 1];
    else
      error('MATLAB:UnknownColorString', 'Unknown color string.');
    end
  end
end

function H = hatchfill2(A,varargin)
% HATCHFILL2 Hatching and speckling of patch objects
%   HATCHFILL2(A) fills the patch(es) with handle(s) A. A can be a vector
%   of handles or a single handle. If A is a vector, then all objects of A
%   should be part of the same group for predictable results. The hatch
%   consists of black lines angled at 45 degrees at 40 hatching lines over
%   the axis span with no color filling between the lines.
%
%   A can be handles of patch or hggroup containing patch objects for
%   Pre-R2014b release. For HG2 releases, 'bar' and 'contour' objects are
%   also supported.
%
%   Hatching line object is actively formatted. If A, axes, or figure size
%   is modified, the hatching line object will be updated accordingly to
%   maintain the specified style.
%
%   HATCHFILL2(A,STYL) applies STYL pattern with default paramters. STYL
%   options are:
%      'single'     single lines (the default)
%      'cross'      double-crossed hatch
%      'speckle'    speckling inside the patch boundary
%      'outspeckle' speckling outside the boundary
%      'fill'       no hatching
%
%   HATCHFILL2(A,STYL,Option1Name,Option1Value,...) to customize the
%   hatching pattern
%
%       Name       Description
%      --------------------------------------------------------------------
%      HatchStyle       Hatching pattern (same effect as STYL argument)
%      HatchAngle       Angle of hatch lines in degrees (45)
%      HatchDensity     Number of hatch lines between axis limits
%      HatchOffset      Offset hatch lines in pixels (0)
%      HatchColor       Color of the hatch lines, 'auto' sets it to the
%                       EdgeColor of A
%      HatchLineStyle   Hatch line style
%      HatchLineWidth   Hatch line width
%      SpeckleWidth         Width of speckling region in pixels (7)
%      SpeckleDensity       Density of speckle points (1)
%      SpeckleMarkerStyle   Speckle marker style
%      SpeckleFillColor     Speckle fill color
%      HatchVisible     [{'auto'}|'on'|'off'] sets visibility of the hatch
%                       lines. If 'auto', Visibile option is synced to
%                       underlying patch object
%      HatchSpacing     (Deprecated) Spacing of hatch lines (5)
%
%   In addition, name/value pairs of any properties of A can be specified
%
%   H = HATCHFILL2(...) returns handles to the line objects comprising the
%   hatch/speckle.
%
%   Examples:
%       Gray region with hatching:
%       hh = hatchfill2(a,'cross','HatchAngle',45,'HatchSpacing',5,'FaceColor',[0.5 0.5 0.5]);
%
%       Speckled region:
%       hatchfill2(a,'speckle','HatchAngle',7,'HatchSpacing',1);

% Copyright 2015-2018 Takeshi Ikuma
% History:
% rev. 7 : (01-10-2018)
%   * Added support for 3D faces
%   * Removed HatchSpacing option
%   * Added HatchDensity option
%   * Hatching is no longer defined w.r.t. pixels. HatchDensity is defined
%     as the number of hatch lines across an axis limit. As a result,
%     HatchAngle no longer is the actual hatch angle though it should be
%     close.
%   * [known bug] Speckle hatching style is not working
% rev. 6 : (07-17-2016)
%   * Fixed contours object hatching behavior, introduced in rev.5
%   * Added ContourStyle option to enable fast drawing if contour is convex
% rev. 5 : (05-12-2016)
%   * Fixed Contour with NaN data point disappearnace issue
%   * Improved contours object support
% rev. 4 : (11-18-2015)
%   * Worked around the issue with HG2 contours with Fill='off'.
%   * Removed nagging warning "UseHG2 will be removed..." in R2015b
% rev. 3 : (10-29-2015)
%   * Added support for HG2 AREA
%   * Fixed for HatchColor 'auto' error when HG2 EdgeColor is 'flat'
%   * Fixed listener creation error
% rev. 2 : (10-24-2015)
%   * Added New option: HatchVisible, SpeckleDensity, SpeckleWidth
%     (SpeckleDensity and SpeckleWidtha are separated from HatchSpacing and
%     HatchAngle, respectively)
% rev. 1 : (10-20-2015)
%   * Fixed HG2 contour data extraction bug (was using wrong hidden data)
%   * Fixed HG2 contour color extraction bug
%   * A few cosmetic changes here and there
% rev. - : (10-19-2015) original release
%   * This work is based on Neil Tandon's hatchfill submission
%     (http://www.mathworks.com/matlabcentral/fileexchange/30733)
%     and borrowed code therein from R. Pawlowicz, K. Pankratov, and
%     Iram Weinstein.

narginchk(1,inf);
[A,opts,props] = parse_input(A,varargin);

drawnow % make sure the base objects are already drawn

if verLessThan('matlab','8.4')
   H = cell(1,numel(A));
else
   H = repmat({matlab.graphics.GraphicsPlaceholder},1,numel(A));
end
for n = 1:numel(A)
   H{n} = newhatch(A(n),opts,props);
   
   % if legend of A(n) is shown, add hatching to it as well
   %    leg = handle(legend(ancestor(A,'axes')));
   %    hsrc = [leg.EntryContainer.Children.Object];
   %    hlc = leg.EntryContainer.Children(find(hsrc==A(n),1));
   %    if ~isempty(hlc)
   %       hlc = hlc.Children(1); % LegendIcon object
   %       get(hlc.Children(1))
   %    end
end

if nargout==0
   clear H
else
   H = [H{:}];
   if numel(H)==numel(A)
      H = reshape(H,size(A));
   else
      H = H(:);
   end
end

end

function H = newhatch(A,opts,props)

% 0. retrieve pixel-data conversion parameters
% 1. retrieve face & vertex matrices from A
% 2. convert vertex matrix from data to pixels units
% 3. get xdata & ydata of hatching lines for each face
% 4. concatenate lines sandwitching nan's in between
% 5. convert xdata & ydata back to data units
% 6. plot the hatching line

% traverse if hggroup/hgtransform
if ishghandle(A,'hggroup')
   if verLessThan('matlab','8.4')
      H = cell(1,numel(A));
   else
      H = repmat({matlab.graphics.GraphicsPlaceholder},1,numel(A));
   end
   
   for n = 1:numel(A.Children)
      try
         H{n} = newhatch(A.Children(n),opts,props);
      catch
      end
   end
   
   H = [H{:}];
   return;
end

% Modify the base object property if given
if ~isempty(props)
   pvalold = sethgprops(A,props);
end

try
   vislisena = strcmp(opts.HatchVisible,'auto');
   if vislisena
      vis = A.Visible;
   else
      vis = opts.HatchVisible;
   end

   redraw = strcmp(A.Visible,'off') && ~vislisena;
   if redraw
      A.Visible = 'on'; % momentarily make the patch visible
      drawnow;
   end
   
   % get the base object's vertices & faces
   [V,F,FillFcns] = gethgdata(A); % object does not have its patch data ready
   
   if redraw
      A.Visible = 'off'; % momentarily make the patch visible
   end
   
   if ~isempty(FillFcns)
      FillFcns{1}();
      drawnow;
      [V,F] = gethgdata(A); % object does not have its patch data ready
      FillFcns{2}();
      drawnow;
   end
   
   % recompute hatch line data
   [X,Y,Z] = computeHatchData(handle(ancestor(A,'axes')),V,F,opts);
   
   % 6. plot the hatching line
   commonprops = {'Parent',A.Parent,'DisplayName',A.DisplayName,'Visible',vis};
   if ~strcmp(opts.HatchColor,'auto')
      commonprops = [commonprops {'Color',opts.HatchColor,'MarkerFaceColor',opts.HatchColor}];
   end
   if isempty(regexp(opts.HatchStyle,'speckle$','once'))
      H = line(X,Y,Z,commonprops{:},'LineStyle',opts.HatchLineStyle','LineWidth',opts.HatchLineWidth);
   else
      H = line(X,Y,Z,commonprops{:},'LineStyle','none','Marker',opts.SpeckleMarkerStyle,...
         'MarkerSize',opts.SpeckleSize,'Parent',A.Parent,'DisplayName',A.DisplayName);
   end
   
   if strcmp(opts.HatchColor,'auto')
      syncColor(H,A);
   end
   
   if isempty(H)
      error('Unable to obtain hatching data from the specified object A.');
   end
   
   % 7. Move H so that it is place right above A in parent's uistack
   p = handle(A.Parent);
   Hcs = handle(p.Children);
   [~,idx] = ismember(A,Hcs); % always idx(1)>idx(2) as H was just created
   p.Children = p.Children([2:idx-1 1 idx:end]);
   
   % if HG1, all done | no dynamic adjustment support
   if verLessThan('matlab','8.4')
      return;
   end
   
   % save the config data & set up the object listeners
   setappdata(A,'HatchFill2Opts',opts); % hatching options
   setappdata(A,'HatchFill2Obj',H); % hatching line object
   setappdata(A,'HatchFill2LastData',{V,F}); % last patch data
   setappdata(A,'HatchFill2LastVisible',A.Visible); % last sensitive properties
   setappdata(A,'HatchFill2PostMarkedClean',{}); % run this function at the end of the MarkClean callback and set NoAction flag
   setappdata(A,'HatchFill2NoAction',false); % no action during next MarkClean callback, callback only clears this flag
   setappdata(H,'HatchFill2MatchVisible',vislisena);
   setappdata(H,'HatchFill2MatchColor',strcmp(opts.HatchColor,'auto'));
   setappdata(H,'HatchFill2Patch',A); % base object
   
   %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
   % Create listeners for active formatting
   
   addlistener(H,'ObjectBeingDestroyed',@hatchBeingDeleted);
   
   lis = [
      addlistener(A,'Reparent',@objReparent)
      addlistener(A,'ObjectBeingDestroyed',@objBeingDeleted);
      addlistener(A,'MarkedClean',@objMarkedClean)
      addlistener(A,'LegendEntryDirty',@(h,evt)[])]; % <- study this later
   
   syncprops = {'Clipping','HitTest','Interruptible','BusyAction','UIContextMenu'};
   syncprops(~cellfun(@(p)isprop(A,p),syncprops)) = [];
   for n = 1:numel(syncprops)
      lis(n+2) = addlistener(A,syncprops{n},'PostSet',@syncProperty);
   end
   
catch ME
   % something went wrong, restore the base object properties
   if ~isempty(props)
      for pname = fieldnames(pvalold)'
         name = pname{1};
         val = pvalold.(name);
         if iscell(val)
            pvalold.(name){1}.(name) = pvalold.(name){2};
         else
            A.(name) = pvalold.(name);
         end
      end
   end
   ME.rethrow();
end

end

%%%%%%%%%% EVENT CALLBACK FUNCTIONS %%%%%%%%%%%%
% Base Object's listeners
% objReparent - also move the hatch object
% ObjectingBeingDestroyed - also destroy the hatch object
% MarkedClean - match color if HatchColor = 'auto'
%             - check if vertex & face changed; if so redraw hatch
%             - check if hatch redraw triggered the event due to object's
%               face not shown; if so clear the flag

function objMarkedClean(hp,~)
% CALLBACK for base object's MarkedClean event
% check: visibility change, hatching area change, & color change

if getappdata(hp,'HatchFill2NoAction')
   setappdata(A,'HatchFill2NoAction',false);
   return;
end

% get the main patch object (loops if hggroup or HG2 objects)
H = getappdata(hp,'HatchFill2Obj');

rehatch = ~strcmp(hp.Visible,getappdata(hp,'HatchFill2LastVisible'));
if rehatch % if visibility changed
   setappdata(hp,'HatchFill2LastVisible',hp.Visible);
   if strcmp(hp.Visible,'off') % if made hidden, hide hatching as well
      if getappdata(H,'HatchFill2MatchVisible')
         H.Visible = 'off';
         return; % nothing else to do
      end
   end
end

% get the patch data
[V,F,FillFcns] = gethgdata(hp);
if ~isempty(FillFcns) % patch does not exist, must momentarily generate it
   FillFcns{1}();
   setappdata(A,'HatchFill2PostMarkedClean',FillFcns{2});
   return;
end
if ~rehatch % if visible already 'on', check for the change in object data
   VFlast = getappdata(hp,'HatchFill2LastData');
   rehatch = ~isequaln(F,VFlast{2}) || ~isequaln(V,VFlast{1});
end

% rehatch if patch data/visibility changed
if rehatch 
   % recompute hatch line data
   [X,Y,Z] = computeHatchData(ancestor(H,'axes'),V,F,getappdata(hp,'HatchFill2Opts'));
   
   % update the hatching line data
   set(H,'XData',X,'YData',Y,'ZData',Z);

   % save patch data
   setappdata(hp,'HatchFill2LastData',{V,F});
end

% sync the color
syncColor(H,hp);

% run post callback if specified (expect it to trigger another MarkedClean
% event immediately)
fcn = getappdata(hp,'HatchFill2PostMarkedClean');
if ~isempty(fcn)
   setappdata(hp,'HatchFill2PostMarkedClean',function_handle.empty);
   setappdata(hp,'HatchFill2NoAction',true);
   fcn();
   return;
end

end

function syncProperty(~,evt)
% sync Visible property to the patch object
hp = handle(evt.AffectedObject); % patch object
hh = getappdata(hp,'HatchFill2Obj');
hh.(evt.Source.Name) = hp.(evt.Source.Name);
end

function objReparent(hp,evt)
%objReparent event listener callback

pnew = evt.NewValue;
if isempty(pnew)
   return; % no change?
end

% move the hatch line object over as well
H = getappdata(hp,'HatchFill2Obj');
H.Parent = pnew;

% make sure to move the hatch line object right above the patch object
Hcs = handle(pnew.Children);
[~,idx] = ismember(hp,Hcs); % always idx(1)>idx(2) as H was just moved
pnew.Children = pnew.Children([2:idx-1 1 idx:end]);

end

function objBeingDeleted(hp,~)
%when base object is deleted

if isappdata(hp,'HatchFill2Obj')
   H = getappdata(hp,'HatchFill2Obj');
   try % in case H is already deleted
   delete(H);
   catch
   end
end

end

function hatchBeingDeleted(hh,~)
%when hatch line object (hh) is deleted

if isappdata(hh,'HatchFill2Patch')
   
   %   remove listeners listening to the patch object
   hp = getappdata(hh,'HatchFill2Patch');
   
   if isappdata(hp,'HatchFill2Listeners')
      delete(getappdata(hp,'HatchFill2Listeners'));
      rmappdata(hp,'HatchFill2Listeners');
   end
end

end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function varargout = computeHatchData(ax,V,F,opts)

varargout = cell(1,nargout);

if isempty(V) % if patch shown
   return;
end

N = size(F,1);
XYZc = cell(2,N);
for n = 1:N % for each face
   
   % 2. get xdata & ydata of the vertices of the face in transformed bases
   f = F(n,:); % get indices to the vertices of the face
   f(isnan(f)) = [];
   
   [v,T,islog] = transform_data(ax,V(f,:),[]); % transform the face
   if isempty(v) % face is not hatchable
      continue;
   end
   
   % 2. get xdata & ydata of hatching lines for each face
   if any(strcmp(opts.HatchStyle,{'speckle','outsidespeckle'}))
      xy = hatch_xy(v.',opts.HatchStyle,opts.SpeckleWidth,opts.SpeckleDensity,opts.HatchOffset);
   else
      xy = hatch_xy(v.',opts.HatchStyle,opts.HatchAngle,opts.HatchDensity,opts.HatchOffset);
   end
   
   % 3. revert the bases back to 3D Eucledian space
   XYZc{1,n} = revert_data(xy',T,islog).';
end

% 4. concatenate hatch lines across faces sandwitching nan's in between
[XYZc{2,:}] = deal(nan(3,1));
XYZ = cat(2,XYZc{:});

% 5. convert xdata & ydata back to data units
[varargout{1:3}] = deal(XYZ(1,:),XYZ(2,:),XYZ(3,:));

end

function tf = issupported(hbase)
% check if all of the given base objects are supported

supported_objtypes = {'patch','hggroup','bar','contour','area','surface','histogram'};

if isempty(hbase)
   tf = false;
else
   tf = ishghandle(hbase,supported_objtypes{1});
   for n = 2:numel(supported_objtypes)
      tf(:) = tf | ishghandle(hbase,supported_objtypes{n});
   end
   tf = all(tf);
end

end

% synchronize hatching line color to the patch's edge color if HatchColor =
% 'auto'
function syncColor(H,A)

if ~getappdata(H,'HatchFill2MatchColor')
   % do not sync
   return;
end

if ishghandle(A,'patch') || ishghandle(A,'Bar') || ishghandle(A,'area') ...
      || ishghandle(A,'surface') || ishghandle(A,'Histogram') %HG2
   pname = 'EdgeColor';
elseif ishghandle(A,'contour') % HG2
   pname = 'LineColor';
end
color = A.(pname);
if strcmp(color,'flat')
   try
      color = double(A.Edge(1).ColorData(1:3)')/255;
   catch
      warning('Does not support CData based edge color.');
      color = 'k';
   end
end
H.Color = color;
H.MarkerFaceColor = color;

end

function [V,F,FillFcns] = gethgdata(A)
% Get vertices & face data from the object along with the critical
% properties to observe change in the hatching area

% initialize the output variable
F = [];
V = [];
FillFcns = {};

if ~isvalid(A) || strcmp(A.Visible,'off')
   return;
end

if ishghandle(A,'patch')
   V = A.Vertices;
   F = A.Faces;
elseif ishghandle(A,'bar')
   [V,F] = getQuadrilateralData(A.Face);
elseif ishghandle(A,'area')
   [V,F] = getTriangleStripData(A.Face);
   set(A,'FaceColor','none');
elseif ishghandle(A,'surface') % HG2
   if strcmp(A.FaceColor,'none')
      FillFcns = {@()set(A,'FaceColor','w'),@()set(A,'FaceColor','none')};
      return;
   end
   [V,F] = getQuadrilateralData(A.Face);
elseif ishghandle(A,'contour') % HG2
   
   % Retrieve data from hidden FacePrims property (a TriangleStrip object)
   if strcmp(A.Fill,'off')
      FillFcns = {@()set(A,'Fill','on'),@()set(A,'Fill','off')};
      return;
   end
   [V,F] = getTriangleStripData(A.FacePrims);
elseif ishghandle(A,'histogram') %HG2: Quadrateral underlying data object
   [V,F] = getQuadrilateralData(A.NodeChildren(4));
end

end

function [V,F] = getQuadrilateralData(A) % surface, bar, histogram,

if isempty(A)
   warning('Cannot hatch the face: Graphics object''s face is not defined.');
   V = [];
   F = [];
   return;
end

V = A.VertexData';

% If any of the axes is in log scale, V is normalized to wrt the axes
% limits,
V(:) = norm2data(V,A);

if ~isempty(A.VertexIndices) % vertices likely reused on multiple quadrilaterals
   I = A.VertexIndices;
   Nf = numel(I)/4; % has to be divisible by 4
else %every 4 consecutive vertices defines a quadrilateral
   Nv = size(V,1);
   Nf = Nv/4;
   I = 1:Nv;
end
F = reshape(I,4,Nf)';
if ~isempty(A.StripData) % hack workaround
   F(:) = F(:,[1 2 4 3]);
end
try
   if ~any(all(V==V(1,:))) % not on any Euclidian plane
      % convert quadrilateral to triangle strips
      F = [F(:,1:3);F(:,[1 3 4])];
   end
catch % if implicit array expansion is not supported (<R2016b)
   if all(V(:,1)~=V(1,1)) || all(V(:,2)~=V(1,2)) || all(V(:,3)~=V(1,3)) % not on any Euclidian plane
      % convert quadrilateral to triangle strips
      F = [F(:,1:3) F(:,[1 3 4])];
   end
end

end

function [V,F] = getTriangleStripData(A) % area & contour

if isempty(A)
   warning('Cannot hatch the face: Graphics object''s face is not defined.');
   V = [];
   F = [];
   return;
end

V = A.VertexData';
I = double(A.StripData);

% If any of the axes is in log scale, V is normalized to wrt the axes
% limits,
V(:) = norm2data(V,A);

N = numel(I)-1; % # of faces
m = diff(I);
M = max(m);
F = nan(N,M);
for n = 1:N
   idx = I(n):(I(n+1)-1);
   if mod(numel(idx),2) % odd
      idx(:) = idx([1:2:end end-1:-2:2]);
   else % even
      idx(:) = idx([1:2:end-1 end:-2:2]);
   end
   F(n,1:numel(idx)) = idx;
end
end

% if graphical objects are given normalized to the axes
function V = norm2data(V,A)
ax = ancestor(A,'axes');
inlog = strcmp({ax.XScale ax.YScale ax.ZScale},'log');
if any(inlog)
   lims = [ax.XLim(:) ax.YLim(:) ax.ZLim(:)];
   dirs = strcmp({ax.XDir ax.YDir ax.ZDir},'normal');
   for n = 1:3 % for each axis
      if inlog(n)
         lims(:,n) = log10(lims(:,n));
      end
      V(:,n) = V(:,n)*diff(lims(:,n));
      if dirs(n)
         V(:,n) = V(:,n) + lims(1,n);
      else
         V(:,n) = lims(2,n) - V(:,n);
      end
      if inlog(n)
         V(:,n) = 10.^V(:,n);
      end
   end
end
end

function pvalold = sethgprops(A,props)
% grab the common property names of the base objects

pnames = fieldnames(props);
if ishghandle(A,'hggroup')
   gpnames = fieldnames(set(A));
   [tf,idx] = ismember(gpnames,pnames);
   idx(~tf) = [];
   for i = idx'
      pvalold.(pnames{i}) = A.(pnames{i});
      A.(pnames{i}) = props.(pnames{i});
   end
   props = rmfield(props,pnames(idx));
   
   h = handle(A.Children);
   for n = 1:numel(h)
      pvalold1 = sethgprops(h(n),props);
      ponames = fieldnames(pvalold1);
      for k = 1:numel(ponames)
         pvalold.(ponames{k}) = {h(n) pvalold1.(ponames{k})};
      end
   end
else
   for n = 1:numel(pnames)
      pvalold.(pnames{n}) = A.(pnames{n});
      A.(pnames{n}) = props.(pnames{n});
   end
end

end

function xydatai = hatch_xy(xydata,styl,angle,step,offset)
%
% M_HATCH Draws hatched or speckled interiors to a patch
%
%    M_HATCH(LON,LAT,STYL,ANGLE,STEP,...line parameters);
%
% INPUTS:
%     X,Y - vectors of points.
%     STYL - style of fill
%     ANGLE,STEP - parameters for style
%
%     E.g.
%
%      'single',45,5  - single cross-hatch, 45 degrees,  5 points apart
%      'cross',40,6   - double cross-hatch at 40 and 90+40, 6 points apart
%      'speckle',7,1  - speckled (inside) boundary of width 7 points, density 1
%                               (density >0, .1 dense 1 OK, 5 sparse)
%      'outspeckle',7,1 - speckled (outside) boundary of width 7 points, density 1
%                               (density >0, .1 dense 1 OK, 5 sparse)
%
%
%      H=M_HATCH(...) returns handles to hatches/speckles.
%
%      [XI,YI,X,Y]=MHATCH(...) does not draw lines - instead it returns
%      vectors XI,YI of the hatch/speckle info, and X,Y of the original
%      outline modified so the first point==last point (if necessary).
%
%     Note that inside and outside speckling are done quite differently
%     and 'outside' speckling on large coastlines can be very slow.

%
% Hatch Algorithm originally by K. Pankratov, with a bit stolen from
% Iram Weinsteins 'fancification'. Speckle modifications by R. Pawlowicz.
%
% R Pawlowicz 15/Dec/2005

I = zeros(1,size(xydata,2));

% face vertices are not always closed
if any(xydata(:,1)~=xydata(:,end))
   xydata(:,end+1) = xydata(:,1);
   I(end+1) = I(1);
end

if any(strcmp(styl,{'speckle','outspeckle'}))
   angle = angle*(1-I);
end

switch styl
   case 'single'
      xydatai = drawhatch(xydata,angle,1/step,0,offset);
   case 'cross'
      xydatai = [...
         drawhatch(xydata,angle,1/step,0,offset) ...
         drawhatch(xydata,angle+90,1/step,0,offset)];
   case 'speckle'
      xydatai = [...
         drawhatch(xydata,45,   1/step,angle,offset) ...
         drawhatch(xydata,45+90,1/step,angle,offset)];
   case 'outspeckle'
      xydatai = [...
         drawhatch(xydata,45,   1/step,-angle,offset) ...
         drawhatch(xydata,45+90,1/step,-angle,offset)];
      inside = logical(inpolygon(xydatai(1,:),xydatai(2,:),x,y)); % logical needed for v6!
      xydatai(:,inside) = [];
   otherwise
      xydatai = zeros(2,0);
end

end

%%%

function xydatai = drawhatch(xydata,angle,step,speckle,offset)
% xydata is given as 2xN matrix, x on the first row, y on the second

% Idea here appears to be to rotate everthing so lines will be
% horizontal, and scaled so we go in integer steps in 'y' with
% 'points' being the units in x.
% Center it for "good behavior".

% rotate first about (0,0)
ca = cosd(angle); sa = sind(angle);
u = [ca sa]*xydata;              % Rotation
v = [-sa ca]*xydata;

% translate to the grid point nearest to the centroid
u0 = round(mean(u)/step)*step; v0 = round(mean(v)/step)*step;
x = (u-u0); y = (v-v0)/step+offset;    % plus scaling and offsetting

% Compute the coordinates of the hatch line ...............
yi = ceil(y);
yd = [diff(yi) 0]; % when diff~=0 we are crossing an integer
fnd = find(yd);    % indices of crossings
dm = max(abs(yd)); % max possible #of integers between points

% This is going to be pretty space-inefficient if the line segments
% going in have very different lengths. We have one column per line
% interval and one row per hatch line within that interval.
%
A = cumsum( repmat(sign(yd(fnd)),dm,1), 1);

% Here we interpolate points along all the line segments at the
% correct intervals.
fnd1 = find(abs(A)<=abs( repmat(yd(fnd),dm,1) ));
A  = A+repmat(yi(fnd),dm,1)-(A>0);
xy = (x(fnd+1)-x(fnd))./(y(fnd+1)-y(fnd));
xi = repmat(x(fnd),dm,1)+(A-repmat(y(fnd),dm,1) ).*repmat(xy,dm,1);
yi = A(fnd1);
xi = xi(fnd1);

% Sorting points of the hatch line ........................
%%yi0 = min(yi); yi1 = max(yi);
% Sort them in raster order (i.e. by x, then by y)
% Add '2' to make sure we don't have problems going from a max(xi)
% to a min(xi) on the next line (yi incremented by one)
xi0 = min(xi); xi1 = max(xi);
ci = 2*yi*(xi1-xi0)+xi;
[~,num] = sort(ci);
xi = xi(num); yi = yi(num);

% if this happens an error has occurred somewhere (we have an odd
% # of points), and the "fix" is not correct, but for speckling anyway
% it really doesn't make a difference.
if rem(length(xi),2)==1
   xi = [xi; xi(end)];
   yi = [yi; yi(end)];
end

% Organize to pairs and separate by  NaN's ................
li = length(xi);
xi = reshape(xi,2,li/2);
yi = reshape(yi,2,li/2);

% The speckly part - instead of taking the line we make a point some
% random distance in.
if length(speckle)>1 || speckle(1)~=0
   
   if length(speckle)>1
      % Now we get the speckle parameter for each line.
      
      % First, carry over the speckle parameter for the segment
      %   yd=[0 speckle(1:end-1)];
      yd = speckle(1:end);
      A=repmat(yd(fnd),dm,1);
      speckle=A(fnd1);
      
      % Now give it the same preconditioning as for xi/yi
      speckle=speckle(num);
      if rem(length(speckle),2)==1
         speckle = [speckle; speckle(end)];
      end
      speckle=reshape(speckle,2,li/2);
      
   else
      speckle=[speckle;speckle];
   end
   
   % Thin out the points in narrow parts.
   % This keeps everything when abs(dxi)>2*speckle, and then makes
   % it increasingly sparse for smaller intervals.
   dxi=diff(xi);
   nottoosmall=sum(speckle,1)~=0 & rand(1,li/2)<abs(dxi)./(max(sum(speckle,1),eps));
   xi=xi(:,nottoosmall);
   yi=yi(:,nottoosmall);
   dxi=dxi(nottoosmall);
   if size(speckle,2)>1, speckle=speckle(:,nottoosmall); end
   % Now randomly scatter points (if there any left)
   li=length(dxi);
   if any(li)
      xi(1,:)=xi(1,:)+sign(dxi).*(1-rand(1,li).^0.5).*min(speckle(1,:),abs(dxi) );
      xi(2,:)=xi(2,:)-sign(dxi).*(1-rand(1,li).^0.5).*min(speckle(2,:),abs(dxi) );
      % Remove the 'zero' speckles
      if size(speckle,2)>1
         xi=xi(speckle~=0);
         yi=yi(speckle~=0);
      end
   end
else
   xi = [xi; ones(1,li/2)*nan];  % Separate the line segments
   yi = [yi; ones(1,li/2)*nan];
end

% Transform back to the original coordinate system
xydatai = [ca -sa;sa ca]*[xi(:)'+u0;(yi(:)'-offset)*step+v0];

end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [h,opts,props] = parse_input(h,argin)
% parse & validate input arguments

patchtypes = {'single','cross','speckle','outspeckle','fill','none'};

% get base object handle
if ~issupported(h)
   error('Unsupported graphics handle type.');
end
h = handle(h);

% get common property names
pnames = getcommonprops(h);

% if style argument is given, convert it to HatchStyle option pair
stylearg = {};
if ~isempty(argin) && ischar(argin{1})
   try
      ptypes = validatestring(argin{1},patchtypes);
      stylearg = {'HatchStyle' ptypes};
      argin(1) = [];
   catch
      % STYL not given, continue on
   end
end

% create inputParser for options
p = inputParser;
p.addParameter('HatchStyle','single');
p.addParameter('HatchAngle',45,@(v)validateattributes(v,{'numeric'},{'scalar','finite','real'}));
p.addParameter('HatchDensity',40,@(v)validateattributes(v,{'numeric'},{'scalar','positive','finite','real'}));
p.addParameter('HatchSpacing',[],@(v)validateattributes(v,{'numeric'},{'scalar','positive','finite','real'}));
p.addParameter('HatchOffset',0,@(v)validateattributes(v,{'numeric'},{'scalar','nonnegative','<',1,'real'}));
p.addParameter('HatchColor','auto',@validatecolor);
p.addParameter('HatchLineStyle','-');
p.addParameter('HatchLineWidth',0.5,@(v)validateattributes(v,{'numeric'},{'scalar','positive','finite','real'}));
p.addParameter('SpeckleWidth',7,@(v)validateattributes(v,{'numeric'},{'scalar','finite','real'}));
p.addParameter('SpeckleDensity',100,@(v)validateattributes(v,{'numeric'},{'scalar','positive','finite','real'}));
p.addParameter('SpeckleMarkerStyle','.');
p.addParameter('SpeckleSize',2,@(v)validateattributes(v,{'numeric'},{'scalar','positive','finite'}));
p.addParameter('SpeckleFillColor','auto',@validatecolor);
p.addParameter('HatchVisible','auto');

for n = 1:numel(pnames)
   p.addParameter(pnames{n},[]);
end
p.parse(stylearg{:},argin{:});

rnames = fieldnames(p.Results);
isopt = ~cellfun(@isempty,regexp(rnames,'^(Hatch|Speckle)','once')) | strcmp(rnames,'ContourStyle');
props = struct([]);
for n = 1:numel(rnames)
   if isopt(n)
      opts.(rnames{n}) = p.Results.(rnames{n});
   elseif ~isempty(p.Results.(rnames{n}))
      props(1).(rnames{n}) = p.Results.(rnames{n});
   end
end

opts.HatchStyle = validatestring(opts.HatchStyle,patchtypes);
if any(strcmp(opts.HatchStyle,{'speckle','outspeckle'}))
   warning('hatchfill2:PartialSupport','Speckle/outspeckle HatchStyle may not work in the current release of hatchfill2')
end
if strcmpi(opts.HatchStyle,'none') % For backwards compatability:
   opts.HatchStyle = 'fill';
end
opts.HatchLineStyle = validatestring(opts.HatchLineStyle,{'-','--',':','-.'},mfilename,'HatchLineStyle');

if ~isempty(opts.HatchSpacing)
   warning('HatchSpacing option has been deprecated. Use ''HatchDensity'' option instead.');
end
opts = rmfield(opts,'HatchSpacing');

opts.SpeckleMarkerStyle = validatestring(opts.SpeckleMarkerStyle,{'+','o','*','.','x','square','diamond','v','^','>','<','pentagram','hexagram'},'hatchfill2','SpeckleMarkerStyle');
opts.HatchVisible = validatestring(opts.HatchVisible,{'auto','on','off'},mfilename,'HatchVisible');

end

function pnames = getcommonprops(h)
% grab the common property names of the base objects

V = set(h(1));
pnames = fieldnames(V);
if ishghandle(h(1),'hggroup')
   pnames = union(pnames,getcommonprops(get(h(1),'Children')));
end
for n = 2:numel(h)
   V = set(h(n));
   pnames1 = fieldnames(V);
   if ishghandle(h(n),'hggroup')
      pnames1 = union(pnames1,getcommonprops(get(h(n),'Children')));
   end
   pnames = intersect(pnames,pnames1);
end

end

function validatecolor(val)

try
   validateattributes(val,{'double','single'},{'numel',3,'>=',0,'<=',1});
catch
   validatestring(val,{'auto','y','yellow','m','magenta','c','cyan','r','red',...
      'g','green','b','blue','w','white','k','black'});
end
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% axes unit conversion functions

function [V,T,islog] = transform_data(ax,V,ref)
% convert vertices data to hatch-ready form
% - if axis is log-scaled, data is converted to their log10 values
% - if 3D (non-zero z), spatially transform data onto the xy-plane. If
%   reference point is given, ref is mapped to the origin. Otherwise, ref
%   is chosen to be the axes midpoint projected onto the patch plane. Along
%   with the data, the axes corner coordinates are also projected onto the
%   patch plane to obtain the projected axes limits.
% - transformed xy-data are then normalized by the projected axes spans.

noZ = size(V,2)==2;

xl = ax.XLim;
yl = ax.YLim;
zl = ax.ZLim;

% log to linear space
islog = strcmp({ax.XScale ax.YScale ax.ZScale},'log');
if islog(1)
   V(:,1) = log10(V(:,1));
   xl = log10(xl);
   if ~isempty(ref)
      ref(1) = log10(ref(1));
   end
end
if islog(2)
   V(:,2) = log10(V(:,2));
   yl = log10(yl);
   if ~isempty(ref)
      ref(2) = log10(ref(2));
   end
end
if islog(3) && ~noZ
   V(:,3) = log10(V(:,3));
   zl = log10(zl);
   if ~isempty(ref)
      ref(3) = log10(ref(3));
   end
end

if noZ
   V(:,3) = 0;
end

% if not given, pick the reference point to be the mid-point of the current
% axes
if isempty(ref)
   ref = [mean(xl) mean(yl) mean(zl)];
end

% normalize the axes so that they span = 1;
Tscale = makehgtform('scale', [1/diff(xl) 1/diff(yl) 1/diff(zl)]);
V(:) = V*Tscale(1:3,1:3);
ref(:) = ref*Tscale(1:3,1:3);

% obtain unique vertices
Vq = double(unique(V,'rows')); % find unique points (sorted order)
Nq = size(Vq,1);
if Nq<3 || any(isinf(Vq(:))) || any(isnan(Vq(:))) % not hatchable
   V = [];
   T = [];
   return;
end

try % erros if 2D object
   zq = unique(Vq(:,3));
catch
   V(:,3) = 0;
   zq = 0;
end
T = eye(4);
if isscalar(zq) % patch is on a xy-plane
   if zq~=0 % not on the xy-plane
      T = makehgtform('translate',[0 0 -zq]);
   end
else
   % if patch is not on a same xy-plane
   
   % use 3 points likely well separated
   idx = round((0:2)/2*(Nq-1))+1;
   
   % find unit normal vector of the patch plane
   norm = cross(Vq(idx(1),:)-Vq(idx(3),:),Vq(idx(2),:)-Vq(idx(3),:)); % normal vector
   norm(:) = norm/sqrt(sum(norm.^2));
   
   % define the spatial rotation
   theta = acos(norm(3));
   if theta>pi/2, theta = theta-pi; end
   u = [norm(2) -norm(1) 0];
   Trot = makehgtform('axisrotate',u,theta);
   
   % project the reference point onto the plane
   P = norm.'*norm;
   ref_proj = ref*(eye(3) - P) + Vq(1,:)*P;
   if norm(3)
      T = makehgtform('translate', -ref_proj); % user specified reference point or -d/norm(3) for z-crossing
   end
   
   % apply the rotation now
   T(:) = Trot*T;
   
   % find the axes limits on the transformed space
   %    [Xlims,Ylims,Zlims] = ndgrid(xl,yl,zl);
   %    Vlims = [Xlims(:) Ylims(:) Zlims(:)];
   %    Vlims_proj = [Vlims ones(8,1)]*T';
   %    lims_proj = [min(Vlims_proj(:,[1 2]),[],1);max(Vlims_proj(:,[1 2]),[],1)];
   %    xl = lims_proj(:,1)';
   %    yl = lims_proj(:,2)';
end

% perform the transformation
V(:,4) = 1;
V = V*T';
V(:,[3 4]) = [];

T(:) = T*Tscale;

end

function V = revert_data(V,T,islog)

N = size(V,1);
V = [V zeros(N,1) ones(N,1)]/T';
V(:,end) = [];

% log to linear space
if islog(1)
   V(:,1) = 10.^(V(:,1));
end
if islog(2)
   V(:,2) = 10.^(V(:,2));
end
if islog(3)
   V(:,3) = 10.^(V(:,3));
end

end