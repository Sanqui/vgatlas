from pprint import pformat

from flask import Flask, render_template, Markup, url_for, get_template_attribute, request, g
from jinja2 import StrictUndefined, contextfilter
import jinja2.exceptions
from importlib import import_module
import datamijn
import datamijn.dmtypes as dmtypes
import datamijn.gfx as dmgfx

from filters import setup_filters, pathjoin

GAMES = "pokered".split()
#GAMES = "xm".split()

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
    dmtypes=dmtypes,
    dmgfx=dmgfx,
    enumerate=enumerate,
    pathjoin=pathjoin,
    len=len,
    list=list, issubclass=issubclass, repr=repr
    )

game_modules = []
for game in GAMES:
    game_modules.append(import_module(f"games.{game}"))

setup_filters(app, game_modules)

for module in game_modules:
    app.register_blueprint(module.views.blueprint)

@app.route("/")
def index():
    return render_template("index.html")

if __name__=="__main__":
    app.run(debug=True, threaded=True)
