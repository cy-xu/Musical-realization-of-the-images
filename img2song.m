%  This function enciphers or converts an image with filename as 'img_filename' 
%         into an audio(wav) file whose name is 'song_filename'

function img2song(img_filename,song_filename)
warning off

a = imread(img_filename);
[m n r]=size(a);

sizedata=[1 numsep(m)/10 1 numsep(n)/10 1 numsep(r)/10 1];

a=double(a);
a=(a-127.5)./127.5;
imgdata=reshape(a,1,m*n*r);

comdata=[sizedata imgdata];

[m n]=size(comdata);

if(rem(n,2)~=0)
    comdata=[comdata 1];
end

[m n]=size(comdata);

arrdata=reshape(comdata,n/2,2);

%wavwrite(arrdata,song_filename);
audiowrite(song_filename, arrdata,8000);