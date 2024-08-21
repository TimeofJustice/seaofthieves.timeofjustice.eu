from django.shortcuts import render
from django.http import JsonResponse, HttpResponse


def to_response(was_successful, data, message=''):
    if was_successful:
        return JsonResponse({'status': 'success', 'data': data}, status=200)
    else:
        return JsonResponse({'status': message}, status=400)
    

# Create your views here.
def burning_blade(request):
    return to_response(True, {'message': 'Hello, World!'})