%Delete the GUI buttons.
proc turnOffMenu
    GUI.Dispose (hostButton)
    GUI.Dispose (playButton)
    GUI.Dispose (quitButton)
end turnOffMenu

%Remove the menu, then run the host.
body proc runHost
    turnOffMenu

    hostGame
end runHost

%Remove the menu, then run the client.
body proc runClient
    turnOffMenu
    startClient
end runClient

%Display the game title, then refresh the GUI.
body proc menu
    drawTitle
    GUI.Refresh
end menu
