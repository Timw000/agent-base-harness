---
name: subagent-context-research
description: Styr hur huvudagenten använder subagenter enbart för att undersöka, analysera och sammanställa befintlig kontext. Använd alltid när en subagent övervägs eller anropas.
---

# Subagenter för kontextinsamling

## Grundregel

Använd subagenter endast för att samla och strukturera befintligt underlag åt huvudagenten, exempelvis:

- relevant kod och nuvarande beteende
- befintliga beslut, krav och dokument
- historik, tidigare implementationer och etablerade mönster
- samband, avvikelser och uttryckliga oklarheter i underlaget

Använd skill ccc för att utföra semanstisk sökning i projektet 

Subagenten får inte:

- föreslå ändringar, kod, lösningar, idéer eller nästa steg
- rekommendera vad som bör prioriteras eller göras
- skapa, redigera eller radera filer
- köra kommandon som förändrar repositoryt eller externa system
- fatta beslut åt huvudagenten

Huvudagenten ansvarar för att värdera resultatet, avgöra vad som är viktigt och besluta vad som ska göras.
