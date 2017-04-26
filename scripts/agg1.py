import pymongo
from pprint import pprint
from pymongo import MongoClient

client = MongoClient()
db = client.dbexam
collection = db.deaths

pipeline = [
		{ "$match": { "MannerOfDeath": "Suicide", "AgeType": "Years" }},
		{ "$bucket": { "groupBy": "$Age", "boundaries": [1,10,20,30,40,50,60,70,80,90,100],"default": "Other"}}
]
 

result = collection.aggregate(pipeline)

for document in result:
	pprint(document)
 
 
 