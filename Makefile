ROOT = .
.SECONDARY:

docs += main

docsPdf = ${docs:%=output/%.pdf}
docsFontchk = ${docs:%=output/%.fontchk}
drawings = 
images = $(wildcard images/*.pdf) $(wildcard images/*.jpg) $(wildcard images/*.png)
depends = ${drawings} ${images}

all: ${docsPdf} ${docsFontchk} ${depends}

ltxopts = -file-line-error-style -output-directory=output
ltxmode =\\nonstopmode\\input

output/%.pdf: %.tex ${depends}
	@mkdir -p $(dir $@)
	pdflatex ${ltxopts} ${ltxmode} $< </dev/null || (rm -f $@; false)
	pdflatex ${ltxopts} ${ltxmode} $< </dev/null || (rm -f $@; false)

output/%.pdf: drawings/%.svg
	@mkdir -p $(dir $@)
	inkscape --export-pdf=$@.tmp $<
	mv -f $@.tmp $@

output/%.fontchk: output/%.pdf
	bin/pdfFontChk $<
	touch $@

output/%.pdf: drawings/%.svg
	@mkdir -p $(dir $@)
	inkscape --export-pdf=$@.tmp $<
	mv -f $@.tmp $@

clean:
	rm -rf output
