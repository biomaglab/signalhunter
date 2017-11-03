function [fmed, rms, fmean]= fmed_rms(x,fsamp,epoch)
%[P,f]=psd(x,fsamp*epoch_len,fsamp,ones(fsamp*epoch_len,1),0);

if mod(length(x),epoch), error('vector length should be multiple of the epoch chosen'), return, end
ReshapedX = reshape(x,epoch,prod(size(x))/epoch);

for column = 1:size(ReshapedX,2)
    x = ReshapedX(:,column);
    
    rms(column,1)=norm(x)/sqrt(length(x));
    x=x-mean(x);
%     [P,f]=psd(x,fsamp,fsamp,boxcar(fsamp),0);
    [P,f]=pwelch(x,rectwin(fsamp),0,fsamp,fsamp);

    if sum(P)~=0,

        num=sum(f.*P);
        den=sum(P);
        fmean(column,1)=num/den;
        den=sum(P);
        k=1;
        while (sum(P(1:k)))<=den/2,
            k=k+1;
        end
        i=k;

        if i<length(P),

            alfa1=sum(P(1:i-1))/den;

            if P(i)<=P(i+1),
                radi=roots([abs(P(i+1)-P(i)) 2*P(i) -2*(0.5-alfa1)*den]);
            else,
                radi=roots([abs(P(i+1)-P(i)) P(i)+P(i+1) -2*(0.5-alfa1)*den]);
            end;

            if radi(1)>0 & radi(1)<1,
                x=radi(1);
            else,
                x=radi(2);
            end;
            df=f(2)-f(1);
            fmed(column,1)=f(k)+df*x;
        else
            fmean(column,1)=NaN;
            fmed(column,1)=NaN;
        end;
    else
        fmean(column,1)=NaN;
        fmed(column,1)=NaN;
    end;
end