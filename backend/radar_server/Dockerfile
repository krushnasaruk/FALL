FROM python:3.12-slim

WORKDIR /app

COPY backend ./backend

ENV RADAR_HOST=0.0.0.0
ENV RADAR_AUTO_COLLECT=true
ENV RADAR_DB_PATH=/data/radar.sqlite3

RUN mkdir -p /data

EXPOSE 8787

CMD ["python", "-m", "backend.radar_server.server"]
