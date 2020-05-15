from flask import Blueprint, flash, redirect, render_template, request, url_for, g, abort

from filters import block_macro_for

def get_object_template(rootobj, root, path):
    path = path.rstrip("/").split('/')
    objpath = [rootobj]
    for segment in path:
        if isinstance(objpath[-1], dict) and segment in objpath[-1]:
            objpath.append(objpath[-1][segment])
        elif isinstance(objpath[-1], list) and segment.isdigit() and int(segment) < len(objpath[-1]):
            objpath.append(objpath[-1][int(segment)])
        else:
            abort(404)
        
    object=objpath[-1]
    
    views = ['auto', 'raw']
    has_page_view = block_macro_for(root, object)
    if has_page_view:
        views.insert(0, 'page')
    
    view = request.args.get('view')
    if not view:
        view = views[0]
    
    attrs = {}
    for attrname in 'id number name'.split():
        if hasattr(object, attrname):
            attrs[attrname] = getattr(object, attrname)
    
    index = None
    prev = None
    next = None
    if len(objpath) > 1 and isinstance(objpath[-2], list):
        index = int(path[-1])
        prev = objpath[-2][index-1] if index != 0 else None
        next = objpath[-2][index+1] if index + 1 < len(objpath[-2]) else None
    
    g.rootobj = rootobj
    
    return ['object.html'], dict(base_template=root+'/_base.html',
        root=root, rootobj=rootobj,
        path=path, object=object, objpath=objpath,
        index=index, prev=prev, next=next,
        view=view, views=views,
        **attrs)

def object_endpoint(obj, root):
    def object(path):
        template_name, attrs = get_object_template(obj, root, path)
        
        if path:
            g.title = f"VGAtlas - {g.gametitle} / {path}"
        else:
            g.title = f"VGAtlas - {g.gametitle}"
        
        return render_template(template_name, **attrs)
    
    return object
