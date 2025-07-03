@echo off
setlocal enabledelayedexpansion
title File Organizer Pro v2.0
color 0A

:MAIN_MENU
cls
echo.
echo    _________________________________________________________________
echo.
echo                          File Organization Methods:
echo.
echo    [1] By Extension          - Organize specific file types
echo    [2] All Common Types      - Images / Documents / Videos / Audio
echo    [3] By Date Modified      - Sort by modification date
echo    [4] By File Size          - Small / Medium / Large / Huge
echo    [5] Mixed Organization    - Extension + Date combination
echo    _________________________________________________________________
echo.
echo    [6] Check Organization Status
echo    [7] View Operation History
echo    [8] Cleanup Tools
echo    _________________________________________________________________
echo.
echo    [9] Help
echo    [0] Exit
echo.
echo    _________________________________________________________________
echo.
set /p choice=Choose a menu option using your keyboard [0,1,2,3...9]: 

if "%choice%"=="1" goto ORGANIZE_BY_TYPE
if "%choice%"=="2" goto ORGANIZE_ALL
if "%choice%"=="3" goto ORGANIZE_BY_DATE
if "%choice%"=="4" goto ORGANIZE_BY_SIZE
if "%choice%"=="5" goto ORGANIZE_MIXED
if "%choice%"=="6" goto CHECK_STATUS
if "%choice%"=="7" goto VIEW_HISTORY
if "%choice%"=="8" goto CLEANUP_TOOLS
if "%choice%"=="9" goto HELP
if "%choice%"=="0" goto EXIT
goto INVALID_CHOICE

:ORGANIZE_BY_TYPE
cls
echo.
echo    _________________________________________________________________
echo.
echo                        ORGANIZE BY EXTENSION
echo    _________________________________________________________________
echo.

:: Get source path
set /p source_path=Enter source folder path (or press Enter for current directory): 
if "%source_path%"=="" set source_path=%CD%

:: Validate source path
if not exist "%source_path%" (
    echo.
    echo    ERROR: Source path does not exist!
    echo    Please check the path and try again.
    echo.
    pause
    goto MAIN_MENU
)

:: Get file extension
set /p file_ext=Enter file extension (without dot, e.g., jpg, pdf, txt): 
if "%file_ext%"=="" (
    echo.
    echo    ERROR: File extension cannot be empty!
    echo.
    pause
    goto MAIN_MENU
)

:: Get custom folder name
set /p custom_folder=Enter custom folder name (or press Enter for default): 
if "%custom_folder%"=="" set custom_folder=All_%file_ext%_Files

:: Create destination folder
set "destination=%source_path%\%custom_folder%"
if not exist "%destination%" mkdir "%destination%"

:: Count and move files
echo.
echo    Processing files...
echo    _________________________________________________________________
echo.
set file_count=0
for /r "%source_path%" %%f in (*.%file_ext%) do (
    if not "%%~dpf"=="%destination%\" (
        echo    Moving: %%~nxf
        move "%%f" "%destination%" >nul 2>&1
        if not errorlevel 1 set /a file_count+=1
    )
)

:: Ask about empty folders
echo.
echo    _________________________________________________________________
echo.
set /p remove_empty=Remove empty folders after organizing? (Y/N): 
if /i "%remove_empty%"=="Y" (
    echo.
    echo    Removing empty folders...
    call :REMOVE_EMPTY_FOLDERS "%source_path%"
)

:: Log operation
echo %date% %time% - Organized %file_count% %file_ext% files to %destination% >> file_organizer.log

echo.
echo    _________________________________________________________________
echo.
echo                        OPERATION COMPLETED
echo.
echo    Files organized: %file_count% %file_ext% files
echo    Destination: %destination%
echo    _________________________________________________________________
echo.
pause
goto MAIN_MENU

:ORGANIZE_ALL
cls
echo.
echo    _________________________________________________________________
echo.
echo                      ORGANIZE ALL COMMON TYPES
echo    _________________________________________________________________
echo.

:: Get source path
set /p source_path=Enter source folder path (or press Enter for current directory): 
if "%source_path%"=="" set source_path=%CD%

:: Validate source path
if not exist "%source_path%" (
    echo.
    echo    ERROR: Source path does not exist!
    echo.
    pause
    goto MAIN_MENU
)

echo.
echo    Processing all file types...
echo    _________________________________________________________________
echo.

:: Define file types and their categories
set "images=jpg jpeg png gif bmp tiff svg webp ico"
set "documents=pdf doc docx txt rtf odt xls xlsx ppt pptx"
set "videos=mp4 avi mkv mov wmv flv webm m4v"
set "audio=mp3 wav flac aac ogg m4a wma"
set "archives=zip rar 7z tar gz bz2"
set "executables=exe msi deb rpm dmg"

:: Organize each category
call :ORGANIZE_CATEGORY "%source_path%" "Images" "%images%"
call :ORGANIZE_CATEGORY "%source_path%" "Documents" "%documents%"
call :ORGANIZE_CATEGORY "%source_path%" "Videos" "%videos%"
call :ORGANIZE_CATEGORY "%source_path%" "Audio" "%audio%"
call :ORGANIZE_CATEGORY "%source_path%" "Archives" "%archives%"
call :ORGANIZE_CATEGORY "%source_path%" "Executables" "%executables%"

:: Ask about empty folders
echo.
echo    _________________________________________________________________
echo.
set /p remove_empty=Remove empty folders after organizing? (Y/N): 
if /i "%remove_empty%"=="Y" (
    echo.
    echo    Removing empty folders...
    call :REMOVE_EMPTY_FOLDERS "%source_path%"
)

echo.
echo    _________________________________________________________________
echo.
echo                    ALL TYPES ORGANIZED SUCCESSFULLY
echo    _________________________________________________________________
echo %date% %time% - Organized all common file types in %source_path% >> file_organizer.log
echo.
pause
goto MAIN_MENU

:ORGANIZE_CATEGORY
set "folder_path=%~1"
set "category=%~2"
set "extensions=%~3"
set "dest_folder=%folder_path%\%category%"
set category_count=0

if not exist "%dest_folder%" mkdir "%dest_folder%"

for %%e in (%extensions%) do (
    for /r "%folder_path%" %%f in (*.%%e) do (
        if not "%%~dpf"=="%dest_folder%\" (
            move "%%f" "%dest_folder%" >nul 2>&1
            if not errorlevel 1 set /a category_count+=1
        )
    )
)

if %category_count% gtr 0 (
    echo    [✓] %category%: %category_count% files organized
) else (
    echo    [-] %category%: No files found
)
goto :eof

:ORGANIZE_BY_DATE
cls
echo.
echo    _________________________________________________________________
echo.
echo                        ORGANIZE BY DATE
echo    _________________________________________________________________
echo.

:: Get source path
set /p source_path=Enter source folder path (or press Enter for current directory): 
if "%source_path%"=="" set source_path=%CD%

:: Validate source path
if not exist "%source_path%" (
    echo.
    echo    ERROR: Source path does not exist!
    echo.
    pause
    goto MAIN_MENU
)

echo.
echo    Organizing files by modification date...
echo    _________________________________________________________________
echo.

:: Create date-based folders and organize files
set total_files=0
for /r "%source_path%" %%f in (*.*) do (
    if not "%%~dpf"=="%source_path%\By_Date\" (
        for /f "tokens=1-3 delims=/" %%a in ("%%~tf") do (
            set "file_date=%%c-%%a-%%b"
            set "date_folder=%source_path%\By_Date\!file_date!"
            if not exist "!date_folder!" mkdir "!date_folder!"
            move "%%f" "!date_folder!" >nul 2>&1
            if not errorlevel 1 set /a total_files+=1
        )
    )
)

:: Ask about empty folders
echo.
set /p remove_empty=Remove empty folders after organizing? (Y/N): 
if /i "%remove_empty%"=="Y" (
    echo.
    echo    Removing empty folders...
    call :REMOVE_EMPTY_FOLDERS "%source_path%"
)

echo.
echo    _________________________________________________________________
echo.
echo                    ORGANIZATION BY DATE COMPLETED
echo.
echo    Files organized: %total_files% files
echo    _________________________________________________________________
echo %date% %time% - Organized %total_files% files by date in %source_path% >> file_organizer.log
echo.
pause
goto MAIN_MENU

:ORGANIZE_BY_SIZE
cls
echo.
echo    _________________________________________________________________
echo.
echo                        ORGANIZE BY SIZE
echo    _________________________________________________________________
echo.

:: Get source path
set /p source_path=Enter source folder path (or press Enter for current directory): 
if "%source_path%"=="" set source_path=%CD%

:: Validate source path
if not exist "%source_path%" (
    echo.
    echo    ERROR: Source path does not exist!
    echo.
    pause
    goto MAIN_MENU
)

echo.
echo    Organizing files by size...
echo    _________________________________________________________________
echo.

:: Create size-based folders
set "small_folder=%source_path%\By_Size\Small_Files_(0-1MB)"
set "medium_folder=%source_path%\By_Size\Medium_Files_(1-10MB)"
set "large_folder=%source_path%\By_Size\Large_Files_(10-100MB)"
set "huge_folder=%source_path%\By_Size\Huge_Files_(100MB+)"

if not exist "%small_folder%" mkdir "%small_folder%"
if not exist "%medium_folder%" mkdir "%medium_folder%"
if not exist "%large_folder%" mkdir "%large_folder%"
if not exist "%huge_folder%" mkdir "%huge_folder%"

:: Organize files by size
set small_count=0
set medium_count=0
set large_count=0
set huge_count=0

for /r "%source_path%" %%f in (*.*) do (
    if not "%%~dpf"=="%source_path%\By_Size\" (
        set "file_size=%%~zf"
        if !file_size! lss 1048576 (
            move "%%f" "%small_folder%" >nul 2>&1
            if not errorlevel 1 set /a small_count+=1
        ) else if !file_size! lss 10485760 (
            move "%%f" "%medium_folder%" >nul 2>&1
            if not errorlevel 1 set /a medium_count+=1
        ) else if !file_size! lss 104857600 (
            move "%%f" "%large_folder%" >nul 2>&1
            if not errorlevel 1 set /a large_count+=1
        ) else (
            move "%%f" "%huge_folder%" >nul 2>&1
            if not errorlevel 1 set /a huge_count+=1
        )
    )
)

:: Ask about empty folders
echo.
set /p remove_empty=Remove empty folders after organizing? (Y/N): 
if /i "%remove_empty%"=="Y" (
    echo.
    echo    Removing empty folders...
    call :REMOVE_EMPTY_FOLDERS "%source_path%"
)

echo.
echo    _________________________________________________________________
echo.
echo                    ORGANIZATION BY SIZE COMPLETED
echo.
echo    [✓] Small files (0-1MB): %small_count% files
echo    [✓] Medium files (1-10MB): %medium_count% files
echo    [✓] Large files (10-100MB): %large_count% files
echo    [✓] Huge files (100MB+): %huge_count% files
echo    _________________________________________________________________
echo %date% %time% - Organized files by size in %source_path% >> file_organizer.log
echo.
pause
goto MAIN_MENU

:ORGANIZE_MIXED
cls
echo.
echo    _________________________________________________________________
echo.
echo                      MIXED ORGANIZATION
echo    _________________________________________________________________
echo.

:: Get source path
set /p source_path=Enter source folder path (or press Enter for current directory): 
if "%source_path%"=="" set source_path=%CD%

:: Validate source path
if not exist "%source_path%" (
    echo.
    echo    ERROR: Source path does not exist!
    echo.
    pause
    goto MAIN_MENU
)

echo.
echo    Select organization combination:
echo    [1] Extension + Date
echo    [2] Extension + Size
echo    [3] Type + Date
echo.
set /p mix_choice=Choose combination (1-3): 

if "%mix_choice%"=="1" goto MIX_EXT_DATE
if "%mix_choice%"=="2" goto MIX_EXT_SIZE
if "%mix_choice%"=="3" goto MIX_TYPE_DATE
goto INVALID_CHOICE

:MIX_EXT_DATE
echo.
echo    This will organize files by extension, then by date within each extension.
echo    Feature coming soon in next update!
echo.
pause
goto MAIN_MENU

:MIX_EXT_SIZE
echo.
echo    This will organize files by extension, then by size within each extension.
echo    Feature coming soon in next update!
echo.
pause
goto MAIN_MENU

:MIX_TYPE_DATE
echo.
echo    This will organize files by type, then by date within each type.
echo    Feature coming soon in next update!
echo.
pause
goto MAIN_MENU

:CHECK_STATUS
cls
echo.
echo    _________________________________________________________________
echo.
echo                    ORGANIZATION STATUS CHECK
echo    _________________________________________________________________
echo.

:: Get source path
set /p source_path=Enter folder path to check (or press Enter for current directory): 
if "%source_path%"=="" set source_path=%CD%

:: Validate source path
if not exist "%source_path%" (
    echo.
    echo    ERROR: Source path does not exist!
    echo.
    pause
    goto MAIN_MENU
)

echo.
echo    Analyzing folder structure...
echo    _________________________________________________________________
echo.

:: Count files by type
set total_files=0
set image_files=0
set doc_files=0
set video_files=0
set audio_files=0
set archive_files=0
set other_files=0

for /r "%source_path%" %%f in (*.*) do (
    set /a total_files+=1
    set "ext=%%~xf"
    if /i "!ext!"==".jpg" set /a image_files+=1
    if /i "!ext!"==".jpeg" set /a image_files+=1
    if /i "!ext!"==".png" set /a image_files+=1
    if /i "!ext!"==".gif" set /a image_files+=1
    if /i "!ext!"==".pdf" set /a doc_files+=1
    if /i "!ext!"==".doc" set /a doc_files+=1
    if /i "!ext!"==".docx" set /a doc_files+=1
    if /i "!ext!"==".txt" set /a doc_files+=1
    if /i "!ext!"==".mp4" set /a video_files+=1
    if /i "!ext!"==".avi" set /a video_files+=1
    if /i "!ext!"==".mkv" set /a video_files+=1
    if /i "!ext!"==".mp3" set /a audio_files+=1
    if /i "!ext!"==".wav" set /a audio_files+=1
    if /i "!ext!"==".zip" set /a archive_files+=1
    if /i "!ext!"==".rar" set /a archive_files+=1
)

echo    Total files found: %total_files%
echo    _________________________________________________________________
echo.
echo    [✓] Image files: %image_files%
echo    [✓] Document files: %doc_files%
echo    [✓] Video files: %video_files%
echo    [✓] Audio files: %audio_files%
echo    [✓] Archive files: %archive_files%
echo    _________________________________________________________________
echo.
pause
goto MAIN_MENU

:CLEANUP_TOOLS
cls
echo.
echo    _________________________________________________________________
echo.
echo                          CLEANUP TOOLS
echo    _________________________________________________________________
echo.
echo    [1] Remove Empty Folders
echo    [2] Remove Duplicate Files
echo    [3] Remove Temporary Files
echo    [4] Back to Main Menu
echo.
set /p cleanup_choice=Choose cleanup option (1-4): 

if "%cleanup_choice%"=="1" goto MANUAL_CLEANUP_EMPTY
if "%cleanup_choice%"=="2" goto REMOVE_DUPLICATES
if "%cleanup_choice%"=="3" goto REMOVE_TEMP
if "%cleanup_choice%"=="4" goto MAIN_MENU
goto INVALID_CHOICE

:MANUAL_CLEANUP_EMPTY
cls
echo.
echo    _________________________________________________________________
echo.
echo                      REMOVE EMPTY FOLDERS
echo    _________________________________________________________________
echo.

:: Get source path
set /p source_path=Enter folder path to clean (or press Enter for current directory): 
if "%source_path%"=="" set source_path=%CD%

:: Validate source path
if not exist "%source_path%" (
    echo.
    echo    ERROR: Source path does not exist!
    echo.
    pause
    goto CLEANUP_TOOLS
)

echo.
echo    Removing empty folders...
echo    _________________________________________________________________
echo.

call :REMOVE_EMPTY_FOLDERS "%source_path%"

echo.
echo    _________________________________________________________________
echo.
echo                    EMPTY FOLDER CLEANUP COMPLETED
echo    _________________________________________________________________
echo.
pause
goto CLEANUP_TOOLS

:REMOVE_DUPLICATES
echo.
echo    _________________________________________________________________
echo.
echo                      REMOVE DUPLICATE FILES
echo    _________________________________________________________________
echo.
echo    Advanced duplicate removal feature coming soon!
echo    This will scan for identical files and remove duplicates.
echo.
pause
goto CLEANUP_TOOLS

:REMOVE_TEMP
echo.
echo    _________________________________________________________________
echo.
echo                      REMOVE TEMPORARY FILES
echo    _________________________________________________________________
echo.
echo    Temporary file cleanup feature coming soon!
echo    This will remove common temporary files (.tmp, .temp, etc.)
echo.
pause
goto CLEANUP_TOOLS

:REMOVE_EMPTY_FOLDERS
set "clean_path=%~1"
set empty_count=0

for /f "delims=" %%d in ('dir "%clean_path%" /ad /b /s 2^>nul ^| sort /r') do (
    rd "%%d" >nul 2>&1
    if not errorlevel 1 (
        echo    Removed: %%d
        set /a empty_count+=1
    )
)

if %empty_count% gtr 0 (
    echo    [✓] %empty_count% empty folders removed
) else (
    echo    [-] No empty folders found
)
goto :eof

:VIEW_HISTORY
cls
echo.
echo    _________________________________________________________________
echo.
echo                        OPERATION HISTORY
echo    _________________________________________________________________
echo.

if exist "file_organizer.log" (
    echo    Recent operations:
    echo.
    type file_organizer.log
    echo.
    echo    _________________________________________________________________
) else (
    echo    No operation history found.
    echo    Start organizing files to see history here.
    echo.
    echo    _________________________________________________________________
)
echo.
pause
goto MAIN_MENU

:HELP
cls
echo.
echo    _________________________________________________________________
echo.
echo                              HELP GUIDE
echo    _________________________________________________________________
echo.
echo    File Organizer Pro v2.0 - Professional File Management Tool
echo.
echo    ORGANIZATION METHODS:
echo    [1] By Extension     - Organize specific file types (jpg, pdf, etc.)
echo    [2] All Common Types - Auto-sort Images/Documents/Videos/Audio
echo    [3] By Date Modified - Sort files by modification date
echo    [4] By File Size     - Group files by size ranges
echo    [5] Mixed Methods    - Combine multiple organization strategies
echo.
echo    SUPPORTED FILE TYPES:
echo    • Images      : jpg, jpeg, png, gif, bmp, tiff, svg, webp, ico
echo    • Documents   : pdf, doc, docx, txt, rtf, odt, xls, xlsx, ppt, pptx
echo    • Videos      : mp4, avi, mkv, mov, wmv, flv, webm, m4v
echo    • Audio       : mp3, wav, flac, aac, ogg, m4a, wma
echo    • Archives    : zip, rar, 7z, tar, gz, bz2
echo    • Executables : exe, msi, deb, rpm, dmg
echo.
echo    USAGE TIPS:
echo    • Use full paths for best results (e.g., C:\Users\Name\Documents)
echo    • Press Enter to use current directory
echo    • Always backup important files before organizing
echo    • All operations are logged automatically
echo    • Choose to remove empty folders after organizing
echo    _________________________________________________________________
echo.
pause
goto MAIN_MENU

:INVALID_CHOICE
cls
echo.
echo    _________________________________________________________________
echo.
echo                            INVALID CHOICE
echo.
echo    Please select a valid option from the menu (0-9)
echo    _________________________________________________________________
echo.
timeout /t 2 >nul
goto MAIN_MENU

:EXIT
cls
echo.
echo    _________________________________________________________________
echo.
echo                    File Organizer Pro v2.0
echo.
echo                 Thank you for using our software!
echo.
echo                    Your files are now organized.
echo    _________________________________________________________________
echo.
timeout /t 3 >nul
exit /b 0