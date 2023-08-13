from rest_framework import serializers
from django.utils.dateparse import parse_datetime
from .models import *

class EvidenceSerializer(serializers.ModelSerializer):
    class Meta:
        model = Evidence
        fields = '__all__'


class SuspectSerializer(serializers.ModelSerializer):
    name = serializers.CharField(max_length=100, default='Unknown')
    image = serializers.ImageField(required=True)
    class Meta:
        model = Suspect
        fields = ['name', 'image']

# class EvidenceSuspectSerializer(serializers.ModelSerializer):
#     class Meta:
#         model = EvidenceSuspect
#         fields = ['evidence', 'suspect']