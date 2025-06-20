from flask import Blueprint, flash, redirect, render_template, request, url_for, g
from datamijn import datamijn

from object_endpoint import object_endpoint

dm = open("ff1/data/ff1.dm")
rom = open("ff1/data/ff1.nes", "rb")
ff1 = datamijn.parse(dm, rom, "ff1/static/")

blueprint = Blueprint('ff1', __name__, 
    static_folder='static/', static_url_path="/ff1/static",
    template_folder='templates/')

@blueprint.before_request
def before_request():
    g.ff1 = ff1



@blueprint.route('/ff1/')
def index():
    return render_template('ff1/index.html', root="ff1", path=[], prev=None, next=None)
"""

@blueprint.route('/ff1/monsters')
def monsters():
    return render_template('ff1/monsters.html')

@blueprint.route('/ff1/monsters/<int:id>')
def monster(id):
    monster = ff1.monsters[id]
    name = ff1.text.monsters[id].str
    return render_template('ff1/monster.html', id=id, monster=monster, name=name)

@blueprint.route('/ff1/weapons')
def weapons():
    return render_template('ff1/weapons.html')

@blueprint.route('/ff1/weapon/<int:id>')
def weapon(id):
    weapon = ff1.weapons[id]
    name = ff1.text.basic.weapons[id].str
    return render_template('ff1/weapon.html', id=id, weapon=weapon, name=name)
"""

object = blueprint.route('/ff1/<path:path>')(object_endpoint(ff1, "ff1"))
