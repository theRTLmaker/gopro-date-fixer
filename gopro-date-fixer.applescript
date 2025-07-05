use framework "Foundation"
use framework "AppKit"
use scripting additions

set exiftoolPath to "/opt/homebrew/bin/exiftool" -- Adjust this path if needed

-- Prompt user to select GoPro files
set photoFiles to choose file with prompt "Select GoPro files to modify" with multiple selections allowed

-- Ask user whether they want to apply an offset or set a specific date
set userChoice to button returned of (display dialog "Would you like to shift the date or set a new date?" buttons {"Shift Date", "Set Date"} default button "Shift Date")

set shiftDays to 0
set newDate to ""

if userChoice is "Shift Date" then
	set shiftDays to text returned of (display dialog "Enter number of days to shift (+ forward, - backward):" default answer "0")
else if userChoice is "Set Date" then
	set newDate to text returned of (display dialog "Enter new date (YYYY-MM-DD):" default answer "2024-01-01")
end if

repeat with photoIndex from 1 to count of photoFiles
	set photo to item photoIndex of photoFiles
	set photoPath to POSIX path of photo
	set the result to "Processing " & (name of (info for photo)) & " – " & photoIndex & "/" & (count of photoFiles)
	set fileExtension to do shell script "echo " & quoted form of photoPath & " | awk -F. '{print tolower($NF)}'"
	
	if fileExtension is in {"jpg", "jpeg", "png"} then
		set exifField to "-DateTimeOriginal"
	else if fileExtension is in {"mov", "mp4", "lrv"} then
		set exifField to "-CreateDate"
	else if fileExtension is "thm" then
		set exifField to ""
	else
		display dialog "Unsupported file type: " & fileExtension buttons {"OK"} default button "OK"
		exit repeat
	end if
	
	if userChoice is "Shift Date" then
		if exifField is not "" then
			if fileExtension is in {"mp4", "mov", "lrv"} then
				set shiftCommand to exiftoolPath & " " & ¬
					"-CreateDate+=0:0:" & shiftDays & " " & ¬
					"-ModifyDate+=0:0:" & shiftDays & " " & ¬
					"-TrackCreateDate+=0:0:" & shiftDays & " " & ¬
					"-TrackModifyDate+=0:0:" & shiftDays & " " & ¬
					"-MediaCreateDate+=0:0:" & shiftDays & " " & ¬
					"-MediaModifyDate+=0:0:" & shiftDays & " " & ¬
					"-Keys:CreationDate+=0:0:" & shiftDays & " " & ¬
					"-overwrite_original " & quoted form of photoPath
			else
				set shiftCommand to exiftoolPath & " " & ¬
					"-DateTimeOriginal" & "+=\"0:0:" & shiftDays & " 0:0:0\" " & ¬
					"-ModifyDate" & "+=\"0:0:" & shiftDays & " 0:0:0\" " & ¬
					"-CreateDate" & "+=\"0:0:" & shiftDays & " 0:0:0\" " & ¬
					"-overwrite_original " & quoted form of photoPath
			end if
			-- display dialog "Executing: " & shiftCommand
			do shell script shiftCommand
		end if
		
	else if userChoice is "Set Date" then
		if exifField is not "" then
			set currentTime to do shell script exiftoolPath & " " & exifField & " -d '%H:%M:%S' " & quoted form of photoPath
			set currentTime to do shell script "echo " & quoted form of currentTime & " | sed 's/^.*: //'"
			
			set formattedNewDate to newDate & " " & currentTime
			
			if fileExtension is in {"mp4", "mov", "lrv"} then
				set setDateCommand to exiftoolPath & " " & ¬
					"-CreateDate='" & formattedNewDate & "' " & ¬
					"-ModifyDate='" & formattedNewDate & "' " & ¬
					"-TrackCreateDate='" & formattedNewDate & "' " & ¬
					"-TrackModifyDate='" & formattedNewDate & "' " & ¬
					"-MediaCreateDate='" & formattedNewDate & "' " & ¬
					"-MediaModifyDate='" & formattedNewDate & "' " & ¬
					"-Keys:CreationDate='" & formattedNewDate & "' " & ¬
					"-overwrite_original " & quoted form of photoPath
			else
				set setDateCommand to exiftoolPath & " " & ¬
					"-DateTimeOriginal='" & formattedNewDate & "' " & ¬
					"-ModifyDate='" & formattedNewDate & "' " & ¬
					"-CreateDate='" & formattedNewDate & "' " & ¬
					"-overwrite_original " & quoted form of photoPath
			end if
			
			-- display dialog "Executing: " & setDateCommand
			do shell script setDateCommand
		end if
	end if
	
	-- Update macOS Finder "Date Created" metadata
	if fileExtension is in {"jpg", "jpeg", "png", "thm"} then
		set updatedDate to do shell script exiftoolPath & " -DateTimeOriginal -d '%m/%d/%Y %H:%M:%S' " & quoted form of photoPath
		set updatedDate to do shell script "echo " & quoted form of updatedDate & " | sed 's/^.*: //'"
		
		set setFileCommand to "/usr/bin/SetFile -d " & quoted form of updatedDate & " " & quoted form of photoPath
		-- display dialog "Executing: " & setFileCommand
		do shell script setFileCommand
	end if
	
	if fileExtension is in {"mp4", "mov", "lrv"} then
		set updatedDate to do shell script exiftoolPath & " -CreateDate -d '%m/%d/%Y %H:%M:%S' " & quoted form of photoPath
		set updatedDate to do shell script "echo " & quoted form of updatedDate & " | sed 's/^.*: //'"
		
		set setFileCommand to "/usr/bin/SetFile -d " & quoted form of updatedDate & " " & quoted form of photoPath
		-- display dialog "Executing: " & setFileCommand
		do shell script setFileCommand
	end if
end repeat

display dialog "Metadata and creation date updated!" buttons {"OK"} default button "OK"
