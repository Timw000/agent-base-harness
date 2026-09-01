---
name: commit
description: Skapar git-commits med meddelande baserat på diff i systemdokumentationen. Använd när användaren ber om en commit, /commit, eller vill committa ändringar.
disable-model-invocation: true
---

# Commit

## Mål

Skapa ett korrekt commit-meddelande genom att först förstå *vad som gjorts* utifrån
ändringar i systemdokumentationen, inte bara utifrån koddiffen.

## Arbetsgång

1. **Läs systemdokumentationens diff först**
   - Kör `git diff documentation/` och `git diff --cached documentation/`.
   - Läs även `git status` för att se vilka dokumentfiler som är nya, ändrade eller borttagna.
   - Tolka diffen på produktnivå: nya eller uppdaterade krav, beslut, flöden, avgränsningar
     och öppna frågor — inte filnamn eller tekniska detaljer.

2. **Avgör vad som gjorts**
   - Utgå från systemdokumentationen som primär källa för commit-meddelandets innehåll.
   - Om dokumentationen inte ändrats: läs hela koddiffen (`git diff` och `git diff --cached`)
     och formulera meddelandet utifrån faktiska beteendeförändringar.
   - Om både dokumentation och kod ändrats: låt dokumentationen styra *varför* och *vad*,
     och använd koddiffen bara för att bekräfta omfattningen.

3. **Förbered commit enligt git-säkerhetsprotokoll**
   - Kör parallellt: `git status`, `git diff` (hela arbetsträdet), `git log -1 --oneline`
     (för att följa befintlig commit-stil).
   - Committa aldrig filer som sannolikt innehåller hemligheter (`.env`, credentials, m.m.).
   - Skapa aldrig commit om det inte finns något att committa.

4. **Skriv commit-meddelandet**
   - 1–2 meningar som fokuserar på *varför* och produktändringen, inte en fillista.
   - Skriv på svenska om ändringarna gäller produktbeteende eller dokumentation; annars
     följ språket i senaste commits i repot.
   - Följ repots etablerade stil (t.ex. `feat:`, `fix:`, `docs:`) om den finns.

5. **Genomför commit**
   - Stagea relevanta filer (inklusive `documentation/` om den ingår i arbetet).
   - Committa med HEREDOC:
     ```bash
     git commit -m "$(cat <<'EOF'
     Commit-meddelande här.

     EOF
     )"
     ```
   - Kör `git status` efteråt för att verifiera att commit lyckades.
   - Committa endast när användaren uttryckligen bett om det. Pusha inte utan begäran.

## Om dokumentationen saknas eller är ofullständig

Om arbetet är klart men `documentation/` inte speglar ändringarna, påpeka det kort
innan commit — föreslå `/close` om användaren vill uppdatera systemdokumentationen först.
Genomför commit ändå om användaren insisterar.

## Undvik

- Commit-meddelanden som bara listar filer eller komponenter.
- Att gissa produktkrav som inte finns i dokumentationen, chatten eller koden.
- `git commit --amend` om inte alla villkor i git-säkerhetsprotokollet är uppfyllda.
- Destruktiva git-kommandon (`push --force`, `reset --hard`) utan uttrycklig begäran.
