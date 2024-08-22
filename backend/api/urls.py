from django.urls import path

from . import views

urlpatterns = [
    path("events/burning-blade", views.burning_blade, name="event/burning-blade"),
    path("visit", views.visit_page, name="visit"),
    path("background", views.background, name="background"),
    path("wiki/<str:page>", views.wiki_page, name="wiki"),
]
