import sys

def mGraph(M):
    n = M.nrows()
    G = Graph(4*n)
    for i in range(n):
        for j in range(n):
            if M[i, j] == 1:
                G.add_edge(i,j+n)
                G.add_edge(i + (2*n) , (j+n) + (2*n))
            else:
                G.add_edge(i,(j+n) + (2*n))
                G.add_edge( (i + (2*n)) , j+n )
    return G

def hadamardFileToGraphList(n):
    Mlist = []
    with open(f'had{n}.txt') as hadFile:
        for s in hadFile:
            had = []
            for num in s.split():
                new = "0x"+num
                new2=bin(Integer(new))
                if len(new2) < n+2:
                    new2=new2[2:].zfill(n)
                    new2=f'0b{new2}'
                new3=new2[2:]
                for c in new3:
                    if c =="1":
                        had.append(1)
                    else:
                        had.append(-1)
            Mlist.append(matrix(n,n,had))
    Glist = []
    for M in Mlist:
        Glist.append(mGraph(M))
    return Glist

def hadamardFileToGraphFile(n):
    Glist = hadamardFileToGraphList(n)
    with open(f'had{n}GraphStrings.txt', 'w') as hadGraphFile:
        for G in Glist:
            hadGraphFile.write(f'{G.graph6_string()}\n')

def checkParameters():
    if len(sys.argv) < 1:
        return False
    try:
        n = int(sys.argv[1])
    except:
        return False
    return True

if __name__ == "__main__":
    if checkParameters():
        n = int(sys.argv[1])
        hadamardFileToGraphFile(n)
    else:
        print(f'Invalid input: argv={sys.argv}')
