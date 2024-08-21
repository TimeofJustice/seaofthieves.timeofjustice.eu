from django.shortcuts import render
from django.http import JsonResponse, HttpResponse
from .models import Page


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