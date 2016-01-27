from flask import Flask, jsonify

app = Flask(__name__)


@app.route('/')
def index():
    return 'Flask is running!'


@app.route('/sports')
def teams():
    data = {"town": "Boston",
            "teams": ["Bruins", "Patriots", "Red Sox", "Celtics"]
            }
    return jsonify(data)


if __name__ == '__main__':
    app.run()
