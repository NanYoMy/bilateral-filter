% Bilateral filter
% Optimized implemetation
%
% Dan Stefanov, 2013

% implemets optimized algorithm 
function [filt_image_fxp] = bf_opt (input_image, sigma, r)
    [extended_image_fxp, od] = extend_image (input_image, r);
    his_image = double(divide_image (extended_image_fxp));
    extended_image = double (extended_image_fxp); 
    his_filt_image = deriche_filter (his_image, pi /2/ sigma.r);
    
    [mask_h, mask_k] = comp_mask (extended_image, sigma.r);
    filt_image_h = squeeze (sum (mask_h.*his_filt_image,1));
    filt_image_k = squeeze (sum (mask_k.*his_filt_image,1));
    
    filt_image = filt_image_h ./ filt_image_k;
    filt_image_cut = filt_image (od.a(1):od.b(1),od.a(2):od.b(2));
    filt_image_fxp = uint8(filt_image_cut);
end

function [his_im] = divide_image (in_image)
    his_im = zeros ([256 size(in_image)]);
    for i=1:256
        his_im(i,:,:) = in_image == (i-1);
    end
end

function [mask_h, mask_k] = comp_mask(in_im,sigma)
   line = 0:255;
   arg0 = repmat (line', [1 size(in_im)]);
   ext_im = zeros ([1 size(in_im)]);
   ext_im (1,:,:) = in_im;
   arg1 = repmat (ext_im, [256 1 1]);
   arg = arg1 - arg0;
   mask_k = exp (-0.5*(arg/sigma).^2);
   mask_h = mask_k .* arg0;  
end



