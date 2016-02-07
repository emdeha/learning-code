def get_freq(ls):
    w = ls[0]
    cnt = 1
    for i in range(1,len(ls)):
        if cnt == 0:
            cnt = 1
            w = ls[i]
        elif ls[i] == w:
            cnt += 1 
        else:
            cnt -= 1
    return w

ls = [1,1,3,1,3,1,3,4,1,1,4]
print(get_freq(ls))
