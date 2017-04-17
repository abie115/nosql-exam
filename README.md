# Projekt na egzamin
Zespół/Indywidualnie:
- Aldona Biewska

Wybrany zbiór danych: [Zgony w Stanach Zjednoczonych w 2014 roku](https://www.kaggle.com/cdc/mortality)

Informacje o komputerze na którym były wykonywane obliczenia:

| Nazwa                 | Wartość    |
|-----------------------|------------|
| System operacyjny     | Windows 7 x64 |    
| Procesor              | Intel Core i5-2450M |
| Ilość rdzeni          | 4 |
| Pamięć                | 6GB |
| Dysk                  | 700 GB HDD |
| Baza danych           |            |


### Przedstawienie danych
Cały zbiór jest podzielony na kilkadziesiąt tabel, każda w osobnym pliku .csv.
Dane do importu do MongoDB przygotowałam i obrobiłam przy pomocy skryptu [prepare.R](https://github.com/abie115/nosql-exam/blob/master/prepare/prepare.R). 

Wybrałam poniże pola:

|Pole |Opis|
|-----|----|
|Id (integer primary key) | id|
|Sex | płec (M = Mężczyzna, F = Kobieta)|
|Education | wykształcenie|
|AgeType | jednostka w jakiej będzie wyznaczony wiek w kolumnie Age,np.: Year, Hour|
|Age | wiek zgonu w jednostce zdefiniowanej przez kolumnę AgeType|
|MaritalStatus  | status małżeński ("Never married, single", Married, Widowed, Divorced, "Marital Status unknown")|
|MonthOfDeath | miesiąc zgonu (numer)|
|DayOfWeekOfDeath | dzień tygodnia zgonu|
|Race | rasa 
|MannerOfDeath | sposób zgonu (np.: Accident, Suicides)|
|PlaceOfDeathAndDecedentsStatus | miejsce zgonu|
|ActivityCode | aktywność krótko przed zgonem|
|Icd10Code | kod podstawowej przyczyny śmierci (kod ICD-10 - Międzynarodowa Statystyczna Klasyfikacja Chorób i Problemów Zdrowotnych) |
|Icd10Code_Description | opis kodu ICD-10|

Przykładowy rekord:
```js
{                                                                                        
  "_id" : ObjectId("58f454b899110e31554609a7"),                                    
  "Id" : 1,                                                                        
  "Sex" : "M",                                                                     
  "Age" : 87,                                                                      
  "MonthOfDeath" : 1,                                                              
  "Icd10Code" : "I64",                                                             
  "AgeType" : "Years",                                                             
  "Education" : "9 - 12th grade, no diploma",                                      
  "MaritalStatus" : "Married",                                                     
  "DayOfWeekOfDeath" : "Wednesday",                                                
  "Race" : "White",                                                                
  "MannerOfDeath" : "Natural",                                                     
  "PlaceOfDeathAndDecedentsStatus" : "Decedent's home",                            
  "ActivityCode" : "Not applicable",                                               
  "Icd10Code_Description" : "Stroke, not specified as haemorrhage or infarction"   
}                                                                                        
```

#### Import danych do MongoDB

```bash
mongoimport -d db_ex -c deaths --type csv --file death_data.csv --headerline
```
Liczba zaimportowanych rekordów:
```js
db.deaths.count()
2631171
```
### Agregacja1
5 najczęstszych przyczyn zgonu według Icd10:
```js
db.deaths.aggregate([
	{ $group: {_id: "$Icd10Code_Description", count: {$sum: 1}} }, 
	{ $sort: {count: -1} }, { $limit : 5}
]);
```
[skrypt JS z aggregacją](https://github.com/abie115/nosql-exam/blob/master/scripts/agg1.js)

eksport wyniku do .csv:
```bash
cd scripts 
mongo --quiet agg1.js | jq "[.[] | {Icd10Code_Description: ._id, count: .count }]" | json2csv -f Icd10Code_Description,count  -o result1.csv
```
Wynik zapisany w pliku [result1.csv](https://github.com/abie115/nosql-exam/blob/master/results/result1.js)

| "Icd10Code_Description"|"count"                             | 
|------------------------|------------------------------------| 
| "Atherosclerotic heart disease"|161961                      | 
| "Malignant neoplasm: Bronchus or lung, unspecified"|154862  | 
| "Unspecified dementia"|122021                               | 
| "Acute myocardial infarction, unspecified"|114107           | 
| "Chronic obstructive pulmonary disease, unspecified"|107836 | 

Przykładowe planowane agregacje:
- porównanie ilości zgonów kobiet i mężczyzn
- porówanie wieku, w jakim był zgon i przyczyny
- pechowy dzień, czyli najczęstszy dzień tygodnia zgonu
- TODO
...
