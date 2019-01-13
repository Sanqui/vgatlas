from pprint import pformat

from flask import Flask, render_template, Markup
from jinja2 import StrictUndefined
import ff1
import telefang
from datamijn import datamijn

app = Flask(__name__)
app.jinja_env.undefined = StrictUndefined
app.jinja_env.globals.update(
    zip=zip,
    pformat=pformat,
    isinstance=isinstance,
    type=type,
    hasattr=hasattr, getattr=getattr,
    str=str,
    datamijn=datamijn,
    enumerate=enumerate,
    pathjoin=lambda path: '/'.join(str(x) for x in path),
    len=len)
app.register_blueprint(ff1.views.blueprint)
app.register_blueprint(telefang.views.blueprint)


@app.route("/")
def index():
    return render_template("index.html")

if __name__=="__main__":
    app.run(debug=True)
