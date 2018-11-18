from flask import Blueprint, flash, redirect, render_template, request, url_for, g
from datamijn import datamijn

dm = open("telefang/data/telefang.dm")
rom = open("telefang/data/telefang_pw.gbc", "rb")
telefang = datamijn.parse(dm, rom)

max_stat = max(max([s for n,s in denjuu.base_stats.items() if n!='_io']) for denjuu in telefang.denjuu)
telefang.max_stat = max_stat

blueprint = Blueprint('telefang', __name__, static_folder='static/', template_folder='templates/')

@blueprint.before_request
def before_request():
    g.telefang = telefang

@blueprint.route('/telefang/')
def index():
    return render_template('telefang/index.html')
    
@blueprint.route('/telefang/denjuu')
def denjuu_list():
    return render_template('telefang/denjuu_list.html')

@blueprint.route('/telefang/denjuu/<int:id>')
def denjuu(id):
    denjuu = telefang.denjuu[id]
    name = telefang.text.denjuu[id][0]
    return render_template('telefang/denjuu.html', id=id, denjuu=denjuu, name=name)

