function [] = motionPattern(direction,delay,ax)
    if strcmp(direction,"Left")
        for iter1 = 1:9
            singlePixel(7,10-iter1,ax);
            singlePixel(7,10-iter1+1,ax);
            singlePixel(8,10-iter1,ax);
            singlePixel(8,10-iter1+1,ax);
            drawnow;
            pause(delay);
            cla(ax);
        end
    end
    if strcmp(direction,"Right")
        for iter1 = 1:9
            singlePixel(7,iter1,ax);
            singlePixel(7,iter1+1,ax);
            singlePixel(8,iter1,ax);
            singlePixel(8,iter1+1,ax);
            drawnow;
            pause(delay);
            cla(ax);
        end
    end
    if strcmp(direction,"Up")
        for iter1 = 1:9
            singlePixel(10-iter1,5,ax);
            singlePixel(10-iter1+1,5,ax);
            singlePixel(10-iter1,6,ax);
            singlePixel(10-iter1+1,6,ax);
            drawnow;
            pause(delay);
            cla(ax);
        end
    end
    if strcmp(direction,"Down")
        for iter1 = 1:9
            singlePixel(iter1,5,ax);
            singlePixel(iter1+1,5,ax);
            singlePixel(iter1,6,ax);
            singlePixel(iter1+1,6,ax);
            drawnow;
            pause(delay);
            cla(ax);
        end
    end
end