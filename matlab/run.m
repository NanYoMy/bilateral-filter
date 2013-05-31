% Bilateral filter run script
% Script used fillters input file with straight forward and optimized
% algorithms. Result are saved to output files
%
% Dan Stefanov, 2013

% input data
in_image = imread ('in.bmp');
ref_image = imread ('ref.bmp');

% filltering
filt_image = bf_opt (in_image, sigma, radius);

% writing result
imwrite (filt_image, 'filt.bmp');

% optimization algorith error
filt_error = norm(double(filt_image-ref_image)) / norm(double(ref_image));
display (['error: ' num2str(filt_error)]);
