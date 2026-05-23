XELATEX = xelatex -interaction=nonstopmode

PHYSICS_DIRS = ClassicalMechanics HighEnergyPhysics Optics QuantumMechanics StatisticalPhysics ThermalDymamics

PHYSICS_PDFS = $(addsuffix /main.pdf, $(addprefix Physics/, $(PHYSICS_DIRS)))

.PHONY: all rebuild clean distclean

all: combined/combined.pdf

rebuild:
	rm -f combined/combined.pdf $(PHYSICS_PDFS)
	$(MAKE) all

combined/combined.pdf: combined/combined.tex $(PHYSICS_PDFS)
	cd combined && $(XELATEX) combined.tex

# Full build pipeline for lecture notes
Physics/%/main.pdf: Physics/%/main.tex
	cd $(@D) && \
	$(XELATEX) $(<F) && \
	-bibtex main 2>/dev/null; \
	-makeglossaries main 2>/dev/null; \
	$(XELATEX) $(<F) && \
	$(XELATEX) $(<F) && \
	$(XELATEX) $(<F)


clean:
	rm -f combined/combined.pdf combined/combined.aux combined/combined.log combined/combined.out
	find Physics -type f \( \
		-name '*.aux' -o -name '*.log' -o -name '*.out' -o \
		-name '*.toc' -o -name '*.glo' -o -name '*.gls' -o \
		-name '*.glg' -o -name '*.bbl' -o -name '*.blg' -o \
		-name '*.synctex.gz' -o -name '*.acn' -o -name '*.acr' -o \
		-name '*.alg' -o -name '*.idx' -o -name '*.ilg' -o \
		-name '*.ind' -o -name '*.ist' -o -name '*.lof' -o \
		-name '*.lot' -o -name '*.fls' -o -name '*.fdb_latexmk' \
	\) -delete

distclean: clean
	find Physics -name '*.pdf' ! -path '*/fig/*' -delete
