set term pngcairo size 800, 500
set output "linkedlist.mbfunction.png"
reset
#set key inside top left
set key at 11,575,0
set style data histogram
set style histogram cluster gap 1
set style fill solid border -1
set boxwidth 0.8
set xlabel 'Data set size (1M elements)'
set ylabel 'Total execution time (ms) - lower is better'

#set yrange [0:]

#set smooth bezier
#set linespoints

plot "data.mbfunction.1.txt" using 2: xtic(1) title "Miniboxed / custom representation" lc rgbcolor "#DDDDDD", '' using 3: xtic(1) title "Miniboxed / standard Scala functions" lc rgbcolor "#AAAAAA", '' using 4: xtic(1) title "Generic" lc rgbcolor "#777777"
