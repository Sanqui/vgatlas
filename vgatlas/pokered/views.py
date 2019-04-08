from flask import Blueprint, flash, redirect, render_template, request, url_for, g, abort
import datamijn

from object_endpoint import object_endpoint

dm = open("pokered/data/pokered.dm")
rom = open("pokered/data/pokered.gbc", "rb")
pokered = datamijn.parse(dm, rom, "pokered/static/")


table_formats = {

}

blueprint = Blueprint('pokered', __name__,
    static_folder='static/', static_url_path="/pokered/static",
    template_folder='templates/')

@blueprint.before_request
def before_request():
    g.pokered = pokered

@blueprint.route('/pokered/')
def index():
    return render_template('pokered/index.html', root="pokered", path=[], prev=None, next=None)

object = blueprint.route('/pokered/<path:path>')(object_endpoint(pokered, "pokered"))

