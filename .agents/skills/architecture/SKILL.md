---
name: architecture
description: Bygg skalbar arkitektur utan kodduplicering. Använd vid ändring av funktionalitet, komponenter, moduler, API:er eller domänlogik för att hitta liknande kod, återanvända befintliga lösningar och avgöra när gemensam logik bör generaliseras.
---

# Skalbar arkitektur och kodåteranvändning

## Innan implementation

1. Sök efter och läs befintlig kod med liknande ansvar, flöde eller datamodell, inklusive regler, valideringar, mappningar och UI-mönster.
2. Återanvänd passande projektmönster, funktioner, komponenter och typer. Välj sedan mellan att:
   - **Generalisera gemensam logik** när fallen delar ett stabilt ansvar eller sannolikt utvecklas parallellt. Utforma tydliga parametrar för de faktiska användningsfallen, inte ett spekulativt ramverk.
   - **Behålla separata implementationer** när likheten är ytlig, ansvaret skiljer sig eller en abstraktion gör koden svårare att förstå.

## Utformning

- Ge varje del ett tydligt ansvar. Separera domänlogik, integrationer, presentation och orkestrering enligt projektets konventioner.
- Håll beroenderiktning och gränssnitt enkla så att nya varianter inte kräver ändringar i orelaterad kod.
- Placera närbesläktad kod tillsammans; dela stora filer efter ansvar, inte radantal, utan att fragmentera enkla flöden eller skapa cirkulära beroenden.
- Placera delade typer, hjälpfunktioner och domänregler där de hör hemma och använd beskrivande namn.
- Håll ändringen fokuserad. Förklara kort valet av ny abstraktion eller separat implementation när det inte är uppenbart.

## Efter ändring

- Kontrollera alla berörda anropare och bevara relevant bakåtkompatibilitet.
- Uppdatera tester för både befintliga och nya fall; testa gemensamt beteende när det har extraherats.
- Om en lämplig refaktorering är för omfattande, isolera den nya lösningen och ange en konkret uppföljning i stället för att kopiera logik.
