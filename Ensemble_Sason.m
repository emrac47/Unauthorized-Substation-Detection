clc;clear;close all

load sasondata
%load feature_select
%Sira=14;
%inds=Feature_Index(1:14);
%     A1=vv_egitim_max(:,4:end)';A2=vv_egitim_mean(:,4:end)';
%     A3=vv_egitim_median(:,4:end)';A4=vv_egitim_min(:,4:end)';
%     B1=vh_egitim_max(:,4:end)';B2=vh_egitim_mean(:,4:end)';
%     B3=vh_egitim_median(:,4:end)';B4=vh_egitim_min(:,4:end)';
%     %Giris=[A1 A2 A3 A4 B1 B2 B3 B4];Cikis=[ones(1,89) zeros(1,89)]';
Giris=sason(:,6); Cikis=sason(:,9);
%Giris=Giris/min(min(Giris));
    %Giris=Giris(:,inds);
%    A=vv_egitim(:,4:end)';B=vh_egitim(:,4:end)';
%    Giris=[A B];Cikis=[ones(1,89) zeros(1,89)]';

    %A=trafolu(:,4:end);B=trafosuz(:,4:end);
    %Giris=[A';B'];Cikis=[ones(size(A,2),1);zeros(size(B,2),1)];

pixels=[Giris Cikis];%1:49: hepsi; 44:49: taradığı alan

pixels = pixels{:,:};


%index=randperm(size(pixels,1));pixels=pixels(index,:);
foldd=size(Giris,1);
adim=floor(length(pixels)/foldd);%1;


        for cc=1:foldd
            egitimgiris=pixels(adim+1:end,1:end-1); %çıkış verileri
            egitimcikis=pixels(adim+1:end,end); %çıkış verileri
            testgiris=pixels(1:adim,1:end-1);%test giris
            testcikis=pixels(1:adim,end);%test çikis 
            
            % Ensemble Sınıflandırıcısı
            

      Mdl = fitcensemble(egitimgiris,egitimcikis,'Method','LogitBoost');
     
      label = predict(Mdl,testgiris);
           
       
            pixels=circshift(pixels,1);
            
             tout(cc)=label;  target(cc)=testcikis;
            
            % Performans
e1=0;

    if label== testcikis
        e1=e1+1;
    end
  performance(cc)=e1*100;
    
        end
average=mean(performance)
         
[c,cm,ind,per] = confusion(target,tout);
plotconfusion(target,tout)

fn=cm(2,1);
fp=cm(1,2);
tp=cm(2,2);
tn=cm(1,1);
 
sensitivity = tp/(tp + fn);  %TPR
specificity = tn/(tn + fp);  %TNR
precision = tp /(tp + fp);
FPR = fp/(tn+fp);
Accuracy = (tp+tn)./(tp+fp+tn+fn);
recall = tp /(tp + fn);
F1 = (2 * precision * recall)/(precision + recall) ;

PerfMetric=100*[sensitivity;specificity;precision;F1;Accuracy]'