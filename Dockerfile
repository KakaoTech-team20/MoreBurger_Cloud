# 1단계: 빌드 단계
FROM python:3.10-slim AS build

# 작업 디렉토리 설정
WORKDIR /app

# 필요한 패키지 설치
RUN apt-get update && apt-get install -y --no-install-recommends \
    git \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# 깃 레포지토리에서 프로젝트를 복사
RUN git clone https://github.com/KakaoTech-team20/MoreBurger_AI.git .

# Python 패키지를 설치
RUN pip install --no-cache-dir -r requirements.txt

# 2단계: 최종 이미지 단계
FROM python:3.10-slim

# 작업 디렉토리 설정
WORKDIR /app

# 빌드 단계에서 설치한 Python 패키지와 코드를 복사
COPY --from=build /app /app

# 애플리케이션 포트를 외부에 노출
EXPOSE 8000

# Uvicorn 서버를 시작
CMD ["uvicorn", "app.main:app", "--host", "0.0.0.0", "--port", "8000", "--reload"]
