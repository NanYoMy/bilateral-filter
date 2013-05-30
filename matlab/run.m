% Bilateral filter run script
% Script used fillters input file with straight forward and optimized
% algorithms. Result are saved to output files
%
% Dan Stefanov, 2013

in_image = imread ('in.bmp');

ref_image = bf_ref (in_image);

imwrite (ref_image, 'ref.bmp');