
%%  Build the Exponential base
function [z]= exponentialITI(lam,minLag,maxLag,trialCT);
% lam = 1/6;
% minLag = 2.5;
% maxLag = 7;
X = minLag:1/1000:maxLag;
expo = -lam.*X+minLag;
Y = lam*exp(-lam.*X);
%%  Build an exponential distribution;
Y = Y/max(Y); 
limiter = min(Y)-.01;
Y = Y - limiter; Y = Y/max(Y);
Y = Y*100; Y = round(Y);
Z = [];
for N = 1:size(Y,2);
    z = ones(Y(1,N),1)*X(1,N);
    Z = [Z;z];
end
z  = randsample(Z',trialCT);
