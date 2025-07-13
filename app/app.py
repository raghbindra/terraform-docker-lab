from flask import Flask
import redis
app = Flask(__name__)
r = redis.Redis(host='redis_container', port=6379, decode_responses=True)

@app.route("/")
def hello():
    count = r.incr('hits')
    return f"Hello from Raghbindra's custom Docker image! This page has been viewed {count} times."

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5000)