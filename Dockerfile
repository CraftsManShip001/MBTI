# Python 3.12 이미지 사용
FROM python:3.12

# 시스템 패키지 업데이트 및 필요한 패키지 설치
RUN apt-get update && apt-get install -y \
    default-jre \
    default-jdk \
    git \
    build-essential \
    python3-dev \
    && rm -rf /var/lib/apt/lists/*

# 필요한 Python 패키지 설치
RUN pip install --upgrade pip
RUN pip install konlpy

# Java 설치 후 Java 버전 확인 및 JAVA_HOME 설정
RUN java -version
ENV JAVA_HOME=/usr/lib/jvm/java-11-openjdk-amd64
ENV PATH=$JAVA_HOME/bin:$PATH

# 작업 디렉토리 설정
WORKDIR /app

# 로컬 파일을 컨테이너로 복사
COPY . /app
COPY requirements.txt .

# requirements.txt에서 의존성 설치
RUN if [ -f "./requirements.txt" ]; then pip install -r requirements.txt; fi

# FastAPI 앱 실행
CMD ["uvicorn", "main:app", "--host", "0.0.0.0", "--port", "8000"]