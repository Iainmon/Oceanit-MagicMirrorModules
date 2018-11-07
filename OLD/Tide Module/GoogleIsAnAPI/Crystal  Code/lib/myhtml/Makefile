CRYSTAL ?= crystal
CRYSTALFLAGS ?=

.PHONY: all package spec
all: bin_usage bin_walk_tree bin_links bin_texts bin_encoding bin_normalize bin_css_selectors1 bin_css_selectors2
package: src/ext/myhtml-c/lib/libmodest_static.a

bin_usage: src/*.cr src/**/*.cr examples/usage.cr package
	$(CRYSTAL) build examples/usage.cr $(CRYSTALFLAGS) -o $@

bin_css_selectors1: src/*.cr src/**/*.cr examples/css_selectors1.cr package
	$(CRYSTAL) build examples/css_selectors1.cr $(CRYSTALFLAGS) -o $@

bin_css_selectors2: src/*.cr src/**/*.cr examples/css_selectors2.cr package
	$(CRYSTAL) build examples/css_selectors2.cr $(CRYSTALFLAGS) -o $@

bin_walk_tree: src/*.cr src/**/*.cr examples/walk_tree.cr package
	$(CRYSTAL) build examples/walk_tree.cr $(CRYSTALFLAGS) -o $@

bin_links: src/*.cr src/**/*.cr examples/links.cr package
	$(CRYSTAL) build examples/links.cr $(CRYSTALFLAGS) -o $@

bin_texts: src/*.cr src/**/*.cr examples/texts.cr package
	$(CRYSTAL) build examples/texts.cr $(CRYSTALFLAGS) -o $@

bin_encoding: src/*.cr src/**/*.cr examples/encoding.cr package
	  $(CRYSTAL) build examples/encoding.cr $(CRYSTALFLAGS) -o $@

bin_normalize: src/*.cr src/**/*.cr examples/normalize.cr package
		$(CRYSTAL) build examples/normalize.cr $(CRYSTALFLAGS) -o $@

src/ext/myhtml-c/lib/libmodest_static.a:
	cd src/ext && make package

spec:
	crystal spec

.PHONY: clean
clean:
	rm -f bin_* src/ext/modest-c/lib/libmodest_static.a
	rm -rf ./src/ext/modest-c
