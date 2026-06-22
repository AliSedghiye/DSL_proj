# Financial Vulnerability in Italy: Who Is Left Behind in Financial Literacy?

An individual-level analysis of the **Bank of Italy IACOFI 2023** survey, examining which demographic, socioeconomic, and behavioural factors predict financial vulnerability among Italian adults — and which groups are most at risk.

> **Data Science Lab — University of Milano-Bicocca — A.Y. 2025/26**
> Course held by Prof. Silvio Gerli
> Authors: **Amin Entezari** · **Ali Sedghiye**

---

## Research Question

> *Which demographic, socioeconomic and behavioural factors predict financial vulnerability among Italian adults, and which population groups are most at risk?*

The study is framed as a **problem-identification** task: the goal is to locate and characterise the worst-off groups and understand what drives their disadvantage, rather than to maximise a predictive metric.

---

## Key Findings

| # | Finding | Evidence |
|---|---------|----------|
| 1 | **Work status drives the largest gap** | Unemployed score 9.04 vs self-employed 12.29 (out of 21) |
| 2 | **Youth paradox** — 18–29 score *lowest* of all ages | 10.25, below even the 70–79 group |
| 3 | **Steep income gradient** | Low income 11.39 → high income 13.01 |
| 4 | **Double disadvantage** | Low education + low income = 11.05; university + high income = 13.45 |
| 5 | **Behaviour beats demographics** | Adding behavioural features lifts model accuracy 55% → 70% |
| 6 | **Hidden vulnerable cluster** | 261 elderly, low-income, offline individuals — lowest literacy (11.02) |

All group differences are statistically significant (*p* < 0.001).

**Central message:** financial vulnerability is driven more by what people *do* — and the buffers they hold — than by who they *are*. The single strongest predictor is a **financial-resilience index**, ahead of every demographic variable.

---

## Dataset

- **Source:** [Bank of Italy — IACOFI 2023](https://www.bancaditalia.it/statistiche/tematiche/indagini-famiglie-imprese/alfabetizzazione/)
- **Sample:** 4,862 Italian adults aged 18–79, collected via CATI (Feb–Mar 2023)
- **Variables:** 219 columns covering knowledge, behaviour, attitudes, digital financial skills, and demographics
- **Enrichment:** ISTAT 2023 macro-regional indicators (unemployment rate, household internet penetration)

> **Note:** the raw survey data are not redistributed in this repository. Download `Database_ENG.csv` directly from the Bank of Italy and place it in `data/raw/`.

---

## Methodology

The analysis follows a five-stage, problem-first logic:

1. **Construct & validate the target** — OECD/INFE composite literacy score (0–21) = Knowledge (0–7) + Behaviour (0–9) + Attitudes (0–5)
2. **Locate the gaps** — exploratory analysis + hypothesis testing (t-tests, ANOVA)
3. **Quantify predictors** — supervised classification (Logistic Regression, Random Forest)
4. **Enrich with behaviour** — feature engineering + Gradient Boosting
5. **Discover hidden profiles** — K-Means clustering

---

## Repository Structure

```
.
├── data/
│   ├── raw/                  # place Database_ENG.csv here (not tracked)
│   └── processed/            # cleaned & scored outputs + figures
├── notebooks/
│   ├── 01_data_loading.ipynb         # load, recode missing, ISTAT merge
│   ├── 02_score_construction.ipynb   # OECD score, validity, weights check
│   ├── 03_eda.ipynb                  # exploratory analysis + significance tests
│   ├── 04_model.ipynb                # Logistic Reg, Random Forest, K-Means
│   ├── 05_feature_engineering.ipynb  # behavioural features, Gradient Boosting
│   └── better_model.ipynb            # improved model: 19 features, tuned GB, ensembles
├── report/
│   └── dslab_report.pdf      # final report
├── requirements.txt
├── docker-compose.yml
├── Dockerfile
├── .dockerignore
└── README.md
```

---

## Reproducing the Analysis

### Option A — Docker (recommended)

**Prerequisites:** Docker and Docker Compose installed.

```bash
git clone https://github.com/AliSedghiye/DSL_proj.git
cd DSL_proj

# 1. Place the raw survey file in data/raw/ before starting
#    Download Database_ENG.csv from the Bank of Italy (see Dataset section)
cp /path/to/Database_ENG.csv data/raw/

# 2. Build the image and start the container
docker-compose up --build
```

Once running, open **http://localhost:8890** in your browser — no token or password is required.

Run the notebooks in order: `01 → 02 → 03 → 04 → 05 → better_model`

Each notebook writes its outputs to `data/processed/`. Any edits you make on the host are reflected instantly inside the container (live volume mount).

To stop the container:

```bash
docker-compose down
```

To run in the background (detached mode):

```bash
docker-compose up --build -d
# then stop with:
docker-compose down
```

> **Security note:** token authentication is disabled by default for local development.
> To protect a remote deployment set `JUPYTER_TOKEN` in `docker-compose.yml`:
> ```yaml
> environment:
>   - JUPYTER_TOKEN=your_secret_token
> ```

### Option B — Local Python

```bash
git clone https://github.com/AliSedghiye/DSL_proj.git
cd DSL_proj
python -m venv venv && source venv/bin/activate   # Windows: venv\Scripts\activate
pip install -r requirements.txt
jupyter lab
```

Run the notebooks sequentially; each stage writes its outputs to `data/processed/`.

---

## Results Summary

**Composite score (national):** mean 11.70 / 21 (weighted 11.52)

| Model | Notebook | Features | CV accuracy |
|-------|----------|----------|-------------|
| Logistic Regression | `04_model` | 8 demographic | 58.2% |
| Random Forest | `04_model` | 8 demographic | 54.9% |
| Random Forest | `05_feature_engineering` | 13 (+ behavioural) | 69.6% |
| Gradient Boosting | `05_feature_engineering` | 13 (+ behavioural) | 70.1% |
| Tuned Gradient Boosting | `better_model` | 19 (+ digital skills, worry, products, regional) | see notebook |
| Voting / Stacking Ensemble | `better_model` | 19 | see notebook |

**Top engineered feature correlations with literacy:** resilience index 0.44 · product breadth 0.37 · budgeting 0.32

---

## Tools

`Python` · `pandas` · `numpy` · `scikit-learn` · `scipy` · `matplotlib` · `seaborn` · `Docker` · `Jupyter`

---

## Limitations

- **Cross-sectional data** — associations only, no causal inference
- **Income non-response (31%)** — likely non-random, may bias income analyses
- **Self-reported behaviour** — possible social-desirability bias
- **Coarse geography** — only 5 macro-regions for the ISTAT enrichment

---

## References

1. Lamboglia, S., Marinucci, M., Stacchini, M., & Vassallo, P. (2024). *Surveys on Financial Literacy and Digital Financial Skills in Italy: Adults — IACOFI 2023.* Bank of Italy.
2. OECD (2022). *OECD/INFE Toolkit for Measuring Financial Literacy and Financial Inclusion 2022.*
3. OECD (2023). *OECD/INFE 2023 International Survey of Adult Financial Literacy.*
4. Lusardi, A., & Mitchell, O. S. (2014). The Economic Importance of Financial Literacy: Theory and Evidence. *Journal of Economic Literature*, 52(1), 5–44.
5. ISTAT (2024). *Employment and unemployment by macro-region, 2023.*

---

## AI Tools Declaration

AI-based assistants were used as a *support* instrument: to help debug and structure the Python code, organise the report, and refine English prose. All analytical decisions, the research question, interpretation, and conclusions were defined and verified by the authors. Every reported number was checked directly against the data.

---

*University of Milano-Bicocca · Data Science Lab 2025/26*
