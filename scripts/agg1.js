var conn = new Mongo();
var db = conn.getDB('db_ex');

var result = db.deaths.aggregate([
	{ $group: {_id: "$Icd10Code_Description", count: {$sum: 1}} }, 
	{ $sort: {count: -1} }, { $limit : 5}
]);
printjson(result.toArray());
