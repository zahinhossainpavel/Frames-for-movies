# Frames-for-movies
**Movie Frame Extractor – README
****1. What this program does
**
This batch script goes through all video files in the current folder and:

Looks for files with these extensions:
.mp4, .mkv, .mov, .avi, .webm, .m4v

For each video:

Creates a folder with the same name as the video (without the extension).

Example:
A Star Is Born-1080P.mp4 → folder A Star Is Born-1080P

Extracts only keyframes (I-frames) from the video.
These are important reference frames chosen by the video encoder and are usually cleaner and more stable than random frames.

Adds a timecode overlay (HH:MM:SS) in the top-left corner of every extracted frame.

Saves each frame as a PNG image in that movie’s folder with this naming style:
MovieName_MovieName_000001.png, MovieName_MovieName_000002.png, etc.

If a folder with the same name as the movie already exists, the script skips that video.
This lets you re-run the script without redoing work you already did.

When it finishes all videos, it prints “All done.” and waits for a keypress.

2. Script code (for reference)
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

3. Requirements

Windows (batch file / .bat support).

ffmpeg installed and added to the system PATH
(so you can type ffmpeg in Command Prompt and it runs).

The font file used for the timecode overlay:
C:\Windows\Fonts\arial.ttf
(this is the default Arial font on Windows).

4. How to use

Put your movie files (e.g. A Star Is Born-1080P.mp4, Bohemian Rhapsody.mkv, etc.) in a single folder.

Copy the script into a file named something like:
extract_keyframes.bat

Save extract_keyframes.bat inside the same folder as the movies.

Double-click the .bat file, or open Command Prompt in that folder and run:

extract_keyframes.bat


Wait while it processes each movie.

You’ll see messages like Processing "A Star Is Born-1080P.mp4"...

If it sees an existing folder, you’ll see Skipping "MovieName" - folder already exists.

When it’s done, each movie will have its own folder full of PNG keyframes with timecode.

5. Notes

Keyframes only: You don’t get every single frame, just the encoder’s important reference frames. This gives fewer but generally cleaner shots.

No cropping: The script saves the full video frame exactly as ffmpeg decodes it.

PNG = lossless: There is no additional compression loss from the script itself.

You might see messages like
Fontconfig error: Cannot load default config file in the console.
These are harmless and can be ignored as long as the frames and timecode are being generated correctly.
