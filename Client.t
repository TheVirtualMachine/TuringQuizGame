var hostIP : string %IP of host.
var connect : int %Connection number to host.
var userName : string %The client's name.
var myIP : string %The client's IP.
var connectPort : int %The port to connect on.
var timePerQ : int %The time given per question.
var qNum : int %The number of questions.
var correct : boolean %If the answer was correct.

%Get the client's name.
proc getName
    drawTitle
    myIP := Net.LocalAddress
    put "What is your name?"
    get userName : *
end getName

%Wait for input from the server.
proc waitForData (connection : int)
    loop
	exit when Net.LineAvailable (connection)
    end loop
end waitForData

%Connect to the server, and return true if the connection worked, false if it did not.
fcn connectToServer : boolean
    drawTitle
    var tConnect : int
    put "Enter the host IP address."
    get hostIP
    tConnect := Net.OpenConnection (hostIP, 9001)
    put "Made temporary connection ", tConnect
    if (tConnect <= 0) then
	put "Connection failed. Did you type in the IP right?"
	delay (3000)
	put "Trying again in 3 seconds."
	delay (1000)
	put "Trying again in 2 seconds."
	delay (1000)
	put "Trying again in 1 second."
	delay (1000)
	result connectToServer ()
    end if

    put : tConnect, userName
    put : tConnect, myIP
    waitForData (tConnect)
    get : tConnect, connectPort

    close : tConnect

    connect := Net.OpenConnection (hostIP, connectPort)
    put "Make permanent connection ", connect
    if (connect <= 0) then
	put "Connection was established, then lost. The program will quit."
	pauseProgram
	result false
    end if

    result true
end connectToServer

%Wait for the server to say the next question is starting.
proc waitForNextQuestion (waitMessage : string)

    put waitMessage
    var temp : string

    loop
	exit when Net.LineAvailable (connect)
    end loop

    get : connect, temp

    %put "Recieved Message: ", temp

end waitForNextQuestion

%Play this question.
proc playQuestion
    drawTitle
    var answers : array 1 .. 4 of string     %Index 1 is correct.
    var pos : array 1 .. 4 of int := init (0, 0, 0, 0)
    var question : string
    var startTime : int := Time.Sec

    waitForData (connect)
    get : connect, question : *
    waitForData (connect)
    get : connect, answers (1) : *
    waitForData (connect)
    get : connect, answers (2) : *
    waitForData (connect)
    get : connect, answers (3) : *
    waitForData (connect)
    get : connect, answers (4) : *

    var picked : boolean := false
    var newVal : int
    for i : 1 .. 4
	loop
	    picked := false
	    newVal := Rand.Int (1, 4)
	    for k : 1 .. 4
		if newVal = pos (k) then
		    picked := true
		    exit
		end if
	    end for
	    exit when ( ~picked)
	end loop
	pos (i) := newVal
    end for

    put question
    put ""
    put "Press the number key for the answer you want to select:"

    for i : 1 .. 4
	put i, ": ", answers (pos (i))
    end for

    var ans : char

    var finalAns : string
    Input.Flush
    loop

	updateTimer (startTime, Time.Sec, timePerQ)

	if hasch then
	    ans := getchar
	    if (ans >= '1' and ans <= '4') then
		finalAns := answers (pos (strint (ans)))
		exit
	    end if
	end if

	if Net.LineAvailable (connect) then
	    put : connect, false
	    correct := false
	    return
	end if

    end loop

    correct := finalAns = answers (1)

    put : connect, correct

end playQuestion

%Tell the user if they were right or wrong.
proc displayCorrect
    drawTitle
    if correct then
	put "You get 1 point!"
    else
	put "You get 0 points."
    end if
end displayCorrect

%Get the game stats.
proc getGameVals
    var temp : string
    waitForData (connect)
    get : connect, temp
    timePerQ := strint (temp)
    waitForData (connect)
    get : connect, temp
    qNum := strint (temp)
end getGameVals

%Play the game.
proc playGame
    waitForNextQuestion ("Succesfully connected. Waiting for game to start.")
    getGameVals
    waitForNextQuestion ("Waiting for the first question.")
    for i : 1 .. qNum
	playQuestion
	waitForNextQuestion ("Waiting for the current question to end.")
	displayCorrect
	waitForNextQuestion ("Waiting for the next question to start.")
    end for
end playGame

%Run the client.
proc startClient
    getName

    if ( ~connectToServer ()) then   %If the game already started.
	return
    end if

    playGame
    GUI.Quit
end startClient
