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
    list=list)
app.register_blueprint(ff1.views.blueprint)
app.register_blueprint(telefang.views.blueprint)

@app.template_filter('block')
@contextfilter
def block_filter(env, object, path=[], in_list=False, depth=0, first=False, last=False, root=None):
    if root == None: root = env.get('root', request.blueprint)
    return get_template_attribute("_macros.html", "block")(object=object, path=path, in_list=in_list,
        depth=depth, first=first, last=last, root=root)

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
    elif isinstance(object, datamijn.Container):
        if hasattr(object, "name"):
            return object.name
        elif hasattr(object, "number"):
            return f"{type(object).__name__} #{number}"
        else:
            return f"<{type(object).__name__}>"
    elif isinstance(object, list):
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
