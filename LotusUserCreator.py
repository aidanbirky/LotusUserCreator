import os
import time
import sys

banner = r'''

      ##     ##    ##
     ####   ####  ####       Lotus Notes User Registration Script v2.4
     ####   ####  ####       Written by - Aidan
      ##     ##    ##
                             Last Updated - 23 September 2014
  #######    ##    #######
  ########  ####  ########
      ####  ####  ####
      ####  ####  ####       Assumes ID files are store in D:\lotus\NotesIDs\Users\
      ####  ####  ####
      ####  ####  ####
      ####  ####  ####
      ####  ####  ####       Ensure you read the ReadMe at the
       ##    ##    ##        main menu before use!

     '''
color = 'color 0E'
exit = 'exit'
cls = 'cls'
windowheight = 'mode con lines=35'
windowwidth = 'mode con cols=100'
servernumber = ''

os.system(color)
os.system(windowwidth)
os.system(windowheight)
os.system(cls)
print(banner)

CECloop = True

while CECloop:
	CEC = input("  Enter the system CEC --> ")
	if len(CEC) >3:
		print("  error. CEC should be 3 characters.")
		time.sleep(2)
		os.system(cls)
		print(banner)
	elif len(CEC) <3:
		print("  error. CEC should be 3 characters.")
		time.sleep(2)
		os.system(cls)
		print(banner)
	else:
		CECloop = False

suite = CEC[0]

servernameloop = True
while servernameloop:
	if suite in ():
		servernumber = ''
		servernameloop = False
	else:
		servernumber = ''
		servernameloop = False

os.system(cls)
print(banner)

classificationloop = True

while classificationloop:
	classification = input("  Is the system ... --> ")
	if classification in ('', '', '', ''):
		classificationloop = False
		os.system(cls)
		print(banner)
	else:
		print("  Ensure you only enter either '' or ''")
		time.sleep(1)
		os.system(cls)
		print(banner)

if classification in (, 'R'):
	mailtemplate = ('.ntf')

else:
	mailtemplate = ('')

servername =
winservername =
menu = ''

def main(menu):
	menuloop = True
	while menuloop:
		os.system(cls)
		print(banner)
		cmd = input(r'''  ######    Main Menu    ######

  1. Create Notes user import file
  2. UserData Setup
  3. ReadMe
  4. Exit

  --> ''')

		if cmd == '1':
			importfile(menu)
		elif cmd == '2':
			userdata(menu)
		elif cmd == '3':
			readme(menu)
		elif cmd == '4':
			exit(menu)
		elif cmd >('9000'):
			ninethousand(menu)
		else:
			print("  Sorry, that's not an option. Try again.")
			time.sleep(1)

def importfile(menu):
	os.system(cls)
	print(banner)

	importloop = True
	while importloop:
		textloc = input(r"  Enter the file path of your list (eg.'C:\names_list.txt') --> ")
		textfileopen = open(textloc, 'r')
		temp = []
		for line in textfileopen:
			item = line.strip('\n').split('.')
			temp.append((r';').join(item[::-1])+';'*3+(r'password;D:\lotus\NotesIDs\Users\;')+''.join(item)+(r'.id;')+''.join(servername)+(r';mail\;')+''.join(item)+ (r'.nsf') + ';'*10 +''.join(mailtemplate))
		os.system(cls)
		print(banner)
		print('  Please wait...........')
		time.sleep(1)
		os.system(cls)
		print(banner)
		importfile = open('User_Import_File.txt', 'w')
		importfile.write('\n'.join(temp))
		textfileopen.close()
		importfile.close()
		print('  Done! User_Import_File.txt has successfully been created!')
		input('  Press enter to continue')
		importloop = False


def userdata(menu):
	os.system(cls)
	print(banner)
	logfile = 'UserData_log.txt'
	userdataloop = True

	while userdataloop:
		firstname = input('  Enter first name here --> ')
		os.system(cls)
		print (banner)
		lastname = input('  Enter last name here (including any number) --> ')
		os.system(cls)
		print (banner)
		print('  Please wait...........')
		username = firstname + '.' + lastname
		idfile = firstname + lastname + '.id'
		notesusersetup = '''[NotesUserSetup]
'''.format(username, idfile, servername)

		idmove = r"copy /V /Y \\{0}\d$\lotus\NotesIDs\Users\{1} \\server\Userdata\{4}\Notes8\{1} "
		mkdir = r"mkdir \\server\Userdata\{2}\Notes8"
		os.system(mkdir)
		time.sleep(1)
		os.system(idmove)

		f = open(r'\\server\Userdata\{2}\Notes8\NotesUserSetup.ini'.format(), 'w')
		f.write(notesusersetup)
		f.close()
		os.system(cls)
		print(banner)
		print('  Done!')
		time.sleep(1)

		f = open(logfile, 'a')
		f.write(time.strftime('%d/%m/%Y %X - '))
		f.write(CEC)
		f.write(r' - ')
		f.write(username)
		f.write(" - Notes8 Folder Created Successfully")
		f.write('\n')
		f.close()

		os.system(cls)
		print(banner)
		print('''  Last created --> {0} {1}\n'''.format(firstname, lastname))

		loop = input("  Is there another user to setup? 'y' or 'n' ---> ")
		if loop == 'n':
			os.system(cls)
			userdataloop = False
		else:
			os.system(cls)
			print(banner)
	main(menu)

def readme(menu):
	os.system(cls)
	print(banner)
	input(r'''  ######    READ ME    ######

  This program has two core funtions;
            - Creating a text file used in bulk user Registration
            - Compiling a Notes8 folder for nominated users.

  Things you should take note of;
            - This program is not forgiving of typos!
            - Not case-sensitive.
            - Any spaces in any input will present errors.
            - Administrator preferences should be set before importing text file.
            - ID files should be stored in D:\lotus\NotesIDs\Users\
            - A log of users created is kept in the program folder.

  Press Enter... ''')

	os.system(cls)
	main(menu)

def ninethousand(menu):
	colorloop = True
	while colorloop:
		os.system(cls)
		print(banner)
		os.system('color D0')
		print('''
   ____ __      __ ______  _____     ___    ___    ___    ___
  / __ \\ \    / /|  ____||  __ \   / _ \  / _ \  / _ \  / _ \
 | |  | |\ \  / / | |__   | |__) | | (_) || | | || | | || | | |
 | |  | | \ \/ /  |  __|  |  _  /   \__, || | | || | | || | | |
 | |__| |  \  /   | |____ | | \ \     / / | |_| || |_| || |_| |
  \____/    \/    |______||_|  \_\   /_/   \___/  \___/  \___/ ''')

		os.system('color 3C')
		os.system('color F2')
		os.system('color 98')
		os.system('color E3')
		os.system('color 0C')
		os.system('color 4A')
		os.system('color AD')

def exit(menu):
	os.system(cls)
	sys.exit()

os.system(cls)
main(menu)
