from django.contrib import admin
from .models import Page, Wiki, Column, Row, Module

# Register your models here.
admin.site.register(Page)
admin.site.register(Wiki)
admin.site.register(Column)
admin.site.register(Row)
admin.site.register(Module)
