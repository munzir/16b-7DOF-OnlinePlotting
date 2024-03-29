function MSE = compute_MSE(predictions, measured)
meanPred = mean(predictions);
meanMeas = mean(measured);

error = predictions - measured;
sqErr = (error).^2;
mSqEr = mean(sqErr);
for i = 1:length(mSqEr)
    MSE(i)  = mSqEr(i); %/abs(meanPred(i)*meanMeas(i));
end
end