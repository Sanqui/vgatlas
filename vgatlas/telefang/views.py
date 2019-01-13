from flask import Blueprint, flash, redirect, render_template, request, url_for, g, abort
from datamijn import datamijn

from object_endpoint import object_endpoint

dm = open("telefang/data/telefang.dm")
rom = open("telefang/data/telefang_pw.gbc", "rb")
telefang = datamijn.parse(dm, rom, "telefang/static/")

max_stat = max(max([s for n,s in denjuu.base_stats.items() if n!='_io']) for denjuu in telefang.denjuu) + 4
telefang.max_stat = max_stat

blueprint = Blueprint('telefang', __name__,
    static_folder='static/', static_url_path="/telefang/static",
    template_folder='templates/')

@blueprint.before_request
def before_request():
    g.telefang = telefang

@blueprint.route('/telefang/')
def index():
    return render_template('telefang/index.html')

object = blueprint.route('/telefang/<path:path>')(object_endpoint(telefang, "telefang"))

