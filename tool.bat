@echo off
setlocal enabledelayedexpansion

REM ================ ��ʼ������ ================
for /F "tokens=1" %%a in ('echo prompt $E ^| cmd') do set "ESC=%%a"
set "LIGHT_BLUE=%ESC%[36m"     REM ǳ��ɫ
set "RED=%ESC%[31m"           REM ��ɫ
set "LIGHT_GREEN=%ESC%[92m"    REM ǳ��ɫ
set "LIGHT_YELLOW=%ESC%[93m"   REM ǳ��ɫ
set "DARK_GREEN=%ESC%[32m"     REM ����ɫ
set "WHITE=%ESC%[37m"          REM ��ɫ
set "RESET=%ESC%[0m"           REM ������ɫ

set "CONFIG_FILE=%~dp0ffmpeg_config.txt"
set "LOG_FILE=%~dp0ffmpeg_conversion.log"
set "FFMPEG_PATH=ffmpeg.exe"
set "CUSTOM_OPTIONS="
set "HAS_GPU=0"
set "MULTI_PROGRESS=0"  REM ���ļ�����������(Ĭ�Ϲر�)
set "OPEN_FOLDER=1"      REM ת����ɺ��Զ����ļ���(Ĭ�Ͽ���)
set "BATCH_RENAME=0"     REM ��������������(Ĭ�Ϲر�)
set "FILE_PREVIEW=0"     REM �ļ�Ԥ������(Ĭ�Ϲر�)
set "SMART_ENCODING=1"   REM ���ܱ��뿪��(Ĭ�Ͽ���)

REM ================ �������� ================
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

REM ================ ���GPU���� ================
if exist "!FFMPEG_PATH!" (
    "!FFMPEG_PATH!" -hwaccels | find "cuda" >nul && set "HAS_GPU=1"
    "!FFMPEG_PATH!" -hwaccels | find "dxva2" >nul && set "HAS_GPU=1"
    "!FFMPEG_PATH!" -hwaccels | find "qsv" >nul && set "HAS_GPU=1"
)

REM ================ ���˵� ================
:MAIN_MENU
cls
echo %LIGHT_YELLOW%==================== ���˵� ====================%RESET%
echo %LIGHT_YELLOW%1. ��ʼת��%RESET%
echo %LIGHT_YELLOW%2. FFmpeg��ַ����%RESET%
echo %LIGHT_YELLOW%3. ����FFmpeg%RESET%
echo %LIGHT_YELLOW%4. �Զ���FFmpegѡ��%RESET%
echo %LIGHT_YELLOW%5. ��־��¼����%RESET%
echo %LIGHT_YELLOW%6. ����%RESET%
echo %LIGHT_YELLOW%7. ������־%RESET%
echo %LIGHT_YELLOW%8. ʵ����%RESET%
echo %LIGHT_YELLOW%9. �˳�%RESET%
echo %LIGHT_YELLOW%===========================================%RESET%
set /p "CHOICE=��ѡ����� [1-9]: "
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

REM ================ ʵ�������� ================
:LAB_SETTINGS
cls
echo %LIGHT_YELLOW%=========== ʵ�������� ===========%RESET%
echo %LIGHT_YELLOW%1. ���ļ���������ʾ: !MULTI_PROGRESS! (1=����, 0=�ر�)%RESET%
echo %LIGHT_YELLOW%2. ת�����Զ����ļ���: !OPEN_FOLDER! (1=����, 0=�ر�)%RESET%
echo %LIGHT_YELLOW%3. ����������ģʽ: !BATCH_RENAME! (1=����, 0=�ر�)%RESET%
echo %LIGHT_YELLOW%4. �ļ�Ԥ������: !FILE_PREVIEW! (1=����, 0=�ر�)%RESET%
echo %LIGHT_YELLOW%5. ���ܱ��빦��: !SMART_ENCODING! (1=����, 0=�ر�)%RESET%
echo %LIGHT_YELLOW%6. �������˵�%RESET%
set /p "LAB_CHOICE=��ѡ�� [1-6]: "

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
    echo %LIGHT_GREEN%[succeed]%WHITE% �ѹرն��ļ���������ʾ%RESET%
) else (
    set "MULTI_PROGRESS=1"
    echo %LIGHT_GREEN%[succeed]%WHITE% �ѿ������ļ���������ʾ%RESET%
)
timeout /t 2 >nul
goto LAB_SETTINGS

:TOGGLE_OPEN_FOLDER
if "!OPEN_FOLDER!"=="1" (
    set "OPEN_FOLDER=0"
    echo %LIGHT_GREEN%[succeed]%WHITE% �ѹر��Զ����ļ��й���%RESET%
) else (
    set "OPEN_FOLDER=1"
    echo %LIGHT_GREEN%[succeed]%WHITE% �ѿ����Զ����ļ��й���%RESET%
)
timeout /t 2 >nul
goto LAB_SETTINGS

:TOGGLE_BATCH_RENAME
if "!BATCH_RENAME!"=="1" (
    set "BATCH_RENAME=0"
    echo %LIGHT_GREEN%[succeed]%WHITE% �ѹر�����������ģʽ%RESET%
) else (
    set "BATCH_RENAME=1"
    echo %LIGHT_GREEN%[succeed]%WHITE% �ѿ�������������ģʽ%RESET%
)
timeout /t 2 >nul
goto LAB_SETTINGS

:TOGGLE_FILE_PREVIEW
if "!FILE_PREVIEW!"=="1" (
    set "FILE_PREVIEW=0"
    echo %LIGHT_GREEN%[succeed]%WHITE% �ѹر��ļ�Ԥ������%RESET%
) else (
    set "FILE_PREVIEW=1"
    echo %LIGHT_GREEN%[succeed]%WHITE% �ѿ����ļ�Ԥ������%RESET%
)
timeout /t 2 >nul
goto LAB_SETTINGS

:TOGGLE_SMART_ENCODING
if "!SMART_ENCODING!"=="1" (
    set "SMART_ENCODING=0"
    echo %LIGHT_GREEN%[succeed]%WHITE% �ѹر����ܱ��빦��%RESET%
) else (
    set "SMART_ENCODING=1"
    echo %LIGHT_GREEN%[succeed]%WHITE% �ѿ������ܱ��빦��%RESET%
)
timeout /t 2 >nul
goto LAB_SETTINGS

REM ================ �Զ���ѡ�� ================
:CUSTOM_OPTIONS
cls
echo %LIGHT_YELLOW%=========== �Զ���FFmpegѡ�� ===========%RESET%
echo %LIGHT_YELLOW%��ǰ�Զ���ѡ��: %CUSTOM_OPTIONS%%RESET%
echo %LIGHT_YELLOW%1. �����Զ���ѡ��%RESET%
echo %LIGHT_YELLOW%2. ����Զ���ѡ��%RESET%
echo %LIGHT_YELLOW%3. �������˵�%RESET%
set /p "OPTION_CHOICE=��ѡ�� [1-3]: "

if "!OPTION_CHOICE!"=="3" goto MAIN_MENU
if "!OPTION_CHOICE!"=="2" goto CLEAR_OPTIONS
if "!OPTION_CHOICE!"=="1" goto SET_OPTIONS
goto CUSTOM_OPTIONS

:SET_OPTIONS
set /p "NEW_OPTIONS=�����Զ���FFmpegѡ��(��:-b:v 1M -preset fast): "
set "CUSTOM_OPTIONS=!NEW_OPTIONS!"
(
    echo !FFMPEG_PATH!
    if not "!CUSTOM_OPTIONS!"=="" echo @!CUSTOM_OPTIONS!
) > "%CONFIG_FILE%"
echo %LIGHT_GREEN%[succeed]%WHITE% �Զ���ѡ��������!%RESET%
timeout /t 2 >nul
goto CUSTOM_OPTIONS

:CLEAR_OPTIONS
set "CUSTOM_OPTIONS="
echo !FFMPEG_PATH! > "%CONFIG_FILE%"
echo %LIGHT_GREEN%[succeed]%WHITE% �Զ���ѡ�������!%RESET%
timeout /t 2 >nul
goto CUSTOM_OPTIONS

REM ================ ������־ ================
:CHANGELOG
cls
echo %DARK_GREEN%=============== ������־ ================%RESET%
echo %WHITE%V1.0
echo ���ڸ�ʽ������װʱһ��С�ľ����װ�װ��ɽ���ԣ���ת�����ʲ����죨�����龰��������룬��ʽ������δ�����Ż���������Ҳ�����ǵ����˿�Դ��ĿFFempeg��
echo �β������Լ���дһ�������ڿ��ָ������������������뷱���Ĵ��룬MP4StudioPro�ĵ�һ���汾�䵮���ˣ�ͬ���ǵ���FFempeg�����Ҳ���������ת������׷
echo ����������������������������������Ƿ�����ѡ���Ȼ��һ��ѧ����ʵ���϶���������ɿ�������ȻAI�Ĺ��ͱز����٣���2023�귢����һ���汾������
echo �ڴ���������⣬��Ԥ��ķ��������Զ�����й��Ϸ���������һ�¸���Ŀ������Github������ǰ�����ԭ����д�ġ�
echo.
echo V1.2
echo ������ΪʲôҪ����V1.1���ʾ�����Ϊ�������޸�������󲻼ǵõ�һ���汾��ʲô���ţ�����ֱ������V1.2�����������־����������ѹ����������ˣ�û��Ҫ��
echo ��ѹ�ĸ��汾���ˡ�
echo ���ΰ汾��
echo 1.�޸��˲�������¿���������FFempeg�������ļ����⣩
echo 2.��������˶��ļ����������ܣ�power by DeepSeek��
echo 3.�Ż��˽���������ʵ�ļ�ת����ʱЧͬ�����Ķ���ԭ�еĽ�������ʾ�޸ģ����ܸ��û�����ֱ�۸��ܣ�����������ʵ��̫���ˣ����н������Ǽٵģ�
echo 4.�Ż����û�����
echo 5.�޸�����֪����
echo 6.�����һЩ���ܶԺ����������õĴ��루power by DeepSeek��
echo.
echo V1.3.0
echo ������ѡ����ת����ʽ���Ҷ���ȷ�Ϻ�������ˣ���Ȼû���ϴ�
echo ���ΰ汾��
echo 1.�����еġ�info����Ϊ��ɫ����info����ĺ��ָ�Ϊ��ɫ
echo 2.����µ���ʾ�ʣ�����ɹ���ʾ��succeed����
echo.
echo V1.3.1Beta
echo ����һ��ȫ�µİ汾�����������¹��ܣ�
echo 1.����Զ���¼��־����
echo 2.��Ӳ���FFempeg���ܣ�����������˵���ѡ��2�н��в��ԣ�
echo 3.�޸�����֪����
echo 4.�Ż��˽����߼�
echo 5.�Ż���������ʾ����ӽ���%%��ͼ����ת��ʽ��δ��ɡ���
echo.
echo V1.3.1����ʽ�棩
echo ����һ��ȫ�µİ汾����Beta��Ļ������Ż�����๦�ܣ�
echo 1.�޸����Զ���¼��־���ܿ��ܴ��ڵ�����
echo 2.�޸���FFempeg���Եĳɹ���ʾ����
echo 3.�޸�����֪����
echo 4.�Ż��˽����߼�
echo 5.���������Bate���н�����δ��ɵĹ���
echo.
echo V2.0Beta
echo ����һ����汾���£������ܵ��޸��˴󲿷����⣬Ϊ�û�������һЩ�°汾����
echo 1.�޸���:CHANGELOG���֣�ȷ��ÿһ���ı���ʹ��echo�������
echo 2.�޸���ת�������������ַ���Ϊ��ֹ���룩
echo 3.������ԭ�е���ɫ��ʽ�ͱ߿����
echo 4.������Զ���FFempegָ���������˸���������Ժ���չ��
echo 5.����˸���֧��ת���ĸ�ʽ
echo 6.�Ż��˽����߼�
echo 7.�Ż���ɫ����ʾ
echo.
echo V2.0����ʽ�棩
echo ��Beta��Ļ����Ͻ�һ���Ż���
echo 1.�޸���������֪����
echo 2.�������Զ���FFmpegѡ���
echo 3.��ǿ�˸�ʽת�����ȶ���
echo 4.�Ľ�����־��¼ϵͳ
echo 5.�Ż����û�����
echo.
echo V2.1Beta
echo ���汾�������������������V2.0��������ļ��������������Ҵ����˴��ļ�������1GB��ת�����ȶ��Ժ���ʾЧ�����Ż�
echo 1.�޸�����֪����
echo 2.�����˲����������ʾ�ļ�ת���ɹ���ʵ������ת�������
echo 3.�Ż��˽�������ʾ����ǿ�˽�������ʱЧ��
echo 4.�Ż�����־����ؼ�¼����
echo 5.�Ż��˽����߼�
echo 6.�������ļ���С��ʾ����Ԥ�ƴ���ʱ�����ʾ
echo.
echo V2.1
echo ��Ӧ����Ŀǰ��ȫ�ܵİ汾
echo 1.�޸�����֪����
echo 2.��������beta���д���3GB���ϵĴ��ļ����ֵĽ�������������
echo 3.����˽������㷨
echo 4.�����ʱ���㷨
echo 5.�Ż��˽����߼�
echo 6.�Ż����ļ���С��ʾ��Ԥ�ƴ���ʱ�����ʾ��Ŀǰ���ڿ����п���ʱ�������ߵ����⣩
echo.
echo V2.2
echo �����ȶ��棬��Ҫ�Ľ���
echo 1. ��ȫ�޸�������������
echo 2. �Ż����ļ���������
echo 3. �Ľ�������׼ȷ��
echo 4. ��ǿ���������
echo.
echo V2.3Beta
echo �������ܣ�
echo 1. ��Ӷ��ļ�������������ʾ����
echo 2. ���Ӹ߼����ò˵�
echo 3. �Ż�������������
echo 4. �Ľ�ʱ������㷨
echo.
echo V2.3
echo ���θ�����Ҫ�޸���Beta���д��ڵ��������⣨��Ĭ������¹ر�ʵ���ң���ͬ��Ҳ������һЩ3���¹��ܣ�
echo 1.�޸���"�����������"�����⣨��Ҫ���ڱ����ȽϺͼ���ʱȱ�����Ż�ո��£�
echo 2.�����ļ�Ԥ�����ܣ���ת��ǰ����Ԥ���ļ���Ϣ��
echo 3.������������������
echo 4.����ת����ɺ��Զ�������ļ���ѡ��
echo 5.��ǿ�˴��������
echo %DARK_GREEN%====================================%RESET%
pause
goto MAIN_MENU

REM ================ ������Ϣ ================
:ABOUT
cls
echo %DARK_GREEN%=============== ���ڱ����� ================%RESET%
echo %LIGHT_YELLOW%MP4StudioPro ��Ƶת������%RESET%
echo %LIGHT_YELLOW%�汾: 2.3%RESET%
echo %LIGHT_YELLOW%������: Ritual Collapse%RESET%
echo.
echo %LIGHT_YELLOW%����FFmpeg��Դ��Ŀ����%RESET%
echo %DARK_GREEN%========================================%RESET%
pause
goto MAIN_MENU

REM ================ ��־���� ================
:LOG_SETTINGS
cls
echo %LIGHT_YELLOW%=========== ��־��¼���� ===========%RESET%
echo %LIGHT_YELLOW%��ǰ��־�ļ�: %LOG_FILE%%RESET%
echo %LIGHT_YELLOW%1. �鿴��־%RESET%
echo %LIGHT_YELLOW%2. �����־%RESET%
echo %LIGHT_YELLOW%3. ������־·��%RESET%
echo %LIGHT_YELLOW%4. �������˵�%RESET%
set /p "LOG_CHOICE=��ѡ�� [1-4]: "

if "!LOG_CHOICE!"=="4" goto MAIN_MENU
if "!LOG_CHOICE!"=="3" goto CHANGE_LOG_PATH
if "!LOG_CHOICE!"=="2" goto CLEAR_LOG
if "!LOG_CHOICE!"=="1" goto VIEW_LOG
goto LOG_SETTINGS

:VIEW_LOG
if not exist "%LOG_FILE%" (
    echo %RED%[error]%RED% ��־�ļ�������!%RESET%
) else (
    notepad "%LOG_FILE%"
)
timeout /t 2 >nul
goto LOG_SETTINGS

:CLEAR_LOG
if exist "%LOG_FILE%" (
    del "%LOG_FILE%" >nul 2>&1
    echo %LIGHT_GREEN%[succeed]%WHITE% ��־�����!%RESET%
) else (
    echo %RED%[error]%RED% ��־�ļ�������!%RESET%
)
timeout /t 2 >nul
goto LOG_SETTINGS

:CHANGE_LOG_PATH
set /p "NEW_LOG_PATH=�����µ���־�ļ�����·��: "
set "NEW_LOG_PATH=!NEW_LOG_PATH:"=!"
if not "!NEW_LOG_PATH!"=="" (
    set "LOG_FILE=!NEW_LOG_PATH!"
    echo %LIGHT_GREEN%[succeed]%WHITE% ��־·���Ѹ���!%RESET%
) else (
    echo %RED%[error]%RED% ·����Ч!%RESET%
)
timeout /t 2 >nul
goto LOG_SETTINGS

REM ================ FFmpeg���� ================
:TEST_FFMPEG
cls
echo %LIGHT_YELLOW%=========== FFmpeg���� ===========%RESET%
if not exist "!FFMPEG_PATH!" (
    echo %RED%[error]%RED% FFmpeg·����Ч: "!FFMPEG_PATH!"%RESET%
    timeout /t 3 >nul
    goto SET_FFMPEG
)

echo %LIGHT_YELLOW%���ڲ���FFmpeg...%RESET%
echo.
echo %LIGHT_BLUE%[info]%WHITE% FFmpeg�汾��Ϣ:%RESET%
"!FFMPEG_PATH!" -version
echo.
echo %LIGHT_BLUE%[info]%WHITE% ��ǰ�Զ���ѡ��: %CUSTOM_OPTIONS%%RESET%
if "!HAS_GPU!"=="1" (
    echo %LIGHT_BLUE%[info]%WHITE% ��⵽GPU����֧��%RESET%
) else (
    echo %LIGHT_BLUE%[info]%WHITE% δ��⵽GPU����֧��%RESET%
)
echo %LIGHT_GREEN%[succeed]%WHITE% FFmpeg���Գɹ�!%RESET%
pause
goto MAIN_MENU

REM ================ FFmpeg·������ ================
:SET_FFMPEG
cls
echo %LIGHT_YELLOW%=========== FFmpeg·������ ===========%RESET%
echo %LIGHT_YELLOW%��ǰ·��: %FFMPEG_PATH%%RESET%
echo %LIGHT_YELLOW%1. �Զ����%RESET%
echo %LIGHT_YELLOW%2. �ֶ�����%RESET%
echo %LIGHT_YELLOW%3. �������˵�%RESET%
set /p "FF_CHOICE=��ѡ�� [1-3]: "

if "!FF_CHOICE!"=="3" goto MAIN_MENU
if "!FF_CHOICE!"=="2" goto MANUAL_PATH
if "!FF_CHOICE!"=="1" goto AUTO_DETECT
goto SET_FFMPEG

:AUTO_DETECT
where ffmpeg >nul 2>&1
if !errorlevel! equ 0 (
    where ffmpeg > "%CONFIG_FILE%"
    set "FFMPEG_PATH=ffmpeg"
    echo %LIGHT_GREEN%[succeed]%WHITE% FFmpeg·�����Զ�����!%RESET%
) else (
    echo %RED%[error]%RED% δ�ҵ�FFmpeg!%RESET%
)
timeout /t 2 >nul
goto SET_FFMPEG

:MANUAL_PATH
set /p "NEW_PATH=����FFmpeg����·��: "
set "NEW_PATH=!NEW_PATH:"=!"
if exist "!NEW_PATH!" (
    echo !NEW_PATH! > "%CONFIG_FILE%"
    set "FFMPEG_PATH=!NEW_PATH!"
    echo %LIGHT_GREEN%[succeed]%WHITE% FFmpeg·���Ѹ���!%RESET%
) else (
    echo %RED%[error]%RED% ·����Ч!%RESET%
)
timeout /t 2 >nul
goto SET_FFMPEG

REM ================ �ļ�ѡ�� ================
:SELECT_FILES
cls
echo %LIGHT_YELLOW%�뽫�����ļ��Ϸŵ��˴���(֧�ֶ���ļ�)%RESET%
echo %LIGHT_BLUE%[info]%WHITE% ����һ���ϷŶ���ļ���ϵͳ���Զ�����%RESET%
set "FILE_LIST="
set /p "FILE_LIST=�����ļ�: "
if "!FILE_LIST!"=="" (
    echo %RED%[error]%RED% δѡ���ļ�!%RESET%
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

REM ================ ��ǿ���ļ�Ԥ�� ================
if "!FILE_PREVIEW!"=="1" (
    call :PREVIEW_FILES
)

if "!BATCH_RENAME!"=="1" goto BATCH_RENAME_SETUP

REM ================ ���Ŀ¼ѡ�� ================
:SELECT_OUTPUT
cls
echo %LIGHT_YELLOW%�뽫����ļ����Ϸŵ��˴���%RESET%
set "OUTPUT_DIR="
set /p "OUTPUT_DIR=����ļ���: "
if "!OUTPUT_DIR!"=="" (
    echo %RED%[error]%RED% δѡ������ļ���!%RESET%
    timeout /t 2 >nul
    goto SELECT_OUTPUT
)

set "OUTPUT_DIR=!OUTPUT_DIR:"=!"
if not exist "!OUTPUT_DIR!\" (
    mkdir "!OUTPUT_DIR!\" >nul 2>&1
    if errorlevel 1 (
        echo %RED%[error]%RED% �޷��������Ŀ¼: !OUTPUT_DIR!%RESET%
        timeout /t 2 >nul
        goto SELECT_OUTPUT
    )
)
goto CONVERT_MENU

REM ================ �ļ�Ԥ������ ================
:PREVIEW_FILES
cls
echo %LIGHT_YELLOW%=========== �ļ�Ԥ�� (��!COUNT!���ļ�) ===========%RESET%
for /l %%N in (1,1,!COUNT!) do (
    set "INFILE=!FILE_%%N!"
    for %%F in ("!INFILE!") do (
        echo %LIGHT_YELLOW%�ļ�%%N: %%~nxF%RESET%
        echo %LIGHT_BLUE%[info]%WHITE% ·��: %%~dpF%RESET%
        
        REM �ļ���С��ʾΪMB
        set /a "SIZE_MB=%%~zF/1048576"
        echo %LIGHT_BLUE%[info]%WHITE% ��С: !SIZE_MB! MB%RESET%
        
        REM ��ȡ����ʽ���ļ�ʱ��
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
                echo %LIGHT_BLUE%[info]%WHITE% ʱ��: !HOURS!:!MINUTES!:!SECONDS!%RESET%
            )
        )
        echo.
    )
)
echo %LIGHT_YELLOW%============================================%RESET%
pause
goto :eof

REM ================ �������������� ================
:BATCH_RENAME_SETUP
cls
echo %LIGHT_YELLOW%=========== �������������� ===========%RESET%
echo %LIGHT_YELLOW%��ǰ�ļ�����: !COUNT!%RESET%
echo %LIGHT_YELLOW%����������ģ��(ʹ��#��Ϊ����ռλ������: ��Ƶ_###)%RESET%
set /p "NAME_TEMPLATE=����ģ��: "
if "!NAME_TEMPLATE!"=="" (
    echo %RED%[error]%RED% ����ģ�岻��Ϊ��!%RESET%
    timeout /t 2 >nul
    goto BATCH_RENAME_SETUP
)

set "OUTPUT_DIR=%~dp0Batch_Renamed_Files"
if not exist "!OUTPUT_DIR!\" (
    mkdir "!OUTPUT_DIR!\" >nul 2>&1
    if errorlevel 1 (
        echo %RED%[error]%RED% �޷��������Ŀ¼: !OUTPUT_DIR!%RESET%
        timeout /t 2 >nul
        goto BATCH_RENAME_SETUP
    )
)

echo %LIGHT_GREEN%[succeed]%WHITE% ���Ŀ¼������Ϊ: !OUTPUT_DIR!%RESET%
timeout /t 2 >nul

REM ================ ��ʽѡ�� ================
:CONVERT_MENU
cls
echo %LIGHT_YELLOW%================ ��ʽѡ�� ================%RESET%
echo %LIGHT_YELLOW%1. MP3 (��Ƶ)%RESET%
echo %LIGHT_YELLOW%2. WAV (��Ƶ)%RESET%
echo %LIGHT_YELLOW%3. FLAC (��Ƶ)%RESET%
echo %LIGHT_YELLOW%4. AVI (��Ƶ)%RESET%
echo %LIGHT_YELLOW%5. MOV (��Ƶ)%RESET%
echo %LIGHT_YELLOW%6. MP4 (��Ƶ)%RESET%
echo %LIGHT_YELLOW%7. MKV (��Ƶ)%RESET%
echo %LIGHT_YELLOW%8. WEBM (��Ƶ)%RESET%
echo %LIGHT_YELLOW%9. �������˵�%RESET%
set /p "FORMAT=ѡ�������ʽ [1-9]: "
if "!FORMAT!"=="9" goto MAIN_MENU
if "!FORMAT!" gtr "9" goto CONVERT_MENU

REM ����һ���ļ�����չ��
set "FIRST_FILE=!FILE_1!"
for %%F in ("!FIRST_FILE!") do set "EXTENSION=%%~xF"
set "EXTENSION=!EXTENSION:~1!"

REM ���ø�ʽ�����Լ��
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
    echo %RED%[error]%RED% ��Ч�ĸ�ʽѡ��%RESET%
    timeout /t 2 >nul
    goto CONVERT_MENU
)

REM ����ʽ������
set "NEED_CONVERT=1"
if /i "!EXTENSION!"=="!EXT!" (
    echo %LIGHT_BLUE%[info]%WHITE% ���������ʽ��ͬ����ֱ�Ӹ����ļ�%RESET%
    set "NEED_CONVERT=0"
    goto SKIP_RECODE
)

REM ���ܱ��빦��
if "!SMART_ENCODING!"=="1" (
    REM �����ʽ��� - �Զ������Ƿ���Ҫ���±���
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
    
    REM �Զ�������Ƶѡ��
    if "!NEED_CONVERT!"=="0" (
        set "AUDIO_OPT=-c:a copy"
    ) else (
        REM ����Ŀ���ʽ�Զ�ѡ����ѱ���
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

REM ================ ѯ���Ƿ����±��� ================
:ASK_RECODE
set "RECODE="
set /p "RECODE=�Ƿ����±�����Ƶ? [y/N]: "
if /i "!RECODE!"=="" set "RECODE=n"
if /i "!RECODE!"=="y" (
    set "AUDIO_OPT=-c:a libmp3lame -q:a 2"
) else if /i "!RECODE!"=="n" (
    set "AUDIO_OPT=-c:a copy"
) else (
    echo %RED%[error]%RED% ������ y �� n%RESET%
    timeout /t 1 >nul
    goto ASK_RECODE
)

:SHOW_SETTINGS
REM ================ ��ʾ���� ================
cls
echo %DARK_GREEN%=============== ��ǰ���� ================%RESET%
echo %LIGHT_YELLOW%�����ļ�����: !COUNT!%RESET%
echo %LIGHT_YELLOW%���Ŀ¼:   !OUTPUT_DIR!%RESET%
echo %LIGHT_YELLOW%�����ʽ:   !EXT!%RESET%
echo %LIGHT_YELLOW%��Ƶ����:   !AUDIO_OPT!%RESET%
echo %LIGHT_YELLOW%�Զ���ѡ��: %CUSTOM_OPTIONS%%RESET%
echo %LIGHT_YELLOW%FFmpeg·��: !FFMPEG_PATH!%RESET%

set "TOTAL_SIZE=0"
for /l %%N in (1,1,!COUNT!) do (
    for %%F in ("!FILE_%%N!") do (
        set /a "TOTAL_SIZE+=%%~zF"
    )
)
set /a "TOTAL_SIZE_MB=TOTAL_SIZE/1048576"
echo %LIGHT_YELLOW%���ļ���С: !TOTAL_SIZE_MB! MB%RESET%

set "EST_TIME=������..."
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
        
        REM �Ľ���ʱ������㷨
        set /a "BASE_TIME=TOTAL_SECONDS * 1000 / 1048576"  REM ��׼ʱ��(����/MB)
        
        if "!AUDIO_OPT!"=="-c:a copy" (
            set /a "EST_SECONDS=5 + !COUNT!"  REM ֱ�Ӹ��Ʒǳ���
        ) else (
            if "!HAS_GPU!"=="1" (
                set /a "EST_SECONDS=BASE_TIME * TOTAL_SIZE_MB / 5000"  REM GPU����
            ) else (
                set /a "EST_SECONDS=BASE_TIME * TOTAL_SIZE_MB / 1000"  REM �������
            )
        )
        
        REM �����Զ���ѡ���Ӱ��
        echo "!CUSTOM_OPTIONS!" | find /i "fast" >nul && set /a "EST_SECONDS=EST_SECONDS*8/10"
        echo "!CUSTOM_OPTIONS!" | find /i "slow" >nul && set /a "EST_SECONDS=EST_SECONDS*12/10"
        
        REM ȷ����Сʱ��
        if !EST_SECONDS! lss 5 set "EST_SECONDS=5"
        
        if !EST_SECONDS! lss 60 (
            set "EST_TIME=Լ!EST_SECONDS!��"
        ) else (
            set /a "EST_MINUTES=(EST_SECONDS+30)/60"
            if !EST_MINUTES! lss 60 (
                set "EST_TIME=Լ!EST_MINUTES!����"
            ) else (
                set /a "EST_HOURS=(EST_MINUTES+30)/60"
                set "EST_TIME=Լ!EST_HOURS!Сʱ"
            )
        )
        echo %LIGHT_YELLOW%����ʱ��: !HOURS!:!MINUTES!:!SECONDS!%RESET%
    )
)
echo %LIGHT_YELLOW%Ԥ�ƴ���ʱ��: !EST_TIME!%RESET%
if "!HAS_GPU!"=="1" echo %LIGHT_BLUE%[info]%WHITE% ��⵽GPU����֧�֣�ת���ٶȽ�����%RESET%
echo %DARK_GREEN%=====================================%RESET%
echo.

set "CONFIRM="
set /p "CONFIRM=ȷ�Ͽ�ʼת��? [Y/N]: "
if /i not "!CONFIRM!"=="Y" goto MAIN_MENU

REM ================ ��־��¼ ================
echo ========== ת����ʼ��: %DATE% %TIME% ========== >> "%LOG_FILE%"
echo �����ļ�: !FILE_LIST! >> "%LOG_FILE%"
echo ���Ŀ¼: !OUTPUT_DIR! >> "%LOG_FILE%"
echo �����ʽ: !EXT! >> "%LOG_FILE%"
echo ��Ƶ����: !AUDIO_OPT! >> "%LOG_FILE%"
echo �Զ���ѡ��: !CUSTOM_OPTIONS! >> "%LOG_FILE%"
echo FFmpeg·��: !FFMPEG_PATH! >> "%LOG_FILE%"
echo. >> "%LOG_FILE%"

REM ================ �ļ�ת�� ================
set INDEX=0
for /l %%N in (1,1,!COUNT!) do (
    set /a INDEX+=1
    set "INFILE=!FILE_%%N!"
    for %%F in ("!INFILE!") do (
        if "!BATCH_RENAME!"=="1" (
            REM ���������������ļ���
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
    
    echo %LIGHT_BLUE%[info]%WHITE% ���ڴ����ļ� !INDEX!/!COUNT!: "!INFILE!"%RESET%
    echo %LIGHT_BLUE%[info]%WHITE% �ļ���С: !CURRENT_SIZE_MB! MB%RESET%
    
    REM ��¼ת����ʼ
    echo ��ʼת��: "!INFILE!" �� "!OUTFILE!" >> "%LOG_FILE%"
    
    if not exist "!INFILE!" (
        echo %RED%[error]%RED% �ļ�������: "!INFILE!"%RESET%
        echo [ERROR] �ļ�������: "!INFILE!" >> "%LOG_FILE%"
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
        
        REM ��ʼ�����ļ�������
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
        echo %LIGHT_GREEN%[succeed]%WHITE% ת���ɹ�: "!CURRENT_FILE!" �� "!OUTFILE_NAME!"%RESET%
        echo %LIGHT_BLUE%[info]%WHITE% ���Ǵ�δ���룬ֻ��������ɢ�ˡ�Ī�£�ɽ�����й��ڡ���л��������ǵ����Σ�ת���ļ���һ·�����̣������������ڡ�%RESET%
        echo %LIGHT_BLUE%[info]%WHITE% ��лʹ�ñ����ߣ�ת������ɣ�%RESET%
        
        REM ��¼ת���ɹ�
        echo [SUCCESS] ת���ɹ�: "!CURRENT_FILE!" �� "!OUTFILE_NAME!" >> "%LOG_FILE%"
    )
    timeout /t 1 >nul
)

if "!MULTI_PROGRESS!"=="1" (
    call :CLEAR_MULTI_PROGRESS !COUNT!
)

if "!OPEN_FOLDER!"=="1" (
    start "" "!OUTPUT_DIR!"
)

echo %LIGHT_BLUE%[info]%WHITE% �����ļ��������!%RESET%
echo ========== ת�������: %DATE% %TIME% ========== >> "%LOG_FILE%"
echo. >> "%LOG_FILE%"
pause
goto MAIN_MENU

REM ================ ���ļ����������� ================
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

REM ================ ���ļ����������� ================
:INIT_MULTI_PROGRESS
    setlocal
    set "FILE_ID=%~1"
    set "FILE_NAME=%~2"
    
    REM ���浱ǰ���λ��
    for /f "tokens=2" %%a in ('mode con') do set "CON_COLS=%%a"
    set /a "LINE_POS=FILE_ID + 3"
    
    REM ��ʼ����������ʾ
    <nul set /p "=File !FILE_ID!: !FILE_NAME! "
    echo.
    
    REM �����ʼ��λ��
    set "MULTI_LINE_!FILE_ID!=!LINE_POS!"
endlocal
goto :eof

:UPDATE_MULTI_PROGRESS
    setlocal
    set "FILE_ID=%~1"
    set "PROGRESS=%~2"
    set "FILE_NAME=%~3"
    
    REM ��ȡ�������λ��
    set "LINE_POS=!MULTI_LINE_!FILE_ID!!"
    
    REM �ƶ���굽ָ����
    <nul set /p "=%ESC%[!LINE_POS!;1H"
    
    REM ���������
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
    
    REM ���½�������ʾ
    <nul set /p "=File !FILE_ID!: !FILE_NAME! !PROGRESS_BAR! !ROTATE_CHAR!%RESET%"
    
    REM �ƶ����ص��ײ�
    <nul set /p "=%ESC%[!COUNT!;1H"
endlocal
goto :eof

:COMPLETE_MULTI_PROGRESS
    setlocal
    set "FILE_ID=%~1"
    set "LINE_POS=!MULTI_LINE_!FILE_ID!!"
    
    REM �ƶ���굽ָ����
    <nul set /p "=%ESC%[!LINE_POS!;1H"
    
    REM ���������
    <nul set /p "=%ESC%[K"
    
    REM �ƶ����ص��ײ�
    <nul set /p "=%ESC%[!COUNT!;1H"
endlocal
goto :eof

:CLEAR_MULTI_PROGRESS
    setlocal
    set "TOTAL_FILES=%~1"
    
    REM ������н�������
    for /l %%i in (1,1,!TOTAL_FILES!) do (
        set "LINE_POS=!MULTI_LINE_%%i!"
        if defined LINE_POS (
            <nul set /p "=%ESC%[!LINE_POS!;1H"
            <nul set /p "=%ESC%[K"
        )
    )
    
    REM �ƶ����ص��ײ�
    <nul set /p "=%ESC%[!TOTAL_FILES!;1H"
endlocal
goto :eof