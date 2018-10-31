close all

%%% open bmp image

im = imread('lena512.bmp');

%%% write jpeg files

for quality = 10:10:90
    
   imwrite(im,strcat('lena',num2str(quality),'.jpg'),'Quality',quality)    
    
end

%%% open jpeg files, copy into a matrix

imjpg = zeros(512,512,9);

figure;

% subplot(4,3,2);
% imshow(im)

for index = 1:9
    
    path = strcat('lena',num2str(index*10),'.jpg');
    file = dir(path);
    size = file.bytes/1024;
    
    imjpg(:,:,index) = imread(path);
    subplot(3,3,index);
    imshow(uint8(imjpg(:,:,index)))
    title(strcat('comp:',num2str(index*10),' Size: ',num2str(size,3),'kB'))
end

%%% plot error graph

for i = 1:9
    
    
    
end

