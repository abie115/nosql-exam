var conn = new Mongo();
var db = conn.getDB('dbexam');

var result = 
	db.deaths.aggregate([
		{ $match: { "MannerOfDeath": "Suicide", "AgeType": "Years" }},
		{ $bucket: { groupBy: "$Age", boundaries: [1,10,20,30,40,50,60,70,80,90,100],default: "Other"}}
	]);

	
printjson(result.toArray());