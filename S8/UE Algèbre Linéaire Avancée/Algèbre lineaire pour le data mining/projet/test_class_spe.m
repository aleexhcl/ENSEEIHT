clear
close all

% test 
load('ToyExample.mat')
for sig = [0.1 0.3 0.7 0.9 1 10 50 100]
    test = classification_spectrale(Data, 6, sig);
    
    figure()
    subplot(1,3,1)
    image(Data(:,1), 'CDataMapping', 'scaled')
    subplot(1,3,2)
    image(Data(:,2), 'CDataMapping', 'scaled')
    subplot(1,3,3)
    image(test, 'CDataMapping', 'scaled')
end

%%
load('DataTransverse.mat');
load('DataSagittale.mat');

DataTempsT=reshape(Image_DataT,64*54,20);
DataTempsS=reshape(Image_DataS,64*54,20);
k= 6;
sig = 10;
[~,n] = size(DataTempsT);

csT = classification_spectrale(DataTempsT, k, sig);
csS = classification_spectrale(DataTempsS, k, sig);

Image_DataT_cs = reshape(csT,64,54);
Image_DataS_cs = reshape(csS,64,54);

%%
close all

figure()
subplot(1,2,1)
image(Image_ROI_T, 'CDataMapping', 'scaled')
subplot(1,2,2)
image(Image_DataT_cs, 'CDataMapping', 'scaled')

figure()
subplot(1,2,1)
image(Image_ROI_S, 'CDataMapping', 'scaled')
subplot(1,2,2)
image(Image_DataS_cs, 'CDataMapping', 'scaled')

