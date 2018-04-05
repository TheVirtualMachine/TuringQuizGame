var title : string := "Vincent's Quiz Game" %The screen title.
var lastTimerVal : int := -1 %Used to prevent the timer from flickering.

%Clear the screen and draw the title centered.
proc drawTitle
    cls
    locate (1, maxcol div 2 - length (title) div 2)
    put title
    put ""
end drawTitle

%Wait for user to continue.
proc pauseProgram
    put "Press any key to continue..."
    Input.Pause
end pauseProgram

%Show how much time is left for this question.
proc updateTimer (sTime, cTime, qTime : int)
    var timeLeft : int := qTime - (cTime - sTime)
    if (lastTimerVal ~= timeLeft) then
	locate (maxrow div 2, maxcol div 2)
	put qTime - (cTime - sTime)
	lastTimerVal := timeLeft
    end if
end updateTimer

%Display the goodbye message.
proc goodbye
    drawTitle
    put "Thank you for using this program!"
    put "You have reached the end."
    put ""
    pauseProgram
    Window.Close (window)
end goodbye
