from django.contrib import admin
from .models import Evidence,EvidenceSuspect,Suspect
# Register your models here.

admin.site.register(Evidence)
admin.site.register(EvidenceSuspect)
admin.site.register(Suspect)