function [ BaseResult,TestResult  ] = plotNaiveHist( BaselineT,TestingT,Bin,n,Type,Interval )
%PLOTNAIVEHIST Summary of this function goes here
%   Detailed explanation goes here
[ BaselineHis,TestingHis, ExCIresult ] = CollectNaiveResults( BaselineT,TestingT,Bin,n );

BaselineHisType = BaselineHis(ExCIresult == Type,:);
TestingHisType = TestingHis(ExCIresult == Type,:);

[NorBase, NorTest] = AvgNorm(BaselineHisType,TestingHisType);

[BaseResult,TestResult] = plotCombLine(NorBase,NorTest,Interval);

end

