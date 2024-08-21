from django.db import models
from django.conf import settings

# Create your models here.
class Page(models.Model):
    path = models.CharField(max_length=255)
    title = models.CharField(max_length=255)
    views = models.IntegerField(default=0)


class Wiki(models.Model):
    title = models.CharField(max_length=255, unique=True, primary_key=True)
    modules = models.JSONField()
    more = models.ManyToManyField(Page)
    updated_at = models.DateTimeField(auto_now=True)
    
    def __str__(self):
        return self.title
