import itertools

def makeBipartite(G):
    try:
        G.relabel()
        return BipartiteGraph(G)
    except:
        return False

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
#                 print(f'j is {row[j]}, so we will add edge (0,{i}),(1,{j})')
                G.add_edge((0,i),(1,j))
    return G

def hadamardBipartite(G):
    B = makeBipartite(G)
    if not B:
        return False
    else:
        bip = B.bipartition()
        leftPart = bip[0]
        for u,v in itertools.combinations(leftPart,2):
            vNeigh = Set(B.neighbors(v))
            uNeigh = Set(B.neighbors(u))
            vNonNeigh = Set(B.vertices()).difference(vNeigh)
            uNonNeigh = Set(B.vertices()).difference(uNeigh)
            n = len(leftPart)
            if (len(vNeigh.intersection(uNeigh)) != n/2) and (len(vNonNeigh.intersection(uNonNeigh)) != n/2):
                return False
        return True

for e in range(0,16,2):
#     print(f'checking with {e} edges')
    for G in graphs.nauty_geng(options=f"8 {e}:{e} -b"):
        if hadamardBipartite(G):
            with open('hamBip8.txt', 'a') as hamGraphs:
                hamGraphs.write(f'{G.graph6_string()}\n')
