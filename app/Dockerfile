FROM python:3.9-slim

WORKDIR /app

COPY app.py .

COPY templates/ templates/

COPY static/ static/

COPY requirements.txt .

RUN pip install -r requirements.txt

RUN pip install flask

RUN pip install flask redis

EXPOSE 5000

CMD ["python", "app.py"]