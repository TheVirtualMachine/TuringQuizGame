%Class for the VincentButton object.
unit
class VincentButton
    export button, createButton, isClicked

	%Declare the button record.
    type button :
	record
	    x1, y1, x2, y2 : int
	    text : string
	end record

    var thisButton : button %Allow the class to refer to itself.
    var canClick : boolean := false %If the button can be clicked.

	%Creates a button.
    proc createButton (xPos, yPos, bWidth, bHeight : int, bText : string)
	var width : int := bWidth  %Width of button
	var height : int := bHeight %Height of button

	var textWidth : int := 1 %Width of text
	var textHeight : int := 1 %Height of text
	var correctSize : int %Used to store the correct text size.
	var size : int := 1 %What the size of the font currently is.
	var fontName : string
	var font : int
	var temp : int %Used because Font.Sizes requires a variable as a parameter.
	loop
	    %Increment size by one.
	    size += 1
	    fontName := "default:" + intstr (size - 1)
	    font := Font.New (fontName)
	    textWidth := Font.Width (bText, font) + 4
	    Font.Sizes (font, textHeight, temp, temp, temp)
	    Font.Free (font)
	    exit when ((textWidth >= width) or (textHeight >= height))
	end loop
	fontName := "default:" + intstr (size - 1)
	font := Font.New (fontName)

	%Assign values
	thisButton.x1 := xPos
	thisButton.x2 := xPos + bWidth
	thisButton.y1 := yPos
	thisButton.y2 := yPos + bHeight
	thisButton.text := bText

	%Draw the button.
	drawfillbox (thisButton.x1, thisButton.y1, thisButton.x2, thisButton.y2, grey)
	drawbox (thisButton.x1, thisButton.y1, thisButton.x2, thisButton.y2, black)
	Font.Draw (bText, thisButton.x1 + 1, thisButton.y2 - textHeight + 1, font, black)
	Font.Free (font) %Remove the font.
    
	end createButton

	%Return if this button was clicked.
    fcn isClicked : boolean
	var x, y, m : int %Declare x,y, and m (mouse button) for keeping track of the mouse.
	Mouse.Where (x, y, m)
	if (m = 0) then %Prevent click detection if the mouse happens to be down where the button is created when it is created.
	    canClick := true
	end if
	%If the button was clicked.
	if (canClick and m = 1 and x >= thisButton.x1 and x <= thisButton.x2 and y >= thisButton.y1 and y <= thisButton.y2) then
	    result true
	else
	    result false
	end if
    end isClicked

end VincentButton
