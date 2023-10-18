%%  Base stuff
close all
clear all

cont = 1.0;
NT = 250;
BITI = 4.0;
JIT = 1.5;
goEXP = 1.0;
minITI = 2.5;
maxITI = 7;
lambda = 6;
VSD = .5;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%
stim_x = 960;
stim_y = 540;
screen_x = 1920;
screen_y = 1080;

clim = [-1 1];
%contrasts = [1 .75 .5 .25  .125  .0625 .03125 .015625 .0078125 .00390625];
contrasts = [.75 .5 .25  .1875 .125 .09375 .0625 .03125 .015625 0];
%contrasts = [ .175 .125 .09375 .0625 .05 .04 .03125 .023438 .015625 0];
%contrasts = [   .125  .09375 .0625 0.055 .05 0.045 .04 .03125 .023438 .015625 0];
%contrasts = [ 0.09  0.075 .06  0.055 .05 0.045 .04 0.035 .03 0.025  .02 .015  0.01 0];
%contrasts = [ 0.1  0.0796 .0631  .0501 0.0398  0.0316 .0251 0.02  .0158 .0126  0.01 0];
%contrasts = [ 0.09  0.075 .06  .05 0.04  0.035 .03 0.025  .02 .015  0.01 0];
%contrasts = [.065 .06 .055 .05 .045 .04 .035 .03 .025 .02 .015 .01];
%contrasts = [.045 .04 .035 .03 .025 .0225 .02 .0175 .015 .0125 .01 .005];  %M1
%contrasts = [.045 .04 .035 .0325 .03 .0275 .025 .0225 .02 .0175 .015 .01]; % M2
%contrasts = [.0228 .0201 .0156 .011 .0084];  %M1
%contrasts = [0.0333 0.0314 0.0281 0.0248 0.023]; % M2
%contrasts = [1  .5 .25  .125  .03125  .0078125 0];
%contrasts = [1  .5 .25  .125  0];
go = 1;
maxc = round(numel(contrasts)/2);
%[left, bottom, width, height]
%set(gcf, 'Position', get(0, 'Screensize'))
%set(0, 'DefaultFigurePosition', [1914 -222.2000 1934 1094]);
set(0, 'DefaultFigurePosition', [1914 0 1940 2000]);
colormap(gray(256))
set(gcf,'MenuBar','none')
set(gca,'DataAspectRatioMode','auto')
set(gca,'Position',[0 0 1 1])
set(gca, 'xlimmode','manual',...
           'ylimmode','manual',...
           'zlimmode','manual',...
           'climmode','manual',...
           'alimmode','manual');

imagesc(0);
set(gca,'xtick',[]);
set(gca,'ytick',[]);
pause(0.01);

% Define grating parameters
orientation = [14*pi/18; 13*pi/18];

center = [1,1]; %[0,0] is the middle of the image, [pi,pi] is the lower right
%width = .5;  %1/e half width of Gaussian
spatialFrequency = 8;  %spatial frequency of Sinewave carrier (cycles/image)
phase = -pi/2; %spatial phase of sinewave carrier (radians)
contrast = cont;  %contrast ranges from 0 to 1;
%screen_x = 1920; %resolution of the image  
%screen_y = 1080;

% Use meshgrid to define matrices X and Y that range from -pi to pi;
[X,Y] = meshgrid(linspace(-pi,pi,screen_x),linspace(-pi/2,pi/2,screen_y));

sinusoid = zeros(screen_y,screen_x,150,2);
time_out1 = ones(screen_y,screen_x)*-1;
time_out2 = zeros(screen_y,screen_x);
%time_out(1,1) = 1;
% Set up individual 4-d matrices (x, y, time, orientation) for movies of the drifting gratings at each
% orientation
for j = 1:length(orientation)                                                            % Phase increase number here
    ramp(1:screen_y,1:screen_x,j) = cos(orientation(j))*(X-center(1)) + sin(orientation(j))*(Y-center(2));     %  |
    for i = 1:150 %Sets the number of frames to define gratings for                   V
       sinusoid(1:screen_y,1:screen_x,i,j) = contrast*sin(spatialFrequency*ramp(1:screen_y,1:screen_x,j)-...
           (phase+(2*pi*(i-1)*(-30)/360))); %Number before '/360' sets the phase increase
    end
end



[RandomizedTrials]=RandomizeTrials_Psuedo_function(contrasts,NT,'n');


iiii = 1;

cchoice = RandomizedTrials(iiii);
cont2 = contrasts(cchoice);
Sinusoid  = sinusoid*cont2;


%%  To be run of not using exponential
%intervals = [ones(1,41)*10 ones(1,41)*11 ones(1,41)*12 ones(1,41)*13 ones(1,40)*14];
if goEXP < 1
     jit = JIT;
     jitter = rand(1,NT);
     jitter = 2*jit*(jitter- .5);
     ITIbase = BITI;
     intervals = [ones(1,NT)*ITIbase];
     intervals = intervals + jitter;
elseif goEXP > 0
     intervals = exponentialITI(1/lambda, minITI, maxITI, NT);
end
%%
stim_id = [ones(1,NT)*1];
%reward = [ones(1,87)*1 ones(1,15)*0 ones(1,87)*1 ones(1,15)*0];
reward = [ones(1,NT)*1];
meanITI = nanmean(intervals);


rand_idx1 = randperm(NT);
rand_idx2 = randperm(NT);
intervals = intervals(rand_idx2);
stim_id = stim_id(rand_idx2);
reward = reward(rand_idx2);

stim_loaded = 1;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

iiii = iiii+1;
cchoice = RandomizedTrials(iiii);
cont2 = contrasts(cchoice);
Sinusoid  = sinusoid*cont2;

%%
imagesc(time_out1,clim);
set(gca,'xtick',[]);
set(gca,'ytick',[]);
pause(0.01);

imagesc(0,clim);
set(gca,'xtick',[]);
set(gca,'ytick',[]);
pause(0.01);
