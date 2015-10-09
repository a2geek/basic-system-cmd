JAVA = java
AC = /Applications/AppleCommander.app/Contents/Resources/Java/AppleCommander.jar
TEMPLATE = ../shared/template.po
VIRTUAL2 = /Applications/Virtual\ \]\[/Virtual\ \]\[.app/Contents/MacOS/Virtual\ \]\[

all: online.bin

online:	online.bin

online.bin: online.asm
	cl65 -l online.lst -v -vm -C ../shared/bi-install.config online.asm -o online.bin
	cp $(TEMPLATE) online.po
	$(JAVA) -jar $(AC) -p online.po online BIN 0x2000 < online.bin

test:
	osascript test.scpt.txt "$(PWD)/online.po"

run:
	$(VIRTUAL2) ./online.po 

clean:
	rm -f *.bin *.lst *.o online.po
