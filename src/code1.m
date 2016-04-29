workspace;

%Read the image
I = imread('pokemon.jpg');
img_size = size(I);
img2d = rgb2gray(I);

%Histogram modification
%imshow(img2d);
I2 = histeq(img2d);
%imshow(I2);
I2 = double(I2);
%divide into 8x8 blocks
[row,col] = size(I2);
bs = 8;
num_blocks = (row/bs) * (col/bs);

mult1=8*ones(1,64);

blocks = mat2cell(I2, mult1, mult1);
%celldisp(blocks);

%Implementing Haar integer wavelet transform on each block

liftscheme = liftwave('haar', '2Int');
els = {'p',[-0.125 0.125],0};
liftscheme2 = addlift(liftscheme,els);

coeff = cell(64,64);
for i=1:64
    for j = 1:64
        [ll, lh, hl, hh] = lwt2(blocks{i,j},liftscheme2);
        coeff{i,j} = [ll, lh, hl, hh];

    end
end

%number of bits used for hiding data

%case 2: k = 3 ; L = 2 for LL subband
L = cell(64,64);
for i = 1:64
    for j = 1:64
        L{i,j} = cell(4,16);
    end
end

    
for i = 1:64
    for j = 1:64
        for k1 = 1:4
            for k2 = 1:16
                if(k2 <= 4)
                    L{i,j}{k1,k2} = 2;
                else
                    if(coeff{i,j}(k1,k2) >= 64)
                        L{i,j}{k1,k2} = 6;
                    else if (coeff{i,j}(k1,k2) >= 32 && coeff{i,j}(k1,k2) < 64)
                        L{i,j}{k1,k2} = 5;
                    else if (coeff{i,j}(k1,k2) >= 16 && coeff{i,j}(k1,k2) < 32)
                        L{i,j}{k1,k2} = 4;
                        else
                        L{i,j}{k1,k2} = 3;
                        end
                        end
                    end
                end
            end
        end
    end
end

% DSP
% 01000100  	01010011  01010000
%embed L bits of data in random coefficients
coeff_b = cell(64,64);
for i = 1:64
    for j = 1:64
        coeff_b{i,j} = cell(4,16);
    end
end
for i=1:64
    for j=1:64
        for m=1:4
            for n= 1:16
coeff_b{i,j}{m,n}= dec2bin(typecast(int8(coeff{i,j}(m,n)), 'uint8'),8);
            end
        end
    end
end
load rand.mat;
% rand = zeros(10,4);
% % for i = 1:10
% %     for j = 1:4
% %         if(j <= 2)
% %             prompt='enter number between 1 and 64: \n';
% %             rand(i,j)= input(prompt);
% %         end
% %         if(j == 3)
% %             prompt='enter number between 1 and 4: \n';
% %             rand(i,j)= input(prompt);
% %         end
% %         if(j == 4)
% %             prompt='enter number between 1 and 16: \n';
% %             rand(i,j)= input(prompt);
% %         end
% %     end
% %     
% % end
%  save rand.mat rand;      
data = [0 1 0 1 1 1 0 0 0 1 0 1 0 0 1 1 0 1 0 1 0 0 0 0];
length=size(data,2);

%embedding the data in given coeffs via rand
ctr = 1;

    for i = 1:10
        change = coeff{rand(i,1),rand(i,2)}(rand(i,3),rand(i,4));
        extract = L{rand(i,1),rand(i,2)}{rand(i,3),rand(i,4)};
%         rep_bits = data(ctr:ctr+extract);
%         zn= zeros(1,extract);
% %         padded= padarray(on,'post');
%         on2= bitshift(b,extract);
%        
%        andn= change && on2;
%        changed_bits=andn+ rep_bits;

       
     for j = extract:-1:1
        i
        j
        coeff{rand(i,1),rand(i,2)}(rand(i,3),rand(i,4)) = bitset(change,j,data(ctr));
        ctr = ctr + 1
     end
         
         if(i == 10 && j == 1)
             break;
         end
    
        if (ctr > length)
            break;
        end;


    end 

    %OPA 
    
    
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
       
        









