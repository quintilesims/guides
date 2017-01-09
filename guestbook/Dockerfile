FROM google/debian:wheezy

RUN apt-get update && \
    apt-get install -y python-dev python-pip && \
    pip install flask

EXPOSE 80

CMD [ "python", "/app/app.py" ]
COPY . /app
