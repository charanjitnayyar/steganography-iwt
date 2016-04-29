%% Histogram Modification ISP Lab 10
% AliArshad Kothawala
% 13/4/2015

%===================================================================================================
%    Read the images
%====================================================================================================
im1=imread('inp_image.pgm'); % Given Image 
im2=imread('ref_image.pgm'); % Reference Image
M = zeros(256,1,'uint8'); %Store mapping - Cast to uint8 to respect data type
figure;subplot(121);imshow(im1);title('Original Image');subplot(122);imshow(im2);title('Reference Image');
%=====================================================================================================
% Compute the Histograms
%=====================================================================================================
hist1 = Histo(im1); %Compute histograms
hist2 = Histo(im2);
%=====================================================================================================
% Cumulative distribution Function
%=====================================================================================================
cdf1 = cumsum(hist1) / numel(im1); %Compute CDFs
cdf2 = cumsum(hist2) / numel(im2);
%=====================================================================================================
% Compute the mapping
%======================================================================================================
for idx = 1 : 256
    [mmm,ind] = min(abs(cdf1(idx) - cdf2));
    M(idx) = ind-1;
end

% Apply the mapping to first image to make the image look like the distribution of the second image
out = M(double(im1)+1);
figure;imshow(out);