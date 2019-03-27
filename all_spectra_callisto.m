close all;
clear all;
clc;
fclose all;

%%define the file name and path & read the header and data
%[file,path,indx] = uigetfile('*.fit');


spectrafiles = dir('ZSTS*.fit');
nfiles = length(spectrafiles);    % Number of files found

for ii=1:nfiles
currentfilename = spectrafiles(ii).name;
currentdata = fitsread(currentfilename,'primary');
currentheader=fitsread(currentfilename,'binarytable');
data1{ii} = currentdata;
header1{ii} = currentheader;
end

data=cell2mat(data1);

freq=cell2mat(header1{1,1}(1,2));
time=cell2mat(header1{1,1}(1,1));

%header=cell2mat(header1);

%time=cell2mat(header(1));
%freq=cell2mat(currentheader(2));


%converting time into UT

file1=spectrafiles(1,1).name;
a1=fitsinfo(file1);
%t1=a.PrimaryData.Keywords{18,2};
%t2=a.PrimaryData.Keywords{20,2};
k1=a1.PrimaryData.Keywords;
firstCol1 = k1(:,1);
Index1 = strfind(firstCol1, 'TIME-OBS');
p1=find(~cellfun(@isempty,Index1));


file_end=spectrafiles(nfiles,1).name;
a2=fitsinfo(file_end);
%t1=a.PrimaryData.Keywords{18,2};
%t2=a.PrimaryData.Keywords{20,2};
k2=a2.PrimaryData.Keywords;
firstCol2 = k2(:,1);
Index2 = strfind(firstCol2, 'TIME-END');
p2=find(~cellfun(@isempty,Index2));

t1=a1.PrimaryData.Keywords{p1,2};
t2=a2.PrimaryData.Keywords{p2,2};

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
%freq=linspace(1,200,100);
%%plot the spectra
figure(1)
imagesc(time,freq,data)
set(gca,'YDir','Normal')
title({file1, 'Raw Spectra'}, 'Interpreter', 'none','FontSize', 14)
xlabel('Universal Time (hh.mm)','FontSize', 14);
ylabel('Frequency (MHz)','FontSize', 14);
colorbar;

%% background subtraced data
figure(2)
med_data=median(data(:,end-100:end),2);
med_array =  med_data*ones(1,length(data));
clean = data-med_array;
imagesc(time,freq,clean)
set(gca,'YDir','Normal')
title({strcat(file1), 'Background Subtracted Spectra'}, 'Interpreter', 'none','FontSize', 14)
xlabel('Universal Time (hh.mm)','FontSize', 14);
ylabel('Frequency (MHz)','FontSize', 14);
colorbar;

%median filtered noise removed data
figure(3)
imagesc(time,freq,medfilt2(clean))
set(gca,'YDir','Normal')
title({file1, 'Noise removed Spectra'}, 'Interpreter', 'none','FontSize', 14)
xlabel('Universal Time (hh.mm)','FontSize', 14);
ylabel('Frequency (MHz)','FontSize', 14);
colorbar;
saveas(gcf,strcat(file1,'_clean','.png'))