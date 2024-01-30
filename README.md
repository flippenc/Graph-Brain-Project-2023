# Graph Brain Project 2023 - Hadamard Matrix Graphs

**General Research Information:**

-   This research was conducted during the summer of 2023 under the
    leadership of Drs.Neal Bushaw, Craig Larson, and Bob Wieman. This
    research was conducted by a group of undergraduate and graduate
    students in the Math and Computer Science departments at Virginia
    Commonwealth University

-   The purpose of this research was to better understand various
    aspects of Hadamard matrices, including properties of graphs that
    correspond to Hadamard matrices. The students in this research chose
    which areas of the problem they wanted to study. A paper compiling
    the results of this project is currently being written by members of
    the research project. The code and data in this repository is the
    work of Christopher Flippen unless otherwise stated

**Theory Explanation:**

-   A Hadamard matrix is a square matrix whose entries are either  + 1
    or  − 1 and whose rows are mutually orthogonal. An equivalent
    definition of a Hadamard matrix is that *H*<sub>*n*</sub> is an
    order *n* Hadamard matrix if and only if
    $$H_nH_n^T = nI_n$$
    where $I_n$ is the $n \times n$ identity matrix. It is
    known that if a Hadamard matrix exists, it’s order must be 1, 2, or
    a multiple of 4. However, it is unknown if there is a Hadamard
    matrix of order $4k$ for every positive integer $k$

-   Two Hadamard matrices are said to be *Hadamard equivalent* if it is
    possible to obtain one matrix from the other by permuting rows,
    permuting columns, and negating rows and columns. In his paper
    “Hadamard Equivalence via Graph Isomorphism," Brendan McKay
    described a construction by which a Hadamard matrix can be
    transformed into a graph and two “McKay graphs" are isomorphic if
    and only if their corresponding Hadamard matrices are Hadamard
    equivalent. This paper is available for free through
    [ScienceDirect](https://www.sciencedirect.com/science/article/pii/0012365X79901134)

**Code Explanation:**

-   My goals for this research project were:

    -   implementing functions for studying McKay graphs such as
        checking if a graph is a McKay graph, transforming a Hadamard
        matrix into a McKay graph and vice versa, and generating all
        non-isomorphic McKay graphs of a given order

    -   studying what other interesting methods exist for encoding a
        Hadamard matrix as a graph exist and implementing functions for
        studying them

-   More information about these goals appears in the following sections

**McKay Graph Functions**

Directly checking if two Hadamard matrices are Hadamard equivalent by
checking all possible row and column permutations and negations is an
extremely difficult task computationally due to how many combinations of
these operations are possible. If $H$ is an $n \times n$ Hadamard matrix,
then its corresponding McKay graph $M(H)$ is a graph with vertices
$v_1, v_2, \ldots, v_n$, $w_1, w_2, \ldots, w_n$, $v'_1, v'_2, \ldots, v'_n$, and $w'_1, w'_2, \ldots, w'_n$ and edges
$$(v_i,w_j),(v'\_i,w'_j) \quad\text{if}\quad h\_{ij} = 1 \quad\text{and}\quad (v_i,w_j'),(v'\_i,w_j) \quad\text{if}\quad h\_{ij} = -1.$$
We can also add loops to the vertices
$v_1, v_2, \ldots, v_n$ and $v'_1, v'_2, \ldots, v'_n$. Without these
loops, if $H$ and $H'$ are Hadamard matrices, $M(H)$ and $M(H')$ are
equivalent if and only if $H$ is Hadamard equivalent to $H'$ or
$H'^T$. With these loops $M(H)$ and $M(H')$ are
equivalent if and only if $H$ is Hadamard equivalent to $H'$

-   The file `McKayFunctions.sage` contains various functions for
    exploring McKay graphs

-   Other files such as `hadamardEquivClass.sage` have code for
    generating all McKay graphs of a given order

**Another Method of Generating Graphs from Hadamard Matrices**

Vic Bednar, another student who worked on this project, described
another method of encoding Hadamard matrices as graphs. If $H$ is an $n \times n$ 
Hadamard matrix, then its corresponding VB graph $VB(H)$ is a graph with vertices 
$(0,1),(0,2),\ldots,(0,n)$ and $(1,1),(1,2),\ldots,(1,n)$ with edges $$(0,i),(1,j)\quad\text{if}\quad h_{i,j} = 1.$$

-   The file `VB-functions.sage` contains various functions for
    generating VB graphs from Hadamard matrices and vice versa as well
    as for generating all VB graphs of a fixed order

-   The files `VB-order4.txt` and `VB-order8.txt` contain results from
    generating all VB graphs of orders 4 and 8. When comparing these
    with the corresponding McKay graphs, stored in
    `McKay-had24GraphStrings.txt` and `McKay-had28GraphStrings.txt`
    respectively, the numbers of non-isomorphic McKay and VB graphs
    corresponding to order 4 and 8 Hadamard matrices are different
