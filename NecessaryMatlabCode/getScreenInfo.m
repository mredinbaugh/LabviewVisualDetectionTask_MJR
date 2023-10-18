function [ScreenInfo] = getScreenInfo()

%% This function is designed to collect basic information about the monitors 
%  being used to display stimuli and should be included at the beginning of 
%  scripts so that data can be preserved.

% Clear the workspace and the screen
sca;
close all;
clear;
Screen('Preference', 'SkipSyncTests', 1);
% Here we call some default settings for setting up Psychtoolbox
PsychDefaultSetup(2);

% Get the screen numbers. This gives us a number for each of the screens
% attached to our computer. For example, when I call this I get the vector
% [0 1]. The first number is the native display for my laptop and the
% second referes to my secondary external monitor. By native display I mean
% the display the is physically part of my laptop. With a non-laptop
% computer look at your screen preferences to see which is the primary
% monitor. This can also be switched in the settings of most computers.
screens = Screen('Screens');

for N = 1:numel(screens);
ScreenInfo{1,N} = ['Screen' num2str(screens(N))];
screenNumber = screens(N); %max(screens);
screeninfo.screen = screenNumber;

% Define black and white (white will be 1 and black 0). This is because it
% is typically useful to have this rather than 0-255 to be compatible
% across different display devices.
white = WhiteIndex(screenNumber);
black = BlackIndex(screenNumber);

% Do a simple calculation to calculate the luminance value for grey. This
% will be half the luminace value of white. Note that this is numerically
% half, dependent on the luminance response of your monitor, the
% relationship between numerical values iin code and physical values might
% be non-linear.
grey = white / 2;
screeninfo.white = white;
screeninfo.black = black;
screeninfo.grey = grey;

% Open an on screen window and color it grey. This function returns a
% number that identifies the window we have opened "window" and a vector
% "windowRect".
% "windowRect" is a vector of numbers: the first is the X coordinate
% representing the far left of our screen, the second the Y coordinate
% representing the top of our screen,
% the third the X coordinate representing
% the far right of our screen and finally the Y coordinate representing the
% bottom of our screeninfo.
[window, windowRect] = PsychImaging('OpenWindow', screenNumber, grey);
screeninfo.dimensions = windowRect;

% Now that we have a window open we can query some of its properties. So,
% lets do the following:

% This function call will give use the same information as contained in
% "windowRect"
rect = Screen('Rect', window);
screeninfo.windowsize = rect;
% Get the size of the on screen window in pixels, these are the last two
% numbers in "windowRect" and "rect"
[screenXpixels, screenYpixels] = Screen('WindowSize', window);
screeninfo.Xpixels = screenXpixels;
screeninfo.Ypixels = screenYpixels;

% Get the centre coordinate of the window in pixels.
% xCenter = screenXpixels / 2
% yCenter = screenYpixels / 2
[xCenter, yCenter] = RectCenter(windowRect);
screeninfo.Xcenter = xCenter;
screeninfo.Ycenter = yCenter;

% Query the inter-frame-interval. This refers to the minimum possible time
% between drawing to the screen
ifi = Screen('GetFlipInterval', window);
screeninfo.ifi = ifi;
screeninfo.RefreshRateF = 1/ifi;

% We can also determine the refresh rate of our screeninfo. The
% relationship between the two is: ifi = 1 / hertz
hertz = FrameRate(window);
screeninfo.RefreshRateM = hertz;

% We can also query the "nominal" refresh rate of our screeninfo. This is
% the refresh rate as reported by the video card. This is rounded to the
% nearest integer. In reality there can be small differences between
% "hertz" and "nominalHertz"
% This is nothing to worry about. See Screen FrameRate? and Screen
% GetFlipInterval? for more information
nominalHertz = Screen('NominalFrameRate', window);
screeninfo.RefreshRateR = nominalHertz;

% Here we get the pixel size. This is not the physical size of the pixels
% but the color depth of the pixel in bits
pixelSize = Screen('PixelSize', window);
screeninfo.pixelsize = pixelSize;
% Queries the display size in mm as reported by the operating system. Note
% that there are some complexities here. See Screen DisplaySize? for
% information. So always measure your screen size directly.
[width, height] = Screen('DisplaySize', screenNumber);
screeninfo.sizeW = width;
screeninfo.sizeH = height;
% Get the maximum coded luminance level (this should be 1 in our case)
maxLum = Screen('ColorRange', window);
screeninfo.maxLum = maxLum;
% Wait for a keyboard button press to exit
% Clear the screeninfo. "sca" is short hand for "Screen('CloseAll')".
% Note: we leave the variables in the workspace so you can have a look at them.
sca;

ScreenInfo{2,N} = screeninfo;
clear screeninfo
end

