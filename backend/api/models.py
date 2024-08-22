from django.db import models
from django.conf import settings

# Create your models here.
class Page(models.Model):
    root = models.CharField(max_length=255)
    page = models.CharField(max_length=255, blank=True, null=True)
    title = models.CharField(max_length=255)
    background = models.URLField(blank=True, null=True)
    views = models.IntegerField(default=0)

    def __str__(self):
        if self.page is None:
            return self.title + ' (' + self.root + ')'
        else:
            return self.title + ' (' + self.root + '/' + self.page + ')'

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
        content = ""

        if self.type == "text":
            content = self.title
        elif self.type == "block":
            content = self.content[:10]
        elif self.type == "image":
            content = self.content[:10]
        elif self.type == "table":
            content = self.title

        return "(" + self.id + ")" + self.type + ': ' + content


class Wiki(models.Model):
    title = models.CharField(max_length=255, unique=True, primary_key=True)
    more = models.ManyToManyField(Page, blank=True, null=True)
    updated_at = models.DateTimeField(auto_now=True)
    
    def __str__(self):
        return self.title
