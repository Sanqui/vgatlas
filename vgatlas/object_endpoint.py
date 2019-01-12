from flask import Blueprint, flash, redirect, render_template, request, url_for, g, abort

def object_endpoint(obj, root):
    def object(path):
        path = path.rstrip("/").split('/')
        objpath = [obj]
        for segment in path:
            if isinstance(objpath[-1], dict) and segment in objpath[-1]:
                objpath.append(objpath[-1][segment])
            elif isinstance(objpath[-1], list) and segment.isdigit() and int(segment) < len(objpath[-1]):
                objpath.append(objpath[-1][int(segment)])
            else:
                abort(404)
        return render_template('object.html', base_template=root+'/_base.html',
            root=root,
            path=path, object=objpath[-1], objpath=objpath)
    
    return object
