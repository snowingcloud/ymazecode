function [ Timestamps ] = loadTimestamp()
%Load timestamps (in second) from sorted NEV file
%   input arguments     
%   'savemat' save output as MAT file
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   SW
%   Fudan U
%   Version 1.0.0
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% Validating input arguments




%% load data from NEV file using openNEV
[fileName pathName] = uigetfile('*.nev','Pick a NEV file');
fileFullPath = [pathName fileName];
if (fileFullPath == 0) 
       disp('No file was selected.');
       return
end

NEVdata = openNEV(fileFullPath, 'nosave' );
TimeStamp = NEVdata.Data.Spikes.TimeStamp;
Electrode = NEVdata.Data.Spikes.Electrode;
Unit = NEVdata.Data.Spikes.Unit;

if ~((size(TimeStamp,2) == size(Electrode,2)) && (size(Electrode,2) == size(Unit,2)))
    dsip('sizes are not equal!!!');
    return
end

%% Re-arrange spikes as sorted units

Timestamps = getSortedData(TimeStamp,Electrode,Unit);

end

