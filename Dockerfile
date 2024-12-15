# Python 3.12 이미지 사용
FROM python:3.12

# Java 환경 변수 설정
ENV JAVA_HOME=/Library/Java/JavaVirtualMachines/openjdk-8.jdk/Contents/Home


# 필수 패키지 설치
RUN apt-get update && apt-get install -y \
    g++ \
    default-jdk \
    && rm -rf /var/lib/apt/lists/*

# Python 패키지 설치
RUN pip install --upgrade pip
RUN pip install konlpy

# 작업 디렉토리 설정
WORKDIR /app

# 로컬 파일을 컨테이너로 복사
COPY . /app
COPY requirements.txt .

# requirements.txt에서 의존성 설치
RUN if [ -f "./requirements.txt" ]; then pip install -r requirements.txt; fi

# FastAPI 앱 실행
CMD ["uvicorn", "main:app", "--host", "0.0.0.0", "--port", "8000"]
