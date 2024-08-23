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
            'description': page.description,
            'route': {'type': 'root', 'value': {'path': page.root}},
            'views': page.views
        }
    else:
        return {
            'title': page.title,
            'description': page.description,
            'route': {'type': 'sub', 'value': {'path': page.root, 'page': page.page}},
            'views': page.views
        }
    

def visit_page(request):
    get = request.GET
    path = get.get('path', '')

    if path == '':
        return to_response(False, {}, 'missing_parameters')
    
    root = '/'.join(path.split('/')[0:-1])
    page = path.split('/')[-1]
    
    root_page = Page.objects.filter(root__iexact=path).first()
    sub_page = Page.objects.filter(root__iexact=root, page__iexact=page).first()

    if root_page is None and sub_page is None:
        return to_response(False, {}, 'not_found')
    
    if root_page is not None:
        current_page = root_page
    else:
        current_page = sub_page
    
    current_page.views += 1
    current_page.save()

    pages = Page.objects.filter(exclude=False)
    pages = [page for page in pages if page != current_page]

    most_viewed = sorted(pages, key=lambda x: x.views, reverse=True)
    most_viewed = most_viewed[:5]

    popular = []
    for page in most_viewed:
        popular.append(route_to_dict(page))

    background = current_page.background

    if background is None:
        background = 'https://timeofjustice.eu/global/background/sea-of-thieves-cannon-guild.jpg'

    return to_response(True, {'views': current_page.views, 'popular': popular, 'background': background})
    

# Create your views here.
def burning_blade(request):
    burning_blade = Page.objects.filter(title__iexact='Burning Blade (World Event)').first()

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
            route_to_dict(burning_blade)
        ]
        })


def module_to_dict(module):
    if module.type == 'text':
        return {
            'type': 'text',
            'value': {
                'title': module.title,
                'content': module.content,
                'order': module.order
            }
        }
    elif module.type == 'block':
        return {
            'type': 'block',
            'value': {
                'content': module.content,
                'order': module.order
            }
        }
    elif module.type == 'image':
        return {
            'type': 'image',
            'value': {
                'description': module.content,
                'path': module.path,
                'order': module.order
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

                cells = row.split(',')
                cells = [cell.strip() for cell in cells]

                rows.append(cells)

        return {
            'type': 'table',
            'value': {
                'title': module.title,
                'columns': columns,
                'rows': rows,
                'order': module.order
            }
        }


def wiki_to_dict(wiki):
    more = []

    for page in wiki.more.all():
        more.append({
            'title': page.title,
            'route': page.path,
        })

    modules = []
    chapters = []

    for module in Module.objects.filter(wiki=wiki).order_by('order'):
        if module.type == 'text' or module.type == 'table':
            if module.title is not None:
                chapters.append({'title': module.title, 'order': module.order})

        modules.append(module_to_dict(module))

    return {
        'title': wiki.title,
        'modules': modules,
        'chapters': chapters,
        'more': more
    }


def wiki_page(request, page):
    wiki = Wiki.objects.filter(title__iexact=page).first()

    if wiki is None:
        return to_response(False, {}, 'not_found')
    
    return to_response(True, wiki_to_dict(wiki))


def search(request):
    get = request.GET
    query = get.get('query', '')

    if query == '':
        pages = Page.objects.filter(exclude=False)

        most_viewed = sorted(pages, key=lambda x: x.views, reverse=True)
        most_viewed = most_viewed[:5]

        popular = []
        for page in most_viewed:
            popular.append(route_to_dict(page))

        return to_response(True, {'pages': popular})
    
    query = query.lower()

    pages = Page.objects.filter(exclude=False)

    results = []

    for page in pages:
        if query in page.title.lower():
            results.append(route_to_dict(page))

    wiki = Wiki.objects.all()

    for page in wiki:
        if page.page is None:
            continue

        if query in page.title.lower():
            results.append(route_to_dict(page.page))
        else:
            modules = Module.objects.filter(wiki=page)

            for module in modules:
                if module.title and query in module.title.lower():
                    results.append(route_to_dict(page.page))
                elif module.content and  query in module.content.lower():
                    results.append(route_to_dict(page.page))
                elif module.rows and query in module.rows.lower():
                    results.append(route_to_dict(page.page))
                elif module.columns and query in module.columns.lower():
                    results.append(route_to_dict(page.page))

    results = list({v['title']: v for v in results}.values())
    
    return to_response(True, {'pages': results})	
