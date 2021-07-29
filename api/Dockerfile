FROM python:3.8-alpine

WORKDIR /usr/app/

COPY requirements.txt /usr/app/

RUN  pip install -r requirements.txt

COPY . /usr/app/

ENV PORT_MICR1=5001
ENV PORT_MICR2=5002

CMD ["python", "api.py"]
