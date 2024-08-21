from django.shortcuts import render
from django.http import JsonResponse, HttpResponse


def to_response(was_successful, data, message=''):
    if was_successful:
        return JsonResponse({'status': 'success', 'data': data}, status=200)
    else:
        return JsonResponse({'status': message}, status=400)
    

# Create your views here.
def burning_blade(request):
    return to_response(True, {
        'title': 'Burning Blade (World Event)',
        'description': '',
        'baseValue': 14000,
        'ritualValue': 26000,
        'emissaryValues': {
            'grade1': 1,
            'grade2': 1.33,
            'grade3': 1.67,
            'grade4': 2,
            'grade5': 2.5,
        },
        'popular': [
            {
                'title': 'Home',
                'route': "/",
            }
        ]
        })