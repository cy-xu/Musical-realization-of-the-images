%  This function gets back the original image named 'img_filename' from
%     the enciphered audio(wav) file whose name is 'song_filename'
function song2img(song_filename,img_filename)

[a,Fs] = audioread(song_filename);
[m n] = size(a);
comdata=reshape(a,1,m*n);


%------to detect the positions of '1' in 'comdata'-------
comdata2=round(10*comdata);
ard=[];
for(i=1:m*n)
    if(comdata2(i)==10)
        ard=[ard i];
    end
end
%---------------detection done in 'ard'---------------------


%------detection of size of the original image--------------
num2=[];
for(j=1:3)
ads=[];
for(i=ard(j)+1:ard(j+1)-1)
ads=[ads i];
end
ads=fliplr(ads);
num=0;
for(i=1:length(ads))
gud=comdata2(ads(i))*(power(10,i-1));
num=num+gud;
end
num2=[num2 num];
end
%---------------detection done in 'num2'---------------------


for(i=1:num2(1)*num2(2)*num2(3))
    comp_data(i)=comdata(i+ard(4));
end
img_data=reshape(comp_data,num2(1),num2(2),num2(3));

img_data=(img_data.*127.5)+127.5;
img_data=uint8(img_data);

imwrite(img_data,img_filename)