function [ PauseTime ] = getPauseTime( Timestamps )
%GETPAUSETIME Summary of this function goes here
%   Get the PauseTime(s) from Timestamps
%   ! Timestamps should be in sec
%   Version 1.0.0 only gets the first PauseTime
ISI = 0;
for i=1:length(Timestamps)
    ISI = Timestamps(i+1) - Timestamps(i);
    if (ISI > 120) %120 sec without activity
        PauseTime = floor(0.5*(Timestamps(i)+Timestamps(i+1))); %set the mid-time as Pause Time
        break;
    end
end

end

