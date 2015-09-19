ca65 main.asm -t none -l $* \
&& cl65 main.asm -o main.bin -t none --start-addr 0x2000 --listing \
&& cp template.po mydisk.po \
&& java -jar /Applications/AppleCommander.app/Contents/Resources/Java/AppleCommander.jar -p mydisk.po cd.online BIN 0x2000 < main.bin
