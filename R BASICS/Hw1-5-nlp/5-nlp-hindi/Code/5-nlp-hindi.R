#Advanced NLP

#Load R packages 
library(tibble)
library(dplyr)
library(ggplot2)

#1. Data cleaning and exploration

#Read data into R object
#Read file 'hindi.txt' into object 'hindi', a character vector 
hindi <- readLines(con <- file("hindi.txt", encoding = "UCS-2LE"))
close(con)
unique(Encoding(hindi))

#2: Staging with pretrained language model

#Load udpipe package
library(udpipe)

#Download and load hindi data model
model <- udpipe_download_model(language = "hindi")
model_hindi <- udpipe_load_model(file = 'hindi-hdtb-ud-2.4-190531.udpipe')


#Add metadata to dataset using 'annotate' to prep the data for easy analysis
#udpipe_annotate() takes the language model and annotates given text data
model_annotate <- udpipe_annotate(model_hindi,hindi)
model_df <- data.frame(model_annotate)

#Check the annotated data
colnames(model_df)
model_df$token
model_df$upos

#3. Analysis

# Plot part-of-speech tags from the given text using package lattice
library(lattice)
stats <- txt_freq(x$upos)
stats$key <- factor(stats$key, levels = rev(stats$key))
barchart(key ~ freq, data = stats, col = "yellow", 
         main = "UPOS (Universal Parts of Speech)\n frequency of occurrence", 
         xlab = "Freq")

# Plot frequently occurring nouns
stats <- subset(x, upos %in% c("NOUN")) 
stats <- txt_freq(stats$token)
stats$key <- factor(stats$key, levels = rev(stats$key))
barchart(key ~ freq, data = head(stats, 20), col = "cadetblue", 
         main = "Most occurring nouns", xlab = "Freq")

# Plot frequently occurring adjectives
stats <- subset(x, upos %in% c("ADJ")) 
stats <- txt_freq(stats$token)
stats$key <- factor(stats$key, levels = rev(stats$key))
barchart(key ~ freq, data = head(stats, 20), col = "purple", 
         main = "Most occurring adjectives", xlab = "Freq")

# Plot frequently occurring verbs
stats <- subset(x, upos %in% c("VERB")) 
stats <- txt_freq(stats$token)
stats$key <- factor(stats$key, levels = rev(stats$key))
barchart(key ~ freq, data = head(stats, 20), col = "gold", 
         main = "Most occurring Verbs", xlab = "Freq")

#Wordcloud
##Plot parts-of-Speech (noun, verb, adjective) for analysis.
stats <- subset(x, upos %in% c("NOUN","VERB","ADJ")) 
stats <- txt_freq(stats$token)
stats$key <- factor(stats$key, levels = rev(stats$key))
barchart(key ~ freq, data = head(stats, 20), col = "cadetblue", 
         main = "Most occurring tokens", xlab = "Freq")

#Plot word cloud for above plotted parts-of-speech data
library(wordcloud)
wordcloud(words = stats$key, freq = stats$freq, min.freq = 50, max.freq = 1000, max.words = 100,
          random.order = FALSE, colors = brewer.pal(6, "Dark2"), scale=c(1,0.5))

