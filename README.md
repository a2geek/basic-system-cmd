# ProDOS BASIC.SYSTEM commands

This project is about re-learning everything I've forgotten or never learned:
* 65C02
* Code relocation
* Makefiles 
* Mac OS X
* Automated testing of application
* BASIC.SYSTEM command integration
* Requesting memory from BASIC.SYSTEM

The general target of these commands is 256 bytes.  
The loader/relocator stub is less important, but also trying to target 256 bytes.
This keeps the commands to 1 block and 1 page of used memory.

# Commands

## ONLINE

Displays all volumes online.  

    ]ONLINE
    S3,D2 /RAM
    S6,D1 ERR=$27
    ...

Accepts slot/drive parameters.

    ]ONLINE,S3,D2
    S3,D2 /RAM
