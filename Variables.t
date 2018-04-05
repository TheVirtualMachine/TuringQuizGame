var window : int := Window.Open ("graphics:max,max;nobuttonbar") %Output window.

%Menu buttons
var hostButton : int := GUI.CreateButtonFull (0, maxy - maxy div 7, maxx div 3, "Host Game", runHost, maxy div 10, '1', false)
var playButton : int := GUI.CreateButtonFull (maxx div 3, maxy - maxy div 7, maxx div 3, "Play Game", runClient, maxy div 10, '2', false)
var quitButton : int := GUI.CreateButtonFull (maxx - maxx div 3, maxy - maxy div 7, maxx div 3, "Quit", GUI.Quit, maxy div 10, '3', false)

%Set menu button colours.
GUI.SetColour (hostButton, 79)
GUI.SetColour (playButton, 10)
GUI.SetColour (quitButton, 12)
