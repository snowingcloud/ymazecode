function [ BaselineHis,TestingHis, ExCIresult ] = CollectNaiveResults( BaselineT,TestingT,Bin,n )
%COLLECTNAIVERESULTS Summary of this function goes here
%   Collect all BaselineHis and TestingHis from one treatment
%   Ver 1.0.0 Jan 12 2014
%   Ver 1.0.1 Jan 12 2014 minimal of Baseline fire rate > 0.1 HZ
%   Ver 1.1.0 Jan 14 2014 added ExCIresults.
if (nargin < 4)
    n = ceil(1200./Bin); % at least 20 min
end

%load all data
[fileName pathName] = uigetfile('*.mat','Pick a mat file');
fileFullPath = [pathName fileName];
if (fileFullPath == 0) 
       disp('No file was selected.');
       return
end
Alldata = struct2cell(load(fileFullPath));

BaselineHis = [];
TestingHis = [];
CIs = []; %all CI
for i=1:length(Alldata)
    [BH,TH,CI] = NaiveAnalysis( Alldata{i},BaselineT,TestingT,Bin,0);
    %minimal of Baseline fire rate > 0.1 HZ
    BaselineHis = [BaselineHis;BH(min(BH,[],2)>0.1,:)]; 
    TestingHis = [TestingHis;TH(min(BH,[],2)>0.1,:)];
    CIs = [CIs;CI(min(BH,[],2)>0.1,:)];
    
end
ExCIresult = ExceedCI( CIs,TestingHis,n );
end

