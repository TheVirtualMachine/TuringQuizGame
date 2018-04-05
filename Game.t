/*
 Vincent Macri
 TEJ2O3-01
 Mr. Fourman
 13/12/2016
 The main file for my ISP. Run this file.
 My game is a multiplayer quiz game. It works over LAN.
 It should work over the Internet if you port forward, but that has not been tested.
 */

%Import class files.
import GUI, "Player.tu", "VincentButton.tu"
%Include .t files.
include "Forwards.t"
include "Variables.t"
include "VisualScreens.t"
include "Client.t"
include "Host.t"
include "Menu.t"

menu %Call menu.
loop
    exit when GUI.ProcessEvent %Button processing.
end loop
goodbye %Goodbye screen.
