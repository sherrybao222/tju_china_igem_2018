clc
clear
%input target and full nucleotide array
data_path_1='C:\Users\StargazerSaki\Desktop\model\full.txt';
data_path_2='C:\Users\StargazerSaki\Desktop\model\target.txt';
fid=fopen(data_path_1,'r');
bb=textscan(fid,'%s');
fclose(fid); 
full=cell2mat(bb{1});
fid=fopen(data_path_2,'r');
bb=textscan(fid,'%s');
fclose(fid);
target=cell2mat(bb{1});
target=fliplr(seqrcomplement(target));
record=[];
len_full=length(full);
len_target=length(target);
%default parameter
para=[1,10,20,1];
%for t=1:1:len_full-len_target+1
%count the energy change in two nucleotide array bind(whether is match or mismatch)
for t=1:1:2000
    cor=full(t:t+len_target-1);
    alpha=count(target,cor);
    %every parameter means diff. base-binding cause correspondng energy-donation proportion  
    energy=-2*para(1)*alpha(1)-3*para(1)*alpha(2)+para(2)*alpha(3)+para(3)*alpha(4)+para(4)*alpha(5);
    %a is a logistic regression type, transfer a unlitmit varible to a possibliy expression 
    a=1/(1+exp(energy));
    E=[];
    %following cycle used to recognize energy change per base binding
    %and if the energy become positive give it all a big value 
    %so that we can make sure the possibility is nearby zero  
    for m=1:1:len_target
        a1=target(1:m);a2=cor(1:m);
        alpha=count(a1,a2);
        energy=-2*para(1)*alpha(1)-3*para(1)*alpha(2)+para(2)*alpha(3)+para(3)*alpha(4)+para(4)*alpha(5);
        a=1/(1+exp(energy));
        E=[E energy];
        if energy>0
            E=1e5*ones(len_target,1);
            break
        end
    end
   % for n=1:1:length(E)
   %     if E(n)>0
   %         E=zeros(length(E),1);
   %         break
   %     end
   % end
   %show energy changement
    plot(1:1:length(E),E,'linewidth',1.5);hold on;
    %record=[record alpha];
    %record=[record -energy];
    %record=[record a];6
end
%plot(1:1:length(record),record)
