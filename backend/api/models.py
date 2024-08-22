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

class Module(models.Model):
    id = models.AutoField(primary_key=True)
    type = models.CharField(max_length=255, choices=MODULE_TYPE_CHOICES, default="text")
    title = models.CharField(max_length=255, blank=True, null=True)
    content = models.TextField(blank=True, null=True)
    path = models.URLField(blank=True, null=True)
    columns = models.TextField(blank=True, null=True)
    rows = models.TextField(blank=True, null=True)
    wiki = models.ForeignKey('Wiki', on_delete=models.CASCADE, blank=True, null=True)

    def __str__(self):
        return str(self.id)


class Wiki(models.Model):
    title = models.CharField(max_length=255, unique=True, primary_key=True)
    more = models.ManyToManyField(Page, blank=True, null=True)
    updated_at = models.DateTimeField(auto_now=True)
    
    def __str__(self):
        return self.title
