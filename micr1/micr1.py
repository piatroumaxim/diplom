import requests
import json
import os
from flask import Flask

apinbrb = os.environ["API_NB_RB"]
port_micr1 = os.environ["PORT_MICR1"]

app = Flask(__name__)

@app.route('/get_courses', methods=['GET'])
def get_courses():
    cours = []
    get_json = requests.get(apinbrb)
    all_courses = json.loads(get_json.content)
    for i in all_courses:
        cours.append(
            {"Date": i["Date"], "Abbr": i["Cur_Abbreviation"], "Name": i["Cur_Name"], "Rate": i["Cur_OfficialRate"]})
    return json.dumps(cours, ensure_ascii=False)

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=port_micr1)
