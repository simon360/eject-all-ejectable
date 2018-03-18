use AppleScript version "2.4" -- Yosemite (10.10) or later
use scripting additions

-- CONFIGURATION

-- The title to show when all ejectable disks ejected successfully
set safeMessage to "Safe to disconnect"

-- The title to show when one or more ejectable disks did not eject
set failMessage to "Some disks did not eject"

-- Show drives that were skipped (likely not ejectable, or in the skip list)
set showSkipped to false

-- A list of names of drives that shouldn't be ejected by this script
--
-- Examples:
--   set drivesToSkip to {"External file storage"}
--   set drivesToSkip to {"Some network location", "CD Drive"}
set drivesToSkip to {}

-- // END CONFIGURATION

tell application "Finder"
	-- APPLICATION ACTIONS
	
	-- Working lists
	set ejected to {}
	set notEjected to {}
	set skipped to {}
	
	-- Get every disk, and convert to a list (so it doesn't change while we're working)
	set allDisks to every disk as list
	
	repeat with currentDisk in allDisks
		set currentDiskName to name of currentDisk as string
		
		if currentDisk is ejectable and not (drivesToSkip contains currentDiskName) then
			eject currentDisk
			
			if currentDisk exists then
				-- Tried to eject, but disk still exists
				copy currentDiskName to end of notEjected
			else
				-- Eject succeeded
				copy currentDiskName to end of ejected
			end if
		else
			-- Either not ejectable, or in the skip list
			copy currentDiskName to end of skipped
		end if
	end repeat
	
	-- // END APPLICATION ACTIONS
	
	-- REPORTING
	
	-- Convert the working lists to comma-delimited strings
	set saveTID to AppleScript's text item delimiters
	set AppleScript's text item delimiters to {", "}
	set ejected to ejected as string
	set notEjected to notEjected as string
	set skipped to skipped as string
	set AppleScript's text item delimiters to saveTID
	
	-- Piece together the alert
	set alertMessage to ""
	
	-- First item: show disks that failed to eject (if any)
	if length of notEjected is greater than 0 then
		set alertMessage to alertMessage & "Could not eject " & notEjected
	end if
	
	-- Second item: show disks that ejected (if any)
	if length of ejected is greater than 0 then
		if length of alertMessage is greater than 0 then
			-- Add a couple of newlines if a previous message exists
			set alertMessage to alertMessage & "

"
		end if
		set alertMessage to alertMessage & "Ejected " & ejected
	end if
	
	-- Third item: show skipped disks (if any, and showSkipped enabled)
	if showSkipped is true and length of skipped is greater than 0 then
		if length of alertMessage is greater than 0 then
			-- Add a couple of newlines if a previous message exists
			set alertMessage to alertMessage & "

"
		end if
		set alertMessage to alertMessage & "Skipped " & skipped
	end if
	
	-- Change the title based on whether notEjected is populated
	if length of notEjected is 0 then
		set title to safeMessage
	else
		set title to failMessage
	end if
	
	-- Activate, to ensure that the dialog shows in the foreground
	activate
	
	-- And we're done. Show the alert.
	display alert title message alertMessage
	
	-- // END REPORTING
end tell
