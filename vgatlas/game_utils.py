from flask import Blueprint, flash, redirect, render_template, request, url_for, g, abort
import datamijn
import requests

from object_endpoint import object_endpoint

ROOT = "pokered"

def setup(name, rom_filename, title=None, post_setup=None, symbols_url=None):
    print(f"Initializing {name}...")
    if symbols_url:
        # Fetch symbols.  XXX this should be pinned to a version at some point
        symbols = requests.get("https://raw.githubusercontent.com/Sanqui/romhacking/master/hp/hp1.sym").text
        symbols_filename = rom_filename.split('.')[0] + '.sym'
        open(f"games/{name}/data/{symbols_filename}", "w").write(symbols)

    dm = open(f"games/{name}/data/{name}.dm")
    rom = open(f"games/{name}/data/{rom_filename}", "rb")
    data = datamijn.parse(dm, rom, f"games/{name}/static/")

    if post_setup:
        post_setup(data)

    blueprint = Blueprint(name, __name__,
        static_folder=f'games/{name}/static/', static_url_path=f"/{name}/static",
        template_folder=f'games/{name}/templates/')

    blueprint.gametitle = title or name

    @blueprint.before_request
    def before_request():
        setattr(g, name, data)
        g.gametitle = title or name

    @blueprint.route(f'/{name}/')
    def index():
        g.title = f"VGAtlas - {g.gametitle}"
        return render_template([f'{name}/index.html', 'root.html'], root=name, path=[], objpath=[], prev=None, next=None)

    object = blueprint.route(f'/{name}/<path:path>')(object_endpoint(data, name))
    
    return blueprint, data

