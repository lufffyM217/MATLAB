clear all;tic
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%This code achieves the following:
%-if M = 1600, an error rate on MNIST of about 96.3% correct on test data in about 14 seconds (on a four core computer using multithreading)
%-if M = 8000, an error rate on MNIST of 98.2% in about 3 minutes

%Author: Assoc Prof Mark D. McDonnell, University of South Australia
%Email: mark.mcdonnell@unisa.edu.au
%Date: January 2015
%Citation: If you find this code useful, please cite the paper described at http://arxiv.org/abs/1412.8307

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%get training and test data; data files can be obtained from http://yann.lecun.com/exdb/mnist/
X = loadMNISTImages('F:\Documents\MATLAB\Data\MNIST\train-images-idx3-ubyte\train-images.idx3-ubyte'); %uses function available from http://ufldl.stanford.edu/wiki/resources/mnistHelper.zip
X_test = loadMNISTImages('F:\Documents\MATLAB\Data\MNIST\t10k-images-idx3-ubyte\t10k-images.idx3-ubyte'); %uses function available from http://ufldl.stanford.edu/wiki/resources/mnistHelper.zip
labels = loadMNISTLabels('F:\Documents\MATLAB\Data\MNIST\train-labels-idx1-ubyte\train-labels.idx1-ubyte'); %uses function available from http://ufldl.stanford.edu/wiki/resources/mnistHelper.zip
labels_test = loadMNISTLabels('F:\Documents\MATLAB\Data\MNIST\t10k-labels-idx1-ubyte\t10k-labels.idx1-ubyte'); %uses function available from http://ufldl.stanford.edu/wiki/resources/mnistHelper.zip

%set up the ELM:

%create a target matrix using the training class labels
NumClasses = 10;
Y = zeros(length(labels),NumClasses);
for ii = 1:length(labels)
    Y(ii,labels(ii)+1) = 1;
end

%specify the hyperparameters:
M = 1600; %set the number of hidden layer neurons
Scaling = 2; %set the input weights scaling
RidgeParam = 1e-8; %set the ridge regression parameter
MinMaskSize = 10; %parameter for RF-ELM
RF_Border = 3; %parameter for RF-ELM

%train the RF-ELM with data X and labels Y
L = size(X,1);
ReceptiveFields =  zeros(M,L);
ImageSize = sqrt(L); %assumes L is a square number, as is the case for MNIST
for ii = 1:M %get the receptive fields masks
    Mask = zeros(ImageSize,ImageSize);
    Inds1 = zeros(2,1);Inds2 = zeros(2,1);
    while (Inds1(2)-Inds1(1))*(Inds2(2)-Inds2(1)) < MinMaskSize
        Inds1 = RF_Border+sort(randperm(ImageSize-2*RF_Border,2));
        Inds2 = RF_Border+sort(randperm(ImageSize-2*RF_Border,2));        
    end
    Mask(Inds1(1):Inds1(2),Inds2(1):Inds2(2))=1;
    ReceptiveFields(ii,:) =  Mask(:);
end
W_randoms =  ReceptiveFields.*sign(randn(M,L)); %get bipolar random weights masked by the receptive fields
W_randoms = Scaling*diag(1./sqrt(sum(W_randoms.^2,2)))*W_randoms; %normalise rows and scale
A = 1./(1+exp(-W_randoms*X)); %get hidden layer activations
W_outputs = (A*Y)'/(A*A'+RidgeParam*eye(M)); %find output weights by solving the for regularised least mean square weights

%test with trained-on data
[MaxVal,ClassificationID_train] = max(W_outputs*A);%get output layer response and then classify it
PercentCorrect_train = 100*(1-length(find(ClassificationID_train-1-labels'~=0))/length(labels)) %calculate the error rate

%test with unseen data, X_test
Y_predicted_test = W_outputs*(1./(1+exp(-W_randoms*X_test)));%get output layer response
[MaxVal,ClassificationID_test] = max(Y_predicted_test); %get classification
PercentCorrect = 100*(1-length(find(ClassificationID_test-1-labels_test'~=0))/length(labels_test))%calculate the error rate
toc
