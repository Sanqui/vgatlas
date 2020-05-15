from flask import Blueprint, flash, redirect, render_template, request, url_for, g, abort
import datamijn

from game_utils import setup

blueprint, pokered = setup("pokered", "pokered.gbc", title="Pokémon Red")

table_formats = {
}
