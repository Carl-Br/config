#!/bin/bash

# Verwendung: ./split_pdf.sh input.pdf "30 75 100"

INPUT_PDF="$1"
SPLIT_POINTS="$2"

# Array aus den Trennpunkten erstellen
IFS=' ' read -ra SPLITS <<< "$SPLIT_POINTS"

# Startseite
START=1

# Counter für Ausgabedateien
COUNTER=1

# Durch alle Trennpunkte iterieren
for SPLIT in "${SPLITS[@]}"; do
    qpdf "$INPUT_PDF" --pages . $START-$SPLIT -- "output_part_$COUNTER.pdf"
    echo "Erstellt: output_part_$COUNTER.pdf (Seiten $START-$SPLIT)"
    START=$((SPLIT + 1))
    COUNTER=$((COUNTER + 1))
done

# Letzte Datei (vom letzten Trennpunkt bis zum Ende)
qpdf "$INPUT_PDF" --pages . $START-z -- "output_part_$COUNTER.pdf"
echo "Erstellt: output_part_$COUNTER.pdf (Seiten $START bis Ende)"
