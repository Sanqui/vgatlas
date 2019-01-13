from flask import Blueprint, flash, redirect, render_template, request, url_for, g, abort

def object_endpoint(obj, root):
    def object(path):
        path = path.rstrip("/").split('/')
        objpath = [obj]
        template_path = []
        for segment in path:
            if isinstance(objpath[-1], dict) and segment in objpath[-1]:
                objpath.append(objpath[-1][segment])
                template_path.append(segment)
            elif isinstance(objpath[-1], list) and segment.isdigit() and int(segment) < len(objpath[-1]):
                objpath.append(objpath[-1][int(segment)])
                template_path.append("_")
            else:
                abort(404)
            
        template_path = root + "/" + ".".join(template_path) + ".html"
        
        object=objpath[-1]
        attrs = {}
        for attrname in 'id number name'.split():
            if hasattr(object, attrname):
                attrs[attrname] = getattr(object, attrname)
        
        return render_template([template_path, 'object.html'], base_template=root+'/_base.html',
            root=root,
            path=path, object=object, objpath=objpath,
            **attrs)
    
    return object
