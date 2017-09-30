TEX = manual.tex header.tex about.tex bib.tex
TEX += platform/platform.tex platform/interpreter.tex platform/neo4j.tex
TEX += platform/knowledge.tex

LATEX = pdflatex -halt-on-error -output-directory ../tmp

manual.pdf: $(TEX)
	$(LATEX) $< && $(LATEX) $<
	
files:
	touch $(TEX)