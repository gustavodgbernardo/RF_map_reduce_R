hadoop jar /usr/hdp/2.2.0.0-2041/hadoop-mapreduce/hadoop-streaming-2.6.0.2.2.0.0-2041.jar \
-D mapred.map.tasks=2 \
-D mapred.reduce.tasks=100 \
-D stream.map.output.field.separator=, \
-D stream.reduce.input.field.separator=, \
-file /home/rstudio/maper.R -mapper "Rscript /home/rstudio/maper.R 100 10" \
-file /home/rstudio/reducer.R -reducer "Rscript /home/rstudio/reducer.R 0.8 1 5" \
-input /tmp/RF/* -output /tmp/rf_selection2 

hadoop fs -cat /tmp/rf_selection2/* | Rscript /home/rstudio/aggregate.R > final_selection.csv