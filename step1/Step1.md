# Step1：整数を吐くコンパイラを作成する

## C言語のコードをアセンブリ出力する
以下のコードをアセンブリコードに変換する。
```intenger.c
#include <stdio.h>

int main() { 
    return 42;
}
```
アセンブリに変換するコードは以下のようになる。
```
$ cc -S -o - -mllvm -x86-asm-syntax=intel intenger.c
```
http://msumimz.hatenablog.com/entry/2014/02/19/214605   
で書かれている通り、デフォルトはintel形式のアセンブリコードを吐かないので、intelに指定する必要がある。
出力された、アセンブリが下のようになる。
```intenger.s
        .section        __TEXT,__text,regular,pure_instructions
        .build_version macos, 10, 15    sdk_version 10, 15, 4
        .intel_syntax noprefix
        .globl  _main                   ## -- Begin function main
        not .globl main
        .p2align        4, 0x90
_main:                                  ## @main
        .cfi_startproc
## %bb.0:
        push    rbp
        .cfi_def_cfa_offset 16
        .cfi_offset rbp, -16
        mov     rbp, rsp
        .cfi_def_cfa_register rbp
        mov     dword ptr [rbp - 4], 0
        mov     eax, 42
        pop     rbp
        ret
        .cfi_endproc
                                        ## -- End function
```


このコードを実行可能形式にするには、以下のように記述する。
```
$ cc -o intenger intenger.s
```
コンパイルに成功して、実行してみる
```
$ ./intenger
```
ただし、このままだと何も出力されない。ただし、returnの値をbashは保持している。これを参照するためには`$?`でアクセスできる。
```
$ echo $?
```

## アセンブリを最小にする
上のアセンブリコードは余分な行を含んでいるので、これをわかりやすくするために最小のコードにする。
また、参照している本では、`main`と書かれている部分が、`_main`に変えないと私の環境ではダメだということがわかった。

元にした、本のアセンブリコード
```sample1.s
.intel_syntax noprefix
.globl main
main:
    mov rax, 42
    ret
```
以下、私の環境で出力されたアセンブリを削ってできた最小のアセンブリ
```minmum_sample1.s
.intel_syntax noprefix
.globl _main
_main:
    mov rax, 42
    ret
```


## コンパイラの作成
```step1-compiler.c
#include <stdio.h>

int main(int argc, char **argv) { 
    if (argc != 2) { 
        fprintf(stderr, "引数の個数が正しくありません\n");
        return 1;
    }

    printf(".intel_syntax noprefix\n");
    printf(".globl _main\n");
    printf("_main:\n");
    printf("    mov rax, %d\n", atoi(argv[1]));
    printf("    ret\n");
    return 0;
}
```
