FROM python:3.8-alpine

WORKDIR /usr/app/

COPY requirements.txt /usr/app/

RUN  pip install -r requirements.txt

ENV IP_DB=192.168.100.58
ENV DB_PORT=27017
ENV DB_NAME=test
ENV PORT_MICR1=5001
ENV PORT_MICR2=5002

COPY . /usr/app/
EXPOSE $PORT_MICR2
CMD ["python", "micr2.py"]
