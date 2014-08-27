
function flist(n) --lists files cleanly for n path
	FileList = fs.list(n) --Table with all the files and directories available
	trk=1
	for _, file in ipairs(FileList) do --Loop. Underscore because we don't use the key, ipairs so it's in order
		print(trk..":"..file) --Print the file name
		trk=trk+1
	end --End the loop
end


disk=fs.exists("/disk")--checks if disk is in
term.clear()--clears OS bs

print'Welcome to the Kizz Easy Storage Server'
print''
print'Please make a choice:'
print'1: Write from Storage to Floppy'
print'2: Write from Floppy to Storage'
print'3: Delete a file from Storage'
print'4: Delete a file from Floppy'
print'5: View Storage'
print'6: View Disk'

ch=io.read()--get choice
---------------------------------------------- Checks for valid options
if ch~="1" and ch~="2" and ch~="3" and ch~="4" and ch~="5" and ch~="6" then --input check
	print'Bad input idiot!'
	sleep(.5)
end
if ch=="1" or ch=="2" or ch=="3" or ch=="4" or ch=="5" or ch=="6" then--double check
	ch=ch+1-1--convert to numeric
end

----------------------------------------------

if ch==1 and disk==true then --from store to floppy
	print'Listing files on Storage...'
	sleep(.5)
	flist("/Store")--lists storage
	print'Please type the number you wish to add to floppy:'
	sTf=io.read()--choose a file to copy
	sTf=sTf+1-1
	fdir=FileList[sTf]
	--Function to check if disk exists
	ow=fs.exists("/disk/"..fdir)--check if it exists on floppy
	
	if ow==false then --if doesnt exist, copy
		fs.copy("/Store/"..fdir,"/disk/"..fdir)
		print'Added file to floppy.'
		sleep(1)
	end
	
	if ow==true then --if does exist, prompt to overwrite
		print
		'You are about to overwrite a file. Press 1 to continue or 2 to exit.'
		owp=io.read()
		owp=owp+1-1
		
		if owp==1 then --yes overwrite
			print'deleting'
			fs.delete("/disk/"..fdir) --delete old
			sleep(1)
			print'copying'
			fs.copy("/Store/"..fdir,"/disk/"..fdir) --replace new
			print'Added file to floppy.'
			sleep(1)
		end
		
		if owp==2 then --no cancel
			print'Cancelling'
			sleep(1) --delay then break
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
	sleep(.5)
	flist("/disk") --list file on floppy
	print'Please type the number you wish to choose:'
	sTf=io.read() --choose file
	sTf=sTf+1-1
	fdir=FileList[sTf]
	ow=fs.exists("/Store/"..fdir)--check if exists in store
	
	if ow==false then --doesnt exist
		fs.copy("/disk/"..fdir,"/Store/"..fdir) --copy to store
		print'Added file to storage.'
		sleep(1)
	end
	
	if ow==true then --does exist, prompt to overwrite
		print
		'You are about to overwrite a file. Press 1 to continue or 2 to exit.'
		owp=io.read()
		owp=owp+1-1
	if owp==1 then --yea overwrite
		print'deleting'
		fs.delete("/Store/"..fdir) --delete old
		sleep(1)
		print'copying'
		fs.copy("/disk/"..fdir,"/Store/"..fdir) --copy new
		print'Added file to storage.'
		sleep(1)
	end
	
	if owp==2 then --cancel 
		print'Cancelling'
		sleep(1)
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
	sleep(.5)
	flist("/Store")--list storage files
	print'Please choose a file to delete or press ctrl+r to reboot.'
	sTf=io.read() --choose file
	sTf=sTf+1-1
	fdir=FileList[sTf]
	print'Deleting...'
	fs.delete("/Store/"..fdir) --delete file
	print'Deleted!'
	print'Press any key to continue.'
	io.read()
end

--------------------------------------------

if ch==4 and disk==true then --delete on disk
	print'Listing files in disk...'
	sleep(.5)
	flist("/disk") --list disk
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
	sleep(.5)
	flist("/Store")
	print'Press any key to continue.'
	io.read()
end

--------------------------------------------

if ch==6 and disk==true then --list disk
	print'Listing files in disk...'
	sleep(.5)
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
