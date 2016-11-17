################################
#Original author: Shaobo Li
#Last modified by: Dan Liu
#Last modified time: 11/16/2016
#Interact with user to get the area id that user wants and get all occupations json file in that area
################################

#Setup your wd first
import os

#Import autho libs
import requests
from requests_oauthlib import OAuth1

#Import Json libs
import simplejson
import json

#Import csv
import csv

#Put function
def put(data,fileName):
	try:
		jsondata = data
		fd = open(fileName, 'w')
		fd.write(jsondata)
		fd.close()
		print('Successfully got data')
	except:
		print ('Failed to get data')
		pass

#get whole data (for stateareas, careerareas etc)
def getWholeData(dataWant):
    insertType = '/'+dataWant
    myurl = 'http://sandbox.api.burning-glass.com/v206/explorer'+insertType;
    IBMauth = OAuth1('IBM', 'F9751F2B48A3474E9C6E41FF989F0AF2','Explorer', '95C93BE538BD48F096D63B03E854AA84')
    fileName = dataWant+'.json'
    r = requests.get(myurl,auth=IBMauth);
    if(r.status_code==404):
        print('empty')
    else:
        put(r.text,fileName)


#get data by part
def getByPart(datawant, startLoop, endLoop):
	for i in range(startLoop, endLoop+1):
		insertType = '/'+dataWant
		myurl = 'http://sandbox.api.burning-glass.com/v206/explorer/occupations/'+str(i)+insertType
		#for data under occupations, modify occupations if you want to get others
		IBMauth = OAuth1('IBM', 'F9751F2B48A3474E9C6E41FF989F0AF2','Explorer', '95C93BE538BD48F096D63B03E854AA84')
		r = requests.get(myurl,auth=IBMauth);
		print(str(i) + ', ' + str(j))
		fileName = dataWant + str(i) + '.json'
		if(r.status_code==404):
			print('empty')
		else:
			put(r.text,fileName)


#App
def setWd():
    print('\n======================================================\n')
    path = input('input your working dir:')
    try:
        os.chdir(path)
    except(Exception):
        print('invalid path')
        setWd()

def app():
	print('\n======================================================\n')
	userChoice = input('Whole data(input 0) or data by parts(input 1) or quit(input quit)?')
	if userChoice == '0':
		dataWant = input('what kind of data you want?')
		try:
			getWholeData(dataWant)
		except(Exception):
			print('check your input')
		app()
	elif userChoice == '1':
		dataWant = input('what kind of data you want?')
		startLoop = int(input('the begining of your loop(a integer)'))
		endLoop = int(input('the end of your loop(a integer)'))
		try:
			getByPart(datawant, startLoop, endLoop)
		except(Exception):
			print('check your input')
		app()
	elif userChoice == 'quit':
		print("user quit")
		return
	else:
		print('check your input')
		app()

##setWd()
app()
