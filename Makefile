SITUATION = ./situation.sh
VIM = vim
# Default directories
DIR_FONTS = ./Fonts
DIR_BG = ./Bg
DIR_RENDERS = ./Renders
# Quote files and vim format script 
FILE_QUOTES_ORIG = ./quotes.orig
FILE_QUOTES = ./quotes
FILE_VIM_FORMAT = ./format.vim
# Main default colors
COLOR_GREEN = rgb(43,254,210)
COLOR_BLACK = black
# Main default backgrounds
FILE_BG_B = $(DIR_BG)/black.png
FILE_BG_G = $(DIR_BG)/green.png


ifndef FONTQ
#FONTQ = $(DIR_FONTS)/Encode_sans/EncodeSansCondensed-Black.ttf
	FONTQ = $(DIR_FONTS)/Avenir_next_condensed/AvenirNextCondensed-Heavy.ttf
endif
ifndef FONTA
	FONTA = $(DIR_FONTS)/Avenir/Avenir-BookOblique.ttf
endif
ifndef FONTCOL
#FONTCOL = $(COLOR_BLACK)
	FONTCOL = $(COLOR_GREEN)
endif
ifndef BG
#BG = $(FILE_BG_G)
	BG = $(FILE_BG_B)
endif
ifndef TEST_OUT
	TEST_OUT = /tmp/test.png
endif

help:
	@echo "TARGETS"
	@echo "    quotes         - Format quote list '$(FILE_QUOTES)' from '$(FILE_QUOTES_ORIG)'"
	@echo "    quote-pic      - Make quote image using '$(SITUATION)'"
	@echo "    batch-render   - Update quote images directory '$(DIR_RENDERS)'"
	@echo "    test-quote-pic - Test rendering of quote image"
	@echo
	@echo "PARAMETERS"
	@echo "    Q='{quote}'"
	@echo "    A='{author}'"
	@echo "    OUT='/path/to/outfile'"
	@echo "    BG='/path/to/bgfile' (defaults to '$(BG)')"
	@echo "    FONTQ='{name|path}'  (defaults to '$(FONTQ)')"
	@echo "    FONTA='{name|path}'  (defaults to '$(FONTA)')"
	@echo "    FONTCOL='{color}'    (defaults to '$(FONTCOL)')"
	@echo
	@echo "EXAMPLES"
	@echo "    $(MAKE) OUT=/tmp/lol A='Karlos Marakas' Q='lmfao bitch' \\"
	@echo "        FONTQ=/my/great/communist/font.ttf"

clean-bg:
	rm -vi "$(FILE_BG_B)" "$(FILE_BG_G)"

deps:
	@which sed       >/dev/null
	@which twurl     >/dev/null
	@which convert   >/dev/null
	@which montage   >/dev/null
	@which composite >/dev/null
	@echo "The dependency check was successful!"

bg-green: clean-bg
	convert xc:$(COLOR_GREEN) -geometry 2000x1500! "$(FILE_BG_G)"

bg-black: clean-bg
	convert xc:$(COLOR_BLACK) -geometry 2000x1500! "$(FILE_BG_B)"

quote-pic: $(SITUATION)
ifndef Q
	$(error Please set 'Q' for quote text (see 'make help'))
endif
ifndef A
	$(error Please set 'A' for quote author (see 'make help'))
endif
ifndef OUT
	$(error Please set 'OUT' for output file (see 'make help'))
endif
	$(SITUATION) -q "$(Q)" -a "$(A)" -o "$(OUT)" -fontq "$(FONTQ)" -fonta "$(FONTA)" -fontcol "$(FONTCOL)" -b "$(BG)"
	@[[ -z "$(SHOW)" ]] || xdg-open "$(OUT)"

test-quote-pic:
	$(SITUATION) -f -q "Le principe de la production marchande, c’est la perte de soi dans la création chaotique et inconsciente d’un monde qui échappe totalement à ses créateurs. Le noyau radicalement révolutionnaire de l’autogestion généralisée, c’est, au contraire, la direction consciente par tous de l’ensemble de la vie. [...] La tâche des Conseils Ouvriers ne sera donc pas l’autogestion du monde existant, mais sa transformation qualitative ininterrompue : le dépassement concret de la marchandise (en tant que gigantesque détour de la production de l’homme par lui-même)." -a "Internationale Situationniste, De la Misère en Milieu Étudiant (1966)" -o "$(TEST_OUT)" -fontq "$(FONTQ)" -fonta "$(FONTA)" -fontcol "$(FONTCOL)" -b "$(BG)"
	xdg-open "$(TEST_OUT)"

quotes: $(FILE_QUOTES_ORIG) $(FILE_VIM_FORMAT)
	cp -vf "$(FILE_QUOTES_ORIG)" "$(FILE_QUOTES)"
	$(VIM) -c ":e $(FILE_QUOTES) | :source $(FILE_VIM_FORMAT) | :w"
	@echo "'$(FILE_QUOTES)' now ready for processing!"

batch-render: $(DIR_RENDERS) $(SITUATION) $(FILE_QUOTES)
	$(error "Not yet implemented (hard to do actually)")
	#@echo "Assuming all previous quotes have been rendered in order."
	# cat $(FILE_QUOTES) | awk -F '---' '{print " -q \"$1\" -a \"$2\" -o ???"}' | xargs -L1 -p $(SITUATION)

