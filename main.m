clear
% Parameters
Gamma = 0.98;
Phi = 200;
Epsilon = -0.1;
k = 1.6;
Sigma = 0.8;

inputIm = imread('sampleImage.jpg');

inputIm = rgb2gray(inputIm);
inputIm = im2double(inputIm);

% Gauss Filters
gFilteredIm1 = imgaussfilt(inputIm, Sigma);
gFilteredIm2 = imgaussfilt(inputIm, Sigma * k);

differencedIm2 = gFilteredIm1 - (Gamma * gFilteredIm2);

x = size(differencedIm2,1);
y = size(differencedIm2,2);

% Extended difference of gaussians
for i=1:x
    for j=1:y
        if differencedIm2(i, j) < Epsilon
            differencedIm2(i, j) = 1;
        else
            differencedIm2(i, j) = 1 + tanh(Phi*(differencedIm2(i,j)));
        end
    end
end

% XDoG Filtered Image
figure, imshow(mat2gray(differencedIm2));

XDOGFilteredImage = mat2gray(differencedIm2);

% take mean of XDoG Filtered image to use in thresholding operation
meanValue = mean2(XDOGFilteredImage);

x = size(XDOGFilteredImage,1);
y = size(XDOGFilteredImage,2);

% thresholding
for i=1:x
    for j=1:y
        if XDOGFilteredImage(i, j) <= meanValue
            XDOGFilteredImage(i, j) = 0.0;
        else 
            XDOGFilteredImage(i, j) = 1.0;
        end
    end
end

figure, imshow(mat2gray(XDOGFilteredImage));

%create XDoG Filtered Image and the thresholded one
imwrite(mat2gray(differencedIm2), 'XDoGFilter.jpg');
imwrite(mat2gray(XDOGFilteredImage), 'XDoGFilterThresholded.jpg');