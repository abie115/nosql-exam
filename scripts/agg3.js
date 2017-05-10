var conn = new Mongo();
var db = conn.getDB('dbexam');

var stage1 =  { "$project": {
       "Id": 1,
       "MannerOfDeath": 1,
       "Race_new": {
         "$switch": {
           "branches": [
              { "case": { "$eq": ["$Race","White"]},"then": "White"},
              { "case": { "$eq": ["$Race","Black"]},"then": "Black"},
              { "case": { "$or": [
                { "$eq": ["$Race","Chinese"]},{ "$eq": ["$Race","Japanese"]},
                { "$eq": ["$Race","Asian Indian"]},{"$eq": ["$Race","Korean"]},
                { "$eq": ["$Race","Other Asian or Pacific Islander"]},
                { "$eq": ["$Race","American Indian (includes Aleuts and Eskimos)"]},
                { "$eq": ["$Race","Vietnamese"]},{ "$eq": ["$Race","Guamanian"]}]},
                  "then": "Yellow"}],
               "default": "Did not match"}}}};
var stage2={ "$match": { "Race_new": {"$ne": "Did not match"}}};
var stage3={ "$group": { "_id": { "race": "$Race_new"},"count": {"$sum": 1}}};
var stage4={ "$project": { "_id": 0,"race": "$_id.race","count": "$count"}};	
var count = db.deaths.aggregate([
   stage1,
   stage2,
   stage3,
   stage4
]);  
  
   
var white,yellow,black;
count.forEach(function(record) {
	if (record.race=="White") white=record.count;
	if (record.race=="Black") black=record.count;
	if (record.race=="Yellow") yellow=record.count;
});

var stage2_2 = {  $match: {"MannerOfDeath":"Homicide","Race_new":{$ne: "Did not match"} } };
var stage3_2 = {  $group: {_id:{race: "$Race_new"}, count: {$sum: 1} } };
var stage4_2 = { 
		$project: { "percentage of all deaths":
		{
		 	 $let: {
               vars: {
                  "white": white,
				  "black":black,
				  "yellow":yellow
               },
               in: {  $switch: {
			    branches: [
			   { case: { $eq: [ "$_id.race","White" ] }, 
						 then: {"$multiply":[{"$divide":[100,"$$white"]},"$count"]} },
			   { case: { $eq: [ "$_id.race","Black" ] }, 
						 then: {"$multiply":[{"$divide":[100,"$$black"]},"$count"]} },
			   { case: { $eq: [ "$_id.race","Yellow" ] }, 
						 then: {"$multiply":[{"$divide":[100,"$$yellow"]},"$count"]} },
		   ],
		  default: "0"
		 }  }
            }
		},"_id":0,"count":"$count","race":"$_id.race"
	   }
	  }	;
var result =  
	db.deaths.aggregate([
     stage1,
	 stage2_2,
	 stage3_2,
	 stage4_2
	]);
	

printjson(result.toArray());