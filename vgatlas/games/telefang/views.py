from flask import Blueprint, flash, redirect, render_template, request, url_for, g, abort
import datamijn

from game_utils import setup

blueprint, telefang = setup("telefang", "telefang_pw.gbc", title="Keitai Denjuu Telefang")

max_stat = max(max([s for n,s in denjuu.base_stats.items() if n!='_io']) for denjuu in telefang.denjuu) + 4
telefang.max_stat = max_stat

table_formats = {
    "Denjuu": "number pic name type".split(),
    "OWSprite": {"down": "block", "up": "block", "left": "block"}
}
