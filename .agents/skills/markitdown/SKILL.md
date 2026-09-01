---
name: markitdown
description: Konverterar filer (PDF, Word, PowerPoint, Excel, bilder, HTML, CSV/JSON/XML, ZIP, EPub) till Markdown lokalt med Microsofts MarkItDown, helt offline och utan LLM. Använd när användaren ber om markitdown, vill konvertera dokument/filer till Markdown, eller uttryckligen vill undvika internetanrop och AI-modeller vid konvertering.
disable-model-invocation: true
---

# MarkItDown lokalt (offline, ingen LLM)

MarkItDown (https://github.com/microsoft/markitdown) är ett Python-verktyg som
konverterar filer till Markdown. Denna skill beskriver hur det används med
**endast lokala, offline-fungerande funktioner** — inga LLM-anrop, ingen
Azure-tjänst, inget som kräver internet.

Engångsinstallation (paket, `exiftool`, ev. Docker) beskrivs i
[references/setup.md](references/setup.md) — läs den filen bara vid
förstagångssetup, inte vid varje konvertering.

## Vad som ÄR lokalt och LLM-fritt

- PDF, Word (docx), PowerPoint (pptx), Excel (xlsx/xls), Outlook-meddelanden
- HTML
- Textbaserade format: CSV, JSON, XML
- ZIP-arkiv (itererar över innehållet och konverterar varje fil)
- EPub
- Bilder (`.jpg`, `.png`) — **endast EXIF-metadata**, ingen textextraktion ur
  bilden. Kräver den externa binären `exiftool` för metadata; annars ges
  tom/minimal output.

## Vad som INTE ska användas (kräver internet och/eller LLM)

Undvik alltid följande vid lokal, offline-användning:

- `llm_client` / `llm_model` — skickar bilder till en LLM för beskrivning.
- `markitdown-ocr`-pluginet — gör OCR genom att skicka bildinnehåll till en
  LLM-vision-modell. Utan `llm_client` skippas OCR:en tyst, men installera
  inte pluginet i onödan.
- `docintel_endpoint` / flaggorna `-d`/`-e` — Azure Document Intelligence
  (molntjänst).
- `cu_endpoint` / flaggan `--use-cu` — Azure Content Understanding
  (molntjänst).
- YouTube-URL:er som indata — kräver att MarkItDown hämtar video/transcript
  över internet.
- `audio-transcription`-extran — den inbyggda ljudtranskriberingen använder
  Googles molnbaserade Speech Recognition-API och fungerar **inte** offline.
  Bilder/ljud får därför bara EXIF-metadata, ingen transkribering, i denna
  lokala setup.
- `enable_plugins=True` i Python-API:t utan att uttryckligen ha granskat vilka
  plugins som är installerade — plugins kan introducera nätverks-/LLM-beroenden.

## Kommandoradsanvändning

```bash
markitdown path-to-file.pdf > document.md
markitdown path-to-file.pdf -o document.md
cat path-to-file.pdf | markitdown
```

## Python-API (lokalt, utan LLM)

```python
from markitdown import MarkItDown

md = MarkItDown(enable_plugins=False)
result = md.convert("test.xlsx")
print(result.text_content)
```

Med EXIF-metadata för bilder:

```python
from markitdown import MarkItDown

md = MarkItDown(enable_plugins=False, exiftool_path="/usr/local/bin/exiftool")
result = md.convert("photo.jpg")
print(result.markdown)
```

För att minimera vad processen får åtkomst till, använd den snävaste metoden
som täcker behovet i stället för `convert()`:

- `convert_local()` — bara lokala filer.
- `convert_stream()` — en redan öppnad ström, maximal kontroll.

## Docker-körning

Efter engångs-`docker build` (se [references/setup.md](references/setup.md)):

```bash
docker run --rm -i markitdown:latest < ~/your-file.pdf > output.md
```

Detta sker helt offline vid varje körning.

## Säkerhet

MarkItDown kör med samma rättigheter som den anropande processen. Sanera
alltid indata i otillförlitliga miljöer och begränsa filsökvägar innan
konvertering, precis som med `open()`.
