function [outputSig, time_vector] = chopSignals(signal, fs, cutLen, RefCh, numCh, scaleFactor)
    numReps = size(signal,1);
    sigLen = cutLen*fs;
    outputSig = zeros(numCh,numReps,sigLen);
    time_vector = (0:sigLen-1)/fs;

    for iter1 = 1:numReps
        diffRef = signal{iter1}(2:end,RefCh) - signal{iter1}(1:end-1,RefCh);
        [~,cutIdx] = max(diffRef);
        for iter2 = 1:numCh
            outputSig(iter2,iter1,:) = scaleFactor*signal{iter1}(cutIdx:cutIdx+sigLen-1,iter2)';
        end
    end
end