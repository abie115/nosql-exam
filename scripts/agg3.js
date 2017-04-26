var conn = new Mongo();
var db = conn.getDB('dbexam');

var result = 
	db.conditions.aggregate([ 
		{ $group: { _id : "$DeathRecordId", Other_conditions: { $push: "$$ROOT" } } },
		{ $match: { "Other_conditions": {  "$elemMatch": { "Part" : 1, "Line":1, "Icd10Code":"I469"}}}},
		{ $unwind : "$Other_conditions" },
		{ $match: { "Other_conditions.Icd10Code": { $ne:  "I469" },"Other_conditions.Part":2  } },
		{ $group: {_id: "$Other_conditions.Icd10Code", count: {$sum: 1}} },	
		{ $sort: {count: -1} }, 
		{ $limit : 10},
		{ $lookup: {from:"icd10", localField:"_id",foreignField:"Code",as:"Icd10Description"}},
		{ $unwind : "$Icd10Description" },
		{ $project : { "_id":0,"code":"$_id","description":"$Icd10Description.Description", "count_of_cases":"$count"  } }
	  ],{allowDiskUse: true});

	
printjson(result.toArray());