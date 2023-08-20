ENTRY(vector_start)         /* 시작 위치의 심볼을 vector_start로 지정 */
SECTIONS                    /* 3~20번 라인까지 블록이 섹션 배치 설정 정보를 가지고 있음 */
{
    . = 0x00;               /* 첫 번째 섹션이 메모리 주소 0x00에 위치함을 알림 */


    .text :                 /* text섹션의 배치 순서를 정함, 추가 정보를 통해 메모리 주소까지 지정 가능 */
    {
        *(vector_start)     /* 0x00에 리셋 벡터가 위치해야 하므로 vector_start 심볼을 먼저 호출 */
        *(.text .rodata)
    }
    .data :                 /* .text섹션에 이어서 연속된 메모리에 배치하도록 설정 */
    {
        *(.data)
    }
    .bss :
    {
        *(.bss)
    }
}
