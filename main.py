from sklearn.feature_extraction.text import CountVectorizer,TfidfVectorizer
from fastapi import FastAPI, HTTPException
from pydantic import BaseModel,Field
from fastapi.middleware.cors import CORSMiddleware
from passlib.context import CryptContext
from konlpy.tag import Okt
import scipy as sp
import pickle,jpype
import subprocess
import jpype
jpype.startJVM(jpype.getDefaultJVMPath(), "-Dfile.encoding=UTF8", "-ea")


t = Okt()

bcrypt_context = CryptContext(schemes=['bcrypt'], deprecated="auto")

app = FastAPI()

origins = [
    "http://localhost:3000",
    "http://localhost:8080",
]

app.add_middleware(
    CORSMiddleware,
    allow_origins=origins,  # 허용할 출처 목록
    allow_credentials=True,
    allow_methods=["POST"],  # 허용할 HTTP 메서드
    allow_headers=["*"],  # 허용할 헤더
)

class getMbti(BaseModel):
    text : str

with open("./X.pickle", 'rb') as fi:
    X = pickle.load(fi)
with open("./vect.pickle", 'rb') as fi:
    vectorizer = pickle.load(fi)

def dist_raw(v1,v2):
    delta = v1-v2
    return sp.linalg.norm(delta.toarray())
@app.post('/mbti')
def getMbti(request : getMbti):
    result = ['INTP','INFP','INTJ','INFJ','ISTP','ISTJ','ISFP','ISFJ','ESTP','ESTJ','ENFP','ENFJ','ESTP','ENTJ','ESFJ','ESFP']
    best_dist = 65535
    best_i = None
    new_post = request.text
    new_post = [new_post]
    newpost_tokens = [t.morphs(row) for row in new_post]
    new_post_for_vectorize = []

    for content in newpost_tokens:
        sentence = ''
        for word in content:
            sentence = sentence + ' ' + word
        new_post_for_vectorize.append(sentence)
    new_post_vec = vectorizer.transform(new_post_for_vectorize)
    for i in range(1600):
        post_vec = X.getrow(i)
        d = dist_raw(post_vec,new_post_vec)
        if d < best_dist:
            best_dist = d
            best_i = i
    return {'mbti':result[best_i // 100]}