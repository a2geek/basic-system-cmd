# ProDOS BASIC.SYSTEM commands

## Purpose

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
This keeps the commands to 1 block on disk and 1 page of used memory.

## Commands

| Command | Description |
| --- | --- |
| [`ONLINE`](./online/) | Display volumes online. |

