JAVA = java
AC = /Applications/AppleCommander.app/Contents/Resources/Java/AppleCommander.jar
TEMPLATE = ../shared/template.po
VIRTUAL2 = /Applications/Virtual\ \]\[/Virtual\ \]\[.app/Contents/MacOS/Virtual\ \]\[

all:
	@echo "Please select a target."

ilen-test.bin: ilen-test.asm
	cl65 -o ilen-test.bin -t none --start-addr 0x2000 -l ilen-test.asm
	cp $(TEMPLATE) ilen-test.po
	$(JAVA) -jar $(AC) -p ilen-test.po ilen.test BIN 0x2000 < ilen-test.bin
	osascript ilen-test.scpt.txt "$(PWD)/ilen-test.po"

clean:
	rm -f *.bin *.lst *.o 
	find . -name "*.po" -not -name "template.po" -print0 | xargs -0 rm -f 
