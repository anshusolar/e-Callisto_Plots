%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%% BY CRAZY SOUL %%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%

close all;
clear all;
clc;
fclose all;

%%define the file name and path & read the header and data
[file,path,indx] = uigetfile('*.fit');
data=fitsread(file,'primary');
header=fitsread(file,'binarytable');
time=cell2mat(header(1));
freq=cell2mat(header(2));

%converting time into UT
a=fitsinfo(file);
%t1=a.PrimaryData.Keywords{18,2};
%t2=a.PrimaryData.Keywords{20,2};
k=a.PrimaryData.Keywords;
firstCol = k(:,1);
Index1 = strfind(firstCol, 'TIME-OBS');
p1=find(~cellfun(@isempty,Index1));
Index2 = strfind(firstCol, 'TIME-END');
p2=find(~cellfun(@isempty,Index2));

t1=a.PrimaryData.Keywords{p1,2};
t2=a.PrimaryData.Keywords{p2,2};

t11=strsplit(t1,':');
start_HH = str2num(t11{1,1});
start_MM = str2num(t11{1,2});
start_SS = str2num(t11{1,3});

t22=strsplit(t2,':');
end_HH = str2num(t22{1,1});
end_MM = str2num(t22{1,2});
end_SS = str2num(t22{1,3});

start_time =  start_HH+start_MM/60+start_SS/3600;
end_time =  end_HH+end_MM/60+end_SS/3600;

time = linspace(start_time,end_time,length(data));

%%plot the spectra
figure(1)
imagesc(time,freq,data)
set(gca,'YDir','Normal')
title({file, 'Raw Spectra'}, 'Interpreter', 'none','FontSize', 14)
xlabel('Universal Time (hh.mm)','FontSize', 14);
ylabel('Frequency (MHz)','FontSize', 14);
colorbar;

%% background subtraced data
figure(2)
med_data=median(data(:,1:100),2);
med_array =  med_data*ones(1,length(data));
clean = data-med_array;
imagesc(time,freq,clean)
set(gca,'YDir','Normal')
title({file, 'Background Subtracted Spectra'}, 'Interpreter', 'none','FontSize', 14)
xlabel('Universal Time (hh.mm)','FontSize', 14);
ylabel('Frequency (MHz)','FontSize', 14);
colorbar;

%median filtered noise removed data
figure(3)
imagesc(time,freq,medfilt2(clean))
set(gca,'YDir','Normal')
title({file, 'Noise removed Spectra'}, 'Interpreter', 'none','FontSize', 14)
xlabel('Universal Time (hh.mm)','FontSize', 14);
ylabel('Frequency (MHz)','FontSize', 14);
colorbar;