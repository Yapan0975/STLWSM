
% Written by Ping Yang,yp@zjut.edu.cn, Oct 2019
%
clear;
addpath('utilized');
%
nSig = [15 20 30 40 50 75];
PSNR_m = size(nSig,2);
%
PSNR1 = zeros(1,PSNR_m);
%
time1 = zeros(1,PSNR_m);

I = imread('house.png');
X_org = I;

[LH,LW,Ldim] = size(X_org);
if Ldim >1
    X_yuv = rgb2ycbcr(X_org);
    X_org = im2double(X_yuv(:,:,1));
else
    X_org = im2double(X_org);
end

%
for k = 1:6
        nSigk = nSig(k);
        
         rng('default'); Mask = randn(size(X_org)); 
        Mask(Mask<(nSigk/100)) =0; 
        Mask(Mask>=(nSigk/100))=1;
        N_img = X_org .* Mask;        %Generate noisy image
        
        PSNRN  =  csnr( N_img, X_org, 0, 0 );
        fprintf( 'Noisy Image: nSig = %2.3f, PSNR = %2.2f \n', nSigk, PSNRN);

        Par   = ParSet(nSigk);  
        [PSNR1(1,k),time1(1,k)] = STLWSM_DeNoising(N_img,X_org,Par);
        save PSNR1;
        save time1;
      
end
