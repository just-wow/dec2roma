set bin=C:\TASM\BIN
set src=C:\SRC

%bin%\TASM.EXE /zi %src%\dec2roma.asm || exit /b
%bin%\TLINK.EXE /v %src%\dec2roma.obj || exit /b
rem %bin%\TD.EXE %src%\dec2roma.exe

