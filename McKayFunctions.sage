import itertools
import random
import sage.combinat.matrices.hadamard_matrix
from sage.combinat.matrices.hadamard_matrix import is_hadamard_matrix

#Hadamard Matrix to McKay Graph
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

# only 3 possibilities: 0, 1, or 2 isolated vertices
def findBalancedBipartition(G):
    iso = [v for v in G.vertices() if G.degree(v)==0]
    Gcopy = G.copy()
    Gcopy.delete_vertices(iso)
    leftPart,rightPart = Gcopy.bipartite_sets()
    leftPart = list(leftPart)
    rightPart = list(rightPart)
    # if no iso
    if len(leftPart) == len(rightPart) and len(iso) == 0:
        return leftPart,rightPart
    # if 1 iso
    elif len(leftPart) == len(rightPart)+1 and len(iso) == 1:
        rightPart.append(iso[0])
        return leftPart, rightPart
    elif len(rightPart) == len(leftPart)+1 and len(iso) == 1:
        leftPart.append(iso[0])
        return leftPart, rightPart
    # if 2 iso
    elif len(leftPart) == len(rightPart) and len(iso) == 2:
        leftPart.append(iso[0])
        rightPart.append(iso[1])
        return leftPart, rightPart
    else:
        return False

def bipartiteToHadamard(G):
    try:
        G.bipartite_sets()
    except:
        return False
    Gcopy = G.copy()
    A = findBalancedBipartition(Gcopy)
    if not A:
        return False
    else:
        leftPart, rightPart = A[0],A[1]
    i = 0
    for v in leftPart:
        Gcopy.relabel({v:(0,i)})
        i += 1
    i = 0
    for v in rightPart:
        Gcopy.relabel({v:(1,i)})
        i += 1
    n = len(leftPart)
    M = matrix([[-1]*n]*n)
    # set entry [i][j] to 1 if edge (0,i),(1,j) is in G
    for e in Gcopy.edges():
        M[e[0][1], e[1][1]] = 1
    return M

def mcKayToMatrix(G,leftPart1,leftPart2,rightPart1,rightPart2):
    M = matrix([[0]*n]*n)
    Gcopy = G.copy()
    i = 0
    for v in leftPart1:
        Gcopy.relabel({v:(0,i)})
        i += 1
    i = 0
    for v in leftPart2:
        Gcopy.relabel({v:(1,i)})
        i += 1
    i = 0
    for v in rightPart1:
        Gcopy.relabel({v:(2,i)})
        i += 1
    i = 0
    for v in rightPart2:
        Gcopy.relabel({v:(3,i)})
        i += 1
    # parts 0,1 on left, 2,3 on right
    for i in range(n):
        for j in range(n):
            # edge ((0,i),(2,j)) and ((1,i),(3,j)) represents a +1 in index [i,j]
            if ((0,i),(2,j)) in Gcopy.edges() and ((1,i),(3,j)) in Gcopy.edges():
                M[i,j] = 1
            # if one edge but not the other, then this is not a mcKay graph
            elif bool(((0,i),(2,j)) in Gcopy.edges()) != bool(((1,i),(3,j)) in Gcopy.edges()):
                return False
            # edge ((0,i),(3,j)) and ((1,i),(2,j)) represents a -1 in index [i,j]
            elif ((0,i),(3,j)) in Gcopy.edges() and ((1,i),(2,j)) in Gcopy.edges():
                M[i,j] = -1
            # if one edge but not the other, then this is not a mcKay graph
            elif bool(((0,i),(3,j)) in Gcopy.edges()) != bool(((1,i),(2,j)) in Gcopy.edges()):
                return False
    return M

def isMcKayGraph(G):
    # find bipartition and split partite sets into two parts
    # mckay graphs are n regular 4n vertices
    k = G.order()
    # check if G has 4n vertices
    if k % 4 != 0:
        return False
    n = k/4
    # check if G is n-regular
    if not G.is_regular(n):
        return False
    # check if G is bipartite
    elif not G.is_bipartite():
        return False
    # now find a balanced bipartition
    bip = findBalancedBipartition(G)
    # if one doesn't exist, return false
    if not bip:
        return False
    # if one found, save it as left and right part
    else:
        leftPart, rightPart = bip
    # try to split left and right part into 2 pieces each: leftPart1, leftPart2, rightPart1, and rightPart2
    # check if leftPart1-rightPart1 and leftPart2-rightPart2 are isomorphic
    # if they are, turn the result into a matrix
    for leftPart1 in itertools.combinations(leftPart,n/2):
        leftPart2 = list(Set(G.vertices()).set_difference(leftPart1))
        for rightPart1 in itertools.combinations(rightPart,n/2):
            rightPart2 = list(Set(G.vertices()).set_difference(rightPart1))
            G1 = G.subgraph(list(Set(leftPart1).union(Set(rightPart1))))
            G2 = G.subgraph(list(Set(leftPart2).union(Set(rightPart2))))
            if G1.is_isomorphic(G2):
                M = mcKayToMatrix(G,leftPart1,leftPart2,rightPart1,rightPart2)
                if not M:
                    continue
                else:
                    return True
    return False

def matrixCopy(M):
    n = len(M.rows())
    m = len(M.columns())
    Mcopy = matrix(n,m)
    for i in range(0,n):
        Mcopy[i] = M[i]
    return Mcopy

def shuffleMatrix(M, numShuffles):
    H = matrixCopy(M)
    n = len(H.rows())
    m = len(H.columns())
    for _ in range(numShuffles):
        i = random.choice([0,1,2])
#         print(i)
        # multiply a row by -1
        if i == 0:
            row = list(random.sample(range(0,n),1))[0]
            H[row] = -1*H[row]
        # switch two rows
        elif i == 1:
            choices = list(random.sample(range(0,n),2))
            row1,row2 = choices[0],choices[1]
            row1data = H[row1]
            row2data = H[row2]
            H[row1] = row2data
            H[row2] = row1data
        # switch two columns
        elif i == 2:
            H = H.transpose()
            choices = list(random.sample(range(0,m),2))
            column1,column2 = choices[0],choices[1]
            column1data = H[column1]
            column2data = H[column2]
            H[column1] = column2data
            H[column2] = column1data
            H = H.transpose()
    return H

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

def hadamardness(G):
    H = bipartiteToHadamard(G)
    count = 0
    for i,j in itertools.combinations(H.rows(),2):
        if i.dot_product(j) != 0:
            count+=1
    return count/binomial(len(H.rows()),2)

def graphLine(line,n,e):
    if line.strip() == f'Starting the n={n} and e={e} case' or line.strip() == f'Finished with the n={n} and e={e} case':
        return False
    return True

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