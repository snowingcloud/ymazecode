function [ results ] = DelayRelatedDailyAnalysis( TSCell,RCell,ETSCell,EWin,WWin,Bin,EventName,nDivide,alpha )
%DELAYRELATEDDAILYANALYSIS Summary of this function goes here
%   Detailed explanation goes here
%   You should get ETSCell from BehCell first, using getETSCell()
if (nargin < 9)
    alpha = 0.05;
end
if (nargin < 8)
    nDivide = EWin(2)-EWin(1); %Default divide will be 1 sec
end
if (nargin < 7)
    EventName = 'Event'; %EventName will show on plots
end

%  Calculate the SpikeRaster in Event period (e.g. Delay,Reward)

nNeuron = getnNeu(TSCell{1});

results = zeros(2,5);

    
for i = 1:nNeuron
    hNeu = false; %hNeu==1:delay related; hNeu==0:delay neutral
    trendNeu = 0; 
   
    for nBlock = 1:3 %3 blocks: pre-treatment; treatment; 3hr post-treatment
        % verify consistence of neuron data
        if ~(TSCell{1}{i}.Electrode == TSCell{2}{i}.Electrode && TSCell{2}{i}.Electrode == TSCell{3}{i}.Electrode...
             && TSCell{1}{i}.Unit == TSCell{2}{i}.Unit && TSCell{2}{i}.Unit == TSCell{3}{i}.Unit) 
        errordlg('inconsistence in neuron info');    
        end   
        %
        
        EventSRCell{nBlock}{i} = getSpikeRaster(TSCell{nBlock}{i}.Timestamp,ETSCell{nBlock},EWin,Bin); %Todo:preallocate EventSR
        [ p,h,trend ] = EventRelated( TSCell{nBlock}{i}.Timestamp,ETSCell{nBlock},EWin,WWin,Bin,nDivide,alpha );
        
        %% testing codes
        if (h == true)
        dispstr = ['Block:' num2str(nBlock) ' Ele:' num2str(TSCell{nBlock}{i}.Electrode) ...
                  ' Unit' num2str(TSCell{nBlock}{i}.Unit) ' Event-Related p:' num2str(p) ' h:' num2str(h) ' Trend:' num2str(trend)];
        disp(dispstr);
        
        % results
        
        
        
        %plot delay-relared PETH
        plotWin = [EWin(1)-10,EWin(2)+1]; %set plotWin
            plothere = 0;
            if (plothere == 1);
                if (trend == 1) 
                subplot(2,1,1);
                plotRaster(TSCell{nBlock}{i}.Timestamp,ETSCell{nBlock},plotWin);
                subplot(2,1,2);
                plotHistogram(TSCell{nBlock}{i}.Timestamp,ETSCell{nBlock},plotWin,Bin*5,[],'b');
                end 
            end
        %end plot
        
        end
       
    hNeu = hNeu|h ; 
    trendNeu = trendNeu + trend;
    % END of testing codes
    end
    
    if(hNeu == true)
    
    [ p12,h12,trend12 ] = RankSumTest(EventSRCell{1}{i},EventSRCell{2}{i},alpha);
    [ p13,h13,trend13 ] = RankSumTest(EventSRCell{1}{i},EventSRCell{3}{i},alpha);
        
        if(trend >0) %actived in delay period
            results(1,1) = results(1,1) + 1;
            
            if(h12 == true)
                if(trend12 >0)

                    results(1,2) = results(1,2) + trend12;
                else
                    results(1,3) = results(1,3) + trend12;
                end    
            end
            
            if(h13 == true)
                if(trend13>0)
                    results(1,4) = results(1,4) + trend13;
                else
                    results(1,5) = results(1,5) + trend13;
                end
            end
        else %inactived in delay period
            results(2,1) = results(2,1) +1;
            
            if(h12 == true)
                if(trend12 >0)

                    results(2,2) = results(2,2) + trend12;
                else
                    results(2,3) = results(2,3) + trend12;
                end    
            end
            
            if(h13 == true)
                if(trend13>0)
                    results(2,4) = results(2,4) + trend13;
                else
                    results(2,5) = results(2,5) + trend13;

                end
            end
       
            
        end
    
    end
    
end




end

