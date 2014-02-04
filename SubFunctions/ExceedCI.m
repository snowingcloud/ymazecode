function [ExceedCIresult] = ExceedCI( CI,Array,n )
%EXCEEDCI Summary of this function goes here
%   Criterion: consecutive n bins exceeding 
%   Ver 1.1 Jan 12 2014 Alpha
%   Ver 1.2 Jan 14 2014
%   TODO: output ExCount and Experiod

MAXCI = repmat(max(CI,[],2),1,size(Array,2));
MINCI = repmat(min(CI,[],2),1,size(Array,2));


Judge = zeros(size(Array,1),size(Array,2));
Judge(Array > MAXCI) = 1;
Judge(Array < MINCI) = -1;

counter = zeros(size(Array,1),size(Array,2));
for i=1:size(Judge,1)
    if(Judge(i,1)~=0) % judge the first element
           counter(i,1) = Judge(i,1);
    end
    for j=2:size(Judge,2)
        
        if(Judge(i,j)~=0)
           if( Judge(i,j)==Judge(i,j-1))
           counter(i,j) = counter(i,j-1)+Judge(i,j);
           else
           counter(i,j) = Judge(i,j);
           end
        end
    end
end

summer = zeros(size(Judge,1),2);
summer(:,1) = max(counter,[],2);
summer(:,2) = min(counter,[],2);

IsSig = (summer(:,1)>=n | summer(:,2) <= -n );

Type = sum(summer,2);
Type(~IsSig) = 0;
Type(Type>0 & IsSig) = 1;
Type(Type<0 & IsSig) = -1;
ExceedCIresult = Type;
end

