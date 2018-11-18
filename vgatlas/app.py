from flask import Flask, render_template
from jinja2 import StrictUndefined
import ff1
#from vgatlas.telefang import telefang

app = Flask(__name__)
app.jinja_env.undefined = StrictUndefined
app.register_blueprint(ff1.views.blueprint)
#app.register_blueprint(telefang)


@app.route("/")
def index():
    return render_template("index.html")

if __name__=="__main__":
    app.run(debug=True)
