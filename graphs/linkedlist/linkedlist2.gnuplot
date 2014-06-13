set term pngcairo size 800, 500
set output "linkedlist2.png"
reset
set key inside top left
set style data histogram
set style histogram cluster gap 1
set style fill solid border -1
set boxwidth 0.8
set xlabel 'Data set size (1M elements)'
set ylabel 'Total execution time (ms) - lower is better'

set yrange [0:900]

#set smooth bezier
#set linespoints

plot "data2.raw" using 2: xtic(1) title "Miniboxing" lc rgbcolor "#AAAAAA", '' using 3: xtic(1) title "Generic" lc rgbcolor "#888888" 
