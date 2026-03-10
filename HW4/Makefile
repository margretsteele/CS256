
TESTDIR=testingFiles

TESTFILES=$(wildcard $(TESTDIR)/*.mfpl)
OUTFILES=$(TESTFILES:.mfpl=.result)

.PHONY: all parser clean test cleantest

all: parser

lex.yy.c: steelereese.l
	flex steelereese.l

mfpl.tab.c: lex.yy.c steelereese.y
	bison steelereese.y

parser: steelereese.tab.c
	g++ -g steelereese.tab.c -o steelem_parser

clean: cleantest
	-rm steelereese.tab.c
	-rm lex.yy.c
	-rm steelem_parser

test: cleantest steelem_parser $(OUTFILES)

%.result : %.mfpl %.out
	-./steelem_parser < $< > $@
	diff -b $(word 2, $^) $@

cleantest:
	-rm $(TESTDIR)/*.result

