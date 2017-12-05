%  This function enciphers or converts an image with filename as 'img_filename' 
%         into an audio(wav) file whose name is 'song_filename'

%% generate a Sinusoid sound to play with - oscillator(wavetype,duration,frequency)
% sin = oscillator('Sinusoid',5,440);
% sin_player = audioplayer(sin,44100);

%% read input image, get size m n r
%function img2song(img_filename,song_filename)
warning off
clear all;
close all;

%input image must be color image to get R G B info
input_img = './output/spiral-rainbow/spiral-rainbow-2.jpg';
[filepath, name, ext] = fileparts(input_img);

a = imread(input_img);
origImg = im2double(a);
[oHeight, oWidth, oDepth] = size(origImg);

outputVideo = VideoWriter(fullfile(filepath,name));
outputVideo.FrameRate = 24;
open(outputVideo)

[m n r] = size(a);

%%
figure
subplot(1,3,1);
imshow(a);
refresh
title('Input Image');

resizeFactor = 1;

if m >= 1000 || n>= 1000
    resizeFactor = 50;
    a = imresize(a,1/resizeFactor);
elseif m >= 300 || n>= 300
    resizeFactor = 30;
    a = imresize(a,1/resizeFactor);
elseif m >= 100 || n>= 100
    resizeFactor = 10;
    a = imresize(a,1/resizeFactor);
end

smallA = a;

[m n r] = size(a);

aGray = rgb2gray(a);
aGray = im2double(aGray);
overAllTone = sum(aGray(:))/(m*n);

%% Gaussian blur the image to produce a smoother tone?
%a = imgaussfilt(a,2);

subplot(1,3,2);
imshow(a);
title('Processed Image');

a = im2double(a);


%% reverse every other row of the image
% for i = 1:m
%     if rem(i,2) ~= 0
%         reverse(i,:,:) = a(i,:,:);
%     else
%         reverse(i,:,:) = a(i,end:-1:1,:);
%     end
% end
% 
% a = reverse;

%% calculate gradient for duration of each pixel

paddedA = padarray(aGray,[0 1],'symmetric','both');
hor_gradient = abs(paddedA(:,3:end) - paddedA(:,1:end-2));
reverse_gradient = abs(1 - hor_gradient);

subplot(1,3,3);
imshow(hor_gradient);
title('Energy Map');

%% loop through each pixel in image to get RGB
% use R,G,B as three inputs to the oscillartor
% concatenate and make it a row
%  OSCILLATOR(wavetype,duration,frequency,gate,phase,sample_freq)
    % '3rd argument ''frequency'' must be a number or vector less than or equal to the Nyquist.'
    % 'optional 5th argument ''phase'' should be a real number between -2pi and 2pi.'
    % 'optional 4th argument ''gate'' must be a positive number less than or equal to half the duration.'

sound = [];
sampleRate = 44100;
timbre = 'Sinusoid';

for x = 1:m
    for y = 1:n
        disp(x);
        
        phase = a(x,y,1) * 2 * pi; %useless
%         frequency = (a(x,y,1) + a(x,y,2) + a(x,y,3))/3 * sampleRate / 20;
        frequency = sum(a(x,y,:));
%         frequency = frequency * overAllTone * sampleRate / 30;
        frequency = abs(log10(frequency)) * overAllTone * sampleRate / 10;
        duration = hor_gradient(x,y) * 2;
        gate = duration / 2;
        s = oscillator(timbre,duration,frequency,gate,phase,sampleRate);
        sound = vertcat(sound,s);
        numFrame = int32(duration*24.0);
        xstart = (x - 1)*resizeFactor;
        ystart = (y - 1)*resizeFactor;
        if xstart == 0
            xstart = 1;
        end
        if ystart == 0
            ystart = 1;
        end
        xend = x*resizeFactor;
        yend = y*resizeFactor;
        if xend >  oHeight
            xend = oHeight;
        end
        if yend > oWidth
            yend = oWidth;
        end
        outputImg = origImg;
        outputImg(xstart:xend, ystart:yend, :) = 1.0 - outputImg(xstart:xend, ystart:yend, :);
        for ii = 1:numFrame
            writeVideo(outputVideo,outputImg)
        end
    end
end

close(outputVideo)

player = audioplayer(sound,sampleRate);
%play(player);

%% output
output_name = strcat(filepath,'/',name,'_',timbre,'.wav');
audiowrite(output_name, sound, 44100);
