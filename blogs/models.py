from django.db import models
from django.conf import settings

# Create your models here.
class Blog(models.Model):
    # id = models.AutoField(primary_key=True)
    title = models.CharField(max_length=100, unique=True)
    content = models.TextField()
    author = models.CharField(max_length=100)
    created_at = models.DateTimeField(auto_now_add=True)
    updated_at = models.DateTimeField(auto_now=True)

    def __str__ (self):
        return self.id
    