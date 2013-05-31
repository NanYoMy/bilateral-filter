% Bilateral filter
% Optimized implemetation
%
% Dan Stefanov, 2013

% implemets optimized algorithm 
function [filtred_image] = bf_opt (input_image, sigma, r)
    [extended_image, od] = extend_image (input_image, r);
    his_image = divide_image (extended_image);
    his_filt_image = his_filt (his_image, od, sigma.d, r);
    
    filtred_image_h = zeros (size(extended_image));
    filtred_image_k = zeros (size(extended_image));
    for i=1:256
        filtred_image_h = filtred_image_h + squeeze(his_filt_image(i,:,:))*i;
        filtred_image_k = filtred_image_k + squeeze(his_filt_image(i,:,:));
    end
    filtred_image = uint8(filtred_image_h./filtred_image_k);
end

function [his_im] = divide_image (in_image)
    his_im = zeros ([256 size(in_image)]);
    for i=1:256
        his_im(i,:,:) = in_image == (i-1);
    end
end

