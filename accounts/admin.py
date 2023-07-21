from django.contrib import admin
from . models import User, DummyAadharInfo
# Register your models here.


admin.site.register(User)
admin.site.register(DummyAadharInfo)