from rest_framework import serializers
from django.utils.dateparse import parse_datetime
from .models import *

class EFirSerializer(serializers.ModelSerializer):
    class Meta:
        model = EFir
        fields = '__all__'

class EFirUpdateSerializer(serializers.Serializer):
    status = serializers.ChoiceField(choices=STATUS, required=False)
    location = serializers.CharField(max_length=100, required=False)
    crime_description = serializers.CharField(required=False)

    class Meta:
        fields = ['status', 'location', 'crime_description']