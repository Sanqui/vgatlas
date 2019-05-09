from flask import Blueprint, flash, redirect, render_template, request, url_for, g, abort
import datamijn

from game_utils import setup

blueprint, telefang = setup("xm", "83623-blinded.xm")


table_formats = {
    "PatternRow": ["note", "instrument", "volume", "effect", "effect_param"]
}
