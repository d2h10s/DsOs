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

***
## Build
### 1. Entry
Entry를 빌드하기 위해서는 다음 명령어가 필요합니다.
```make
$ arm-none-eabi-as -march=$(ARCHITECTURE) -mcpu=$(CPU) -o ./boot/Entry.o ./boot/Entry.S
$ arm-none-eabi-objcopy -O binary ./boot/Entry.o ./boot/Entry.bin
```

***
### 2. LD


> ELF 파일: ELF파일이란 리눅스 표준 실행 파일 형식입니다. QMEU가 펌웨어 파일을 읽어 부팅하려면 입력으로 지정한 펌웨어 바이너리 파일이 ELF 파일 형식이어야 합니다.

> LD 파일:  ELF 파일을 만드려면 링커가 필요합니다. 링커를 동작시키려면 링커 스크립트 파일(.ld)가 필요합니다. 링커 스크립트로 링커의 동작을 제어하여 원하는 형태의 ELF파일을 생성합니다.

링커 실행은 다음과 같습니다.

```bash
$ arm-none-eabi-ld -n -T ./dsos.ld -nostdlib -o dsos.axf boot/Entry.o
```

- -n 섹션 자동 정렬 해제합니다.
- -T 링커 스크립트를 지정합니다.
- -nostdlib 표준 라이브러리를 링킹하지 않도록 합니다.
### 3. QEMU로 실행하기

QEMU를 실행합니다.
```bash
$ qemu-system-arm -M realview-pb-a8 -kernel $(dsos) -S -gdb tcp::1234,ipv4
```
- -kernel ELF 파일 이름을 지정합니다.
- -M 머신을 지정합니다.
- -S QEMU가 동작하자마자 바로 일시정지 되도록 지정하는 옵션입니다.
- -gdb gdb와 연결하는 소켓 포트를 지정합니다.

### 4. gdb로 레지스터 확인하기

이 명령어를 통해 QEMU를 gdb로 디버깅하여 메모리 값을 확인할 수 있습니다.
```bash
$ arm-none-eabi-gdb
```

예시로 다음 명령을 통하여 0번 주소 메모리의 데이터를 16진수로 4바이트씩 출력하여 볼 수 있습니다.
```
(gdb) x/4x 0
```

target 명령어를 통하여 gdb와 QEMU 디버깅 소켓과 연결합니다. 
```bash
(gdb) target remote:1234
``` 
file 명령은 ELF 파일예 포함되어 있는 디버깅 심볼을 읽습니다. 이 명령을 사용하려면 컴파일 단계에서 -g 옵션을 통하여 디버깅 심볼을 실행 파일에 포함해야 합니다.
```bash
(gdb) file build/DsOs.axf
```


## aa 
ARM 코어에 전원이 들어가면 ARM 코어가 가장 먼저 하는 일은 reset vector에 있는 명령을 수행하는 것입니다.  
reset vector는 0x00000000입니다. 따라서 전원이 들어오면 0x00000000에서 32비트를 읽어 명령을 실행합니다.
