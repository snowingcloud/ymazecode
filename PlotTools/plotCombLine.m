function [ Result1,Result2 ] = plotCombLine( Array1,Array2,Interval )
%PLOT Summary of this function goes here
%   Detailed explanation goes here
%   Output:
%   Result = [Mean,SEM]
    Result1 = [mean(Array1,1);std(Array1,1)./sqrt(size(Array1,1))];
    Result2 = [mean(Array2,1);std(Array2,1)./sqrt(size(Array2,1))];
    
    %Plot using errorbar(X,Y,E)
    
    errorbar(1:size(Result1,2),Result1(1,:),Result1(2,:));
    hold on
    Leading = size(Result1,2)+Interval;
    errorbar(Leading+1:Leading+size(Result2,2),Result2(1,:),Result2(2,:));
    hold on
   
end

