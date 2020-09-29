clear all;
m0 = double(hdrread('office.hdr'));
% m0 = zeros(1000,1000,3);
% m0(:,:,1) = imresize(mk(:,:,1),[1000,1000]);
% m0(:,:,2) = imresize(mk(:,:,2),[1000,1000]);
% m0(:,:,3) = imresize(mk(:,:,3),[1000,1000]);
% m0 = imresize(mk,[1000,1000]);
% tic
% % m0 = m0 / 255;
% m0 = (m0-min(m0(:)))/(max(m0(:))-min(m0(:)));
tic
m0 = m0/max(m0(:));
m2 = (m0(:,:,1)+m0(:,:,2)+m0(:,:,3))/3;
% m2 = rgb2gray(m0);
m1 = log(m2*10^6+1);
% m1 = m2;
m1 = m1 / max(m1(:));

[m,n] = size(m2);

middd = LEPfilter(m1, 2); % first base layer

d3 = m1-middd; % first decomposed detail layer
% figure, plot(d3(1000,:));
d3 = atan(d3*20)./1.58;
% d3 =sign(d3).*abs(d3).^0.5;
% d3 = 2*((1+exp(-d3*20)).^-1-0.5);
% d3 = tan(d3*1.58)./100;
% hold on,plot(d3(1000,:),'r');

middd2 = LEPfilter(middd, 20); % second base layer

d2 = middd - middd2; % second decomposed detail layer
d2 = atan(d2*20)./1.58;
% d2 = sign(d2).*abs(d2).^0.5;
% d2 = 2*((1+exp(-d2*20)).^-1-0.5);
% d2 = tan(d2*1.58)./100;

basel = mean(middd2(:)); % the base layer

d1 = middd2-basel; % the last found detail layer
% figure, plot(d1(1000,:));
d1 = atan(d1*20)./1.58;
% d1 = sign(d1).*abs(d1).^0.5;
% d1 = 2*((1+exp(-d1*20)).^-1-0.5);
% d1 = tan(d1*1.58)./100;
% hold on,plot(d1(1000,:),'r');

mout = d3+d2+d1*0.5;

maxi = max(mout(:)); mini = min(mout(:));
outr2 = (mout-mini)/(maxi-mini);
outr2 = imadjust(outr2,stretchlim(outr2,[0.005,0.995]));
% outr2 = imadjust(outr2,stretchlim(outr2,[0.01,0.99]));
% figure ,imshow(outr2);

outr = zeros(m,n,3);
outr(:,:,1) = (m0(:,:,1)./m2(:,:)).^0.9 .* outr2;
outr(:,:,2) = (m0(:,:,2)./m2(:,:)).^0.9 .* outr2;
outr(:,:,3) = (m0(:,:,3)./m2(:,:)).^0.9 .* outr2;
toc

figure,imshow(outr);