# Projekt Aggregation Pipeline (egzamin)

### Aldona Biewska
* prezentacja: [prezentacja.pdf](https://github.com/abie115/nosql-exam/blob/master/pdf/prezentacja.pdf)
## Dane

* [Zgony w Stanach Zjednoczonych w 2014 roku](https://www.kaggle.com/cdc/mortality)
* próbki danych po 1001 dokumentów dla [DeathRecords_sample.csv](https://github.com/abie115/nosql-exam/blob/master/sample/DeathRecords_sample.csv) i [EntityAxisConditions_sample.csv](https://github.com/abie115/nosql-exam/blob/master/sample/EntityAxisConditions_sample.csv) oraz 12131 dokumentów dla [Icd10Code.csv](https://github.com/abie115/nosql-exam/blob/master/sample/Icd10Code.csv)
* plik _DeathRecords.csv_ obrobiony przy pomocy skryptu w R - [prepare.R](https://github.com/abie115/nosql-exam/blob/master/scripts/prepare.R)
* wybrane pliki:

| Plik                    | Liczba dokumentów | Czas importu | 
|-------------------------|-------------------|--------------| 
| DeathRecords.csv        | 2631171           | 4 min 4 s    | 
| EntityAxisCondition.csv | 8052877           | 7min 41s     | 
| Icd10Code.csv           | 12131             | 3s           | 

_deaths_:
```js
{                                                                
  "_id" : ObjectId("58fcdd07bd26e96c4d2d9129"),            
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
  "ActivityCode" : "Not applicable"                        
}                                                                
```
_conditions_:
```js
{                                                                
  "_id" : ObjectId("58fcdebfbd26e96c4d55c198"),            
  "Id" : 1,                                                
  "DeathRecordId" : 1,                                     
  "Part" : 1,                                              
  "Line" : 1,                                              
  "Sequence" : 1,                                          
  "Icd10Code" : "I64"                                      
}                                                                
```
_icd10_:
```js
{
  "_id" : ObjectId("58fce11abd26e96c4dd0c1d1"),
  "Code" : "A00",
  "Description" : "Cholera"
}
```

## Agregacje

1. Porównanie samobójstw w danym przedziale wiekowym.
2. Wpływ edukacji i stanu cywilnego na żywotność kobiet i mężczyzn.
3. Najczęstsze czynniki pośrednie przyczyniające się do głownej przyczyny śmierci.
4. Porównanie ilościowe i procentowe zgonów w wyniku zabójstwa, pogrupowane według wybranych ras (niektóre szczegółowe rasy należy zgrupować).

* agregacje w JS dostępne są [tutaj](https://github.com/abie115/nosql-exam/blob/master/scripts)
* dodatkowo wszystkie aggregacje zostały napisane i uruchomione w R - skrypt [mongo.R](https://github.com/abie115/nosql-exam/blob/master/scripts/mongo.R), dzięki czemu łatwiej było wykonać wszystkie wykresy oraz tabele. Aby móc korzystać w R z bazy mongodb wymagany jest pakiet _mongolite_

## Prezentacja

link do pliku pdf z tekstem prezentacji: [prezentacja.pdf](https://github.com/abie115/nosql-exam/blob/master/pdf/prezentacja.pdf)
