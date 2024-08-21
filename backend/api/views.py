from django.shortcuts import render
from django.http import JsonResponse, HttpResponse
from .models import Page, Wiki


def to_response(was_successful, data, message=''):
    if was_successful:
        return JsonResponse({'status': 'success', 'data': data}, status=200)
    else:
        return JsonResponse({'status': message}, status=400)
    

def visit_page(request):
    get = request.GET
    path = get.get('path', '')

    if path == '':
        return to_response(False, {}, 'missing_parameters')
    
    page = Page.objects.filter(path=path).first()

    if page is None:
        return to_response(False, {}, 'not_found')
    
    page.views += 1
    page.save()

    pages = Page.objects.exclude(path=path)

    most_viewed = sorted(pages, key=lambda x: x.views, reverse=True)
    most_viewed = most_viewed[:5]

    popular = []
    for page in most_viewed:
        popular.append({
            'title': page.title,
            'route': page.path,
        })

    return to_response(True, {'views': page.views, 'popular': popular})
    

# Create your views here.
def burning_blade(request):
    return to_response(True, {
        'title': 'Burning Blade (Calculator)',
        'description': 'Calculate the value of the Burning Blade ritual in Sea of Thieves according to the emissary grade.',
        'baseValue': 14000,
        'ritualValue': 26000,
        'emissaryValues': {
            'grade1': 1,
            'grade2': 1.33,
            'grade3': 1.67,
            'grade4': 2,
            'grade5': 2.5,
        },
        'more': [
            {
                'title': 'Burning Blade (World Event)',
                'route': '/events/burning-blade',
            }
        ]
        })


def module_to_dict(module):
    if module.type == 'text':
        return {
            'type': 'text',
            'value': {
            'title': module.title,
            'content': module.content
            }
        }
    elif module.type == 'block':
        return {
            'type': 'block',
            'value': {
                'content': module.content
            }
        }
    elif module.type == 'image':
        return {
            'type': 'image',
            'value': {
                'description': module.description,
                'path': module.path
            }
        }
    elif module.type == 'table':
        columns = []
        for column in module.columns.all():
            columns.append(column.name)

        rows = []
        for row in module.rows.all():
            row_columns = []
            for column in row.columns.all():
                row_columns.append(row_to_dict(column))
            rows.append(row_columns)

        return {
            'type': 'table',
            'value': {
                'columns': columns,
                'rows': rows
            }
        }
    

def row_to_dict(row):
    if row.type == 'text':
        return {
            'type': 'text',
            'value': row.title
        }
    elif row.type == 'gold':
        return {
            'type': 'gold',
            'value': row.amount
        }


def wiki_to_dict(wiki):
    more = []

    for page in wiki.more.all():
        more.append({
            'title': page.title,
            'route': page.path,
        })

    modules = []

    for module in wiki.modules.all():
        modules.append(module_to_dict(module))

    return {
        'title': wiki.title,
        'modules': modules,
        'more': more
    }


def wiki_page(request, page):
    wiki = Wiki.objects.filter(title__iexact=page).first()

    if wiki is None:
        return to_response(False, {}, 'not_found')
    
    return to_response(True, wiki_to_dict(wiki))
