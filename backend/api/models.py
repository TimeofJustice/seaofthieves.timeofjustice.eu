from django.db import models
from django.conf import settings

# Create your models here.
class Page(models.Model):
    path = models.CharField(max_length=255)
    title = models.CharField(max_length=255)
    views = models.IntegerField(default=0)
