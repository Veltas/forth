( Copyright 2023 Christopher Leonard - MIT Licence )
( Library for loading Forth blocks encoded into files )
: ?LINE ( n)        16 = ABORT" Too many lines in block" ;
: LINE ( n-a)       6 LSHIFT  SCR @ BLOCK  + ;
: ?LEN ( n)         64 > ABORT" Block line too long" ;
: READ ( n)         DUP ?LINE  LINE  SOURCE  DUP ?LEN
                    ROT SWAP MOVE ;
: NEXT!             REFILL 0= ABORT" Missing ===" ;
: -END? ( -?)       SOURCE S" ===" COMPARE 0<> ;
: WIPE              SCR @ BUFFER  1024 BLANK  UPDATE ;
( e: execution token to check if current line shouldn't stop
  the parsing. )
: >BLOCK ( e)       WIPE  0 BEGIN  NEXT!
                    OVER EXECUTE  -END?  AND WHILE
                    DUP READ  1+  REPEAT 2DROP
                    REFILL DROP ;
: ALT               SCR @ SHADOW < IF  SHADOW SCR +!
                    ELSE  SHADOW NEGATE SCR +!  THEN ;
: -DOC? ( -?)       SOURCE S" ===DOC===" COMPARE 0<>  DUP 0= IF
                    ALT  ['] TRUE >BLOCK  ALT  THEN ;
( Parse until line containing exactly ===DOC=== or ===, reading
  content into given block number. Load contents from ===DOC===
  to === into shadow block. Leave block number on stack. )
: ===BLOCK=== ( n)  SCR !  ['] -DOC? >BLOCK ;
: ===NEXT===        SCR @  1+  ===BLOCK=== ;
