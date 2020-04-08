from flask import Blueprint, flash, redirect, render_template, request, url_for, g, abort
import datamijn

from object_endpoint import object_endpoint

ROOT = "pokered"

def setup(name, rom_filename):
    print(f"Initializing {name}...")
    dm = open(f"games/{name}/data/{name}.dm")
    rom = open(f"games/{name}/data/{rom_filename}", "rb")
    data = datamijn.parse(dm, rom, f"games/{name}/static/")

    blueprint = Blueprint(name, __name__,
        static_folder=f'games/{name}/static/', static_url_path=f"/{name}/static",
        template_folder=f'games/{name}/templates/')

    @blueprint.before_request
    def before_request():
        setattr(g, name, data)

    @blueprint.route(f'/{name}/')
    def index():
        return render_template([f'{name}/index.html', 'root.html'], root=name, path=[], objpath=[], prev=None, next=None)

    object = blueprint.route(f'/{name}/<path:path>')(object_endpoint(data, name))
    
    return blueprint, data

