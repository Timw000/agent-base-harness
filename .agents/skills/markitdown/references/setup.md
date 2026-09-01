# Engångsinstallation

## Python-paket

Installera bas-paketet plus de format som behövs (undvik `[all]` om du vill
slippa onödiga tunga beroenden som `markitdown-ocr`/`openai`):

```bash
pip install 'markitdown[pdf,docx,pptx,xlsx,xls,outlook]'
```

Dessa extras är rent lokala och kräver ingen internetuppkoppling vid körning.

Installera **inte** `audio-transcription`-extran — den drar in beroenden för
Googles molnbaserade Speech Recognition-API, vilket krockar med kravet på
offline-användning (se SKILL.md för detaljer).

## EXIF-metadata för bilder

För att kunna extrahera EXIF-metadata ur `.jpg`/`.png` krävs den externa
binären `exiftool`, version 12.24 eller senare:

```bash
# macOS
brew install exiftool

# Ubuntu/Debian
sudo apt-get install libimage-exiftool-perl
```

Verifiera version:

```bash
exiftool -ver
```

## Docker (alternativ till lokal Python-installation)

```bash
git clone git@github.com:microsoft/markitdown.git
cd markitdown
docker build -t markitdown:latest .
```

Efter detta körs konvertering via `docker run` enligt SKILL.md, helt offline.

## Verifiera installationen

```bash
markitdown --list-plugins
```

Kommandot ska köras utan fel. Aktivera inga plugins härifrån utan att först
granska dem (se SKILL.md).
