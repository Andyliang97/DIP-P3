close all
clc
clear

%read in image
img=imread('Capture2.PNG');
gray=rgb2gray(img);
subplot(2,3,1),imshow(gray)
title('original')

sigma=1;
%mask1,formula comes from http://academic.mu.edu/phys/matthysd/web226/Lab02.htm
mask=zeros(9,9);
W=0;
for i=-4:4
    for j=-4:4
        mask(i+5,j+5)=-(-(1/pi*sigma^4))*(1-(i^2+j^2)/(2*sigma^2))*exp((-(i^2+j^2))/(2*sigma^2));
        W=W+mask(i+5,j+5);
    end
end
mask=mask/W;
edgemask1=conv2(gray,mask,'valid');
subplot(2,3,2),imshow(-(edgemask1));
title('MyResult(sigma=1)')

sigma2=1;
%mask2,formula comes from book page582
mask2=zeros(5,5);
W2=0;
for i=-2:2
    for j=-2:2
        mask2(i+3,j+3)=((i^2+j^2-2*(sigma2^2))/sigma2^4)*exp(-(i^2+j^2)/(2*sigma2^2));
        W2=W2+mask2(i+3,j+3);
    end
end
mask2=mask2/W2;
edgemask2=conv2(gray,mask2,'valid');
%subplot(2,3,3),imshow(-(edgemask2));
%title('mask2')

%mask comes from book
bookmask1=[0 0 -1 0 0; 0 -1 -2 -1 0; -1 -2 16 -2 -1; 0 -1 -2 -1 0; 0 0 -1 0 0];
bookmask2=[-1 -1 -1; -1 8 -1; -1 -1 -1];
sobelmask1=[0 1 2 ; -1 0 1 ; -2 -1 0];


%filter through build-in function
edgemaskmatlab=edge(gray,'log',0,1);
subplot(2,3,4),imshow(edgemaskmatlab);
title('Matlab Implementation(sigma=1)')

%apply gaussian filter first, then apply laplacian filter
sigma3=1;
W3=0;
gaussianmask=zeros(3,3);
for i=1:8
    for j=1:3
        gaussianmask(i,j)=exp(-((i-2)^2+(j-2)^2)/(2*sigma3*sigma3))/(2*pi*sigma3*sigma3);
        W3=W3+gaussianmask(i,j);
    end
end
%gaussianmask=gaussianmask/W3; 

gaussian=uint8(conv2(gray,gaussianmask,'valid'));
gaussian2 = imgaussfilt(gray,sigma3);
laplacian=[0 -1 0 ; -1 4 -1; 0 -1 0];
laplacian2=[-1 -1 -1 ; -1 8 -1; -1 -1 -1];
edgemask3=conv2(gaussian2,laplacian2);
subplot(2,3,5),imshow((gaussian2))
title('Gaussian(sigma=1)')
subplot(2,3,6),imshow(edgemask3)
title('MyResult(sigma=1)')

%zero cross 
zerocross=edge(gray,'zerocross');
subplot(2,3,3),imshow(zerocross)
title('zero-crossing')

zerocrossmask=zeros(5,5);
sigma0=1;
for i=-2:2
    for j=-2:2
        zerocrossmask(i+3,j+3)=-exp((i^2+j^2)/(-2*(sigma0*sigma0)));
    end
end
zerocrossimg=conv2(gray,zerocrossmask,'valid');
unit8zerocross=uint8(zerocrossimg);
%figure,imshow(unit8zerocross);





