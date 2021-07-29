FROM python:3.8-alpine

WORKDIR /usr/app/

COPY requirements.txt /usr/app/

RUN  pip install -r requirements.txt

COPY . /usr/app/

EXPOSE 5001

ENV API_NB_RB=https://www.nbrb.by/api/exrates/rates?periodicity=0
ENV PORT_MICR1=5001

CMD ["python", "micr1.py"]

