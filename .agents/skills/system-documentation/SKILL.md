---
name: system-documentation
description: Skapar och uppdaterar krav- och beslutsdriven systemdokumentation på svenska när användaren uttryckligen ber om det eller när skill:et "close" körs.
disable-model-invocation: true
---

# Systemdokumentation

## Mål

Dokumentera produktens avsikt: Vilka funktioner som finns och varför den finns, för vem den finns,
vilka krav och regler som gäller, samt vilka beslut som styr utformningen.
Dokumentationen är inte en teknisk genomgång av implementationen. Den ska beskriva systemet på ett icke tekniskt vis. Den ska samtidigt agera som en wiki för hur systemet fungerar och hur man som användare använder systemet.

## Aktivering

Använd endast denna skill när användaren uttryckligen ber om att skapa eller
uppdatera systemdokumentation, eller när skill:et `close` körs. Skriv aldrig
eller uppdatera dokumentation på eget initiativ som en del av annan utveckling.

## Arbetsgång

1. Läs berörda produktunderlag, befintlig dokumentation, issue/uppgift om den
   finns och den kod som visar aktuellt beteende.
2. Skilj tydligt mellan:
   - **bekräftade krav eller beslut** från beställare och produktunderlag,
   - **härledda observationer** från befintligt beteende,
   - **öppna frågor** som behöver produktbeslut.
3. Skapa eller uppdatera en liten Markdown-fil per avgränsat flöde, use case,
   beslut eller regelområde. Gruppera bara när informationen normalt måste
   läsas tillsammans.
4. Länka filen från `documentation/README.md`.
5. Dokumentera vägledande beslut på den plats där de behövs, eller i
   `documentation/beslutslogg.md` om flera områden påverkas.

## Form och längd

Använd inget fast format. Välj bara de rubriker, listor eller korta stycken
som gör dokumentet lätt att läsa.

Dokumentationen läses av AI-agenter. Skriv därför minimalt men informativt:

- Korta, direkta meningar. Undvik bakgrundstext och utfyllnadsord.
- Upprepa inte information. referera till andra avsnitt istället.
- Ta bara med information som inte kan utläsas direkt ur koden.
- Skriv testbara krav när underlaget räcker. Skriv annars en öppen fråga.

## Undvik

- API-kontrakt, komponenthierarkier, filstruktur och andra detaljer som kan
  läsas direkt ur koden.
- Påhittade motiv, roller, behörigheter eller affärsregler.
- En stor systembeskrivning som blandar oberoende funktioner.
- Att behandla en prototyp eller ett UI-exempel som ett fastställt
  produktkrav utan bekräftelse.
- Fasta mallar, obligatoriska rubriker eller utförliga beslutsloggar.
