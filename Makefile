
all: online.bin

online.bin: online.asm
	cl65 -o online.bin -t none --start-addr 0x2000 -l online.asm
	cp template.po online.po
	java -jar /Applications/AppleCommander.app/Contents/Resources/Java/AppleCommander.jar -p online.po online BIN 0x2000 < online.bin

test:
	/Applications/Virtual\ \]\[/Virtual\ \]\[.app/Contents/MacOS/Virtual\ \]\[ ./online.po 

clean:
	rm *.bin *.lst *.o online.po
