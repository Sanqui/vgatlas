from flask import Blueprint, flash, redirect, render_template, request, url_for, g, abort
import datamijn

from game_utils import setup

blueprint, hp1 = setup("hp1", "hp1.gbc", title="Harry Potter and the Philosopher's Stone (GBC)")

table_formats = {
}

@blueprint.route(f'/hp1/notes/')
def notes():
    return render_template('hp1/notes.html', root='hp1', objpath=[], path=[])