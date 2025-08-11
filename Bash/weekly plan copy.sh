cp C:\Users\imran.ullah\Downloads\weekly plan 2025-2026\AIS\Grade 01\WEEK 01"

for i in $(seq -w 0 40); do
  cp "WEEK 01.docx" "WEEK-$i.docx"
done
