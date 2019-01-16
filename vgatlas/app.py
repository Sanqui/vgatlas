from pprint import pformat

from flask import Flask, render_template, Markup, url_for, get_template_attribute, request
from jinja2 import StrictUndefined, contextfilter
import ff1
import telefang
from datamijn import datamijn

pathjoin = lambda path: '/'.join(str(x) for x in path)

app = Flask(__name__)
app.jinja_env.undefined = StrictUndefined
app.jinja_env.globals.update(
    zip=zip,
    pformat=pformat,
    isinstance=isinstance,
    type=type,
    hasattr=hasattr, getattr=getattr,
    str=str,
    datamijn=datamijn,
    enumerate=enumerate,
    pathjoin=pathjoin,
    len=len,
    list=list, issubclass=issubclass)
app.register_blueprint(ff1.views.blueprint)
app.register_blueprint(telefang.views.blueprint)

@app.template_filter('block')
@contextfilter
def block_filter(env, object, path=[], in_list=False, depth=0, first=False, last=False, root=None):
    if root == None: root = env.get('root', request.blueprint)
    return get_template_attribute("_macros.html", "block")(object=object, path=path, in_list=in_list,
        depth=depth, first=first, last=last, root=root)

@app.template_filter('table')
@contextfilter
def table_filter(env, object, path=[], root=None, columns=[]):
    if not isinstance(object, datamijn.Array):
        raise TypeError("Can't make table out of {type(object).__name__}, only Array.")
    #if not isinstance(object._type, datamijn.Container):
    #    raise TypeError("Objects inside array must be containers (?)")
    
    # No columns were given to us, make a guess on what's appropriate.
    if not columns:
        columns = []
        for name, type_ in object._type._contents:
            if not issubclass(type_, datamijn.Container) and not issubclass(type_, datamijn.Array):
                columns.append(name)
    
    print(type(object), object._type, type(object[0]))
    
    if root == None: root = env.get('root', request.blueprint)
    return get_template_attribute("_macros.html", "table")(object=object, path=path, root=root, columns=columns)

# TODO maybe this should really just be __str__ and __html__ of objects, in datamijn

@app.template_filter('inline')
@contextfilter
def inline_filter(env, object):
    root = env.get('root', request.blueprint)
    if isinstance(object, datamijn.ForeignKey):
        return Markup(f"""
            <a href="{ url_for(root+'.object',
              path=pathjoin(list(object._field_name) + [object._result])) }">
                { inline_filter(env, object._object) }
            </a>
        """)
    elif isinstance(object, datamijn.Image) or isinstance(object, datamijn.Tileset):
        if hasattr(object, "_filename"):
            return Markup(f"""<img src="{ url_for(root+'.static', filename=object._filename) }">""")
        else:
            return(str(object))
    elif isinstance(object, datamijn.Container):
        out = []
        if hasattr(object, "icon"):
            out.append(inline_filter(env, object.icon))
        if hasattr(object, "name"):
            out.append(str(object.name))
        elif hasattr(object, "number"):
            out.append(f"{type(object).__name__} #{number}")
        else:
            out.append(f"<{type(object).__name__}>")
        
        return " ".join(out)
    elif isinstance(object, list):
        # XXX make native datamijn String
        if getattr(object._type, "_char", False):
            return str(object)
        else:
            return f"<{type(object).__name__}>"
    elif object == None:
        return "-"
    else:
        return str(object)

@app.route("/")
def index():
    return render_template("index.html")

if __name__=="__main__":
    app.run(debug=True)
