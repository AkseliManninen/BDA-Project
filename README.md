# BDA-Project - Projektisuunnitelma

# Tapaaminen 10.11.2022

Tehty:
- Katsottu datasettiä: https://collegescorecard.ed.gov/data/

Ehdotettuja tutkimuskysymyksiä:
- Palkka valmistumisen jälkeen (Public schools)
- Valmistuminen
- Opintolainan vaikutus valmistumiseen

(- Työllistyminen)

Hierarkinen malli:
- Public schools --> Tarpeeksi pääaineita, esim. ainakin 10
- Public schools --> Tietyn alan koulut (ei ehkä löydy > 100)

Toinen:
- Ilmansaasteiden vaikutus hengitystiesairauksiin / hengitystiesairauskuolleisuuteen.
- Ei tiedetä mistä saadaan datasetit

Muista kysymyksiä:
- Voiko muuttujat valita maalaisjärjellä?
- Vai pitääkö tehdä jotenkin matemaattisesti valita?

- Miten se karsisi muuttujat?

Mitä seuraavaksi:
- Selvitetään R:llä onko tarpeeksi havaintoja ehdotettuihin hierarkisiin malleihin
- Muuttujien kartoitus ja valinta

# Tapaaminen 1.11.2022 

Tehty:
- Data otettu Exceliin / CSV-muodossa. Tiedostot löytyy githubista.
- Valittu kasvatusala tutkimuksen kohteeksi alustavasti. Syy: Kasvatusalan työllistymisessä ei pitäisi olla suuria alueellisia tai yliopistollisia eroja vrt. esim. kauppis.
- Keskitytään 5 vuoden yliopistotutkintoihin (tätä voidaan vielä tutkia tarkemmin). Syynä se, että suurin osa kasvatusalan tutkinnoista on 5 vuoden yliopistotutkintoja. Ei ehkä järkevää tutkia 3 vuoden ammattikorkeakoulututkintoja yhdessä hierarkisessa mallissa (varhaiskasvatus): Lähde (voisi etsiä jonkun paremman): https://opintoneuvoja.fi/1opintoblogi/kasvatusala-mit-opiskella
- Tutkitaan pääasiassa ylipistokuntia: Helsinki > Uusimaa, Joensuu > Pohjois-Karjala, Tampere > Pirkanmaa, Oulu > Pohjois-Pohjanmaa, Rovaniemi > Lappi,
Turku > Varsinais-Suomi, Jyväskylä > Keskisuomi, Rauma > Satakunta
- Datan kevyttä analysointia / validointia. Vaikuttaa lupaavalta. 

Sovittua: 
- Tustustutaan projektin ohjeistukseen vielä astetta tarkemmin. 
- Tehdään datan muokkaus Tidyverse / dplyr (Akseli & Santeri tutstuu, Nikolla jo hanskassa)
  - @Santeri: https://www.youtube.com/watch?v=sV5lwAJ7vnQ Tää oli must ihan hyvä video t. Akseli
- Tehdään plotteja eri alueiden välillä jne., jotta ymmärretään dataa paremmin ja että voidaanko ylipäätään saada kiinnostava projekti tästä datasetistä
- Tehdään viikkopalautus, niin saadaan parempi kuva hierarkisesta mallista.

Aikataulu:
- Groups of 3 can reserve a presentation slot starting 9th Nov, 2021.
- Project report deadline 4.12.2022. Submit in peergrade (separate “class”, the link will be added to MyCourses).
- Project report peer grading 4. - 8.12.2022 (so that you’ll get feedback for the report before the presentations).
- Project presentations 12.-16.12.2022.


Sekalaista:
- Syy-seuraussuhde: Voidaan selittää työllistymistä sukupuolen perusteella. (Mahdollinen toinen malli, koska pitää olla useampi)
- Santeri kokeilee että voi päivittää tähän ja se näkyy
