function dirStat = calcDirStats( inputAngles )
%% Assumes input data is in radians, returns unit vectors
%%
inputRads = ( inputAngles );
dirStat = exp(1j*inputRads);
end