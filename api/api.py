from flask import Flask, render_template, request
import requests
import json
import os


link_micr1 = "http://micr1:" + os.environ["PORT_MICR1"] + "/get_courses"
link_micr2 = "http://micr2:" + os.environ["PORT_MICR2"] + "/to_db"
link_micr3 = "http://micr2:" + os.environ["PORT_MICR2"] + "/for3"


app = Flask(__name__)
@app.route('/')
def index():
    return render_template("index.html")

@app.route('/microservice1')
def get_courses():
    get_json = requests.get(link_micr1)
    all_courses = json.loads(get_json.content)
    return render_template("microservice1.html", value=all_courses)

@app.route('/microservice2', methods=['GET','POST'])
def select_to_db():
    get_json = requests.get(link_micr2)
    list_users = json.loads(get_json.content)
    if request.method == 'POST':
        users_orders = request.form['user']
        if users_orders == "":
            message = "Введите логин"
            return render_template("microservice2.html", users=list_users, message=message)
        else:
            info_user = requests.post(link_micr2, data={'user': users_orders})
            message = info_user.content.decode('utf-8')
            return render_template("microservice2.html", users=list_users, message = message)


    return render_template("microservice2.html", users=list_users)

@app.route('/microservice3', methods=['GET','POST'])
def orders():
    if request.method == 'POST':
        users_orders = request.form['user']
        if users_orders == "":
            message = "Введите логин"
            return render_template("microservice3.html", message=message)
        else:
            info_user = requests.post(link_micr3, data={'user': users_orders})
            message = info_user.content.decode('utf-8') + " USD"
            return render_template("microservice3.html", message = message)


    return render_template("microservice3.html")

if __name__ == '__main__':
    app.run(host='0.0.0.0')
