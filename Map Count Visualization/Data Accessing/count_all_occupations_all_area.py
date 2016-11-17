################################
#Original author: Shaobo Li, modified from original codes from_Api_to_Json_model.py
#Last modified by: Dan Liu
#Last modified time: 11/16/2016
#Give directly all the posting count data in all areas
################################

import csv
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

def main():
	try:
		csvfile1 = open('bgtoccs_data.csv', 'r')
		#csv given by /Job_Analytics_and_Visualizations/Map Count Visualization/Data Preprocessing/get_bgtoccs.R
		bgtoccs_data = csv.reader(csvfile1)
		print("succeed to open csv")
		next(bgtoccs_data)
		csvfile2 = open('states_data.csv', 'r')
		#csv given by /Job_Analytics_and_Visualizations/Map Count Visualization/Data Preprocessing/get_states_data.R
		states_data = csv.reader(csvfile2)
		next(states_data)
		index = []
		for row2 in states_data:
			index.append(row2[0])
		for row1 in bgtoccs_data:
			newpath = "/Users/Dan/IBM project/data/new/occupations-all-areas-all/" + str(row1[0])
			if not os.path.exists(newpath):
				os.makedirs(newpath)
				print("success create a new folder of occupation" + str(row1[0]))
			os.chdir(newpath)
			for i in index:
				myurl = 'http://sandbox.api.burning-glass.com/v206/explorer/occupations/count?bgtoccs='+str(row1[1])+'&areaId='+str(i)
				#for data under occupations, modify occupations if you want to get others
				IBMauth = OAuth1('IBM', 'F9751F2B48A3474E9C6E41FF989F0AF2','Explorer', '95C93BE538BD48F096D63B03E854AA84')
				r = requests.get(myurl,auth=IBMauth)
				print(str(row1[0]) + ', ' + str(i))
				fileName = str(row1[0]) + '-' + str(i) + '.json'#dataWant + str(i) + '.json'
				if(r.status_code==404):
					print('empty')
				else:
					put(r.text,fileName)
		csvfile2.close()
		csvfile1.close()
	except:
	    print("fail to open csv")

main()
