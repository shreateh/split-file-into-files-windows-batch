@echo off
setlocal EnableDelayedExpansion


REM Set copyright text with newline
set "Copyright=Batch Script for splitting file into files"
echo.
echo !Copyright!
echo.
echo Copyright (c) [https://khalil-shreateh.com/links]

pause
echo.
echo.

REM Prompt user for number of lines to start splitting
set /p "split_count=Enter the number of lines to start splitting: "

set "input_file="
set "output_prefix=output"
set /a file_count=1
set /a line_count=0

REM Find the first file in the current directory to use as input
for %%f in (*) do (
    if not "%%~xf"==".bat" (
        set "input_file=%%f"
        goto :FoundInputFile
    )
)
:FoundInputFile

if not defined input_file (
    echo No suitable input file found.
    exit /b
)

for /f "delims=" %%i in ('type "%input_file%" ^| findstr /n "^"') do (
    set "line=%%i"
    REM Extract line number and line content
    for /f "delims=:" %%j in ("!line!") do (
        set "line_number=%%j"
        set "line_content=!line:*:=!"
    )
    REM Check if the line is empty
    if "!line_content!"=="" (
        REM Append empty line to the output file
        echo.>> "%output_prefix%!file_count!.txt"
    ) else (
        REM Increment line count for non-empty lines
        set /a line_count+=1
        echo !line_content!>> "%output_prefix%!file_count!.txt"
        REM Check if the line count reaches the split count
        if !line_count! equ %split_count% (
            REM Reset line count and increment file count
            set /a file_count+=1
            set /a line_count=0
        )
    )
)

echo Files split successfully.
pause
