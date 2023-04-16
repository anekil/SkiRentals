# Ski Rentals
Obiektowa baza danych stworzona na potrzeby wypożyczalni sprzętu narciarskiego. Baza zawiera dane o sprzęcie jakim dysponuje wypożyczalnia oraz o jej klientach. Obie te tabele łączy tabela ze szczegółami wypożyczeń. 
Projekt wykonany w ramach zaliczenia przedmiotu Relacyjno-Obiektowe Bazy Danych. 

## Diagram relacji obiektów
![diagram](https://user-images.githubusercontent.com/78557681/232348173-42386ebc-3403-4b87-8c31-c2772ae8b4d7.png)

## Założenia projektu
- Właściciel wypożyczalni ma możliwość dodania, edytowania bądź usunięcia sprzętu oraz zobaczenia zawartości tabeli ze sprzętem i tabeli ze szczegółami wypożyczeń. 
- Klient ma możliwość wypożyczenia sprzętu, oddania go, zobaczenia swoich wypożyczeń oraz dobrania odpowiednich nart. 
- Jednorazowo klient może wypożyczyć jeden zestaw składający się z nart, butów i kasku. 
- Aby wypożyczyć sprzęt klient musi podać swoje dane takie jak imię, nazwisko, adres, numer telefonu i email. 
- Nie można wypożyczyć sprzętu, który jest aktualnie wypożyczony. 
- Po zwróceniu sprzętu wyświetlana jest cena do zapłaty, wyliczana na podstawie ceny i czasu wypożyczenia. 
- Klient ma możliwość wcześniejszego zwrotu sprzętu, wtedy opłata zostanie odpowiednio zmniejszona. 
- Narty wybierane są na podstawie wzrostu klienta, płci oraz typu. 
- Sprzęt posiada typ, stan wypożyczenia oraz cenę za dzień użytkowania. Ponadto buty i kaski posiadają odpowiednie rozmiary, a narty posiadają długość i typ (allride, allmountain albo race). 
- Właściciel nie może usunąć przedmiotu, który jest aktualnie wypożyczony. 
- Klient może wypożyczyć dany sprzęt na minimum 1 dzień lub maksimum 2 tygodnie. 
