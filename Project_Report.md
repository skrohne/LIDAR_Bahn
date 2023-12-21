##### Projektbericht
##### Autoren @skrohne @eerlenko


# Gefahrenanalyse von Baumbeständen entlang von Bahnschienen mit Hilfe von LIDAR


## Einleitung
Rahmen eines Studienprojekts; Mit Lidar Daten Bäume entlang von Bahntrassen untersuchen; wie gefährlich können diese sein, im Hinblick auf das Umfallen auf die Schienen  
Analyse von Höhe im Verhältnis zur Nähe zu den Scheinen der Bäume, können diese bis auf die Gleise reichen, stehen sie im Schutzstreifen; liegt ein U-Profil oder ein V-Profil vor


## Motivation
Die Deutsche Bahn wird immer unupünktlicher durch verschiedene Gründe, einer davon: umgefallene Bäume auf den Schienen bzw. auf den Oberleitungen  
Starkwetterereignisse werden durch Klimawandel immer häufiger und stärker, Bäume werden durch extremes Wetter gestresst/krank => Gefahr von Umfallen von Bäumen steigt immer weiter  
Monitoring der Forstbestände entlang von Bahntrassen wichtig, um die Pünktlichkeit der Züge zu gewährleisten


## Datengrundlage
Das Land NRW stellt LIDAR Daten für ganz NRW bereit, diese werden in einem 5 Jahres (?) Zyklus erneuert und sind frei verfügbar über das openDate Portal  
Die DB stellt ihr Schienennetz auf ihrem eigenen openData Portal zum Download verfügbar. Dort gibt es das Netz als Shapefile, welches mithilfe von QGis auf NRW zugeschnitten wurde und auf das passende Referenzsystem zu den Lidar Daten (ETRS) transformiert wurde.  
Um die Datenmenge, die zu bearbeiten ist, möglichst gering zu halten, damit nicht unnötig Rechenleistung und Speicherplatz verbraucht wird, wurde sich auf ein kleines Testgebiet begrenzt. Als Testgebiet wurde ein Streckenabschnitt südlich von Münster - Hiltrup der Strecke Hamm - Münster ausgesucht. Dieses Gebiet hat den Vorteil verschiedenste Umgebungen zu beinhalten, wie den Dortmund - Ems Kanal, die Brücke darüber, umstehende Baumbestände, sowie vereinzelte Häuser und Straßen. 

## Vorprozessieren
Ein sehr großer Teil des Projekts war das Vorprozessieren der Lidar Daten.   
Hierbei musste zum einem das Gebiet begrenzt werdern und vor allem mussten die Lidar Daten gefiltert werden, damit nur noch die Bäume von den Algorithmen erkannt wurden und diese dann in die Analyse einfließen können.  
#### Filtern 
Zum Filtern der Daten wurde zum einem die gegebene Klassifikation der Lidar Daten durch das Land NRW benutzt. Allerdings stellte sich heraus, dass diese Klassifikationen sehr unzuverlässig sind und lediglich nützlich sind, um Störpixel(, wie Vögel?)zu entfernen.  
Deswegen wurde zum Einem die Fläche der Schiene herausgefiltert, indem das Shapefile der Schienen gebuffert und die entstande Fläche aus den Lidar Daten gefiltert wurde.  
Zum Anderen wurde eine Maske mit Hilfe des NDVIs erstellt, die nicht Vegetation aus den Lidar Daten filtert.
