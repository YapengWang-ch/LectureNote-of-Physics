# AGENTS.md

## Project overview

LaTeX lecture notes and homework for physics/math courses. Single branch (`main`), no CI/CD. Root-level `Makefile` compiles all projects and merges into `combined.pdf`.

## Directory map

```
Physics/<Subject>/main.tex   → 6 active lecture note projects (book class)
Physics/<Subject>/src/       → included chapters, appendices, preface, glossaries
hw/<Course>/hw<N>/hw<N>.tex  → standalone homework assignments (article class)
Math/                        → placeholder stub (MathematicalAnalysis/main.tex is empty)
publicsrc/newcommands.tex    → shared macros loaded by all Physics/*/main.tex
publicsrc/format.tex         → EMPTY, unused — ignore it
```

## Compilation

- **Compiler**: `xelatex` (required for Chinese via `xeCJK`/`ctex`). Do NOT use `pdflatex`.
- **Full build** from the project directory (e.g. `Physics/QuantumMechanics/`):

  ```bash
  xelatex main.tex
  bibtex main.aux
  makeglossaries main
  xelatex main.tex
  xelatex main.tex
  xelatex main.tex
  ```

- For a quick sanity check: `xelatex main.tex` only.
- Only `QuantumMechanics` and `StatisticalPhysics` have committed `compile.sh`. For other projects, copy the pattern above.
- Root `Makefile` provides `make`, `make clean`, `make distclean`. Default target builds all PDFs and merges into `combined/combined.pdf` via `pdfpages`.
- Homework files (`hw/*/*.tex`) are simpler — typically one pass: `xelatex hw1.tex`.

## Shared preamble system

- All 6 `Physics/*/main.tex` files share an **identical** preamble (same packages, same order), duplicated in each file. When adding a package, update ALL of them.
- `publicsrc/newcommands.tex` is the only shared file, loaded by every `main.tex` at line 44 via `\input{../../publicsrc/newcommands.tex}`. The `../../` path works because every `main.tex` is two levels deep (`Physics/<Subject>/`).
- Homework `.tex` files do **not** use shared files — they have self-contained preambles.

## Pre-existing `newcommands.tex` macros to know

- `\bra{...}`, `\ket{...}`, `\braket{...}` — Dirac notation
- `\com{A}{B}`, `\anticom{A}{B}` — commutator / anticommutator
- `\der`, `\d`, `\p`, `\pp` — derivative shorthands (ordinary and partial, 1st and 2nd)
- `\expect{...}` — expectation value
- `\graybox{...}` — tcolorbox for boxed content
- Redefines `\vec` → `\mathbf` (bold, not arrow)

## Style conventions

- Chinese + English bilingual content throughout.
- Chapter source files: `src/chapter<N>.tex`, `src/appendix<X>.tex`, `src/preface.tex`.
- Glossaries entries defined in `src/glossaries.tex`, printed via `\printglossaries` in main.
- PDFs are tracked in git (not in `.gitignore` — the `*.pdf` rule is commented out).
- TeX auxiliary files are comprehensively gitignored (`.aux`, `.log`, `.out`, `.toc`, `.synctex.gz`, glossaries output, etc.).
