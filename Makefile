DUNE=dune

.PHONY: all test install uninstall clean example retest

build:
	$(DUNE) build

test: build
	echo "\ntest wikitext :" ; _build/default/wktxt_cmdline.exe < test/test.wikitext; echo "\ntest bold OR italic :\n" ; _build/default/wktxt_cmdline.exe < test/test.boldital | head -n 100; echo "\ntest bold AND italic :\n" ; _build/default/wktxt_cmdline.exe < test/test.bothboldital ;

runtest:
	$(DUNE) build @runtest

wikitext.install:
	$(DUNE) build @install

install: wikitext.install
	$(DUNE) install wikitext

uninstall: wikitext.install
	$(DUNE) uninstall wikitext

js:
	$(DUNE) build test/wikitext_js.bc.js
	cp _build/default/test/wikitext_js.bc.js test/wikitext.js

clean:
	dune clean

retest: clean test
