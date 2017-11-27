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
input_img = './output/Picasso_-_Le_pigeon_aux_petits_pois_1911.jpg';

a = imread(input_img);
[m n r] = size(a);

resizeFactor = 10;

if m >= 1000 || n>= 1000
    a = imresize(a,1/(5*resizeFactor));
elseif m >= 300 || n>= 300
    a = imresize(a,1/(3*resizeFactor));
elseif m >= 100 || n>= 100
    a = imresize(a,1/(1*resizeFactor));
end

[m n r] = size(a);

%a = imgaussfilt(a,2);
a = im2double(a);
figure
imshow(a)

[filepath, name, ext] = fileparts(input_img);

%% reverse every other row of the image
for i = 1:m
    if rem(i,2) ~= 0
        reverse(i,:,:) = a(i,:,:);
    else
        reverse(i,:,:) = a(i,end:-1:1,:);
    end
end

a = reverse;

%% loop through each pixel in image to get RGB
% use R,G,B as three inputs to the oscillartor
% concatenate and make it a row
%  OSCILLATOR(wavetype,duration,frequency,gate,phase,sample_freq)
    % '3rd argument ''frequency'' must be a number or vector less than or equal to the Nyquist.'
    % 'optional 5th argument ''phase'' should be a real number between -2pi and 2pi.'
    % 'optional 4th argument ''gate'' must be a positive number less than or equal to half the duration.'

duration = 1/10;
sound = [];
sampleRate = 44100;

for x = 1:m
    for y = 1:n
        phase = a(x,y,1) * 2 * pi;
        frequency = (a(x,y,1) + a(x,y,2) + a(x,y,3))/3 * sampleRate / 20;
        gate = a(x,y,3) * duration / 2;
        s = oscillator('Sinusoid',duration,frequency,gate,phase,sampleRate);
        sound = vertcat(sound,s);
    end
end

player = audioplayer(sound,sampleRate);
play(player);

%% output
output_name = strcat(filepath,'/',name,'_Sinusoid','.wav');
audiowrite(output_name, sound, 44100);

%% read a sound
% [y,Fs] = audioread('./output/jingle.wav');
% y = y(:,1);
% % dt = 1/Fs;
% % t = 0 : dt : (length(y) * dt) - dt;
% % figure
% % plot(psd(spectrum.periodogram,y,'Fs',Fs,'NFFT',length(y)));
% % 
% %sound_fft = fft2(y);
% player = audioplayer(y,Fs);
% %play(player);

% %% hmmm...
% sizedata = [1 numsep(m)/10 1 numsep(n)/10 1 numsep(r)/10 1];
% 
% a = double(a);
% a = (a-127.5)./127.5;

% %% reshape data into one row, reshape(A,sz), prod(sz) must be the same as numel(A).
% imgdata = reshape(a,1,m*n*r);

% %% what's comdata for?
% comdata = [sizedata imgdata];
% 
% %% one row data
% [m n] = size(comdata);
% 
% %% make sure numel(comdata) is even number
% if(rem(n,2)~=0)
%     comdata = [comdata 1];
% end
% 
% %% reshape data to two rows and audiowrite with same input name
% [m n] = size(comdata);
% %arrdata = reshape(comdata,n/2,2);

%% padarray comdata to same length as sin sound

