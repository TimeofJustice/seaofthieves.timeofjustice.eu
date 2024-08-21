from django.urls import path

from . import views

urlpatterns = [
    path("events/burning-blade", views.burning_blade, name="event/burning-blade"),
]
