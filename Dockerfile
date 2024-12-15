# Python 3.12 이미지 사용
FROM python:3.12

# Java 설치
RUN apt-get update && apt-get install -y openjdk-8-jdk && \
    apt-get clean

# 환경 변수 설정
ENV JAVA_HOME=/usr/lib/jvm/java-8-openjdk-amd64
ENV PATH=$JAVA_HOME/bin:$PATH
ENV LD_LIBRARY_PATH=$JAVA_HOME/jre/lib/amd64/server:$LD_LIBRARY_PATH

# 의존성 설치
RUN pip install --upgrade pip
RUN pip install wheel


# 시스템 의존성 설치 (필요한 경우만 사용)
RUN apt-get update && apt-get install -y \
    libpq-dev \
    && rm -rf /var/lib/apt/lists/*

# 작업 디렉토리 설정
WORKDIR /app

# 로컬 파일을 컨테이너로 복사
COPY . /app
COPY requirements.txt .

# requirements.txt에서 의존성 설치
RUN if [ -f "./requirements.txt" ]; then pip install -r requirements.txt; fi

COPY . .

# FastAPI 앱 실행
CMD ["uvicorn", "main:app", "--host", "0.0.0.0", "--port", "8000"]
