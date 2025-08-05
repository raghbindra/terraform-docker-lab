from flask import Flask , render_template
import os
import redis
app = Flask(__name__)
r = redis.Redis(host='redis_container', port=6379, decode_responses=True)

@app.route("/")
def index():
    count_file = "count.txt"
    if not os.path.exists(count_file):
        with open(count_file, "w") as f:
            f.write("0")
    with open(count_file, "r+") as f:
        count = int(f.read()) + 1
        f.seek(0)
        f.write(str(count))
        f.truncate()
    return render_template("index.html", count=count)

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5000)