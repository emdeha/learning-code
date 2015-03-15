getCallSamples <- function(n)
{
	days <- c(1,2,3,4,5,6,7);
    allLen <- 0;

	for (i in seq(0,n,by=1))
	{
        smpl <- sample(days,12,TRUE);
        uniq <- unique(smpl);
        if (length(uniq) == 7)
        {
            allLen = allLen + 1;
        }
	}

    allLen/n;
}
