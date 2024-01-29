import itertools
import random
import sage.combinat.matrices.hadamard_matrix
from sage.combinat.matrices.hadamard_matrix import is_hadamard_matrix

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

#is VB-hadamard bipartite graph - more efficient implementation
def isHadamardBipartite(G):
    bip = findBalancedBipartition(G)
    if not bip:
        return False
    leftPart,rightPart = bip[0],bip[1]
    for u,v in itertools.combinations(leftPart,2):
        vNeigh = Set(G.neighbors(v))
        uNeigh = Set(G.neighbors(u))
        vNonNeigh = Set(rightPart).difference(vNeigh)
        uNonNeigh = Set(rightPart).difference(uNeigh)
        n = len(leftPart)
        if (len(vNeigh.intersection(uNeigh)) + len(vNonNeigh.intersection(uNonNeigh)) != n/2):
            return False
    return True

#is VB-hadamard bipartite graph - alternate implementation
def is_hadamard_graph(g):
    if not g.is_bipartite():
        return False
    V = g.vertices()
    D = g.degree()
    Isolated = [v for v in V if g.degree(v)==0]
    if len(Isolated) > 2:
        return False
    Rest = [v for v in V if v not in Isolated]
    n = g.order()
    k=n/2
    gcon = g.subgraph(Rest)
    A,B = gcon.bipartite_sets()
    if len(A) < k:
        A = A.union(Set([Isolated[0]]))
    if len(B) < k:
        B = B.union(Set([Isolated[1]]))
    for v in A:
        for w in A:
            if v != w:
                Nv=g.neighbors(v)
                #print("Nv is {}".format(Nv))
                Nvc=B.difference(Nv)
                #print("Nvc is {}".format(Nvc))
                Nw=g.neighbors(w)
                Nwc=B.difference(Nw)
                S=Set(Nv).intersection(Set(Nw))
                Sc=Nwc.intersection(Nvc)
                if len(S)+len(Sc) != k/2:
                    return False
    return True

# hadamard matrix to VB graph
def hadamardToBipartite(H):
    n = len(H)
    for i in [0..n-1]:
        verts.append((0,i))
        verts.append((1,i))
    G = BipartiteGraph([verts,[]])
    for i in [0..n-1]:
        row = H[i].tolist()
        for j in [0..n-1]:
            if row[j] == 1:
                G.add_edge((0,i),(1,j))
    return G

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

def generateBipartiteGraphsN(n):
    i=0
    outFileName = f'hadamard{n}Graphs.txt'
    for e in range(0,n*n,2):
        for G in graphs.nauty_geng(options=f"{2*n} {e}:{e} -b"):
            i+=1
            if isHadamardBipartite(G):
                M = bipartiteToHadamard(G)
                if is_hadamard_matrix(M):
                    with open(outFileName, 'a') as hamFile:
                        hamFile.write(f'{G.graph6_string()}\n')
                else:
                    with open(outFileName, 'a') as hamFile:
                        hamFile.write(f'SOMETHING IS WRONG WITH {G.graph6_string()}\n')
                    return False

def generateBipartiteGraphsNE(n,e):
    i=0
    outFileName = f'list{n}/hadamard{n}Graphs{e}.txt'
    with open(outFileName, 'a') as hamFile:
        hamFile.write(f'Starting the n={n} and e={e} case\n')
    for G in graphs.nauty_geng(options=f"{2*n} {e}:{e} -b"):
        i+=1
        if isHadamardBipartite(G):
            M = bipartiteToHadamard(G)
            if is_hadamard_matrix(M):
                with open(outFileName, 'a') as hamFile:
                    hamFile.write(f'{G.graph6_string()}\n')
            else:
                with open(outFileName, 'a') as hamFile:
                    hamFile.write(f'SOMETHING IS WRONG WITH {G.graph6_string()}\n')
                return False
    with open(outFileName, 'a') as hamFile:
        hamFile.write(f'Finished with the n={n} and e={e} case\n')

def checkParameters():
    if len(sys.argv) < 2:
        return False
    try:
        n = int(sys.argv[1])
        e = int(sys.argv[2])
    except:
        return False
    # 0 <= e <= n^2
    if 0 > e or e > n*n:
        return False
    return True

if __name__ == "__main__":
    if checkParameters():
        n = int(sys.argv[1])
        e = int(sys.argv[2])
        print(f'Starting generation with n={n} and e={e}')
        generateBipartiteGraphsNE(n,e)
    else:
        print(f'Invalid input: argv={sys.argv}')