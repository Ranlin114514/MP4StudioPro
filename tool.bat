@echo off
setlocal enabledelayedexpansion

REM ================ 初始化设置 ================
for /F "tokens=1" %%a in ('echo prompt $E ^| cmd') do set "ESC=%%a"
set "LIGHT_BLUE=%ESC%[36m"     REM 浅蓝色
set "RED=%ESC%[31m"           REM 红色
set "LIGHT_GREEN=%ESC%[92m"    REM 浅绿色
set "LIGHT_YELLOW=%ESC%[93m"   REM 浅黄色
set "DARK_GREEN=%ESC%[32m"     REM 深绿色
set "WHITE=%ESC%[37m"          REM 白色
set "RESET=%ESC%[0m"           REM 重置颜色

set "CONFIG_FILE=%~dp0ffmpeg_config.txt"
set "LOG_FILE=%~dp0ffmpeg_conversion.log"
set "FFMPEG_PATH=ffmpeg.exe"
set "CUSTOM_OPTIONS="
set "HAS_GPU=0"
set "MULTI_PROGRESS=0"  REM 多文件进度条开关(默认关闭)
set "OPEN_FOLDER=1"      REM 转换完成后自动打开文件夹(默认开启)
set "BATCH_RENAME=0"     REM 批量重命名开关(默认关闭)
set "FILE_PREVIEW=0"     REM 文件预览开关(默认关闭)
set "SMART_ENCODING=1"   REM 智能编码开关(默认开启)

REM ================ 加载配置 ================
if exist "%CONFIG_FILE%" (
    for /f "usebackq delims=" %%I in ("%CONFIG_FILE%") do (
        set "LINE=%%I"
        if "!LINE:~0,1!"=="@" (
            set "CUSTOM_OPTIONS=!LINE:~1!"
        ) else (
            set "FFMPEG_PATH=%%I"
        )
    )
)

REM ================ 检测GPU加速 ================
if exist "!FFMPEG_PATH!" (
    "!FFMPEG_PATH!" -hwaccels | find "cuda" >nul && set "HAS_GPU=1"
    "!FFMPEG_PATH!" -hwaccels | find "dxva2" >nul && set "HAS_GPU=1"
    "!FFMPEG_PATH!" -hwaccels | find "qsv" >nul && set "HAS_GPU=1"
)

REM ================ 主菜单 ================
:MAIN_MENU
cls
echo %LIGHT_YELLOW%==================== 主菜单 ====================%RESET%
echo %LIGHT_YELLOW%1. 开始转换%RESET%
echo %LIGHT_YELLOW%2. FFmpeg地址设置%RESET%
echo %LIGHT_YELLOW%3. 测试FFmpeg%RESET%
echo %LIGHT_YELLOW%4. 自定义FFmpeg选项%RESET%
echo %LIGHT_YELLOW%5. 日志记录设置%RESET%
echo %LIGHT_YELLOW%6. 关于%RESET%
echo %LIGHT_YELLOW%7. 更新日志%RESET%
echo %LIGHT_YELLOW%8. 实验室%RESET%
echo %LIGHT_YELLOW%9. 退出%RESET%
echo %LIGHT_YELLOW%===========================================%RESET%
set /p "CHOICE=请选择操作 [1-9]: "
if "%CHOICE%"=="9" exit /b
if "%CHOICE%"=="8" goto LAB_SETTINGS
if "%CHOICE%"=="7" goto CHANGELOG
if "%CHOICE%"=="6" goto ABOUT
if "%CHOICE%"=="5" goto LOG_SETTINGS
if "%CHOICE%"=="4" goto CUSTOM_OPTIONS
if "%CHOICE%"=="3" goto TEST_FFMPEG
if "%CHOICE%"=="2" goto SET_FFMPEG
if "%CHOICE%"=="1" goto SELECT_FILES
goto MAIN_MENU

REM ================ 实验室设置 ================
:LAB_SETTINGS
cls
echo %LIGHT_YELLOW%=========== 实验室设置 ===========%RESET%
echo %LIGHT_YELLOW%1. 多文件进度条显示: !MULTI_PROGRESS! (1=开启, 0=关闭)%RESET%
echo %LIGHT_YELLOW%2. 转换后自动打开文件夹: !OPEN_FOLDER! (1=开启, 0=关闭)%RESET%
echo %LIGHT_YELLOW%3. 批量重命名模式: !BATCH_RENAME! (1=开启, 0=关闭)%RESET%
echo %LIGHT_YELLOW%4. 文件预览功能: !FILE_PREVIEW! (1=开启, 0=关闭)%RESET%
echo %LIGHT_YELLOW%5. 智能编码功能: !SMART_ENCODING! (1=开启, 0=关闭)%RESET%
echo %LIGHT_YELLOW%6. 返回主菜单%RESET%
set /p "LAB_CHOICE=请选择 [1-6]: "

if "!LAB_CHOICE!"=="6" goto MAIN_MENU
if "!LAB_CHOICE!"=="5" goto TOGGLE_SMART_ENCODING
if "!LAB_CHOICE!"=="4" goto TOGGLE_FILE_PREVIEW
if "!LAB_CHOICE!"=="3" goto TOGGLE_BATCH_RENAME
if "!LAB_CHOICE!"=="2" goto TOGGLE_OPEN_FOLDER
if "!LAB_CHOICE!"=="1" goto TOGGLE_MULTI_PROGRESS
goto LAB_SETTINGS

:TOGGLE_MULTI_PROGRESS
if "!MULTI_PROGRESS!"=="1" (
    set "MULTI_PROGRESS=0"
    echo %LIGHT_GREEN%[succeed]%WHITE% 已关闭多文件进度条显示%RESET%
) else (
    set "MULTI_PROGRESS=1"
    echo %LIGHT_GREEN%[succeed]%WHITE% 已开启多文件进度条显示%RESET%
)
timeout /t 2 >nul
goto LAB_SETTINGS

:TOGGLE_OPEN_FOLDER
if "!OPEN_FOLDER!"=="1" (
    set "OPEN_FOLDER=0"
    echo %LIGHT_GREEN%[succeed]%WHITE% 已关闭自动打开文件夹功能%RESET%
) else (
    set "OPEN_FOLDER=1"
    echo %LIGHT_GREEN%[succeed]%WHITE% 已开启自动打开文件夹功能%RESET%
)
timeout /t 2 >nul
goto LAB_SETTINGS

:TOGGLE_BATCH_RENAME
if "!BATCH_RENAME!"=="1" (
    set "BATCH_RENAME=0"
    echo %LIGHT_GREEN%[succeed]%WHITE% 已关闭批量重命名模式%RESET%
) else (
    set "BATCH_RENAME=1"
    echo %LIGHT_GREEN%[succeed]%WHITE% 已开启批量重命名模式%RESET%
)
timeout /t 2 >nul
goto LAB_SETTINGS

:TOGGLE_FILE_PREVIEW
if "!FILE_PREVIEW!"=="1" (
    set "FILE_PREVIEW=0"
    echo %LIGHT_GREEN%[succeed]%WHITE% 已关闭文件预览功能%RESET%
) else (
    set "FILE_PREVIEW=1"
    echo %LIGHT_GREEN%[succeed]%WHITE% 已开启文件预览功能%RESET%
)
timeout /t 2 >nul
goto LAB_SETTINGS

:TOGGLE_SMART_ENCODING
if "!SMART_ENCODING!"=="1" (
    set "SMART_ENCODING=0"
    echo %LIGHT_GREEN%[succeed]%WHITE% 已关闭智能编码功能%RESET%
) else (
    set "SMART_ENCODING=1"
    echo %LIGHT_GREEN%[succeed]%WHITE% 已开启智能编码功能%RESET%
)
timeout /t 2 >nul
goto LAB_SETTINGS

REM ================ 自定义选项 ================
:CUSTOM_OPTIONS
cls
echo %LIGHT_YELLOW%=========== 自定义FFmpeg选项 ===========%RESET%
echo %LIGHT_YELLOW%当前自定义选项: %CUSTOM_OPTIONS%%RESET%
echo %LIGHT_YELLOW%1. 设置自定义选项%RESET%
echo %LIGHT_YELLOW%2. 清除自定义选项%RESET%
echo %LIGHT_YELLOW%3. 返回主菜单%RESET%
set /p "OPTION_CHOICE=请选择 [1-3]: "

if "!OPTION_CHOICE!"=="3" goto MAIN_MENU
if "!OPTION_CHOICE!"=="2" goto CLEAR_OPTIONS
if "!OPTION_CHOICE!"=="1" goto SET_OPTIONS
goto CUSTOM_OPTIONS

:SET_OPTIONS
set /p "NEW_OPTIONS=输入自定义FFmpeg选项(如:-b:v 1M -preset fast): "
set "CUSTOM_OPTIONS=!NEW_OPTIONS!"
(
    echo !FFMPEG_PATH!
    if not "!CUSTOM_OPTIONS!"=="" echo @!CUSTOM_OPTIONS!
) > "%CONFIG_FILE%"
echo %LIGHT_GREEN%[succeed]%WHITE% 自定义选项已设置!%RESET%
timeout /t 2 >nul
goto CUSTOM_OPTIONS

:CLEAR_OPTIONS
set "CUSTOM_OPTIONS="
echo !FFMPEG_PATH! > "%CONFIG_FILE%"
echo %LIGHT_GREEN%[succeed]%WHITE% 自定义选项已清除!%RESET%
timeout /t 2 >nul
goto CUSTOM_OPTIONS

REM ================ 更新日志 ================
:CHANGELOG
cls
echo %DARK_GREEN%=============== 更新日志 ================%RESET%
echo %WHITE%V1.0
echo 由于格式工厂安装时一不小心就容易安装金山毒霸，且转换速率并不快（部分情景可以免编码，格式工厂并未进行优化），而且也不过是调研了开源项目FFempeg。
echo 何不如我自己编写一个类似于快捷指令的批处理来代替输入繁琐的代码，MP4StudioPro的第一个版本变诞生了，同样是调用FFempeg，而且不单单是能转换而是追
echo 求快且质量不差，所以我在批处理中添加了是否编码的选项，当然以一个学生的实力肯定不足以完成开发，固然AI的功劳必不可少，于2023年发布第一个版本，但由
echo 于存在诸多问题，和预想的方案相差甚远，所有果断放弃。解释一下该项目来自于Github，所有前面的是原作者写的。
echo.
echo V1.2
echo 别问我为什么要跳过V1.1，问就是因为懒，在修改完问题后不记得第一个版本叫什么来着，索性直接命名V1.2，结果翻到日志才想起来，压缩包都打好了，没必要再
echo 解压改个版本号了。
echo 本次版本：
echo 1.修复了部分情况下可能遇到的FFempeg报错（非文件问题）
echo 2.尝试添加了多文件批量处理功能（power by DeepSeek）
echo 3.优化了进度条与真实文件转换的时效同步，改动了原有的进度条显示修改，可能给用户带来直观感受（批处理限制实在太多了，所有进度条是假的）
echo 4.优化了用户交互
echo 5.修复了已知问题
echo 6.添加了一些可能对后续开发有用的代码（power by DeepSeek）
echo.
echo V1.3.0
echo 出现在选择完转换格式并且二次确认后出现闪退，固然没有上传
echo 本次版本：
echo 1.将所有的【info】改为蓝色，【info】后的汉字改为黄色
echo 2.添加新的提示词（引入成功提示【succeed】）
echo.
echo V1.3.1Beta
echo 这是一个全新的版本，添加了许多新功能：
echo 1.添加自动记录日志功能
echo 2.添加测试FFempeg功能（你可以在主菜单的选项2中进行测试）
echo 3.修复了已知问题
echo 4.优化了交互逻辑
echo 5.优化进度条显示（添加进度%%后图形旋转样式【未完成】）
echo.
echo V1.3.1（正式版）
echo 这是一个全新的版本，在Beta版的基础上优化了许多功能：
echo 1.修复了自动记录日志功能可能存在的问题
echo 2.修复了FFempeg测试的成功显示机制
echo 3.修复了已知问题
echo 4.优化了交互逻辑
echo 5.尝试完成在Bate版中进度条未完成的功能
echo.
echo V2.0Beta
echo 这是一个大版本更新，尽可能的修复了大部分问题，为用户带来了一些新版本特性
echo 1.修复了:CHANGELOG部分，确保每一行文本都使用echo命令输出
echo 2.修复并转译了所有特殊字符（为防止乱码）
echo 3.保持了原有的颜色格式和边框设计
echo 4.添加了自定义FFempeg指定，带来了更多的延伸性和拓展性
echo 5.添加了更多支持转换的格式
echo 6.优化了交互逻辑
echo 7.优化了色彩显示
echo.
echo V2.0（正式版）
echo 在Beta版的基础上进一步优化：
echo 1.修复了所有已知问题
echo 2.完善了自定义FFmpeg选项功能
echo 3.增强了格式转换的稳定性
echo 4.改进了日志记录系统
echo 5.优化了用户体验
echo.
echo V2.1Beta
echo 本版本稳中求进，不仅保留了V2.0中优秀的文件处理能力，而且带来了大文件（大于1GB）转换的稳定性和显示效果的优化
echo 1.修复了已知问题
echo 2.完善了部分情况下显示文件转换成功但实际认在转换的情况
echo 3.优化了进度条显示，增强了进度条的时效性
echo 4.优化了日志的相关记录错误
echo 5.优化了交互逻辑
echo 6.增加了文件大小显示，和预计处理时间的提示
echo.
echo V2.1
echo 这应该是目前最全能的版本
echo 1.修复了已知问题
echo 2.完善了在beta版中处理3GB以上的大文件出现的进度条卡死现象
echo 3.添加了进度条算法
echo 4.添加了时间算法
echo 5.优化了交互逻辑
echo 6.优化了文件大小显示和预计处理时间的提示（目前正在开发中可能时间存在虚高的问题）
echo.
echo V2.2
echo 最终稳定版，主要改进：
echo 1. 完全修复所有闪退问题
echo 2. 优化大文件处理性能
echo 3. 改进进度条准确性
echo 4. 增强错误处理机制
echo.
echo V2.3Beta
echo 新增功能：
echo 1. 添加多文件独立进度条显示功能
echo 2. 增加高级设置菜单
echo 3. 优化多任务处理体验
echo 4. 改进时间估算算法
echo.
echo V2.3
echo 本次更新主要修复了Beta版中存在的乱码问题（在默认情况下关闭实验室），同样也带来了一些3个新功能：
echo 1.修复了"运算符不存在"的问题（主要是在变量比较和计算时缺少引号或空格导致）
echo 2.新增文件预览功能（在转换前可以预览文件信息）
echo 3.新增批量重命名功能
echo 4.新增转换完成后自动打开输出文件夹选项
echo 5.增强了错误处理机制
echo %DARK_GREEN%====================================%RESET%
pause
goto MAIN_MENU

REM ================ 关于信息 ================
:ABOUT
cls
echo %DARK_GREEN%=============== 关于本工具 ================%RESET%
echo %LIGHT_YELLOW%MP4StudioPro 视频转换工具%RESET%
echo %LIGHT_YELLOW%版本: 2.3%RESET%
echo %LIGHT_YELLOW%开发者: Ritual Collapse%RESET%
echo.
echo %LIGHT_YELLOW%基于FFmpeg开源项目构建%RESET%
echo %DARK_GREEN%========================================%RESET%
pause
goto MAIN_MENU

REM ================ 日志设置 ================
:LOG_SETTINGS
cls
echo %LIGHT_YELLOW%=========== 日志记录设置 ===========%RESET%
echo %LIGHT_YELLOW%当前日志文件: %LOG_FILE%%RESET%
echo %LIGHT_YELLOW%1. 查看日志%RESET%
echo %LIGHT_YELLOW%2. 清除日志%RESET%
echo %LIGHT_YELLOW%3. 更改日志路径%RESET%
echo %LIGHT_YELLOW%4. 返回主菜单%RESET%
set /p "LOG_CHOICE=请选择 [1-4]: "

if "!LOG_CHOICE!"=="4" goto MAIN_MENU
if "!LOG_CHOICE!"=="3" goto CHANGE_LOG_PATH
if "!LOG_CHOICE!"=="2" goto CLEAR_LOG
if "!LOG_CHOICE!"=="1" goto VIEW_LOG
goto LOG_SETTINGS

:VIEW_LOG
if not exist "%LOG_FILE%" (
    echo %RED%[error]%RED% 日志文件不存在!%RESET%
) else (
    notepad "%LOG_FILE%"
)
timeout /t 2 >nul
goto LOG_SETTINGS

:CLEAR_LOG
if exist "%LOG_FILE%" (
    del "%LOG_FILE%" >nul 2>&1
    echo %LIGHT_GREEN%[succeed]%WHITE% 日志已清除!%RESET%
) else (
    echo %RED%[error]%RED% 日志文件不存在!%RESET%
)
timeout /t 2 >nul
goto LOG_SETTINGS

:CHANGE_LOG_PATH
set /p "NEW_LOG_PATH=输入新的日志文件完整路径: "
set "NEW_LOG_PATH=!NEW_LOG_PATH:"=!"
if not "!NEW_LOG_PATH!"=="" (
    set "LOG_FILE=!NEW_LOG_PATH!"
    echo %LIGHT_GREEN%[succeed]%WHITE% 日志路径已更新!%RESET%
) else (
    echo %RED%[error]%RED% 路径无效!%RESET%
)
timeout /t 2 >nul
goto LOG_SETTINGS

REM ================ FFmpeg测试 ================
:TEST_FFMPEG
cls
echo %LIGHT_YELLOW%=========== FFmpeg测试 ===========%RESET%
if not exist "!FFMPEG_PATH!" (
    echo %RED%[error]%RED% FFmpeg路径无效: "!FFMPEG_PATH!"%RESET%
    timeout /t 3 >nul
    goto SET_FFMPEG
)

echo %LIGHT_YELLOW%正在测试FFmpeg...%RESET%
echo.
echo %LIGHT_BLUE%[info]%WHITE% FFmpeg版本信息:%RESET%
"!FFMPEG_PATH!" -version
echo.
echo %LIGHT_BLUE%[info]%WHITE% 当前自定义选项: %CUSTOM_OPTIONS%%RESET%
if "!HAS_GPU!"=="1" (
    echo %LIGHT_BLUE%[info]%WHITE% 检测到GPU加速支持%RESET%
) else (
    echo %LIGHT_BLUE%[info]%WHITE% 未检测到GPU加速支持%RESET%
)
echo %LIGHT_GREEN%[succeed]%WHITE% FFmpeg测试成功!%RESET%
pause
goto MAIN_MENU

REM ================ FFmpeg路径设置 ================
:SET_FFMPEG
cls
echo %LIGHT_YELLOW%=========== FFmpeg路径设置 ===========%RESET%
echo %LIGHT_YELLOW%当前路径: %FFMPEG_PATH%%RESET%
echo %LIGHT_YELLOW%1. 自动检测%RESET%
echo %LIGHT_YELLOW%2. 手动输入%RESET%
echo %LIGHT_YELLOW%3. 返回主菜单%RESET%
set /p "FF_CHOICE=请选择 [1-3]: "

if "!FF_CHOICE!"=="3" goto MAIN_MENU
if "!FF_CHOICE!"=="2" goto MANUAL_PATH
if "!FF_CHOICE!"=="1" goto AUTO_DETECT
goto SET_FFMPEG

:AUTO_DETECT
where ffmpeg >nul 2>&1
if !errorlevel! equ 0 (
    where ffmpeg > "%CONFIG_FILE%"
    set "FFMPEG_PATH=ffmpeg"
    echo %LIGHT_GREEN%[succeed]%WHITE% FFmpeg路径已自动设置!%RESET%
) else (
    echo %RED%[error]%RED% 未找到FFmpeg!%RESET%
)
timeout /t 2 >nul
goto SET_FFMPEG

:MANUAL_PATH
set /p "NEW_PATH=输入FFmpeg完整路径: "
set "NEW_PATH=!NEW_PATH:"=!"
if exist "!NEW_PATH!" (
    echo !NEW_PATH! > "%CONFIG_FILE%"
    set "FFMPEG_PATH=!NEW_PATH!"
    echo %LIGHT_GREEN%[succeed]%WHITE% FFmpeg路径已更新!%RESET%
) else (
    echo %RED%[error]%RED% 路径无效!%RESET%
)
timeout /t 2 >nul
goto SET_FFMPEG

REM ================ 文件选择 ================
:SELECT_FILES
cls
echo %LIGHT_YELLOW%请将输入文件拖放到此窗口(支持多个文件)%RESET%
echo %LIGHT_BLUE%[info]%WHITE% 可以一次拖放多个文件，系统会自动处理%RESET%
set "FILE_LIST="
set /p "FILE_LIST=输入文件: "
if "!FILE_LIST!"=="" (
    echo %RED%[error]%RED% 未选择文件!%RESET%
    timeout /t 2 >nul
    goto SELECT_FILES
)

set "TEMP_FILE=%temp%\ffmpeg_files.tmp"
echo !FILE_LIST! > "!TEMP_FILE!"
set "FILE_LIST="
set COUNT=0

for /f "usebackq tokens=*" %%F in ("!TEMP_FILE!") do (
    for %%G in (%%F) do (
        set /a COUNT+=1
        set "FILE_!COUNT!=%%~G"
        set "FILE_LIST=!FILE_LIST! "%%~G""
    )
)
del "!TEMP_FILE!" >nul 2>&1

REM ================ 增强版文件预览 ================
if "!FILE_PREVIEW!"=="1" (
    call :PREVIEW_FILES
)

if "!BATCH_RENAME!"=="1" goto BATCH_RENAME_SETUP

REM ================ 输出目录选择 ================
:SELECT_OUTPUT
cls
echo %LIGHT_YELLOW%请将输出文件夹拖放到此窗口%RESET%
set "OUTPUT_DIR="
set /p "OUTPUT_DIR=输出文件夹: "
if "!OUTPUT_DIR!"=="" (
    echo %RED%[error]%RED% 未选择输出文件夹!%RESET%
    timeout /t 2 >nul
    goto SELECT_OUTPUT
)

set "OUTPUT_DIR=!OUTPUT_DIR:"=!"
if not exist "!OUTPUT_DIR!\" (
    mkdir "!OUTPUT_DIR!\" >nul 2>&1
    if errorlevel 1 (
        echo %RED%[error]%RED% 无法创建输出目录: !OUTPUT_DIR!%RESET%
        timeout /t 2 >nul
        goto SELECT_OUTPUT
    )
)
goto CONVERT_MENU

REM ================ 文件预览函数 ================
:PREVIEW_FILES
cls
echo %LIGHT_YELLOW%=========== 文件预览 (共!COUNT!个文件) ===========%RESET%
for /l %%N in (1,1,!COUNT!) do (
    set "INFILE=!FILE_%%N!"
    for %%F in ("!INFILE!") do (
        echo %LIGHT_YELLOW%文件%%N: %%~nxF%RESET%
        echo %LIGHT_BLUE%[info]%WHITE% 路径: %%~dpF%RESET%
        
        REM 文件大小显示为MB
        set /a "SIZE_MB=%%~zF/1048576"
        echo %LIGHT_BLUE%[info]%WHITE% 大小: !SIZE_MB! MB%RESET%
        
        REM 获取并格式化文件时长
        if exist "!FFMPEG_PATH!" (
            for /f "tokens=2 delims=," %%D in ('""!FFMPEG_PATH!" -i "!INFILE!" 2^>^&1 ^| find "Duration""') do (
                set "DURATION=%%D"
                set "DURATION=!DURATION:~1!"
                for /f "tokens=1-4 delims=:." %%a in ("!DURATION!") do (
                    set "HOURS=%%a"
                    set "MINUTES=%%b"
                    set "SECONDS=%%c"
                    set "MILLISECONDS=%%d"
                )
                echo %LIGHT_BLUE%[info]%WHITE% 时长: !HOURS!:!MINUTES!:!SECONDS!%RESET%
            )
        )
        echo.
    )
)
echo %LIGHT_YELLOW%============================================%RESET%
pause
goto :eof

REM ================ 批量重命名设置 ================
:BATCH_RENAME_SETUP
cls
echo %LIGHT_YELLOW%=========== 批量重命名设置 ===========%RESET%
echo %LIGHT_YELLOW%当前文件数量: !COUNT!%RESET%
echo %LIGHT_YELLOW%请输入命名模板(使用#作为数字占位符，如: 视频_###)%RESET%
set /p "NAME_TEMPLATE=命名模板: "
if "!NAME_TEMPLATE!"=="" (
    echo %RED%[error]%RED% 命名模板不能为空!%RESET%
    timeout /t 2 >nul
    goto BATCH_RENAME_SETUP
)

set "OUTPUT_DIR=%~dp0Batch_Renamed_Files"
if not exist "!OUTPUT_DIR!\" (
    mkdir "!OUTPUT_DIR!\" >nul 2>&1
    if errorlevel 1 (
        echo %RED%[error]%RED% 无法创建输出目录: !OUTPUT_DIR!%RESET%
        timeout /t 2 >nul
        goto BATCH_RENAME_SETUP
    )
)

echo %LIGHT_GREEN%[succeed]%WHITE% 输出目录已设置为: !OUTPUT_DIR!%RESET%
timeout /t 2 >nul

REM ================ 格式选择 ================
:CONVERT_MENU
cls
echo %LIGHT_YELLOW%================ 格式选择 ================%RESET%
echo %LIGHT_YELLOW%1. MP3 (音频)%RESET%
echo %LIGHT_YELLOW%2. WAV (音频)%RESET%
echo %LIGHT_YELLOW%3. FLAC (音频)%RESET%
echo %LIGHT_YELLOW%4. AVI (视频)%RESET%
echo %LIGHT_YELLOW%5. MOV (视频)%RESET%
echo %LIGHT_YELLOW%6. MP4 (视频)%RESET%
echo %LIGHT_YELLOW%7. MKV (视频)%RESET%
echo %LIGHT_YELLOW%8. WEBM (视频)%RESET%
echo %LIGHT_YELLOW%9. 返回主菜单%RESET%
set /p "FORMAT=选择输出格式 [1-9]: "
if "!FORMAT!"=="9" goto MAIN_MENU
if "!FORMAT!" gtr "9" goto CONVERT_MENU

REM 检查第一个文件的扩展名
set "FIRST_FILE=!FILE_1!"
for %%F in ("!FIRST_FILE!") do set "EXTENSION=%%~xF"
set "EXTENSION=!EXTENSION:~1!"

REM 设置格式兼容性检查
set "FORMATS[1]=mp3"
set "FORMATS[2]=wav"
set "FORMATS[3]=flac"
set "FORMATS[4]=avi"
set "FORMATS[5]=mov"
set "FORMATS[6]=mp4"
set "FORMATS[7]=mkv"
set "FORMATS[8]=webm"

for /f "tokens=1,2 delims==" %%A in ('set FORMATS[ 2^>nul') do (
    if "%%A"=="FORMATS[!FORMAT!]" set "EXT=%%B"
)

if not defined EXT (
    echo %RED%[error]%RED% 无效的格式选择%RESET%
    timeout /t 2 >nul
    goto CONVERT_MENU
)

REM 检查格式兼容性
set "NEED_CONVERT=1"
if /i "!EXTENSION!"=="!EXT!" (
    echo %LIGHT_BLUE%[info]%WHITE% 输入输出格式相同，将直接复制文件%RESET%
    set "NEED_CONVERT=0"
    goto SKIP_RECODE
)

REM 智能编码功能
if "!SMART_ENCODING!"=="1" (
    REM 特殊格式检查 - 自动决定是否需要重新编码
    if "!EXTENSION!"=="mp3" (
        if "!EXT!"=="wav" set "NEED_CONVERT=1"
        if "!EXT!"=="flac" set "NEED_CONVERT=1"
    ) else if "!EXTENSION!"=="wav" (
        if "!EXT!"=="mp3" set "NEED_CONVERT=1"
        if "!EXT!"=="flac" set "NEED_CONVERT=0"
    ) else if "!EXTENSION!"=="flac" (
        if "!EXT!"=="mp3" set "NEED_CONVERT=1"
        if "!EXT!"=="wav" set "NEED_CONVERT=0"
    ) else if "!EXTENSION!"=="mp4" (
        if "!EXT!"=="mkv" set "NEED_CONVERT=0"
        if "!EXT!"=="avi" set "NEED_CONVERT=1"
    )
    
    REM 自动设置音频选项
    if "!NEED_CONVERT!"=="0" (
        set "AUDIO_OPT=-c:a copy"
    ) else (
        REM 根据目标格式自动选择最佳编码
        if "!EXT!"=="mp3" set "AUDIO_OPT=-c:a libmp3lame -q:a 2"
        if "!EXT!"=="wav" set "AUDIO_OPT=-c:a pcm_s16le"
        if "!EXT!"=="flac" set "AUDIO_OPT=-c:a flac -compression_level 8"
    )
    goto SHOW_SETTINGS
)

:SKIP_RECODE
if "!NEED_CONVERT!"=="0" (
    set "AUDIO_OPT=-c:a copy"
    goto SHOW_SETTINGS
)

REM ================ 询问是否重新编码 ================
:ASK_RECODE
set "RECODE="
set /p "RECODE=是否重新编码音频? [y/N]: "
if /i "!RECODE!"=="" set "RECODE=n"
if /i "!RECODE!"=="y" (
    set "AUDIO_OPT=-c:a libmp3lame -q:a 2"
) else if /i "!RECODE!"=="n" (
    set "AUDIO_OPT=-c:a copy"
) else (
    echo %RED%[error]%RED% 请输入 y 或 n%RESET%
    timeout /t 1 >nul
    goto ASK_RECODE
)

:SHOW_SETTINGS
REM ================ 显示设置 ================
cls
echo %DARK_GREEN%=============== 当前设置 ================%RESET%
echo %LIGHT_YELLOW%输入文件数量: !COUNT!%RESET%
echo %LIGHT_YELLOW%输出目录:   !OUTPUT_DIR!%RESET%
echo %LIGHT_YELLOW%输出格式:   !EXT!%RESET%
echo %LIGHT_YELLOW%音频编码:   !AUDIO_OPT!%RESET%
echo %LIGHT_YELLOW%自定义选项: %CUSTOM_OPTIONS%%RESET%
echo %LIGHT_YELLOW%FFmpeg路径: !FFMPEG_PATH!%RESET%

set "TOTAL_SIZE=0"
for /l %%N in (1,1,!COUNT!) do (
    for %%F in ("!FILE_%%N!") do (
        set /a "TOTAL_SIZE+=%%~zF"
    )
)
set /a "TOTAL_SIZE_MB=TOTAL_SIZE/1048576"
echo %LIGHT_YELLOW%总文件大小: !TOTAL_SIZE_MB! MB%RESET%

set "EST_TIME=计算中..."
if !COUNT! gtr 0 (
    for /f "tokens=2 delims==." %%A in ('""!FFMPEG_PATH!" -i "!FILE_1!" 2^>^&1 ^| find "Duration""') do (
        set "DURATION=%%A"
        set "DURATION=!DURATION:~1!"
        for /f "tokens=1-4 delims=:." %%a in ("!DURATION!") do (
            set "HOURS=%%a"
            set "MINUTES=%%b"
            set "SECONDS=%%c"
            set "MILLISECONDS=%%d"
        )
        set /a "TOTAL_SECONDS=HOURS*3600 + MINUTES*60 + SECONDS"
        
        REM 改进的时间估算算法
        set /a "BASE_TIME=TOTAL_SECONDS * 1000 / 1048576"  REM 基准时间(毫秒/MB)
        
        if "!AUDIO_OPT!"=="-c:a copy" (
            set /a "EST_SECONDS=5 + !COUNT!"  REM 直接复制非常快
        ) else (
            if "!HAS_GPU!"=="1" (
                set /a "EST_SECONDS=BASE_TIME * TOTAL_SIZE_MB / 5000"  REM GPU加速
            ) else (
                set /a "EST_SECONDS=BASE_TIME * TOTAL_SIZE_MB / 1000"  REM 软件编码
            )
        )
        
        REM 考虑自定义选项的影响
        echo "!CUSTOM_OPTIONS!" | find /i "fast" >nul && set /a "EST_SECONDS=EST_SECONDS*8/10"
        echo "!CUSTOM_OPTIONS!" | find /i "slow" >nul && set /a "EST_SECONDS=EST_SECONDS*12/10"
        
        REM 确保最小时间
        if !EST_SECONDS! lss 5 set "EST_SECONDS=5"
        
        if !EST_SECONDS! lss 60 (
            set "EST_TIME=约!EST_SECONDS!秒"
        ) else (
            set /a "EST_MINUTES=(EST_SECONDS+30)/60"
            if !EST_MINUTES! lss 60 (
                set "EST_TIME=约!EST_MINUTES!分钟"
            ) else (
                set /a "EST_HOURS=(EST_MINUTES+30)/60"
                set "EST_TIME=约!EST_HOURS!小时"
            )
        )
        echo %LIGHT_YELLOW%样本时长: !HOURS!:!MINUTES!:!SECONDS!%RESET%
    )
)
echo %LIGHT_YELLOW%预计处理时间: !EST_TIME!%RESET%
if "!HAS_GPU!"=="1" echo %LIGHT_BLUE%[info]%WHITE% 检测到GPU加速支持，转换速度将更快%RESET%
echo %DARK_GREEN%=====================================%RESET%
echo.

set "CONFIRM="
set /p "CONFIRM=确认开始转换? [Y/N]: "
if /i not "!CONFIRM!"=="Y" goto MAIN_MENU

REM ================ 日志记录 ================
echo ========== 转换开始于: %DATE% %TIME% ========== >> "%LOG_FILE%"
echo 输入文件: !FILE_LIST! >> "%LOG_FILE%"
echo 输出目录: !OUTPUT_DIR! >> "%LOG_FILE%"
echo 输出格式: !EXT! >> "%LOG_FILE%"
echo 音频编码: !AUDIO_OPT! >> "%LOG_FILE%"
echo 自定义选项: !CUSTOM_OPTIONS! >> "%LOG_FILE%"
echo FFmpeg路径: !FFMPEG_PATH! >> "%LOG_FILE%"
echo. >> "%LOG_FILE%"

REM ================ 文件转换 ================
set INDEX=0
for /l %%N in (1,1,!COUNT!) do (
    set /a INDEX+=1
    set "INFILE=!FILE_%%N!"
    for %%F in ("!INFILE!") do (
        if "!BATCH_RENAME!"=="1" (
            REM 生成批量重命名文件名
            set "NUM=00!INDEX!"
            set "NUM=!NUM:~-3!"
            set "OUTFILE=!OUTPUT_DIR!\!NAME_TEMPLATE:#=!NUM!!.!EXT!"
            set "OUTFILE_NAME=!NAME_TEMPLATE:#=!NUM!!.!EXT!"
        ) else (
            set "OUTFILE=!OUTPUT_DIR!\%%~nF.!EXT!"
            set "OUTFILE_NAME=%%~nF.!EXT!"
        )
        set "CURRENT_FILE=%%~nxF"
        set "CURRENT_SIZE=%%~zF"
        set /a "CURRENT_SIZE_MB=CURRENT_SIZE/1048576"
    )
    
    echo %LIGHT_BLUE%[info]%WHITE% 正在处理文件 !INDEX!/!COUNT!: "!INFILE!"%RESET%
    echo %LIGHT_BLUE%[info]%WHITE% 文件大小: !CURRENT_SIZE_MB! MB%RESET%
    
    REM 记录转换开始
    echo 开始转换: "!INFILE!" 到 "!OUTFILE!" >> "%LOG_FILE%"
    
    if not exist "!INFILE!" (
        echo %RED%[error]%RED% 文件不存在: "!INFILE!"%RESET%
        echo [ERROR] 文件不存在: "!INFILE!" >> "%LOG_FILE%"
    ) else (
        set "PROGRESS=0"
        set "DONE=0"
        set "ROTATE_INDEX=0"
        
        if "!AUDIO_OPT!"=="-c:a copy" (
            set "SPEED=100"
        ) else (
            if "!HAS_GPU!"=="1" (
                set "SPEED=20"
            ) else (
                set "SPEED=5"
            )
        )
        
        REM 初始化多文件进度条
        if "!MULTI_PROGRESS!"=="1" (
            call :INIT_MULTI_PROGRESS !INDEX! "!CURRENT_FILE!"
        ) else (
            call :UPDATE_PROGRESS
        )
        
        start /B "" "!FFMPEG_PATH!" -i "!INFILE!" -y !AUDIO_OPT! !CUSTOM_OPTIONS! "!OUTFILE!" >> "%LOG_FILE%" 2>&1
        
        :PROGRESS_LOOP
        tasklist /fi "imagename eq ffmpeg.exe" | find "ffmpeg.exe" >nul
        if !errorlevel! equ 1 (
            if !DONE! equ 0 (
                set "SPEED=100"
                set "DONE=1"
            )
        )
        
        if !PROGRESS! lss 100 (
            set /a "PROGRESS+=SPEED"
            if !PROGRESS! gtr 100 set "PROGRESS=100"
            
            if "!MULTI_PROGRESS!"=="1" (
                call :UPDATE_MULTI_PROGRESS !INDEX! !PROGRESS! "!CURRENT_FILE!"
            ) else (
                call :UPDATE_PROGRESS
            )
            
            if !SPEED! geq 100 (
                timeout /t 1 >nul
            ) else if !SPEED! geq 20 (
                timeout /t 2 >nul
            ) else (
                timeout /t 3 >nul
            )
            goto PROGRESS_LOOP
        )
        
        if "!MULTI_PROGRESS!"=="1" (
            call :COMPLETE_MULTI_PROGRESS !INDEX!
        )
        
        echo.
        echo %LIGHT_GREEN%[succeed]%WHITE% 转换成功: "!CURRENT_FILE!" → "!OUTFILE_NAME!"%RESET%
        echo %LIGHT_BLUE%[info]%WHITE% 我们从未分离，只不过是走散了。莫怕，山河自有归期。感谢你对于我们的信任，转换文件这一路风雨兼程，不过有我们在。%RESET%
        echo %LIGHT_BLUE%[info]%WHITE% 感谢使用本工具，转换已完成！%RESET%
        
        REM 记录转换成功
        echo [SUCCESS] 转换成功: "!CURRENT_FILE!" → "!OUTFILE_NAME!" >> "%LOG_FILE%"
    )
    timeout /t 1 >nul
)

if "!MULTI_PROGRESS!"=="1" (
    call :CLEAR_MULTI_PROGRESS !COUNT!
)

if "!OPEN_FOLDER!"=="1" (
    start "" "!OUTPUT_DIR!"
)

echo %LIGHT_BLUE%[info]%WHITE% 所有文件处理完成!%RESET%
echo ========== 转换完成于: %DATE% %TIME% ========== >> "%LOG_FILE%"
echo. >> "%LOG_FILE%"
pause
goto MAIN_MENU

REM ================ 单文件进度条函数 ================
:UPDATE_PROGRESS
    setlocal
    set /a "BAR=PROGRESS/2"
    set "PROGRESS_BAR=["
    for /l %%i in (1,1,!BAR!) do set "PROGRESS_BAR=!PROGRESS_BAR!#"
    set /a "REMAINING=50-BAR"
    for /l %%i in (1,1,!REMAINING!) do set "PROGRESS_BAR=!PROGRESS_BAR! "
    set "PROGRESS_BAR=!PROGRESS_BAR!] !PROGRESS!%%"
    
    set "ROTATE_CHAR=!"
    if !ROTATE_INDEX! equ 0 set "ROTATE_CHAR=\"
    if !ROTATE_INDEX! equ 1 set "ROTATE_CHAR=|"
    if !ROTATE_INDEX! equ 2 set "ROTATE_CHAR=/"
    if !ROTATE_INDEX! equ 3 set "ROTATE_CHAR=-"
    set /a "ROTATE_INDEX=(ROTATE_INDEX+1)%%4"
    
    <nul set /p "=%LIGHT_BLUE%[working...] %WHITE%!PROGRESS_BAR! !ROTATE_CHAR!%RESET%"
    echo.
endlocal
goto :eof

REM ================ 多文件进度条函数 ================
:INIT_MULTI_PROGRESS
    setlocal
    set "FILE_ID=%~1"
    set "FILE_NAME=%~2"
    
    REM 保存当前光标位置
    for /f "tokens=2" %%a in ('mode con') do set "CON_COLS=%%a"
    set /a "LINE_POS=FILE_ID + 3"
    
    REM 初始化进度条显示
    <nul set /p "=File !FILE_ID!: !FILE_NAME! "
    echo.
    
    REM 保存初始行位置
    set "MULTI_LINE_!FILE_ID!=!LINE_POS!"
endlocal
goto :eof

:UPDATE_MULTI_PROGRESS
    setlocal
    set "FILE_ID=%~1"
    set "PROGRESS=%~2"
    set "FILE_NAME=%~3"
    
    REM 获取保存的行位置
    set "LINE_POS=!MULTI_LINE_!FILE_ID!!"
    
    REM 移动光标到指定行
    <nul set /p "=%ESC%[!LINE_POS!;1H"
    
    REM 计算进度条
    set /a "BAR=PROGRESS/2"
    set "PROGRESS_BAR=["
    for /l %%i in (1,1,!BAR!) do set "PROGRESS_BAR=!PROGRESS_BAR!#"
    set /a "REMAINING=50-BAR"
    for /l %%i in (1,1,!REMAINING!) do set "PROGRESS_BAR=!PROGRESS_BAR! "
    set "PROGRESS_BAR=!PROGRESS_BAR!] !PROGRESS!%%"
    
    set "ROTATE_CHAR=!"
    set /a "ROTATE_INDEX=(FILE_ID + PROGRESS) %% 4"
    if !ROTATE_INDEX! equ 0 set "ROTATE_CHAR=\"
    if !ROTATE_INDEX! equ 1 set "ROTATE_CHAR=|"
    if !ROTATE_INDEX! equ 2 set "ROTATE_CHAR=/"
    if !ROTATE_INDEX! equ 3 set "ROTATE_CHAR=-"
    
    REM 更新进度条显示
    <nul set /p "=File !FILE_ID!: !FILE_NAME! !PROGRESS_BAR! !ROTATE_CHAR!%RESET%"
    
    REM 移动光标回到底部
    <nul set /p "=%ESC%[!COUNT!;1H"
endlocal
goto :eof

:COMPLETE_MULTI_PROGRESS
    setlocal
    set "FILE_ID=%~1"
    set "LINE_POS=!MULTI_LINE_!FILE_ID!!"
    
    REM 移动光标到指定行
    <nul set /p "=%ESC%[!LINE_POS!;1H"
    
    REM 清除行内容
    <nul set /p "=%ESC%[K"
    
    REM 移动光标回到底部
    <nul set /p "=%ESC%[!COUNT!;1H"
endlocal
goto :eof

:CLEAR_MULTI_PROGRESS
    setlocal
    set "TOTAL_FILES=%~1"
    
    REM 清除所有进度条行
    for /l %%i in (1,1,!TOTAL_FILES!) do (
        set "LINE_POS=!MULTI_LINE_%%i!"
        if defined LINE_POS (
            <nul set /p "=%ESC%[!LINE_POS!;1H"
            <nul set /p "=%ESC%[K"
        )
    )
    
    REM 移动光标回到底部
    <nul set /p "=%ESC%[!TOTAL_FILES!;1H"
endlocal
goto :eof