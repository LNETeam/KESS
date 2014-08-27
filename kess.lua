
function flist(n) --lists files cleanly for n path
	FileList = fs.list(n) --Table with all the files and directories available
	trk=1
	for _, file in ipairs(FileList) do --Loop. Underscore because we don't use the key, ipairs so it's in order
		print(trk..":"..file) --Print the file name
		trk=trk+1
	end --End the loop
end

function addslash()
	strlen=string.len(strdir) --get length
	if strdir[strlen]~='/' then --add / to prevent creation of new files
		strdir=strdir.."/"
	end
end 

 
disk=fs.exists("/disk")--checks if disk is in
term.clear()--clears OS bs

print'Welcome to the Kizz Easy Storage Server'
print''
print'Default settings store to /Store.'
print'Please make a choice:'
print'1: Write from Storage to Floppy'
print'2: Write from Floppy to Storage'
print'3: Delete a file from Storage'
print'4: Delete a file from Floppy'
print'5: View Storage'
print'6: View Disk'
print'7: Change Storage Directory'

ch=io.read()--get choice
---------------------------------------------- Checks for valid options
if ch~="1" and ch~="2" and ch~="3" and ch~="4" and ch~="5" and ch~="6" and ch~="7" then --input check
	print'Bad input idiot!'
	sleep(.5)
end
if ch=="1" or ch=="2" or ch=="3" or ch=="4" or ch=="5" or ch=="6" or ch=="7" then--double check
	ch=ch+1-1--convert to numeric
end

if fs.exists("/Store/")==false then
	fs.makeDir("/Store/")
end


strdir="/Store/" --sets default directory
if fs.exists("/kessconfig") then
	cfg=fs.open("kessconfig","r")
	strdir=cfg.readLine() --read config
	addslash()
	cfg.close()
end

-- This has to go before the rest of the choices to prevent using wrong dir
if ch==7 then --allows user to change default directory
	print'Please enter the new directory, being sure to include pre and post slashes.'
	print'Ex: /Deep/Storage/Example/'
	
	strdir=io.read()
	chkdirstr=fs.exists(strdir)
	if chkdirstr==true then --if suggested dir exists, create config, write new default dir, close
		cfg=fs.open("kessconfig","w")
		addslash()
		cfg.write(strdir)
		cfg.close()
		print'Directory exists. Storage directory altered.'
	end
	if chkdirstr==false then --if dir missing, create dir, write new config, close
		print'Directory missing. Would you like to create it?'
		print'Press 1 to continue or 2 to cancel.'
		dirch=io.read()
		dirch=dirch+1-1
		if dirch==1 then
			fs.makeDir(strdir)
			print'Directory created.'
			cfg=fs.open("kessconfig","w")
			addslash()
			cfg.write(strdir)
			cfg.close()
			print'Default directory altered.'
		end
		if dirch==2 then --cancel and revert
			print'Reverting to default directory.'
			strdir="/Store/"
		end
	end
end

----------------------------------------------

if ch==1 and disk==true then --from store to floppy
	print'Listing files on Storage...'
	sleep(.2)
	flist(strdir)--lists storage
	print'Please type the number you wish to add to floppy:'
	sTf=io.read()--choose a file to copy
	sTf=sTf+1-1
	fdir=FileList[sTf]
	--Function to check if disk exists
	ow=fs.exists("/disk/"..fdir)--check if it exists on floppy
	
	if ow==false then --if doesnt exist, copy
		fs.copy(strdir..""..fdir,"/disk/"..fdir)
		print'Added file to floppy.'
		sleep(.2)
	end
	
	if ow==true then --if does exist, prompt to overwrite
		print
		'You are about to overwrite a file. Press 1 to continue or 2 to exit.'
		owp=io.read()
		owp=owp+1-1
		
		if owp==1 then --yes overwrite
			print'deleting'
			fs.delete("/disk/"..fdir) --delete old
			sleep(.2)
			print'copying'
			fs.copy(strdir..""..fdir,"/disk/"..fdir) --replace new
			print'Added file to floppy.'
			sleep(.2)
		end
		
		if owp==2 then --no cancel
			print'Cancelling'
			sleep(.2) --delay then break
		end
		
		print'Press any key to continue.'
		io.read()
	end
end

if ch==1 and disk==false then --if no disk then quit
	print'Failed to find disk.'
	print'Press any key to continue.'
	io.read()
end

--------------------------------------------

if ch==2 and disk==true then --copy from floppy to store
	print'Listing files on floppy...'
	sleep(.2)
	flist("/disk") --list file on floppy
	print'Please type the number you wish to choose:'
	sTf=io.read() --choose file
	sTf=sTf+1-1
	fdir=FileList[sTf]
	ow=fs.exists(strdir..""..fdir)--check if exists in store
	
	if ow==false then --doesnt exist
		fs.copy("/disk/"..fdir,strdir..""..fdir) --copy to store
		print'Added file to storage.'
		sleep(.2)
	end
	
	if ow==true then --does exist, prompt to overwrite
		print
		'You are about to overwrite a file. Press 1 to continue or 2 to exit.'
		owp=io.read()
		owp=owp+1-1
	if owp==1 then --yea overwrite
		print'deleting'
		fs.delete(strdir..""..fdir) --delete old
		sleep(.2)
		print'copying'
		fs.copy("/disk/"..fdir,strdir..""..fdir) --copy new
		print'Added file to storage.'
		sleep(.2)
	end
	
	if owp==2 then --cancel 
		print'Cancelling'
		sleep(.2)
	end
	
	print'Press any key to continue.'
	io.read()
	end
end

if ch==2 and disk==false then --no disk inserted
print'Failed to find disk.'
print'Press any key to continue.'
io.read()
end

--------------------------------------------


if ch==3 then --delete in Store
	print'Listing files in storage...'
	sleep(.2)
	flist(strdir)--list storage files
	print'Please choose a file to delete or press ctrl+r to reboot.'
	sTf=io.read() --choose file
	sTf=sTf+1-1
	fdir=FileList[sTf]
	print'Deleting...'
	fs.delete(strdir..""..fdir) --delete file
	print'Deleted!'
	print'Press any key to continue.'
	io.read()
end

--------------------------------------------

if ch==4 and disk==true then --delete on disk
	print'Listing files in disk...'
	sleep(.2)
	flist("/disk/") --list disk
	print'Please choose a file to delete or press ctrl+r to reboot.'
	sTf=io.read() --choose file
	sTf=sTf+1-1
	fdir=FileList[sTf]
	print'Deleting...'
	fs.delete("/disk/"..fdir) --delete file
	print'Deleted!'
	print'Press any key to continue.'
	io.read()
end

if ch==4 and disk==false then --no disk found
	print'Failed to find a floppy.'
	print'Press any key to continue.'
	io.read()
end

--------------------------------------------

if ch==5 then -- list storage
	print'Listing files in storage...'
	sleep(.2)
	flist(strdir)
	print'Press any key to continue.'
	io.read()
end

--------------------------------------------

if ch==6 and disk==true then --list disk
	print'Listing files in disk...'
	sleep(.2)
	flist("/disk")
	print'Press any key to continue.'
	io.read()
end

if ch==6 and disk==false then --no disk found
	print'Cannot find a disk.'
	print'Press any key to continue.'
	io.read()
end

--------------------------------------------

os.reboot()
