function [chop_idx] = ChopSignal(signal,frequency,start_idx,fs)
    dy = diff(signal);

    period = fs/frequency;
    chop_idx = [];

    while start_idx+period < length(dy)
        [~,min_idx] = min(dy(floor(start_idx):floor(start_idx+period)));
        chop_idx = [chop_idx min_idx+floor(start_idx)-1];
        start_idx = start_idx+period;
    end
end