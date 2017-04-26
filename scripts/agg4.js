var conn = new Mongo();
var db = conn.getDB('dbexam');

var result = 
	db.deaths.aggregate([
	 { 
		$project: { "Id": 1,"MannerOfDeath": 1, "Race_new":
		 {
			 $switch: {
				branches: [
				 { case: { $eq: [ "$Race","White" ] }, then: "White" },
				 { case: { $eq: [ "$Race","Black" ] }, then: "Black" },
				 { case: { $or: [ 
							{ $eq: [ "$Race", "Chinese" ] },
							{ $eq: [ "$Race", "Japanese" ] },
							{ $eq: [ "$Race", "Asian Indian" ] },
							{ $eq: [ "$Race", "Korean" ] },
							{ $eq: [ "$Race", "Other Asian or Pacific Islander" ] },
							{ $eq: [ "$Race", "American Indian (includes Aleuts and Eskimos)" ] },
							{ $eq: [ "$Race", "Vietnamese" ] },
							{ $eq: [ "$Race", "Guamanian" ] },
						] }, then: "Yellow" }
			  ],
				  default: "Did not match"
		   }
		 }
	   }
	 },
	 {  $match: {"MannerOfDeath":"Homicide","Race_new":{$ne: "Did not match"} } },
	 {  $group: {_id:{race: "$Race_new"}, count: {$sum: 1} } }, 
	 { 
		$project: { "percentage":
		{
		  $switch: {
			branches: [
			   { case: { $eq: [ "$_id.race","White" ] }, 
						 then: {"$multiply":[{"$divide":[100,2241510]},"$count"]} },
			   { case: { $eq: [ "$_id.race","Black" ] }, 
						 then: {"$multiply":[{"$divide":[100,309504]},"$count"]} },
			   { case: { $eq: [ "$_id.race","Yellow" ] }, 
						 then: {"$multiply":[{"$divide":[100,56205]},"$count"]} },
		   ],
		  default: "0"
		 } 
		},"_id":0,"count":"$count","race":"$_id.race"
	   }
	  }
	]);
	
printjson(result.toArray());