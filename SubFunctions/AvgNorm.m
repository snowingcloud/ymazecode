function [ Nor1,Nor2 ] = AvgNorm( Array1,Array2 )
%AVGNOMOLIZATION Summary of this function goes here
%   Normalization Array 1&2 by deviding Avarage of Array 1
%   Citation: PNAS ? June 1, 2004 ? vol. 101 ? no. 22 ? 8467?8472
%   NMDA receptor hypofunction produces concomitant firing rate potentiation 
%   and burst activity reduction in the prefrontal cortex
%   Mark E. Jackson, Houman Homayoun, and Bita Moghaddam*

AvgArray1=mean(Array1,2);
Nor1 = diag(AvgArray1)\Array1;
Nor2 = diag(AvgArray1)\Array2;

end

