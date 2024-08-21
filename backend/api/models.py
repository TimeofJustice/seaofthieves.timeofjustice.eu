from django.db import models
from django.conf import settings

# Create your models here.
class Page(models.Model):
    path = models.CharField(max_length=255)
    title = models.CharField(max_length=255)
    views = models.IntegerField(default=0)

    def __str__(self):
        return self.title + ' (' + self.path + ')'

MODULE_TYPE_CHOICES = (
    ("text", "text"),
    ("block", "block"),
    ("image", "image"),
    ("table", "table")
)

CELL_TYPE_CHOICES = (
    ("text", "text"),
    ("gold", "gold")
)

class Column(models.Model):
    id = models.AutoField(primary_key=True)
    type = models.CharField(max_length=255, choices=CELL_TYPE_CHOICES, default="text")
    title = models.CharField(max_length=255, blank=True, null=True)

    def __str__(self):
        return str(self.id)
    

class Row(models.Model):
    id = models.AutoField(primary_key=True)
    columns = models.ManyToManyField(Column, blank=True, null=True)

    def __str__(self):
        return str(self.id)

class Module(models.Model):
    id = models.AutoField(primary_key=True)
    type = models.CharField(max_length=255, choices=MODULE_TYPE_CHOICES, default="text")
    title = models.CharField(max_length=255, blank=True, null=True)
    content = models.TextField(blank=True, null=True)
    description = models.TextField(blank=True, null=True)
    path = models.URLField(blank=True, null=True)
    columns = models.ManyToManyField(Column, blank=True, null=True)
    rows = models.ManyToManyField(Row, blank=True, null=True)

    def __str__(self):
        return str(self.id)


class Wiki(models.Model):
    title = models.CharField(max_length=255, unique=True, primary_key=True)
    modules = models.ManyToManyField(Module, blank=True, null=True)
    more = models.ManyToManyField(Page, blank=True, null=True)
    updated_at = models.DateTimeField(auto_now=True)
    
    def __str__(self):
        return self.title
