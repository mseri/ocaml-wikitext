
.PHONY: all test doc install uninstall clean example re retest

build:
	dune build wktxt_cmdline.exe

test: build
	_build/default/wktxt_cmdline.exe < test.wikitext | head -n 100

clean:
	dune clean

re: clean build

retest: clean test
