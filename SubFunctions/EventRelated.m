function [ p,h,trend ] = EventRelated( Timestamp,Event,EWin,WWin,Bin,nDivide,alpha )
%EVENTRELATED examine if a neuron is event-related
%   INPUT
%   EWin: Event window; e.g. [-3 3]
%   WWin: Wider window (as basline activity); e.g. [-20 20]
%   
%   OUTPUT
%   trend: 1 means neural activity was increased during Event 
%          -1 means neural activity was decreased during Event
if(nargin<7)
    alpha = 0.05;
elseif(nargin<6)
    nDivide = 1;
end
EventSR = getSpikeRaster(Timestamp,Event,EWin,Bin); % Event window SpikeRaster
WSR = getSpikeRaster(Timestamp,Event,WWin,Bin); %Winder window SpikeRaster
diff = getevrFR(EventSR,Bin) - getevrFR(WSR,Bin); %difference
if(diff >=0)
    trend = 1; % neural activity was increased 
else
    trend = -1; % neural activity was decreased
end

EWinW = EWin(1,2) - EWin(1,1); %EWindowWidth
subEWinW = floor(EWinW/nDivide);

p=1;
h=false;

for n=1:nDivide
    subEventSR = getSpikeRaster(Timestamp,Event,[EWin(1,1)+(n-1)*subEWinW,EWin(1,1)+n*subEWinW],Bin); %subEvent SpikeRaster
    
    [pn,hn] = RankSumTest(subEventSR,WSR,alpha);
    % if any subEvent has significat difference
    p = min(p,pn); 
    h = h|hn; 
end
end

