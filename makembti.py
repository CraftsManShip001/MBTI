from sklearn.feature_extraction.text import CountVectorizer
from sklearn.feature_extraction.text import TfidfVectorizer
from konlpy.tag import Okt
import scipy as sp
import pickle
import jpype
import os
jvmpath = "/usr/lib/jvm/java-8-openjdk-amd64/jre/lib/amd64/server/libjvm.so"

if not jpype.isJVMStarted():
    jpype.startJVM(jvmpath)
t = Okt()

vectorizer = CountVectorizer(min_df=1,decode_error='ignore')

mbti = []

with open('./dataset/mbti.txt', 'r') as file:
    for line in file:
        now = line.strip()
        if len(now) == 5:
            now_mbti = now[:-1]
        else:
            sentence = now[1:-2]
            mbti.append(sentence)
            
mbti_tokens = [t.morphs(row) for row in mbti]
mbti_for_vectorize = []

for content in mbti_tokens:
    sentence = ''
    for word in content:
        sentence = sentence + ' ' + word
    mbti_for_vectorize.append(sentence)

X = vectorizer.fit_transform(mbti_for_vectorize)
num_samples, num_features = X.shape

with open("X.pickle", 'wb') as f:
    pickle.dump(X, f)
with open("vect.pickle", 'wb') as f:
    pickle.dump(vectorizer, f)