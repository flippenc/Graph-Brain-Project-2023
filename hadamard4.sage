def is_hadamard(M):
    # Check if the matrix is square
    if M.nrows() != M.ncols():
        return False

    # Check if all entries are +1 or -1 and all rows are orthogonal
    n = M.nrows()
    for i in range(n):
        for j in range(n):
            if M[i, j] not in {-1, 1}:
                return False
        for j in range(i + 1, n):
            if M.row(i).dot_product(M.row(j)) != 0:
                return False

    # If all checks passed, then the matrix is Hadamard
    return True

import itertools

n = 4 # replace with your desired size

def viewAsBip(M):
    #start with 2n vertices
    n = M.nrows()
    G = Graph(2*n)
    #add a A-to-B edge if 1 in matrix
    for i in range(n):
        for j in range(n):
            if M[i, j] ==1:
                G.add_edge(i,j+n)
    pos_dict = {}
    for i in range(2*n):
        if i <n:
            pos_dict[i] = [0,i]
        else:
            pos_dict[i] = [2,i-n]
    #G.show(pos=pos_dict)
    return(G)

# Generate all possible combinations of -1 and 1 in an n*n matrix
elements = list(itertools.product([-1, 1], repeat=n*n))

# Create matrices from the combinations
matrices = [matrix(n, list(e)) for e in elements]

hadamardfour=[]
hadamardfourgraphs=[]

for m in matrices:
    if is_hadamard(m):
        hadamardfour.append(m)
        hadamardfourgraphs.append(viewAsBip(m))

save(hadamardfourgraphs,'hadamardfourgraphs.sobj')
#save(hadamardfourgraphs,'hadamardeightgraphs.sobj')
#len(hadamardfour)

cleanlist=[]

for g in hadamardfourgraphs:
    flagg=False
    for h in cleanlist:
        if g.is_isomorphic(h):
            flagg=True
    if not flagg:
        cleanlist.append(g)

with open('hadamard4.txt','w') as hadamard:
    for g in cleanlist:
        hadamard.write(f'{g.graph6_string()}\n')
