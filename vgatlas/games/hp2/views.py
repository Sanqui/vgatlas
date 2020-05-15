from flask import Blueprint, flash, redirect, render_template, request, url_for, g, abort
import datamijn

from game_utils import setup

def post_setup(hp2):
    for enemy in hp2.enemies:
        enemy['name'] = None
    
    for bruti_enemy in hp2.folio_bruti_enemies:
        bruti_enemy.enemy._object['name'] = bruti_enemy.name

blueprint, pokered = setup("hp2", "hp2.gbc", title="Harry Potter and the Chamber of Secrets (GBC)", post_setup=post_setup)

table_formats = {
    'MapRosters': []
}
