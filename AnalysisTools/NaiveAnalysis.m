function [ BaselineHis,TestingHis,BaselineCI] = NaiveAnalysis( TSCell,BaselineT,TestingT,Bin,plothere )
%NAIVEANALYSIS Naive Homecage Analysis
%   
%   You NEED to load NEV file using loadTimestamp first.
%   TSCell here could be a complete recording session.
%   TSCell(TimestampCell): The whole timestamp of all neurons recorded from a daily session
%   BaselineT (sec): Set this time as Baseline Time, Example: 600 for 10 min
%   TestT (sec): Set this time as post-treatment Testing Time, Example: 10800 for 3hr
%   Bin (sec): Example: 120 for 120 sec bin

%   Ver: 1.0.0
%   Ver: 1.0.1 Auto-set PauseTime
%   Ver: 1.0.2 Added output BaselineHis,TestingHis
%   Ver: 1.1.0 Added output BaslineCI, for determine response type
%              1: increaded; -1: decreased; 0: Neutral
if (nargin < 5)
    plothere = 1;
end

PauseTime = getPauseTime(TSCell{1}.Timestamp);
nNeu = getnNeu(TSCell);

[ dividedTS ] = divideTimestamp( TSCell, PauseTime );
BTSCell = dividedTS{1}; %Baseline Timestamp in Cell
TTSCell = dividedTS{2}; %Testing Timestamp in Cell


sizeBHis = BaselineT./Bin;
sizeTHis = TestingT./Bin;
BaselineHis = zeros(nNeu,sizeBHis); %pre-allocate Baseline Histogram
CIalpha = 0.01; %alpha for Confidence Interval
BaselineCI = zeros(nNeu,2); %Baseline Confidence Interval
TestingHis = zeros(nNeu,sizeTHis);  %pre-allocate Testing Histogram


for i = 1:nNeu
    %Baseline Time is set to be the period before injection
    BaselineTS = BTSCell{i}.Timestamp(BTSCell{i}.Timestamp>(BTSCell{i}.Timestamp(end)-BaselineT)); %get Baseline Timestamp
   
    BaselineHis(i,:) = hist(BaselineTS,sizeBHis)./Bin; 
    %% get Confidence Intervel of Baseline
    [MUHAT,SIGMAHAT,MUCI,SIGMACI] = normfit(BaselineHis(i,:),CIalpha);
    MUCI(MUCI<0) = 0; %There should be no negative value for spike firing rate.
    BaselineCI(i,:) = MUCI; %Baseline confidence Interval of cell i
    %% get Testing time histogram
    %  Testing time is set to be the period right after headstage re-plug in 
    TestingTS = TTSCell{i}.Timestamp(TTSCell{i}.Timestamp<(TestingT+TTSCell{i}.Timestamp(1)));
    TestingHis(i,:) = hist(TestingTS,sizeTHis)./Bin;

    
    %% plot histogram
    
    if (plothere == 1)
    
    nfigure = ceil(i/6); % 6 cells in one figure
    figure(nfigure);
    
    IntervalTime = 20; %Interval (in min) between basline recording and post-treatment recording
    
    subplot(2,3,i-(nfigure-1)*6);
   
    %axes(i);
    % x-axis is in min
    LeadingBars = sizeBHis*(Bin/60) + IntervalTime ;
    bar(LeadingBars:Bin/60:LeadingBars+(sizeTHis-1)*(Bin/60),TestingHis(i,:),1,'r');
    hold on
    
    bar(Bin/60:Bin/60:Bin/60+(sizeBHis-1)*(Bin/60),BaselineHis(i,:),1,'b');
    hold on
    
    % Confidence Interval
    line([0,(30+sizeTHis*(Bin/60))],[BaselineCI(i,1),BaselineCI(i,1)],'Color','Black','LineStyle','--');
    line([0,(30+sizeTHis*(Bin/60))],[BaselineCI(i,2),BaselineCI(i,2)],'Color','Black','LineStyle','--');
    
    %%TODO
    %line(); %continuously increased bins
    %line(); %continuously decreased bins
    
    set(gca,'TickDir','Out');
    set(gca,'box','off');
    
    
    xlim([0,210]);
    xlabel('Time (min)');
    ylabel('Firing Rate (sp/s)');
    axis on;
    title(['Cell#' num2str(i)]);
    end
    hold on
end

end

