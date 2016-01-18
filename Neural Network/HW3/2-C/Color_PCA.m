clear all
close all

%%read images
Data = IO();
%%
cd 'F:\Documents\MATLAB\Neural Network\HW3\2-C';
%%extract chaneles and eigs
%seprate chanels
for i=1:80
    Red = Data.train_image{i}(:,:,1);
    Green =  Data.train_image{i}(:,:,2);
    Blue = Data.train_image{i}(:,:,3);
    
    %reshape Red matrix to the vector
    [height,width] = size(Red);
    Data.red_im_vector{i} = reshape(Red,[1,height*width]);
    Data.blue_im_vector{i} = reshape(Blue,[1,height*width]);
    Data.green_im_vector{i} = reshape(Blue,[1,height*width]);
    
    %claculte PCA eigvector and eigvalue for all chanels
    [ Data.red_eigvector{i} ,  Data.red_eigvalue{i}] = PCA_(Data.red_im_vector{i}, 30);
    [ Data.blue_eigvector{i} ,  Data.blue_eigvalue{i}] = PCA_(Data.blue_im_vector{i}, 30);
    [ Data.green_eigvector{i} ,  Data.green_eigvalue{i}] = PCA_(Data.green_im_vector{i}, 30);
    
    %feature extarction
    Data.red_ytrn{i} = (Data.red_im_vector{i}*Data.red_eigvector{i} )';
end
%%


% % Normalize the Image:
% myRange = getrangefromclass(RGB_Image(1));
% newMax = myRange(2);
% newMin = myRange(1);
% RGB_Image_Norm = (RGB_Image - min(RGB_Image(:)))*(newMax - newMin)/(max(RGB_Image(:)) - min(RGB_Image(:))) + newMin;
% %resize image
% RGB_Image_Norm_Resized = imresize(RGB_Image_Norm, [240 240]) ;

% %seprate chanels
%
% Red = RGB_Image_Norm_Resized(:,:,1);
% Green = RGB_Image_Norm_Resized(:,:,2);
% Blue = RGB_Image_Norm_Resized(:,:,3);
%
% %show Red Chanel
% figure(10)
% imshow(Red);
% %claculte PCA eigvector and eigvalue for all chanels
% [red_eigvector , red_eigvalue] = PCA_(Red, 3);
% [blue_eigvector , blue_eigvalue] = PCA_(Blue, 3);
% [green_eigvector , green_eigvalue] = PCA_(Green, 3);
% %reshape Red matrix to the vector
% [height,width] = size(Red);
% red_im_vector = reshape(Red,[1,height*width]);
% blue_im_vector = reshape(Blue,[1,height*width]);
% green_im_vector = reshape(Blue,[1,height*width]);

