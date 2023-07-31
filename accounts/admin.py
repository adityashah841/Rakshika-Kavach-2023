from django.contrib import admin
from . models import User, DummyAadharInfo, EmergencyContact,Address
# Register your models here.


admin.site.register(User)
admin.site.register(DummyAadharInfo)
admin.site.register(EmergencyContact)
admin.site.register(Address)