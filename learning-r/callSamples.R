getCallSamples <- function(n)
{
	days <- c(1,2,3,4,5,6,7);
    allCalls <- c();
    j <- 0;

	for (i in seq(0,n,by=1))
	{
        smpl <- sample(days,12,TRUE);
        uniq <- unique(smpl);
        if (length(uniq) <= 6)
        {
            allCalls[j] = length(uniq);
            j = j + 1;
        }
	}

    allLen <- length(allCalls);
    1 - allLen/n;
}
