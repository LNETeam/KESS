
function flist(n)
 FileList = fs.list(n) --Table with all the files and directories available
trk=1
for _, file in ipairs(FileList) do --Loop. Underscore because we don't use the key, ipairs so it's in order
  print(trk..":"..file) --Print the file name
  trk=trk+1
end --End the loop
end


disk=fs.exists("/disk")







term.clear()
print'Welcome to the Kizz Easy Storage Server'
print''
print'Please make a choice:'
print'1: Write from Storage to Floppy'
print'2: Write from Floppy to Storage'
print'3: View Storage'

ch=io.read()

if ch~="1" and ch~="2" and ch~="3" then --input check
	print'Bad input idiot!'
	sleep(.5)
end
if ch=="1" or ch=="2" or ch=="3" then--double check
	ch=ch+1-1--convert to numeric
end



if ch==1 and disk==true then
print'Listing files on Storage...'
sleep(.5)
flist("/Store")
print'Please type the number you wish to add to floppy:'
sTf=io.read()
sTf=sTf+1-1
fdir=FileList[sTf]
--Function to check if disk exists

ow=fs.exists("/disk/"..fdir)


if ow==false then
fs.copy("/Store/"..fdir,"/disk/"..fdir)
print'Added file to floppy.'
sleep(1)
end

if ow==true then
print
'You are about to overwrite a file. Press 1 to continue or 2 to exit.'
owp=io.read()
owp=owp+1-1
if owp==1 then
print'deleting'
fs.delete("/disk/"..fdir)

sleep(1)
print'copying'
fs.copy("/Store/"..fdir,"/disk/"..fdir)
print'Added file to floppy.'
sleep(1)
end
if owp==2 then
print'Cancelling'
sleep(1)
end
print'Press any key to continue.'
io.read()
end
end



if ch==1 and disk==false then
print'Failed to find disk.'
print'Press any key to continue.'
io.read()
end


if ch==2 and disk==true then
print'Listing files on floppy...'
sleep(.5)
flist("/disk")
print'Please type the number you wish to choose:'
sTf=io.read()
sTf=sTf+1-1
fdir=FileList[sTf]

--Function to check if disk exists

ow=fs.exists("/Store/"..fdir)


if ow==false then
fs.copy("/disk/"..fdir,"/Store/"..fdir)
print'Added file to storage.'
sleep(1)
end

if ow==true then
print
'You are about to overwrite a file. Press 1 to continue or 2 to exit.'
owp=io.read()
owp=owp+1-1
if owp==1 then
print'deleting'
fs.delete("/Store/"..fdir)
sleep(1)
print'copying'
fs.copy("/disk/"..fdir,"/Store/"..fdir)
print'Added file to storage.'
sleep(1)
end
if owp==2 then
print'Cancelling'
sleep(1)
end
print'Press any key to continue.'
io.read()
end
end
if ch==2 and disk==false then
print'Failed to find disk.'
print'Press any key to continue.'
io.read()
end

if ch==3 then
print'Listing files in storage...'
sleep(.5)
flist("/Store")
print'Press any key to continue.'
io.read()
end

os.reboot()
