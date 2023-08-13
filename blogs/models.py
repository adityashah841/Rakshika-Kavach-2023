from django.db import models
from django.conf import settings

def upload_path_handler(instance, filename):
    return "images/blog/{label}/{file}".format(
        label=instance.title, file=filename
    )

# Create your models here.
class Blog(models.Model):
    # id = models.AutoField(primary_key=True)
    title = models.CharField(max_length=100, unique=True)
    content = models.TextField()
    author = models.CharField(max_length=100)
    image = models.ImageField(upload_to = upload_path_handler,null = True, blank = True)
    created_at = models.DateTimeField(auto_now_add=True)
    updated_at = models.DateTimeField(auto_now=True)

    def __str__ (self):
        return self.title
    