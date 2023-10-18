%%  Base stuff
sca
close all
clear all

cont = 1.0;
NT = 10;
BITI = 4.0;
JIT = 1.5;
goEXP = 1.0;
minITI = 2.5;
maxITI = 7;
lambda = 6;
VSD = .5;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%

contrasts = [.75 .5 .25  .1875 .125 .09375 .0625 .03125 .015625 0];
go = 1;
maxc = round(numel(contrasts)/2);
[RandomizedTrials]=RandomizeTrials_Psuedo_function(contrasts,NT,'n');
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

%%%%%
sca;
close all;
% Setup PTB with some default values
PsychDefaultSetup(2);
% Set the screen number to the external secondary monitor if there is one
% connected
screenNumber = max(Screen('Screens'));

% Define black, white and grey
white = WhiteIndex(screenNumber);
black = BlackIndex(screenNumber);
grey = white / 2;

% Open the screen
[window, windowRect] = PsychImaging('OpenWindow', screenNumber, grey,...
    [], 32, 2, [], [], kPsychNeedRetinaResolution);
[xCenter, yCenter] = RectCenter(windowRect);
[screenXpixels, screenYpixels] = Screen('WindowSize', window);
% Get the vertical refresh rate of the monitor
ifi = Screen('GetFlipInterval', window);

% Set maximum priority level
topPriorityLevel = MaxPriority(window);
Priority(topPriorityLevel);

%--------------------
% Gabor information
%--------------------

% Dimension of the region where will draw the Gabor in pixels
%gaborDimPix = windowRect(4) / 2;
gaborDimPix = windowRect(3);

% Sigma of Gaussian  (how much to fade 
sigma = gaborDimPix / 0;

% Obvious Parameters
orientation = 45;%0;
%contrast = .5;
%contrasts = [.75 .5 .25 .10 .08 .06 .04 .02 .01 0];
aspectRatio = 1.0;
phase = 0;
% We choose an arbitary value at which our Gabor will drift
desiredfrequency = 4;
phasePerFrame = desiredfrequency*360*ifi;
% Spatial Frequency (Cycles Per Pixel)
% One Cycle = Grey-Black-Grey-White-Grey i.e. One Black and One White Lobe
numCycles = 7;
freq = numCycles / gaborDimPix;

% Build a procedural gabor texture (Note: to get a "standard" Gabor patch
% we set a grey background offset, disable normalisation, and set a
% pre-contrast multiplier of 0.5).
backgroundOffset = [0.5 0.5 0.5 0.0];
disableNorm = 1;
preContrastMultiplier = 0.5;
gabortex = CreateProceduralGabor(window, gaborDimPix, gaborDimPix, [],...
    backgroundOffset, disableNorm, preContrastMultiplier);

% Randomise the phase of the Gabors and make a properties matrix.
for N = 1:numel(contrasts)
propertiesMat{1,N} = [phase, freq, sigma, contrasts(N), aspectRatio, 0, 0, 0];
end

iiii = 1;
cchoice = RandomizedTrials(iiii);
cont2 = contrasts(cchoice);
pm = propertiesMat{1,1};

stim_loaded = 1;
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%  Now that all the stimuli have been loaded, we can start to present trials

for N = 1:NT
    
    
    
%------------------------------------------
%    Draw stuff - button press to exit
%------------------------------------------

% FLip to the vertical retrace rate
vbl = Screen('Flip', window);

% We will update the stimulus on each frame
waitframes = 1;
pm = propertiesMat{1,cchoice};
frameCounter = 0;
tic
while  frameCounter < round(VSD/ifi)%~KbCheck
frameCounter = frameCounter + 1;
    % Draw the Gabor. By default PTB will draw this in the center of the screen
    % for us.
   
    Screen('DrawTextures', window, gabortex, [], [], orientation, [], [], [], [],...
        kPsychDontDoRotation, pm');

    % Flip to the screen
    vbl = Screen('Flip', window, vbl + (waitframes - 0.5) * ifi);

    % Update the phase element of the properties matrix (we could if we
    % want update any or all of the properties on each frame. Here the
    % Gabor will drift to the left.
    %propertiesMat(1) = propertiesMat(1) + phasePerFrame;
    pm(1) = pm(1) + phasePerFrame;
end
Time(N) = toc;
vbl = Screen('Flip', window);
pause(intervals(N));
clear pm
iiii = iiii+1;
if iiii <= NT
cchoice = RandomizedTrials(iiii);
cont2 = contrasts(cchoice);
end


end


    
    
    
time_on = 0;



%%

baseRect = [0 0 screenXpixels screenYpixels];
centeredRect = CenterRectOnPointd(baseRect, xCenter, yCenter);

% Set the color of our square to full red. Color is defined by red green
% and blue components (RGB). So we have three numbers which
% define our RGB values. The maximum number for each is 1 and the minimum
% 0. So, "full red" is [1 0 0]. "Full green" [0 1 0] and "full blue" [0 0
% 1]. Play around with these numbers and see the result.
rectColorB = [0 0 0];
rectColorG = [128 128 128]/255;

% Draw the square to the screen. For information on the command used in
% this line see Screen FillRect?
Screen('FillRect', window, rectColorG, centeredRect);
Screen('Flip', window);



% iiii = iiii+1;
% cchoice = RandomizedTrials(iiii);
% cont2 = contrasts(cchoice);
% Sinusoid  = sinusoid*cont2;
% 
% %%
% imagesc(time_out1,clim);
% set(gca,'xtick',[]);
% set(gca,'ytick',[]);
% pause(0.01);
% 
% imagesc(0,clim);
% set(gca,'xtick',[]);
% set(gca,'ytick',[]);
% pause(0.01);
