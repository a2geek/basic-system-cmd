JAVA = java
AC = /Applications/AppleCommander.app/Contents/Resources/Java/AppleCommander.jar
TEMPLATE = ../shared/template.po
VIRTUAL2 = /Applications/Virtual\ \]\[/Virtual\ \]\[.app/Contents/MacOS/Virtual\ \]\[

all: online.bin

online.bin: online.asm
	cl65 -o online.bin -t none --start-addr 0x2000 -l online.asm
	cp $(TEMPLATE) online.po
	$(JAVA) -jar $(AC) -p online.po online BIN 0x2000 < online.bin

test:
	#$(VIRTUAL2) ./online.po 
	osascript test.scpt "$(PWD)/online.po"

clean:
	rm *.bin *.lst *.o online.po
