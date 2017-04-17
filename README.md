# Projekt na egzamin
Zespół/Indywidualnie:
- Aldona Biewska

Zbiór zawiera dane na temat zgonów w Stanach zjednoczonych w 2014 roku, pochodzi on z [kaggle.com](https://www.kaggle.com/cdc/mortality).
Cały zbiór jest podzielony na kilkadziesiąt tabel, każda w osobnym pliku .csv.
Przed przystąpieniem do importu do mongo, scaliłam wybrane tabele.
Jako, że kolumn jest bardzo dużo, wybrałam poniższe interesujące kolumny:

|Pole |Opis|
|-----|----|
|Id (integer primary key) | id|
|Sex | płec (M = Mężczyzna, F = Kobieta)|
|Education | wykształcenie|
|AgeType | wyznacza w jakich jednostkach będzie wyznaczony wiek w kolumnie,np.: Year, Minute|
|Age | wiek zgonu w jednostce zdefiniowanej przez kolumnę AgeType|
|MaritalStatus  | status małżeński ("Never married, single", Married, Widowed, Divorced, "Marital Status unknown")|
|MonthOfDeath | miesiąc śmierci (numer)|
|DayOfWeekOfDeath | dzień tygodnia śmierci|
|Race | rasa 
|MannerOfDeath | sposób zgonu (np.: Accident, Suicides)|
|PlaceOfDeathAndDecedentsStatus | miejsce zgonu|
|ActivityCode | aktywność, krótko przed śmiercią|
|Icd10Code | kod podstawowej przyczyny śmierci (kod ICD-10 - Międzynarodowa Statystyczna Klasyfikacja Chorób i Problemów Zdrowotnych) |
|Icd10Code_Description | opis kodu ICD-10|

Dane do importu przygotowałam przy pomocy skryptu [prepare.R](https://github.com/abie115/nosql/tree/master/prepare/prepare.R)

Import zbioru do mongo:
```bash
mongoimport -d db_ex -c deaths --type csv --file death_data.csv --headerline
```
Liczba zaimportowanych rekordów:
```bash
db.deaths.count()
2631171
```
Przykładowy rekord:
```bash
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
Przykładowe planowane agregacje:
- porównanie ilości zgonów kobiet i mężczyzn
- porówanie wieku, w jakim był zgon i przyczyny
- pechowy dzień, czyli najczęstszy dzień tygodnia zgonu
- TODO
...