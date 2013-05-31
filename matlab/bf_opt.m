% Bilateral filter
% Optimized implemetation
%
% Dan Stefanov, 2013

% implemets optimized algorithm 
function [filt_image_fxp] = bf_opt (input_image, sigma, r)
    [extended_image_fxp, od] = extend_image (input_image, r);
    his_image = double(divide_image (extended_image_fxp));
    extended_image = double (extended_image_fxp);
    his_filt_image = his_filt_ref (his_image, od, sigma.d, r);
    filt_image_h = zeros (size(extended_image));
    filt_image_k = zeros (size(extended_image));
    for x = 1:size(his_filt_image,3)
        for y = 1:size(his_filt_image,2)
            his = squeeze(his_filt_image(:,y,x));
            f_xy = extended_image(y,x);
            [mask_h, mask_k] = comp_mask(f_xy,sigma.r);
            filt_image_h(y,x) = sum(his'.* mask_h);
            filt_image_k(y,x) = sum(his'.* mask_k);
        end
    end
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

function [mask_h, mask_k] = comp_mask(val,sigma)
   line = (0:255);
   arg = line - squeeze(val);
   mask_k = exp(-(arg/sigma).^2);
   mask_h = mask_k.*line;
end

    


