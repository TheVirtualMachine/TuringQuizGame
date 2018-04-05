var fileName : string %The .quiz file name.
var playerList : flexible array 0 .. 0 of pointer to Player %Array of players.
var nextEmptyPort : int := 9002 %The next port that can be used.
var file : int %Input file.
var answers : int := 0 %Number of answers received.
var correctAnswers : int := 0 %Number of correctAnswers received.
var wrongAnswers : int := 0 %Number of wrong answered received.
var questionNumber : int %The number of questions.
var correctAnswer : string %What the correct answer is.
var lastAnswers : int := -1 %The last value of how many answers was received. This is used to prevent flickering.

%Check if the file name is valid.
proc checkFile
    loop
	put "What is the name of the quiz?"
	get fileName : *
	fileName := "Games/" + fileName + ".quiz"
	exit when File.Exists (fileName)
	put "File does not exist."
    end loop

    put "File found."
end checkFile



%Connect users until we don't want anymore.
proc connectUsers
    drawTitle

    var tempConnect : int
    var tempAddress : string

    var connectNum : int
    put "How many people are playing? " ..
    get connectNum

    put "Connect on:"
    put Net.LocalAddress

    for i : 1 .. connectNum

	tempConnect := Net.WaitForConnection (9001, tempAddress)
	put "New client ", tempConnect, " started connecting."
	var uName, uIP : string
	%Get the name and IP from the client.
	get : tempConnect, uName : *
	get : tempConnect, uIP
	put : tempConnect, nextEmptyPort
	%Close the Net connection.
	close : tempConnect

	new playerList, upper (playerList) + 1
	new Player, playerList (upper (playerList))
	Player (playerList (upper (playerList))).createPlayer (uName, nextEmptyPort)
	tempConnect := Net.WaitForConnection (nextEmptyPort, uIP)
	nextEmptyPort += 1
	Player (playerList (upper (playerList))).setConnection (tempConnect, uIP)
	put Player (playerList (upper (playerList))).getName ()

	put "New client finished connecting."

    end for
    put "No longer accepting clients."
end connectUsers

%Send text to a user.
proc sendText (text : string, user : int)
    var tConnect : int := Player (playerList (user)).getConnect %Use tConnect for more readable code.

    put : tConnect, text
end sendText

%Send text to every user.
proc sendTextToAll (text : string)

    for i : lower (playerList) + 1 .. upper (playerList)
	sendText (text, i)
	delay (100) %TODO: TEST
    end for

end sendTextToAll

%Wait until the continue button is pressed.
proc waitForContinue
    var continueButton : ^VincentButton
    new continueButton
    VincentButton (continueButton).createButton (0, 0, maxx div 15, maxy div 25, " Continue ")
    loop
	exit when VincentButton (continueButton).isClicked
    end loop
    free continueButton
end waitForContinue

%Display the question on the screen.
proc displayQuestion (question : string)
    drawTitle
    put question
end displayQuestion

%Reset the question stats.
proc resetStats
    answers := 0
    correctAnswers := 0
    wrongAnswers := 0
end resetStats

%Ask a question.
proc askQuestion

    var question, wrong1, wrong2, wrong3 : string
    get : file, question : *

    get : file, correctAnswer : *
    get : file, wrong1 : *
    get : file, wrong2 : *
    get : file, wrong3 : *


    sendTextToAll (question)
    sendTextToAll (correctAnswer)
    sendTextToAll (wrong1)
    sendTextToAll (wrong2)
    sendTextToAll (wrong3)

    displayQuestion (question)
end askQuestion

%Read in the answers.
proc getAnswers
    var tConnect : int
    var ans : boolean
    for i : lower (playerList) + 1 .. upper (playerList)
	tConnect := Player (playerList (i)).getConnect
	if (Net.LineAvailable (tConnect)) then
	    get : tConnect, ans

	    if (ans) then             %Check if answer is right.
		Player (playerList (i)).addCorrect
		correctAnswers += 1
	    else
		Player (playerList (i)).addWrong
		wrongAnswers += 1
	    end if
	    answers += 1
	end if
    end for
end getAnswers

%Update the number of answers count.
proc updateAnswerCount
    if (lastAnswers ~= answers) then
	var text : string
	text := intstr (answers) + " out of " + intstr (upper (playerList)) + " answers received."
	locate ((maxrow div 2) + 3, (maxcol div 2) - (length (text) div 2))
	put text
    end if
    lastAnswers := answers
end updateAnswerCount

%Display the question stats.
proc displayQuestionStats
    put "The correct answer was:"
    put correctAnswer
    put ""
    put intstr (answers) + " people answered, out of " + intstr (upper (playerList)) + " people playing."
    put intstr (correctAnswers) + " people were correct."
    put intstr (wrongAnswers) + " people were wrong."
end displayQuestionStats

%Run the quiz.
proc runQuiz
    var timePerQuestion : int
    var qStartTime : int

    open : file, fileName, get

    get : file, timePerQuestion
    sendTextToAll ("StartStats")     %Tell clients the game is starting, and they should recieve question data.

    sendTextToAll (intstr (timePerQuestion))
    get : file, questionNumber

    sendTextToAll (intstr (questionNumber))
    waitForContinue
    sendTextToAll ("StartGame")

    for i : 1 .. questionNumber
	exit when eof (file)
	drawTitle
	resetStats
	askQuestion
	qStartTime := Time.Sec
	loop     %Wait until we're out of time or everyone answered.
	    getAnswers
	    updateTimer (qStartTime, Time.Sec, timePerQuestion)
	    updateAnswerCount
	    exit when (((Time.Sec - qStartTime) >= timePerQuestion) or (answers >= upper (playerList)))
	end loop
	sendTextToAll ("EndQuestion")
	drawTitle
	displayQuestionStats
	waitForContinue
	getAnswers
	sendTextToAll ("NewQuestion")
    end for
end runQuiz

%Show the scores.
proc displayScores
    drawTitle
    put "Final Scores:"
    for i : 1 .. upper (playerList)
	put Player (playerList (i)).getName (), " scored ", Player (playerList (i)).getScore () : 4, "%"
    end for
    waitForContinue
end displayScores

%Disconnect everyone.
proc disconnectAll
    put ""
    for i : 1 .. upper (playerList)
	close : Player (playerList (i)).getConnect
    end for
    put "Everyone has been disconnected."
    waitForContinue
end disconnectAll

%Call all of the procedures to run the game.
proc hostGame

    drawTitle
    checkFile
    delay (1000)

    connectUsers
    delay (1000)
    runQuiz

    displayScores

    disconnectAll

    GUI.Quit
end hostGame
