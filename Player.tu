%Class for the Player object.
unit
class Player
    export getName, getScore, getCorrect, getWrong, createPlayer, addWrong, addCorrect, setConnection, getConnect

	%Declare player record.
    type player :
	record
	    userName : string
	    port : int
	    score : real
	    correct : int
	    wrong : int
	    connect : int
	    address : string
	end record
	
    var me : player %Allow the class to refer to itself.

	%Assign the values for the new player.
    proc createPlayer (name : string, connectPort : int)
	me.userName := name
	me.port := connectPort
	me.score := 0
	me.correct := 0
	me.wrong := 0
    end createPlayer

	%Return the player name.
    fcn getName : string
	result me.userName
    end getName

	%Return the player score.
    fcn getScore : real
	result me.score
    end getScore

	%Return how many answers this player has gotten correct.
    fcn getCorrect : int
	result me.correct
    end getCorrect

	%Return how many answers this player has gotten wrong.
    fcn getWrong : int
	result me.wrong
    end getWrong

	%Calculate the player score as a percentage.
    proc calcScore
	if (me.correct <= 0) then
	    me.score := 0
	else
	    me.score := (me.correct / (me.correct + me.wrong)) * 100
	end if
    end calcScore

	%Add one to the player's wrong count, and recalculate the score.
    proc addWrong
	me.wrong += 1
	calcScore
    end addWrong

	%Add one the player's correct count, and recalculate the score.
    proc addCorrect
	me.correct += 1
	calcScore
    end addCorrect

	%Set the IP and connection number for the player.
    proc setConnection (c : int, ip : string)
	me.connect := c
	me.address := ip
    end setConnection

	%Return the connection number of the player.
    fcn getConnect : int
	result me.connect
    end getConnect

end Player

