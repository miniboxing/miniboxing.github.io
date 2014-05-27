set term pngcairo size 800, 500
set output "linkedlist.png"
reset
set key inside top left
set style data histogram
set style histogram cluster gap 1
set style fill solid border -1
set boxwidth 0.8
set xlabel 'Data set size (1M elements)'
set ylabel 'Total execution time (ms) - lower is better'

plot "data.raw" using 2: xtic(1) title "Miniboxing" fill solid 0.5 lc rgbcolor "#000000", '' using 3: xtic(1) fill solid 0.2 lc rgbcolor "#000000" lt 1 title "Generic" with histogram

