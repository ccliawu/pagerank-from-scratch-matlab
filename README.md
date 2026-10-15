# PageRank Search Ranking Engine

**Ranking a twelve-page web, then searching it.**

A MATLAB course project exploring how linear algebra turns hyperlinks into page-importance scores. Using a network of **12 pages, 25 hyperlinks, and 18 tree-related keywords**, we compute PageRank, compare two numerical methods, and combine keyword matching with link-based ranking to answer four search queries.

Developed for **MAT 167, UC Davis, Summer Session 2, 2026**. Group 08 presented the project on September 12, 2026.

**Instructor:** Dowman P Varn.

## The question

A search system needs to determine both which pages match a query and which matching pages should appear first. This project separates those tasks:

- **Relevance:** a binary term-document matrix identifies pages containing the requested words.
- **Importance:** PageRank assigns each page a global score based on the link network.

The script filters pages by the query, then sorts the matches by PageRank. It demonstrates this process on a fixed classroom dataset, with predefined queries and no web crawler or interactive search interface.

## How it works

### 1. Turn hyperlinks into a transition matrix

Each row of `G` represents a source page. If a page has `k` outgoing links, each destination receives transition probability `1/k`.

Page E has no outgoing links, leaving its row entirely zero. In this network, the raw matrix has a largest eigenvalue of approximately `0.9601`. Replacing E's row with `1/12` in every column repairs the dangling page and makes every row sum to one.

### 2. Compute PageRank in two ways

The stationary probability vector satisfies

```text
G' * pi = pi
sum(pi) = 1
```

The script obtains this vector through eigendecomposition and independently approximates it through power iteration, starting from a uniform distribution. Following the final code PDF, iteration stops when the L2 difference between successive vectors is at most `1e-5`. A semilog plot shows the convergence history.

### 3. Introduce teleportation

The damped matrix uses a uniform teleportation distribution:

```matlab
alpha = 0.85;
E = ones(n,n) / n;
G_tilde = alpha * G + (1 - alpha) * E;
```

At each step, the random surfer follows the link transition with probability `0.85` and jumps uniformly to a page with probability `0.15`. The script compares rankings from the repaired matrix and this damped matrix.

### 4. Filter and rank search results

The `18 x 12` matrix `T` records whether each keyword appears on each page. Query vectors implement single-term, AND, OR, and BUT NOT matching. Following the final code PDF, the script sorts matching pages using `pi`, the PageRank scores from the repaired, undamped matrix `G`.

## Results

### Global ranking

| Model | Pages, highest to lowest score |
| --- | --- |
| Repaired link matrix | D, J, H, F, B, A, I, G, L, K, E, C |
| Teleportation, alpha = 0.85 | D, J, H, F, A, B, I, G, L, K, E, C |

Page D receives approximately **11.95%** of the stationary probability under the repaired matrix. Teleportation swaps the closely ranked pages A and B while preserving the other positions.

### Convergence and damping experiments

The final code PDF reports that power iteration on the repaired matrix converges in **19 iterations** at a tolerance of `1e-5`, with an L2 difference of approximately **4.3253 x 10^-6** from the eigendecomposition solution. The script retains these settings.

The script also implements the final code PDF's comparison of three damping factors, using a uniform initial vector and the same L2 stopping tolerance:

| Damping factor | Reported iterations | Pages, highest to lowest score |
| --- | --- | --- |
| 0.50 | 8 | D, H, J, A, F, I, B, L, G, K, E, C |
| 0.85 | 14 | D, J, H, F, A, B, I, G, L, K, E, C |
| 0.90 | 15 | D, J, H, F, A, B, I, G, L, K, E, C |

For this network and these settings, stronger teleportation converges faster and changes more ranking positions. The script prints each factor's iteration count and ranking and stores the results in `iter_alpha` and `PageRank_alpha`.

### Search examples

| Query | Matching pages in PageRank order |
| --- | --- |
| Cherry | D, H, A, K, E |
| Hickory AND Oak | E, C |
| Pine OR Willow | J, H, B, I, L, E |
| Redwood BUT NOT Eucalyptus | F, B, G, K |

These examples illustrate why relevance and importance are separate: C and E are the only pages containing both Hickory and Oak, so they are the complete result set even though they rank near the bottom globally.

## Run the project

Use MATLAB with string-array support. The script uses standard matrix operations and plotting functions, with all input data defined in the file.

1. Download or clone the repository.
2. Open its folder in MATLAB.
3. Run:

```matlab
run('pagerank_search_ranking.m')
```

The Command Window displays eigenvalues, PageRank vectors, rankings, the iteration count, and query results. A figure displays the power-method convergence curve. Run the full script first because later sections depend on variables created earlier.

## Files

| File | Purpose |
| --- | --- |
| `pagerank_search_ranking.m` | Transition matrices, PageRank calculations, three-factor damping experiment, Boolean queries, and convergence plot |
| `README.md` | Project overview, results, usage, and source notes |

## Team and Contributions

**Group 08:** Yuheng (Medio) Chen, Mulan Xiao, and Cecelia (Yufei) Wu.

This is a collaborative course project.

The contribution statement records the following division of work:

| Activity | Contributors |
| --- | --- |
| Planning and organizing the project | Cecelia (Yufei) Wu, Mulan Xiao, Yuheng (Medio) Chen |
| Writing the code | Cecelia (Yufei) Wu |
| Writing the presentation | Cecelia (Yufei) Wu, Mulan Xiao, Yuheng (Medio) Chen |
| Making figures and tables | Cecelia (Yufei) Wu, Mulan Xiao, Yuheng (Medio) Chen |

In the contribution statement, CW refers to Cecelia (Yufei) Wu, MX to Mulan Xiao, and MC to Medio Chen, who appears as Yuheng Chen in the presentation.

## Reproducibility and version notes

The authoritative computational source is *Group8_FinalProject_MAT167.pdf*, the 17-page code-and-output document published with MATLAB R2026a. The repository follows its matrices, L2 convergence settings, three-factor damping experiment, and undamped search scoring. The final presentation and contribution statement provide presentation context and team credits.

- **Plot label:** the convergence-axis subscript is corrected from 1 to 2 to match the existing L2 calculation. This is a label-only correction; it does not change the experiment.
- **Eigenvector selection:** the script retains the PDF's first-column selection from `eig`. The recorded PDF run places the stationary eigenvalue there; eigenvalue ordering should be checked if reproducing the script in another environment.
- **Presentation differences:** the repository follows the code PDF where the slides differ: Teak marks A, B, F, I, and J, and search ranking uses undamped `pi`. The slides instead list different Teak data and display damped search scores. None of the four queries uses Teak, and all four result orders agree across the documents.
- **Validation:** numerical results were cross-checked independently in Python/NumPy; the prepared script has not been executed in MATLAB in this environment.

## References

Sources credited in the team presentation:

- Dowman P Varn. *Final Project: Google's PageRank*, *Final Project Overview*, *Network #1*, and *WebPage Keywords #3 (Trees)*. MAT 167 021, UC Davis, Summer Session 2, 2026.
- Cleve Moler. *Numerical Computing with MATLAB*, Chapter 2.
- Naoki Saito. MAT 167, Lectures 24 and 25.
- Sergey Brin and Lawrence Page. *The Anatomy of a Large-Scale Hypertextual Web Search Engine*, 1998.
