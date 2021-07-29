import json
from flask import Flask, request
from pymongo import MongoClient
import requests
import os

link_micr1 = "http://micr1:" + os.environ["PORT_MICR1"] + "/get_courses"
#IP_DB = "192.168.100.8"
IP_DB = os.environ["IP_DB"]
DB_PORT = int(os.environ["DB_PORT"])
DB_NAME = os.environ["DB_NAME"]

#DB_PORT = 27017
#DB_NAME = "test"
conn = MongoClient(IP_DB, DB_PORT)
db = conn[DB_NAME]
port_micr = os.environ["PORT_MICR2"]

app = Flask(__name__)

@app.route('/to_db', methods=['GET', 'POST'])
def get_db():
    if request.method == 'POST':
        users_orders = request.form["user"]
        select_db_users = db["users"]
        for i in select_db_users.find():
                if i["login"] == users_orders :
                    b = ("Логин: " + i["login"] + ", Полное имя: " + i["full_name"] +
                         ", Адрес: Город - " + i["address"]["city"] +
                         ", Улица - " + i["address"]["street"] +
                         ", Телефон - " + i["address"]["phone"])
                    return b
    else:
        select_db_orders = db['orders']
        users_orders = set()
        for i in select_db_orders.find():
            users_orders.add(i["cust_login"])
        my_list = list(users_orders)
        return json.dumps(my_list)


@app.route('/for3', methods=['GET', 'POST'])
def orders():
    if request.method == 'POST':
        json_list_users = request.form["user"]
        select_db_orders = db['orders']
        users_orders = set()
        list_users_orders = []
        for i in select_db_orders.find():
            if i["cust_login"] == json_list_users:
                users_orders.add(json_list_users)
                list_users_orders.append(i)
        dictin_users_and_orders = {}
        for k in users_orders:
            dictin_users_and_orders[k] = ""
            list_orders = []
            for i in list_users_orders:
                if i["cust_login"] == k:
                    list_orders.append(i["product_code"])
                dictin_users_and_orders[k] = list_orders
        for i in dictin_users_and_orders:
            for k in users_orders:
                if i == k:
                    counter = 0
                    all_prices = 0
                    for s in dictin_users_and_orders[i]:
                        for orders in s:
                            counter += 1
                            select_db_products = db['products']
                            select = select_db_products.find_one({"code": {"$eq": orders}},
                                                                 {"_id": 0, "code": 0, "category": 0,
                                                                  "manufacter": 0, "model": 0})
                            all_prices += int(select["price"])
    get_json = requests.get(link_micr1)
    all_courses = json.loads(get_json.content)
    for i in all_courses:
        if i["Abbr"] == "USD":
            rate = i["Rate"]
    price_in_br = float(rate)*all_prices
    return_message = ("суммы заказов в USD = " + str(all_prices) + ", в BYR=" + str(price_in_br) )
    return return_message
if __name__ == '__main__':
    app.run(host='0.0.0.0', port=port_micr)


