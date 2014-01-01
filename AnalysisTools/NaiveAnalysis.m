function [ output_args ] = NaiveAnalysis( TSCell,BaselineT,TestingT,Bin )
%NAIVEANALYSIS Naive Homecage Analysis
%   
%   You NEED to load NEV file using loadTimestamp first.
%   TSCell here could be a complete recording session.
%   TSCell(TimestampCell): The whole timestamp of all neurons recorded from a daily session
%   BaselineT (sec): Set this time as Baseline Time, Example: 600 for 10 min
%   TestT (sec): Set this time as post-treatment Testing Time, Example: 10800 for 3hr
%   Bin (sec): Example: 120 for 120 sec bin

%   Version: 1.0.05
%   Version: 1.0.1 Auto-set PauseTime
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
    BaselineTS = BTSCell{i}.Timestamp(BTSCell{i}.Timestamp>(BTSCell{i}.Timestamp(end)-BaselineT)); %get Baseline Timestamp
   
    BaselineHis(i,:) = hist(BaselineTS,sizeBHis)./(BaselineTS(end)-BaselineTS(1))*sizeBHis;
    %% get Confidence Intervel of Baseline
    [MUHAT,SIGMAHAT,MUCI,SIGMACI] = normfit(BaselineHis(i,:),CIalpha);
    MUCI(MUCI<0) = 0; %There should be no negative value for spike firing rate.
    BaselineCI(i,:) = MUCI; %Baseline confidence Interval of cell i
    %%
    TestingTS = TTSCell{i}.Timestamp(TTSCell{i}.Timestamp<(TestingT+TTSCell{i}.Timestamp(1)));
    TestingHis(i,:) = hist(TestingTS,sizeTHis)./Bin;

    %% plot histogram
    plothere = 1;
    if (plothere == 1)
    
    nfigure = ceil(i/6);
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

