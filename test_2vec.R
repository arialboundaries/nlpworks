#example using movie db
PATH=getwd()
file_name=paste0(PATH,"/event_analysis/labeledTrainData.tsv")

df <- read.csv(file_name,encoding="utf-8",quote="",sep="\t",stringsAsFactors = F)
df

library(tm)
text <- df$review
corpus <- VCorpus(VectorSource(text))


inspect(corpus[[1]])

corpus <- tm_map(corpus, content_transformer(tolower))
corpus <- tm_map(corpus, content_transformer(removePunctuation))
corpus <- tm_map(corpus, content_transformer(removewords,stopwords("english")))

BigramTokenizer <- function(x){unlist(lapply(ngrams(words(x),2),paste,collapse=" "), use.names=F)}
dtm <- DocumentTermMatrix(corpus,control=list(tokenize=BigramTokenizer))
dtm <- removeSparseTerms(dtm,.995)
x <- as.data.frame(as.matrix(dtm))
x$sentiment <- df$sentiment
x$sentiment <- ifelse(x$sentiment<0.5,0,1)
