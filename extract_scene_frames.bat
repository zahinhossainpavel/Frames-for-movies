@echo off
setlocal EnableDelayedExpansion

rem Font for timecode overlay (change if needed)
set "FONT=C\\:\\Windows\\Fonts\\arial.ttf"

for %%F in (*.mp4 *.mkv *.mov *.avi *.webm *.m4v) do (
    if exist "%%F" (
        rem Check if output folder already exists
        if exist "%%~nF\" (
            echo Skipping "%%F" - folder "%%~nF" already exists.
        ) else (
            echo Processing "%%F"...

            rem Create folder with same name as the movie (without extension)
            mkdir "%%~nF" 2>nul

            rem Extract ONLY keyframes (I-frames), add timecode, no crop, PNG
            ffmpeg -hide_banner -loglevel error -y -i "%%F" ^
                -vf "select='eq(pict_type\,I)',drawtext=fontfile=%FONT%:text='%%{pts\:hms}':x=10:y=10:fontsize=24:box=1:boxcolor=black@0.5:boxborderw=5" ^
                -vsync vfr -c:v png "%%~nF\%%~nF_%%06d.png"
        )
    )
)

echo All done.
endlocal
pause
