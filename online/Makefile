JAVA = java
AC = /Applications/AppleCommander.app/Contents/Resources/Java/AppleCommander.jar
TEMPLATE = ../shared/template.po
VIRTUAL2 = /Applications/Virtual\ \]\[/Virtual\ \]\[.app/Contents/MacOS/Virtual\ \]\[

all: online.bin

online:	online.bin
ilen:	ilen.bin

online.bin: online.asm
	cl65 -o online.bin -t none --start-addr 0x2000 -l online.asm
	cp $(TEMPLATE) online.po
	$(JAVA) -jar $(AC) -p online.po online BIN 0x2000 < online.bin

ilen.bin: ilen.asm
	cl65 --asm-define TESTILEN -o ilen-test.bin -t none --start-addr 0x2000 -l ilen.asm
	cp $(TEMPLATE) ilen-test.po
	$(JAVA) -jar $(AC) -p ilen-test.po ilen.test BIN 0x2000 < ilen-test.bin
	osascript ilen-test.scpt.txt "$(PWD)/ilen-test.po"

test:
	osascript test.scpt "$(PWD)/online.po"

run:
	$(VIRTUAL2) ./online.po 

clean:
	rm *.bin *.lst *.o online.po
