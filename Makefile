# directories to search for yang files
YANGS_DIR = r-phy-10
OUT_DIR = pyang_build

# extract unique entries from a list with dups
uniq = $(if $1,$(firstword $1) $(call uniq,$(filter-out $(firstword $1),$1)))

# find all yang files
YANGS = $(shell find $(YANGS_DIR) -type f -name "*.yang")
INC_PATHS = $(call uniq,$(dir $(YANGS)))

_space := $(subst ,, )
INC_PATHS_COLONS := $(subst $(_space),:,$(INC_PATHS))
TREES = $(YANGS:%.yang=%.tree)

#UMLS = $(addprefix $(OUT_DIR)/umls/,$(YANGS:.yang=.uml))
#UMLS = $(subst $(YANGS_DIR),$(OUT_DIR)/umls,$(YANGS:.yang=.uml))
#UML_FOOTER="-"
#UML_OPTS=--uml-no=import,module --uml-inline-grouping --uml-max-enums=25 --uml-truncate=leafref --uml-footer=$(UML_FOOTER)
#
#$(OUT_DIR)/umls/%.uml: $(YANGS)
#	mkdir -p $(@D)
#	pyang -p $(INC_PATHS_COLONS) -f uml $(UML_OPTS) $< -o $@

validate: $(YANGS)
	@echo "Validate all the YANG files."
	pyang -p $(INC_PATHS_COLONS) --lint --strict $^
	@echo "The tree is valid."
	@echo ""

#uml: % : validate $(UMLS)
#	@echo "Create UML diagrams."
#	mkdir -p $(OUT_DIR)/umls $(OUT_DIR)/diagrams
#	plantuml -o $(OUT_DIR)/diagrams/ -r $(OUT_DIR)/umls

tree: validate $(YANGS)
	@echo "Build the tree."
	mkdir -p $(OUT_DIR)
	pyang -p $(INC_PATHS_COLONS) -f tree $(YANGS) -o $(OUT_DIR)/main-rcp-tlv-module.tree.txt

clean:
	@echo "Clean output files."
	-rm $(OUT_DIR)


# makefile debug
debug:
	@echo yangs=$(YANGS)
	@echo ''
	@echo trees=$(TREES)
	@echo ''
	@echo umls=$(UMLS)
	@echo ''
	@echo inc_paths=$(INC_PATHS)
	@echo ''
	@echo inc_paths_colons=$(INC_PATHS_COLONS)
	@echo ''

