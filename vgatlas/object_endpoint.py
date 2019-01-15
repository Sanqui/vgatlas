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
            
        object=objpath[-1]
        attrs = {}
        for attrname in 'id number name'.split():
            if hasattr(object, attrname):
                attrs[attrname] = getattr(object, attrname)
        
        #template_path = root + "/" + ".".join(template_path) + ".html"
        template_path = root + "/" + type(object).__name__ + ".html"
        
        index = None
        prev = None
        next = None
        if len(objpath) > 1 and isinstance(objpath[-2], list):
            index = int(path[-1])
            prev = objpath[-2][index-1] if index != 0 else None
            next = objpath[-2][index+1] if index + 1 < len(objpath[-2]) else None
        
        return render_template([template_path, 'object.html'], base_template=root+'/_base.html',
            root=root,
            path=path, object=object, objpath=objpath,
            index=index, prev=prev, next=next,
            **attrs)
    
    return object
