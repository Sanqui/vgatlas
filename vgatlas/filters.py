from pprint import pformat

from flask import Flask, render_template, Markup, url_for, get_template_attribute, request, g
from jinja2 import StrictUndefined, contextfilter
import jinja2.exceptions
import datamijn
import datamijn.dmtypes as dmtypes
import datamijn.gfx as dmgfx

def pathjoin(path):
    pathlist = []
    for part in path:
        while isinstance(part, tuple) and len(part) == 2:
            pathlist.append(part[0])
            part = part[1]
        while isinstance(part, tuple) and len(part) == 1:
            part = part[0]
        pathlist.append(part)
    return '/'.join(str(x) for x in pathlist)

def setup_filters(app, game_modules):
    @app.template_filter('block')
    @contextfilter
    def block_filter(env, object, path=None, in_list=False, depth=0, max_depth=5, first=False, last=False, root=None):
        if path == None: path = []
        if root == None: root = env.get('root', request.blueprint)
        
        typename = type(object).__name__
        template_path = root + "/" + typename + ".html"
        try:
            out = get_template_attribute(template_path, 'block')(object=object, path=path, in_list=in_list,
                depth=depth, max_depth=max_depth, first=first, last=last, root=root)
            return out
        except (jinja2.exceptions.TemplateNotFound, ):
            pass
        
        #if isinstance(object, datamijn.ListArray) and not isinstance(object, datamijn.Image):
        #    return table_filter(env, object=object, path=path, root=root)
        
        try:
            out = get_template_attribute(f"{root}/_macros.html", "block")(object=object, path=path, in_list=in_list,
                depth=depth, max_depth=max_depth, first=first, last=last, root=root)
            if out.strip():
                return out
        except jinja2.exceptions.TemplateNotFound:
            pass
        
        return get_template_attribute("_macros.html", "block")(object=object, path=path, in_list=in_list,
            depth=depth, max_depth=max_depth, first=first, last=last, root=root)

    def get_table_data(env, object, path, root, columns):
        typename = object._child_type.__name__
        
        template_path = root + "/" + typename + ".html"
        try:
            thead_macro = get_template_attribute(template_path, 'thead')
            trow_macro = get_template_attribute(template_path, 'trow')
        except (jinja2.exceptions.TemplateNotFound, AttributeError):
            thead_macro = None
            trow_macro = None
        
        # (object=object, path=path, root=root)
        
        if not columns:
            for module in game_modules:
                if typename in getattr(module.views, 'table_formats', {}):
                    columns = module.views.table_formats[typename]
        
        # No columns were given to us, make a guess on what's appropriate.
        if not columns:
            columns = []
            for name, type_ in object._child_type._contents.items():
                if not issubclass(type_, dmtypes.Struct) and not issubclass(type_, dmtypes.Array)\
                  and name and not name.startswith("_"):
                    columns.append(name)
        
        return columns, thead_macro, trow_macro

    @app.template_filter('makes_a_good_table')
    @contextfilter
    def makes_a_good_table(env, object, path=[], root=None, columns=[]):
        if not issubclass(object._child_type, dmtypes.Struct):
            return False
        else:
            columns, thead_macro, trow_macro = get_table_data(env, object, path, root, columns)
            if thead_macro and trow_macro:
                return True
            if len(columns):
                return True
            return False

    @app.template_filter('table')
    @contextfilter
    def table_filter(env, object, path=[], root=None, columns=[]):
        if not isinstance(object, dmtypes.Array):
            raise TypeError("Can't make table out of {type(object).__name__}, only Array.")
        #if not isinstance(object._type, datamijn.Container):
        #    raise TypeError("Objects inside array must be containers (?)")
        
        columns, thead_macro, trow_macro = get_table_data(env, object, path, root, columns)
        
        if root == None: root = env.get('root', request.blueprint)
        return get_template_attribute("_macros.html", "table")(object=object, path=path, root=root, columns=columns, thead_macro=thead_macro, trow_macro=trow_macro)

    # TODO maybe this should really just be __str__ and __html__ of objects, in datamijn

    @app.template_filter('inline_block')
    @contextfilter
    def inline_block_filter(env, object):
        root = env.get('root', request.blueprint)
        if isinstance(object, dmtypes.ForeignKey):
            if isinstance(object, dmgfx.Image) or isinstance(object, dmgfx.Tileset):
                return inline_filter(env, object._object)
            
            return Markup(f"""
                <a class='card' style='display:inline-block; text-align: center;' href="{ url_for(root+'.object',
                  path=pathjoin(list(object._field_name) + [object._key])) }">""") \
                    + inline_block_filter(env, object._object) + Markup("</a>")
        elif isinstance(object, dmtypes.Struct):
            out = []
            if hasattr(object, "pic"):
                out.append(Markup("<span>") + inline_block_filter(env, object.pic._object) + Markup("</span>"))
            if hasattr(object, "name"):
                out.append(str(object.name))
            elif hasattr(object, "number"):
                out.append(f"{type(object).__name__} #{number}")
            else:
                out.append(f"<{type(object).__name__}>")
            
            return Markup("<br>").join(out)
        else:
            return inline_filter(env, object)

    @app.template_filter('inline')
    @contextfilter
    def inline_filter(env, object):
        root = env.get('root', request.blueprint)
        if isinstance(object, dmtypes.ForeignKey):
            if isinstance(object, dmgfx.Image) or isinstance(object, dmgfx.Tileset):
                return inline_filter(env, object._object)
            
            return Markup(f""" 
                <a href="{ url_for(root+'.object',
                  path=pathjoin(list(object._field_name) + [object._key])) }">""") \
                    + inline_filter(env, object._object) + Markup("</a>")
        elif isinstance(object, dmgfx.Image) or isinstance(object, dmgfx.Tileset):
            if hasattr(object, "_filename"):
                return Markup(f"""<img src="{ url_for(root+'.static', filename=object._filename) }">""")
            else:
                return(str(object))
        elif isinstance(object, dmtypes.Struct):
            out = []
            if hasattr(object, "icon"):
                out.append(Markup("<span class='icon'>") + inline_filter(env, object.icon._object) + Markup("</span>"))
            if hasattr(object, "name"):
                out.append(str(object.name))
            elif hasattr(object, "number"):
                out.append(f"{type(object).__name__} #{number}")
            else:
                out.append(f"<{type(object).__name__}>")
            
            return Markup(" ").join(out)
        elif isinstance(object, dmtypes.String):
            return str(object)
        elif isinstance(object, list):
            return f"<{type(object).__name__}>"
        elif isinstance(object, dmtypes.B1) and object._num_bits == 1:
            return Markup(("<span class='text-danger'>✗</span>", "<span class='text-success'>✔</span>")[object])
        elif object == None:
            return "-"
        else:
            return str(object)
