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

# SSL 인증서와 프라이빗 키를 이미지로 복사
COPY privkey.pem /etc/ssl/private/privkey.pem
COPY fullchain.pem /etc/ssl/certs/fullchain.pem

# Nginx 설치 및 설정 파일 복사
RUN apt-get update && apt-get install -y nginx && apt-get clean
COPY nginx.conf /etc/nginx/nginx.conf

# Nginx 설정 파일 수정
RUN sed -i 's|ssl_certificate /etc/nginx/ssl/fullchain.pem;|ssl_certificate /etc/ssl/certs/fullchain.pem;|' /etc/nginx/nginx.conf \
    && sed -i 's|ssl_certificate_key /etc/nginx/ssl/privkey.pem;|ssl_certificate_key /etc/ssl/private/privkey.pem;|' /etc/nginx/nginx.conf

# 애플리케이션 포트를 외부에 노출
EXPOSE 443

# Nginx를 시작
CMD ["nginx", "-g", "daemon off;"]
