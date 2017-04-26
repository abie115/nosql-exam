var conn = new Mongo();
var db = conn.getDB('dbexam');

var result = 
	db.deaths.aggregate( [
	  { $match: { "AgeType": "Years", "Education":{$ne: "NA"}, $and: [ { "Age" : { $gt : 35 }} , { "Age" : { $lt : 100 }} ]}},     
	  { $facet: { 
		Education: [    
			{ $group: {_id:{sex: "$Sex",edu: "$Education"}, count: {$sum: 1}} }, 
			{ $sort: {count: -1} },
			{ $group: {_id: "$_id.sex",education: {$push: {range: "$_id.edu" , total:"$count"}}}}		
			
		],    
		Marriage: [
			{ $group: {_id:{sex: "$Sex", status: "$MaritalStatus" }, count: {$sum: 1}} }, 
			{ $sort: {count: -1} },
			{ $group: {_id: "$_id.sex", marriage: {$push: {status: "$_id.status" , total:"$count"}}}}
		  ]
	 } }
	] );
	
printjson(result.toArray());