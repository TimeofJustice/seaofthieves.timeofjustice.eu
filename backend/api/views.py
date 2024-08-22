from django.shortcuts import render
from django.http import JsonResponse, HttpResponse
from .models import Page, Wiki, Module


def to_response(was_successful, data, message=''):
    if was_successful:
        return JsonResponse({'status': 'success', 'data': data}, status=200)
    else:
        return JsonResponse({'status': message}, status=400)
    

def route_to_dict(page):
    if page.page is None:
        return {
            'title': page.title,
            'route': {'type': 'root', 'path': page.root},
            'views': page.views
        }
    else:
        return {
            'title': page.title,
            'route': {'type': 'sub', 'path': page.root, 'page': page.page},
            'views': page.views
        }
    

def visit_page(request):
    get = request.GET
    path = get.get('path', '')

    if path == '':
        return to_response(False, {}, 'missing_parameters')
    
    page = Page.objects.filter(path__iexact=path).first()

    if page is None:
        return to_response(False, {}, 'not_found')
    
    page.views += 1
    page.save()

    pages = Page.objects.exclude(path__iexact=path)

    most_viewed = sorted(pages, key=lambda x: x.views, reverse=True)
    most_viewed = most_viewed[:5]

    popular = []
    for page in most_viewed:
        popular.append(route_to_dict(page))

    return to_response(True, {'views': page.views, 'popular': popular})
    

# Create your views here.
def burning_blade(request):
    return to_response(True, {
        'title': 'Burning Blade (Calculator)',
        'description': 'Berechnet den Wert der Burning Blade für Sea of Thieves, basierend auf der Anzahl der Rituale',
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
                'route': {'type': 'sub', 'path': '/events', 'page': 'burning-blade'}
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
                'description': module.content,
                'path': module.path
            }
        }
    elif module.type == 'table':
        columns = []

        if module.columns:
            columns = module.columns.split(',')
            columns = [column.strip() for column in columns]

        rows = []

        if module.rows:
            rows_list = module.rows.split('\n')

            for row in rows_list:
                row = row.strip()

                if row == '': continue

                cells = row.split('),')
                cells = [cell.strip() for cell in cells]
                cells = [cell[1:] if cell.startswith('(') else cell for cell in cells]
                cells = [cell[:-1] if cell.endswith(')') else cell for cell in cells]
                cells = [cell.split(',') for cell in cells]
                cells = [[value.strip() for value in cell] for cell in cells]

                row = [row_to_dict(cell[0], cell[1]) for cell in cells]

                rows.append(row)

        return {
            'type': 'table',
            'value': {
                'title': module.title,
                'columns': columns,
                'rows': rows
            }
        }
    

def row_to_dict(type, value):
    if type == 'text':
        return {
            'type': 'text',
            'value': value
        }
    elif type == 'gold':
        value = int(value)

        return {
            'type': 'gold',
            'value': value
        }


def wiki_to_dict(wiki):
    more = []

    for page in wiki.more.all():
        more.append({
            'title': page.title,
            'route': page.path,
        })

    modules = []

    for module in Module.objects.filter(wiki=wiki):
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
