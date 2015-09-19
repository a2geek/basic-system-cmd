
all: online.bin

online.bin:
	cl65 online.asm -o online.bin -t none --start-addr 0x2000 --listing
	cp template.po online.po
	java -jar /Applications/AppleCommander.app/Contents/Resources/Java/AppleCommander.jar -p online.po online BIN 0x2000 < online.bin

clean:
	rm *.bin *.lst *.o online.po
