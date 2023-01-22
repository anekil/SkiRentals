```diff
@@ TODO @@

Projekt obiektowej bazy danych powinien zawierać opracowaną strukturę składającą się z:

! definicji typów obiektowych  (łącznie z przewidzianymi niezbędnymi do ich obsługi metodami) ,
+ definicji tabel obiektowych w których składowane będą obiekty wierszowe  i kolumnowe 
- zastosowana zostanie referencja  (wskaźnikiem do rekordu tabeli obiektowej) i dereferencja pozwalająca na wprowadzenie relacji występujących między obiektami,
- wstawianie danych do tabeli z referencją,
! tworzenie i użytkowanie typu VARRY/ NESTED TABLE - do modelowania relacji jeden do wielu, gdzie po stronie "wiele" występuje kolekcja obiektów,
! implementacja z zastosowaniem języka PL/SQL logiki biznesowej w postaci pakietów (a w nich procedur/funkcji) umożliwiającej obsługę bazy obiektowej (kursory, ref kursory, obsługa błędów, wyzwalacze itp.)
! przykład obsługi obiektowej bazy danych od strony opracowanych funkcjonalności.


Dodatkowo proszę przygotować sprawozdanie w którym opisane zostaną założenia projektowe:

- opis projektu,
- opis realizacji założeń i przyjętych ograniczeń,
- przyjęte role użytkowników z podziałem na funkcjonalności
- podanie "Diagramu Relacji obiektów" wykorzystanych do stworzenia tabel
```


<h1>Projekt bazy danych dla wypożyczalni sprzętu narciarskiego</h1>

<b>Założenia projektu:</b>
<ul>
  <li>Jednorazowo klient może wypożyczyć jeden zestaw składający się z nart, butów, kijków i kasku. </li> 

  <li>Klient musi podać swoje dane, aby wypożyczyć sprzęt tj. Imię, nazwisko, PESEL </li> 

  <li>Nie można wypożyczyć sprzętu, który jest aktualnie wypożyczony.  </li> 

  <li>Po zwróceniu sprzętu wyświetlana jest cena do zapłaty, wyliczana na podstawie ceny, czasu wypożyczenia i ewentualnej kary za przekroczenie zadeklarowanego czasu dzierżawy. </li> 

  <li>Klient ma możliwość wcześniejszego zwrotu sprzętu, odpowiednio opłata zostanie zmniejszona </li> 

  <li>Klient może wydłużyć okres wypożyczenia </li> 

  <li>Narty wybierane są na podstawie wzrostu klienta, płci oraz typu/poziomu zaawansowania? </li> 

  <li>Sprzęt posiada cenę, typ, stan wypożyczenia, płeć docelową, [buty] rozmiar, [kask] rozmiar, [narty] długość, [narty] typ (allride, allmountain, race) </li> 
  
  <li>Właściciel nie może usunąć przedmiotu który jest aktualnie wypożyczony</li>
</ul>

 

<b>Typy </b>

 

<b>Schemat relacji </b>

 

<b>Pakiety </b>

 

<b>Kod </b>
