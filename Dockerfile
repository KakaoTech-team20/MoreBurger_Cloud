# 베이스 이미지로 Nginx를 사용
FROM nginx:alpine

# 작업 디렉토리 설정
WORKDIR /usr/share/nginx/html

# 필요한 패키지 설치
RUN apk add --no-cache git

# 기존 파일 삭제
RUN rm -rf /usr/share/nginx/html/*

# GitHub 리포지토리에서 콘텐츠를 클론
RUN git clone https://github.com/KakaoTech-team20/MoreBurger_Cloud.git .

# Nginx 설정 파일 복사
COPY nginx.conf /etc/nginx/nginx.conf

# 443 포트를 외부에 노출
EXPOSE 443

# Nginx 실행
CMD ["nginx", "-g", "daemon off;"]
