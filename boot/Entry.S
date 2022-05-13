.text                       // text 섹션 선언
    .code 32                // 명령어 크기가 32비트

    .global vector_start    // extern 같은 구문
    .global vector_end      // 외부 파일에서 심볼을 읽을 수 있게 함

    vector_start:           // 레이블 선언
        MOV     R0,     R1  // 레지스터 R0 값을 R1에 대입
    vector_end:             // 레이블 선언
        .space 1024,    0   // 여기서부터 1024바이트를 0으로 채워라
.end                        // text 섹션 종료

/*
0000000 0001 e1a0 0000 0000 0000 0000 0000 0000
0000010 0000 0000 0000 0000 0000 0000 0000 0000
*
0000404
*/
