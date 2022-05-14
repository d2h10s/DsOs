# DsOs


File|Description|
:-:|-
Entry.S|reset vector가 수행할 명령을 기록합니다.

## Dependency

Label|Description|
:-:|:-:
Build Os|Ubuntu20.04
Compiler|gcc-arm-none-eabi
Emulator|qemu-system-arm
Machine|realview-pb-a8
Architecture|armv7-a
CPU|cortex-a8


## Build
### 1. Entry
Entry를 빌드하기 위해서는 다음 명령어가 필요합니다.
```make
arm-none-eabi-as -march=$(ARCHITECTURE) -mcpu=$(CPU) -o ./boot/Entry.o ./boot/Entry.S
arm-none-eabi-objcopy -O binary ./boot/Entry.o ./boot/Entry.bin
```
### 2. LD

```
> ELF 파일: ELF파일이란 리눅스 표준 실행 파일 형식입니다. QMEU가 펌웨어 파일을 읽어 부팅하려면 입력으로 지정한 펌웨어 바이너리 파일이 ELF 파일 형식이어야 합니다.

> LD 파일:  ELF 파일을 만드려면 링커가 필요합니다. 링커를 동작시키려면 링커 스크립트 파일(.ld)가 필요합니다. 링커 스크립트로 링커의 동작을 제어하여 원하는 형태의 ELF파일을 생성합니다.

링커를 실행은 다음과 같습니다.

```bash
arm-none-eabi-ld -n -T ./dsos.ld -nostdlib -o dsos.axf boot/Entry.o
```
- -n 섹션 자동 정렬 해제합니다.
- -T 링커 스크립트를 지정합니다.
- -nostdlib 표준 라이브러리를 링킹하지 않도록 합니다.
### 3. QEMU로 실행하기


## aa 
ARM 코어에 전원이 들어가면 ARM 코어가 가장 먼저 하는 일은 reset vector에 있는 명령을 수행하는 것입니다.  
reset vector는 0x00000000입니다. 따라서 전원이 들어오면 0x00000000에서 32비트를 읽어 명령을 실행합니다.
