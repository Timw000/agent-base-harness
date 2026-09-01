---
name: close
description: Avslutar arbetet genom att uppdatera systemdokumentationen utifrån bekräftade krav, beslut, avgränsningar och öppna frågor i den aktuella chatten. Använd när användaren vill stänga eller sammanfatta ett arbete.
disable-model-invocation: true
---

# Close

## Mål

Bevara produktkunskap från chatten i systemdokumentationen innan arbetet
avslutas.

## Arbetsgång

1. Läs hela den aktuella chatten och dess historik. Identifiera endast
   information som uttryckligen framkommit från användaren eller har
   bekräftats av användaren.
2. Kontrollera relevant innehåll i `documentation/` och
   `.agents/skills/system-documentation/SKILL.md`.
3. Klassificera varje relevant punkt som:
   - **Bekräftat krav eller beslut**
   - **Härledd observation – bekräfta**
   - **Öppen fråga**
   - **Ej dokumentationsrelevant**
4. Uppdatera eller skapa den minsta relevanta dokumentationen enligt
   `.agents/skills/system-documentation/SKILL.md`. Dokumentera inte tekniska
   implementationdetaljer som redan kan utläsas ur koden.
5. Rapportera kort vilka filer som ändrades. Om inget bekräftat
   dokumentationsrelevant framkom, säg det.

## Rapportering

Skriv en kort rapport på svenska efter uppdateringen. Använd bara de rubriker
som behövs. Bevara skillnaden mellan bekräftade beslut, härledda observationer
och öppna frågor.
