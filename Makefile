ROOT = .
.SECONDARY:

doc = main
docFinal = output/gencode-ucsc-2018.pdf

docPdf = ${doc:%=output/%.pdf}
docFontchk = ${doc:%=output/%.fontchk}
drawings = 
images = $(wildcard images/*.pdf) $(wildcard images/*.jpg) $(wildcard images/*.png)
depends = ${drawings} ${images}

all: ${docFinal} ${docPdf} ${docFontchk} ${depends}

ltxopts = -file-line-error-style -output-directory=output
ltxmode =\\nonstopmode\\input

# create a more desiable name and keep preview from seeing partial PDF
${docFinal}: output/${doc}.pdf ${docFontchk}
	cp -f $< $@.tmp
	mv -f $@.tmp $@

output/%.pdf: %.tex ${depends}
	@mkdir -p $(dir $@)
	pdflatex ${ltxopts} ${ltxmode} $< </dev/null || (rm -f $@; false)
	pdflatex ${ltxopts} ${ltxmode} $< </dev/null || (rm -f $@; false)

output/%.pdf: drawings/%.svg
	@mkdir -p $(dir $@)
	inkscape --export-pdf=$@.tmp $<
	mv -f $@.tmp $@

output/%.fontchk: output/%.pdf
	bash bin/pdfFontChk $<
	touch $@

output/%.pdf: drawings/%.svg
	@mkdir -p $(dir $@)
	inkscape --export-pdf=$@.tmp $<
	mv -f $@.tmp $@

clean:
	rm -rf output
